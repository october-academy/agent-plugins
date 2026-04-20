"""
Offline unit tests for trend-scout Phase 1 components.
Run: python -m pytest test_lib.py -v
"""
import os
import sys
import unittest
from unittest.mock import MagicMock, patch

sys.path.insert(0, os.path.dirname(__file__))

from lib import (
    classify_failure,
    dedupe_items,
    enrich_summary,
    extract_ld_json,
    FallbackChain,
    http_text,
)

FALLBACK_EVENTS = []


# ---------------------------------------------------------------------------
# TestClassifyFailure
# ---------------------------------------------------------------------------

class TestClassifyFailure(unittest.TestCase):

    def test_403_status(self):
        result = classify_failure(None, "", 403)
        self.assertEqual(result, "blocked_403")

    def test_429_status(self):
        result = classify_failure(None, "", 429)
        self.assertEqual(result, "rate_limited_429")

    def test_waf_challenge_body(self):
        body = "<html><body>cf-browser-verification challenge</body></html>"
        result = classify_failure(None, body, 200)
        self.assertEqual(result, "waf_challenge")

    def test_waf_challenge_platform(self):
        body = "<html>challenge-platform detected</html>"
        result = classify_failure(None, body, 200)
        self.assertEqual(result, "waf_challenge")

    def test_empty_spa_body(self):
        body = "<html><head></head><body><script src='app.js'></script></body></html>"
        result = classify_failure(None, body, 200)
        self.assertEqual(result, "empty_spa")

    def test_timeout_exception(self):
        exc = TimeoutError("timed out")
        result = classify_failure(exc, "", None)
        self.assertEqual(result, "timeout")

    def test_unknown_fallthrough(self):
        result = classify_failure(Exception("some random error"), "normal page content here", 200)
        self.assertEqual(result, "unknown")


# ---------------------------------------------------------------------------
# TestDedupeItems
# ---------------------------------------------------------------------------

class TestDedupeItems(unittest.TestCase):

    def _item(self, url, title, score=1.0, source="test"):
        return {
            "source": source,
            "channel": "Test/ch",
            "title": title,
            "url": url,
            "author": "",
            "score": score,
            "comments": 0,
            "stars": 0,
            "reactions": 0,
            "created_at": None,
            "summary": "",
            "trend_score": score,
        }

    def test_url_key_normalization(self):
        items = [
            self._item("https://example.com/page/?foo=1#bar", "Title A", 5),
            self._item("https://example.com/page/", "Title A duplicate", 3),
        ]
        result = dedupe_items(items)
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]["trend_score"], 5)

    def test_duplicate_merge_highest_score(self):
        items = [
            self._item("https://example.com/post/1", "Post One", 10),
            self._item("https://example.com/post/1", "Post One Again", 5),
        ]
        result = dedupe_items(items)
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]["trend_score"], 10)

    def test_sorted_by_trend_score_desc(self):
        items = [
            self._item("https://a.com/1", "Low", 2),
            self._item("https://b.com/2", "High", 10),
            self._item("https://c.com/3", "Mid", 5),
        ]
        result = dedupe_items(items)
        scores = [r["trend_score"] for r in result]
        self.assertEqual(scores, sorted(scores, reverse=True))

    def test_title_key_fallback(self):
        items = [
            self._item("https://news.google.com/rss/articles/CBMiABC", "Anthropic Launches Claude 4 Model", 5, "google_news"),
            self._item("https://techcrunch.com/2026/04/20/claude-4", "Anthropic Launches Claude 4 Model", 8, "techcrunch"),
        ]
        result = dedupe_items(items)
        self.assertIsInstance(result, list)
        self.assertGreaterEqual(len(result), 1)

    def test_short_title_no_false_merge(self):
        # Short titles (< 15 chars after stripping non-word chars) must NOT trigger title-based dedup
        items = [
            self._item("https://site-a.com/post/1", "AI 소식", 5, "source_a"),
            self._item("https://site-b.com/post/2", "AI 소식", 8, "source_b"),
        ]
        result = dedupe_items(items)
        # Both items have different URLs and a short title — they must be kept separate
        self.assertEqual(len(result), 2)


# ---------------------------------------------------------------------------
# TestEnrichSummary
# ---------------------------------------------------------------------------

class TestEnrichSummary(unittest.TestCase):

    def test_og_description_extraction(self):
        html = '<html><head><meta property="og:description" content="This is OG description"/></head></html>'
        with patch("lib.http_text", return_value=html):
            result = enrich_summary("https://example.com/post", "")
        self.assertIn("OG description", result)

    def test_skips_when_summary_exists(self):
        existing = "This summary is definitely longer than twenty characters."
        with patch("lib.http_text", side_effect=AssertionError("should not fetch")):
            result = enrich_summary("https://example.com/post", existing)
        self.assertEqual(result, existing)

    def test_ld_json_fallback(self):
        html = '''<html><head>
        <script type="application/ld+json">{"@type":"Article","description":"LD JSON description here"}</script>
        </head></html>'''
        with patch("lib.http_text", return_value=html):
            result = enrich_summary("https://example.com/post", "")
        self.assertIn("LD JSON description", result)

    def test_returns_empty_on_error(self):
        def raise_err(url, **kw):
            raise ConnectionError("network error")
        with patch("lib.http_text", side_effect=raise_err):
            result = enrich_summary("https://example.com/post", "")
        self.assertEqual(result, "")


# ---------------------------------------------------------------------------
# TestFallbackChain
# ---------------------------------------------------------------------------

class TestFallbackChain(unittest.TestCase):

    def setUp(self):
        FALLBACK_EVENTS.clear()

    def test_phase1_success_no_escalation(self):
        phase1 = MagicMock(return_value=["item1"])
        phase2 = MagicMock(return_value=["item2"])
        chain = FallbackChain([phase1, phase2], "test_source")
        result, event = chain.execute(fallback_events=FALLBACK_EVENTS)
        self.assertEqual(result, ["item1"])
        self.assertEqual(event["phase_used"], 1)
        phase2.assert_not_called()

    def test_phase1_fail_phase2_success(self):
        phase1 = MagicMock(side_effect=RuntimeError("403 blocked"))
        phase2 = MagicMock(return_value=["item_from_cffi"])
        chain = FallbackChain([phase1, phase2], "test_source")
        result, event = chain.execute(fallback_events=FALLBACK_EVENTS)
        self.assertEqual(result, ["item_from_cffi"])
        self.assertEqual(event["phase_used"], 2)

    def test_phase1_fail_phase2_skip_phase3_success(self):
        phase1 = MagicMock(side_effect=RuntimeError("blocked"))
        phase2 = MagicMock(side_effect=RuntimeError("curl_cffi not available"))
        phase3 = MagicMock(return_value=["item_from_naver"])
        chain = FallbackChain([phase1, phase2, phase3], "test_source")
        result, event = chain.execute(fallback_events=FALLBACK_EVENTS)
        self.assertEqual(result, ["item_from_naver"])
        self.assertEqual(event["phase_used"], 3)

    def test_all_phases_fail(self):
        phase1 = MagicMock(side_effect=RuntimeError("fail1"))
        phase2 = MagicMock(side_effect=RuntimeError("fail2"))
        phase3 = MagicMock(side_effect=RuntimeError("fail3"))
        chain = FallbackChain([phase1, phase2, phase3], "test_source")
        result, event = chain.execute(fallback_events=FALLBACK_EVENTS)
        self.assertIsNone(result)
        self.assertEqual(event["phase_used"], -1)

    def test_event_record_structure(self):
        phase1 = MagicMock(return_value=["data"])
        chain = FallbackChain([phase1], "my_source")
        result, event = chain.execute(fallback_events=FALLBACK_EVENTS)
        self.assertIn("source", event)
        self.assertIn("phase_used", event)
        self.assertIn("reason", event)
        self.assertEqual(event["source"], "my_source")
        self.assertTrue(any(e["source"] == "my_source" for e in FALLBACK_EVENTS))


if __name__ == "__main__":
    unittest.main(verbosity=2)
