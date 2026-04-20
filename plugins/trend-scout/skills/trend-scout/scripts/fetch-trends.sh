#!/usr/bin/env bash
set -euo pipefail

PERIOD="${1:-day}"
LIMIT="${2:-10}"
OUTDIR="${TREND_SCOUT_OUTDIR:-/tmp/trend-scout}"

mkdir -p "$OUTDIR"

python3 - "$PERIOD" "$LIMIT" "$OUTDIR" <<'PY'
import datetime as dt
import email.utils
import html
import json
import math
import os
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from html.parser import HTMLParser

PERIOD = sys.argv[1]
LIMIT = max(1, int(sys.argv[2]))
OUTDIR = sys.argv[3]
NOW = dt.datetime.now(dt.timezone.utc)
DAYS = 7 if PERIOD == "week" else 1
CUTOFF = NOW - dt.timedelta(days=DAYS)
CUTOFF_DATE = CUTOFF.date().isoformat()
CUTOFF_TS = int(CUTOFF.timestamp())
MOBILE_UA = (
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) "
    "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 "
    "Mobile/15E148 Safari/604.1"
)
BROWSER_UA = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/135.0.0.0 Safari/537.36"
)
NAVER_HEADERS = {
    "User-Agent": BROWSER_UA,
    "Accept-Language": "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7",
    "Referer": "https://www.naver.com/",
}
RSS_HEADERS = {
    "User-Agent": BROWSER_UA,
    "Accept": "application/rss+xml, application/atom+xml, application/xml;q=0.9, text/xml;q=0.8",
}
SUBREDDITS = [
    "Solopreneur",
    "indiehackers",
    "SaaS",
    "Entrepreneur",
    "ClaudeAI",
    "ChatGPT",
    "nextjs",
    "GeminiAI",
]
GITHUB_TOPICS = [
    {"label": "ai", "topic": "ai"},
    {"label": "developer-tools", "topic": "developer-tools"},
    {"label": "productivity", "topic": "productivity"},
]
STACKOVERFLOW_TAGS = ["openai-api", "artificial-intelligence", "reactjs"]
NPM_QUERIES = ["mcp", "ai sdk", "agent framework", "browser automation"]
V2EX_NODES = ["openai", "python", "programmer"]
BLUESKY_HANDLES = [
    {"channel": "Bluesky/Vercel", "handle": "vercel.com"},
    {"channel": "Bluesky/Supabase", "handle": "supabase.com"},
    {"channel": "Bluesky/Cloudflare", "handle": "cloudflare.social"},
    {"channel": "Bluesky/Anthropic", "handle": "anthropic.com"},
]
MASTODON_TIMELINES = [
    {"channel": "Mastodon/AI", "url": "https://hachyderm.io/api/v1/timelines/tag/ai?limit=10"},
    {"channel": "Mastodon/OpenSource", "url": "https://hachyderm.io/api/v1/timelines/tag/opensource?limit=10"},
    {"channel": "Mastodon/Security", "url": "https://hachyderm.io/api/v1/timelines/tag/security?limit=10"},
]
CLIEN_SOURCES = [
    {
        "channel": "Clien/새로운소식",
        "url": "https://www.clien.net/service/board/news",
        "pattern": r"/service/board/news/\d+",
        "require_theme": False,
    },
    {
        "channel": "Clien/개발한당",
        "url": "https://www.clien.net/service/board/cm_app",
        "pattern": r"/service/board/cm_app/\d+",
        "require_theme": False,
    },
    {
        "channel": "Clien/AI당",
        "url": "https://www.clien.net/service/board/cm_ai",
        "pattern": r"/service/board/cm_ai/\d+",
        "require_theme": False,
    },
]
RULIWEB_SOURCES = [
    {
        "channel": "Ruliweb/PC정보",
        "url": "https://bbs.ruliweb.com/community/board/300006",
        "pattern": r"/community/board/300006/read/\d+",
        "require_theme": False,
    },
    {
        "channel": "Ruliweb/애플정보",
        "url": "https://bbs.ruliweb.com/community/board/300008",
        "pattern": r"/community/board/300008/read/\d+",
        "require_theme": False,
    },
]
YOZM_FEEDS = [
    {"channel": "Yozm/all", "url": "https://yozm.wishket.com/magazine/feed/"},
    {"channel": "Yozm/ai", "url": "https://yozm.wishket.com/magazine/ai/feed/"},
]
GOOGLE_NEWS_FEEDS = [
    {
        "channel": "GoogleNews/tech-ko",
        "url": "https://news.google.com/rss/headlines/section/topic/TECHNOLOGY?hl=ko&gl=KR&ceid=KR:ko",
    }
]
NAVER_BLOG_QUERIES = [
    "AI 개발자 도구",
    "클로드 코드",
    "오픈소스 AI",
    "SaaS 자동화",
]
FMKOREA_SEARCH_QUERIES = [
    "에펨코리아 디지털 AI",
    "에펨코리아 디지털 오픈소스",
    "에펨코리아 디지털 클로드",
]
SOURCE_WEIGHTS = {
    "reddit": 1.0,
    "hackernews": 1.25,
    "lobsters": 1.15,
    "devto": 0.95,
    "github": 1.1,
    "stackoverflow": 0.95,
    "npm": 0.55,
    "bluesky": 0.8,
    "mastodon": 0.65,
    "geeknews": 1.1,
    "yozm": 1.0,
    "google_news": 0.85,
    "naver_blog": 0.95,
    "clien": 0.95,
    "ruliweb": 0.9,
    "ppomppu": 0.8,
    "dcinside": 0.8,
    "fmkorea": 0.8,
    "v2ex": 0.85,
    "arxiv": 0.8,
}
SPAM_PATTERNS = [
    r"\bhiring\b",
    r"\bfor hire\b",
    r"\bcofounder\b",
    r"\bjob\b",
    r"\blooking for\b",
    r"\bnewsletter\b",
    r"^\s*공지",
    r"^\s*창당",
    r"^\s*입당",
    r"^\s*홍보",
]
REDDIT_RELAXED_SUBS = {"ClaudeAI", "GeminiAI", "nextjs"}
TITLE_EXCLUDE_PATTERNS = [
    r"행동강령",
    r"등록 방법",
    r"업데이트 중지 안내",
    r"기념품 변경 안내",
    r"창당 인사",
    r"홍보에 관한 공지",
]
SIGNAL_KEYWORDS = [
    "mrr",
    "arr",
    "revenue",
    "profit",
    "launch",
    "launched",
    "users",
    "growth",
    "pricing",
    "open source",
    "opensource",
    "agent",
    "workflow",
    "api",
    "benchmark",
    "security",
    "postmortem",
    "show hn",
    "show gn",
    "case study",
    "github",
    "vercel",
    "openai",
    "anthropic",
    "gemini",
    "claude",
    "chatgpt",
    "codex",
    "startup",
    "saas",
    "developer",
    "devtool",
    "productivity",
    "automation",
    "browser",
    "database",
    "frontend",
    "backend",
    "cli",
    "framework",
    "typescript",
    "javascript",
    "react",
    "next.js",
    "nextjs",
    "infra",
    "cloud",
    "llm",
    "gpu",
    "chip",
    "memory",
    "agentic",
    "에이전트",
    "오픈소스",
    "개발",
    "개발자",
    "스타트업",
    "창업",
    "자동화",
    "보안",
    "반도체",
    "메모리",
    "클로드",
    "코덱스",
    "제미나이",
    "챗gpt",
    "버셀",
    "바이브 코딩",
    "바이브코딩",
    "llm",
    "ai",
    "saas",
]
THEME_HOSTS = [
    "github.com",
    "vercel.com",
    "openai.com",
    "anthropic.com",
    "supabase.com",
    "cloudflare.com",
    "render.com",
    "cursor.com",
    "claude.ai",
    "news.hada.io",
    "yozm.wishket.com",
    "stackoverflow.com",
    "stackexchange.com",
]
DEVTO_THEME_TAGS = {
    "ai",
    "webdev",
    "opensource",
    "productivity",
    "programming",
    "javascript",
    "typescript",
    "react",
    "nextjs",
    "startup",
    "saas",
    "devops",
}
ERRORS = []
FALLBACK_EVENTS = []

TREND_SCOUT_TIMEOUT_PER_SOURCE = int(os.environ.get("TREND_SCOUT_TIMEOUT_PER_SOURCE", "30"))
TREND_SCOUT_TIMEOUT_TOTAL = int(os.environ.get("TREND_SCOUT_TIMEOUT_TOTAL", "240"))
TREND_SCOUT_ENRICH = os.environ.get("TREND_SCOUT_ENRICH", "1") != "0"


def has_curl_cffi():
    try:
        import curl_cffi  # noqa: F401
        return True
    except ImportError:
        return False


def curl_cffi_request(url, headers, impersonate="safari"):
    from curl_cffi import requests as cffi_requests
    impersonation_order = ["safari", "chrome", "firefox"]
    if impersonate in impersonation_order:
        impersonation_order = [impersonate] + [x for x in impersonation_order if x != impersonate]
    last_exc = None
    for browser in impersonation_order:
        try:
            resp = cffi_requests.get(url, headers=headers, impersonate=browser, timeout=TREND_SCOUT_TIMEOUT_PER_SOURCE)
            return resp.text
        except Exception as exc:
            last_exc = exc
    raise last_exc


def classify_failure(exc, response_body="", status_code=None):
    if status_code == 403:
        return "blocked_403"
    if status_code == 429:
        return "rate_limited_429"
    if response_body:
        if "cf-browser-verification" in response_body or "challenge-platform" in response_body:
            return "waf_challenge"
        if len(response_body) < 500 and "<script" in response_body and not re.search(r">[^<]{10,}<", response_body):
            return "empty_spa"
    exc_str = str(type(exc).__name__).lower() if exc else ""
    if "timeout" in exc_str or (exc and "timed out" in str(exc).lower()):
        return "timeout"
    return "unknown"


class FallbackChain:
    def __init__(self, phases, source_name):
        self.phases = phases
        self.source_name = source_name

    def execute(self, **kwargs):
        last_reason = "unknown"
        for phase_index, phase_fn in enumerate(self.phases, start=1):
            try:
                result = phase_fn(**kwargs)
                if result is not None:
                    event = {"source": self.source_name, "phase_used": phase_index, "reason": "ok"}
                    FALLBACK_EVENTS.append(event)
                    return result, event
                last_reason = "empty_result"
            except Exception as exc:
                last_reason = classify_failure(exc)
                if phase_index < len(self.phases):
                    continue
        event = {"source": self.source_name, "phase_used": -1, "reason": last_reason}
        FALLBACK_EVENTS.append(event)
        return None, event


class LinkExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []
        self._href = None
        self._text = []

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            self._href = dict(attrs).get("href")
            self._text = []

    def handle_data(self, data):
        if self._href is not None:
            self._text.append(data)

    def handle_endtag(self, tag):
        if tag == "a" and self._href is not None:
            text = clean_text(" ".join(self._text))
            if text and self._href:
                self.links.append((text, self._href))
            self._href = None
            self._text = []


def eprint(message):
    print(message, file=sys.stderr)


def unique_preserve(values):
    seen = set()
    ordered = []
    for value in values:
        if value in seen:
            continue
        seen.add(value)
        ordered.append(value)
    return ordered


def write_json(name, payload):
    path = os.path.join(OUTDIR, name)
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(payload, handle, ensure_ascii=False, indent=2)


def run_command(args):
    return subprocess.run(args, capture_output=True, text=True, check=False)


def curl_json(url, headers=None):
    headers = headers or {}
    command = ["curl", "-sSL", "--compressed", "--max-time", "20"]
    for key, value in headers.items():
        command.extend(["-H", f"{key}: {value}"])
    command.append(url)
    completed = run_command(command)
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr.strip() or f"curl failed for {url}")
    try:
        return json.loads(completed.stdout)
    except json.JSONDecodeError as exc:
        snippet = completed.stdout[:180].replace("\n", " ")
        raise RuntimeError(f"non-json response from {url}: {snippet}") from exc


def http_json(url, headers=None):
    request = urllib.request.Request(url, headers=headers or {})
    with urllib.request.urlopen(request, timeout=20) as response:
        return json.load(response)


def decode_body(raw, header_charset=None, fallback_encodings=None):
    fallback_encodings = fallback_encodings or []
    encodings = []
    if header_charset:
        encodings.append(header_charset)
    meta_match = re.search(rb"charset=['\"]?([A-Za-z0-9._-]+)", raw[:4096], re.I)
    if meta_match:
        encodings.append(meta_match.group(1).decode("ascii", "ignore"))
    encodings.extend(fallback_encodings)
    encodings.extend(["utf-8", "euc-kr", "cp949", "latin-1"])
    for encoding in unique_preserve([enc for enc in encodings if enc]):
        try:
            return raw.decode(encoding)
        except (LookupError, UnicodeDecodeError):
            continue
    return raw.decode("utf-8", "ignore")


def http_text(url, headers=None, fallback_encodings=None):
    request = urllib.request.Request(url, headers=headers or {})
    with urllib.request.urlopen(request, timeout=20) as response:
        raw = response.read()
        return decode_body(
            raw,
            header_charset=response.headers.get_content_charset(),
            fallback_encodings=fallback_encodings,
        )


def clean_text(text):
    if not text:
        return ""
    compact = html.unescape(text)
    compact = re.sub(r"<[^>]+>", " ", compact)
    compact = re.sub(r"\s+", " ", compact).strip()
    return compact


def clean_title(title):
    value = clean_text(title)
    value = re.sub(r"^\[[^\]]+\]\s*", "", value)
    value = re.sub(r"^(자유|후기|질문|담소|모공|새소식|유용한|사용기|강좌|사게|장터|직홍게|정보|루머)\s+", "", value)
    value = re.sub(r"^(?:·|-|•)\s*", "", value)
    return value.strip()


def summarize(text, limit=220):
    compact = clean_text(text)
    if len(compact) <= limit:
        return compact
    return compact[: limit - 1].rstrip() + "…"


def parse_iso(value):
    if not value:
        return None
    fixed = value.replace("Z", "+00:00")
    try:
        parsed = dt.datetime.fromisoformat(fixed)
    except ValueError:
        return None
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=dt.timezone.utc)
    return parsed.astimezone(dt.timezone.utc)


def parse_datetime(value):
    parsed = parse_iso(value)
    if parsed:
        return parsed
    try:
        parsed = email.utils.parsedate_to_datetime(value)
    except (TypeError, ValueError, IndexError, OverflowError):
        return None
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=dt.timezone.utc)
    return parsed.astimezone(dt.timezone.utc)


def iso_from_epoch(value):
    if value in (None, ""):
        return None
    try:
        return dt.datetime.fromtimestamp(float(value), tz=dt.timezone.utc).isoformat()
    except (TypeError, ValueError, OSError):
        return None


def extract_links(html_text, base_url):
    parser = LinkExtractor()
    parser.feed(html_text)
    seen = set()
    links = []
    for text, href in parser.links:
        href = urllib.parse.urljoin(base_url, href)
        href = href.strip()
        if not href or href.startswith("javascript:"):
            continue
        key = (text, href)
        if key in seen:
            continue
        seen.add(key)
        links.append((text, href))
    return links


def extract_meta_content(html_text, field):
    patterns = [
        rf'<meta[^>]+property=["\']{re.escape(field)}["\'][^>]+content=["\']([^"\']+)["\']',
        rf'<meta[^>]+content=["\']([^"\']+)["\'][^>]+property=["\']{re.escape(field)}["\']',
        rf'<meta[^>]+name=["\']{re.escape(field)}["\'][^>]+content=["\']([^"\']+)["\']',
        rf'<meta[^>]+content=["\']([^"\']+)["\'][^>]+name=["\']{re.escape(field)}["\']',
    ]
    for pattern in patterns:
        match = re.search(pattern, html_text, re.I)
        if match:
            return clean_text(match.group(1))
    return ""


def extract_ld_json(html_text):
    match = re.search(r'<script[^>]+type=["\']application/ld\+json["\'][^>]*>(.*?)</script>', html_text, re.S | re.I)
    if not match:
        return {}
    try:
        data = json.loads(match.group(1))
        if isinstance(data, list):
            data = data[0] if data else {}
        return {
            "name": data.get("name", "") or data.get("headline", ""),
            "description": data.get("description", ""),
            "author": (data.get("author") or {}).get("name", "") if isinstance(data.get("author"), dict) else str(data.get("author", "")),
        }
    except (json.JSONDecodeError, AttributeError):
        return {}


def enrich_summary(url, current_summary=""):
    if current_summary and len(current_summary) > 20:
        return current_summary
    try:
        html_body = http_text(url, headers={"User-Agent": BROWSER_UA}, fallback_encodings=["utf-8", "euc-kr", "cp949"])
        og_desc = extract_meta_content(html_body, "og:description")
        if og_desc:
            return summarize(og_desc)
        meta_desc = extract_meta_content(html_body, "description")
        if meta_desc:
            return summarize(meta_desc)
        ld = extract_ld_json(html_body)
        if ld.get("description"):
            return summarize(ld["description"])
        og_title = extract_meta_content(html_body, "og:title")
        if og_title:
            return summarize(og_title)
    except Exception:
        pass
    return current_summary


def _batch_enrich(items, cap=3):
    if not TREND_SCOUT_ENRICH:
        return items
    import concurrent.futures
    to_enrich = [(i, item) for i, item in enumerate(items) if not item.get("summary") or len(item.get("summary", "")) <= 20]
    to_enrich = to_enrich[:cap]
    if not to_enrich:
        return items
    def do_enrich(idx_item):
        idx, item = idx_item
        return idx, enrich_summary(item["url"], item.get("summary", ""))
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
        futures = {executor.submit(do_enrich, x): x for x in to_enrich}
        for future in concurrent.futures.as_completed(futures, timeout=TREND_SCOUT_TIMEOUT_TOTAL):
            try:
                idx, enriched = future.result()
                items[idx] = dict(items[idx], summary=enriched)
            except Exception:
                pass
    return items


def title_excluded(title):
    lowered = clean_text(title).lower()
    return any(re.search(pattern, lowered, re.I) for pattern in TITLE_EXCLUDE_PATTERNS)


def looks_spam(title, summary=""):
    blob = f"{title} {summary}".lower()
    if not title or title.lower() in {"[deleted]", "[removed]"}:
        return True
    for pattern in SPAM_PATTERNS:
        if re.search(pattern, blob):
            return True
    return False


def has_signal_text(title, summary=""):
    blob = f"{title} {summary}".lower()
    if re.search(r"\d", blob):
        return True
    return any(keyword in blob for keyword in SIGNAL_KEYWORDS)


def url_has_theme_signal(url):
    lowered = (url or "").lower()
    return any(host in lowered for host in THEME_HOSTS)


def matches_theme_signal(title, summary="", url=""):
    return has_signal_text(title, summary) or url_has_theme_signal(url)


def reddit_score_floor(subreddit):
    return 5 if subreddit in REDDIT_RELAXED_SUBS else 10


def reddit_has_substance(subreddit, data):
    title = data.get("title", "")
    summary = data.get("selftext", "") or ""
    domain = (data.get("domain") or "").lower()
    if data.get("score", 0) < reddit_score_floor(subreddit):
        return False
    if data.get("is_gallery") or data.get("is_video"):
        return False
    if data.get("post_hint") in {"image", "hosted:video", "rich:video"}:
        return False
    if len(summary.strip()) >= 120:
        return True
    if has_signal_text(title, summary):
        return True
    if domain and domain not in {
        "reddit.com",
        "www.reddit.com",
        "i.redd.it",
        "v.redd.it",
        "self." + subreddit.lower(),
    }:
        return True
    return False


def freshness_bonus(created_at):
    parsed = parse_iso(created_at)
    if not parsed:
        return 0.0
    age_hours = max(0.0, (NOW - parsed).total_seconds() / 3600)
    max_window = 24.0 * DAYS
    if age_hours >= max_window:
        return 0.0
    return round((max_window - age_hours) * 0.12, 2)


def trend_score(source, score=0, comments=0, stars=0, reactions=0, created_at=None):
    base = (
        float(score)
        + (float(comments) * 0.35)
        + (float(reactions) * 0.2)
        + math.log10(max(float(stars), 1.0)) * 18.0
        + freshness_bonus(created_at)
    )
    return round(base * SOURCE_WEIGHTS.get(source, 1.0), 2)


def normalized_item(
    *,
    source: str,
    channel: str,
    title: str,
    url: str,
    author: str = "",
    score=0,
    comments=0,
    stars=0,
    reactions=0,
    created_at=None,
    summary="",
    extra=None,
):
    item = {
        "source": source,
        "channel": channel,
        "title": clean_title(title),
        "url": url,
        "author": clean_text(author),
        "score": score,
        "comments": comments,
        "stars": stars,
        "reactions": reactions,
        "created_at": created_at,
        "summary": summarize(summary),
    }
    item["trend_score"] = trend_score(
        source,
        score=score,
        comments=comments,
        stars=stars,
        reactions=reactions,
        created_at=created_at,
    )
    if extra:
        item["extra"] = extra
    return item


def dedupe_items(items):
    deduped = {}
    for item in items:
        url_key = re.sub(r"[?#].*$", "", item["url"]).rstrip("/").lower()
        title_key = re.sub(r"\W+", "", item["title"]).lower()
        key = url_key or title_key
        existing = deduped.get(key)
        if not existing or item["trend_score"] > existing["trend_score"]:
            deduped[key] = item
    return sorted(
        deduped.values(),
        key=lambda entry: (
            entry["trend_score"],
            parse_iso(entry.get("created_at")) or dt.datetime(1970, 1, 1, tzinfo=dt.timezone.utc),
        ),
        reverse=True,
    )


def position_score(index, ceiling=18):
    return max(1, ceiling - index)


def is_counter_text(text):
    cleaned = clean_text(text)
    if not cleaned:
        return True
    if re.fullmatch(r"[\[\(]?\d+(?:/\d+)?[\]\)]?", cleaned):
        return True
    return len(cleaned) <= 1


def parse_feed_entries(url):
    xml_text = http_text(url, headers=RSS_HEADERS)
    root = ET.fromstring(xml_text)
    entries = []
    if root.tag.endswith("rss"):
        for item in root.findall("./channel/item"):
            entries.append(
                {
                    "title": clean_text(item.findtext("title") or ""),
                    "url": clean_text(item.findtext("link") or ""),
                    "summary": clean_text(item.findtext("description") or ""),
                    "published": (
                        parse_datetime(item.findtext("pubDate") or "").isoformat()
                        if parse_datetime(item.findtext("pubDate") or "")
                        else None
                    ),
                }
            )
        return entries
    atom_ns = {"atom": "http://www.w3.org/2005/Atom"}
    for entry in root.findall("atom:entry", atom_ns):
        link = ""
        for link_node in entry.findall("atom:link", atom_ns):
            href = link_node.attrib.get("href")
            rel = link_node.attrib.get("rel", "alternate")
            if href and rel == "alternate":
                link = href
                break
            if href and not link:
                link = href
        published = (
            entry.findtext("atom:updated", "", atom_ns)
            or entry.findtext("atom:published", "", atom_ns)
        )
        entries.append(
            {
                "title": clean_text(entry.findtext("atom:title", "", atom_ns)),
                "url": clean_text(link),
                "summary": clean_text(
                    entry.findtext("atom:summary", "", atom_ns)
                    or entry.findtext("atom:content", "", atom_ns)
                ),
                "published": parse_datetime(published).isoformat() if parse_datetime(published) else None,
            }
        )
    return entries


def extract_page_candidates(url, pattern, source_headers=None, fallback_encodings=None):
    html_text = http_text(url, headers=source_headers or {"User-Agent": BROWSER_UA}, fallback_encodings=fallback_encodings)
    matches = []
    for text, href in extract_links(html_text, url):
        href_key = href.split("#", 1)[0]
        if not re.search(pattern, href_key):
            continue
        title = clean_title(text)
        if is_counter_text(title) or looks_spam(title) or title_excluded(title):
            continue
        matches.append({"title": title, "url": href_key})
    ordered = []
    seen = set()
    for match in matches:
        key = (match["title"], match["url"])
        if key in seen:
            continue
        seen.add(key)
        ordered.append(match)
    return ordered


def naver_blog_to_mobile(url):
    match = re.search(r"https?://blog\.naver\.com/([^/]+)/([0-9]+)", url)
    if not match:
        return None
    return (
        "https://m.blog.naver.com/PostView.naver?"
        f"blogId={match.group(1)}&logNo={match.group(2)}"
    )


def fetch_reddit():
    eprint(f"Fetching Reddit ({len(SUBREDDITS)} subs)...")
    raw = {}
    items = []
    headers = {
        "User-Agent": MOBILE_UA,
        "Accept": "application/json",
        "Accept-Language": "en-US,en;q=0.9",
    }
    for subreddit in SUBREDDITS:
        url = f"https://www.reddit.com/r/{subreddit}/top.json?t={PERIOD}&limit={LIMIT}"
        try:
            payload = curl_json(url, headers=headers)
            raw[subreddit] = payload
        except Exception as exc:
            ERRORS.append(f"reddit:{subreddit}: {exc}")
            raw[subreddit] = {"error": str(exc)}
            continue
        for child in payload.get("data", {}).get("children", []):
            data = child.get("data", {})
            title = data.get("title", "")
            summary = data.get("selftext", "") or ""
            if looks_spam(title, summary):
                continue
            if not reddit_has_substance(subreddit, data):
                continue
            items.append(
                normalized_item(
                    source="reddit",
                    channel=f"r/{subreddit}",
                    title=title,
                    url=f"https://reddit.com{data.get('permalink', '')}",
                    author=data.get("author", ""),
                    score=data.get("score", 0),
                    comments=data.get("num_comments", 0),
                    created_at=iso_from_epoch(data.get("created_utc")),
                    summary=summary,
                )
            )
        time.sleep(0.25)
    write_json("reddit.json", raw)
    return items


def fetch_hackernews():
    eprint("Fetching Hacker News...")
    raw = {"lists": {}, "stories": []}
    items = []
    story_ids = []
    for list_name in ("topstories", "beststories"):
        try:
            ids = http_json(f"https://hacker-news.firebaseio.com/v0/{list_name}.json")
            raw["lists"][list_name] = ids[: LIMIT * 2]
            story_ids.extend(ids[: LIMIT * 2])
        except Exception as exc:
            ERRORS.append(f"hackernews:{list_name}: {exc}")
            raw["lists"][list_name] = {"error": str(exc)}
    ordered_ids = []
    seen = set()
    for story_id in story_ids:
        if story_id in seen:
            continue
        seen.add(story_id)
        ordered_ids.append(story_id)
    for story_id in ordered_ids[: LIMIT * 2]:
        try:
            data = http_json(f"https://hacker-news.firebaseio.com/v0/item/{story_id}.json")
        except Exception as exc:
            ERRORS.append(f"hackernews:item:{story_id}: {exc}")
            continue
        if not data or data.get("type") != "story":
            continue
        raw["stories"].append(data)
        title = data.get("title", "")
        if looks_spam(title):
            continue
        if data.get("score", 0) < 50:
            continue
        if not matches_theme_signal(title, data.get("text", ""), data.get("url", "")):
            continue
        items.append(
            normalized_item(
                source="hackernews",
                channel="hn/front-page",
                title=title,
                url=data.get("url") or f"https://news.ycombinator.com/item?id={story_id}",
                author=data.get("by", ""),
                score=data.get("score", 0),
                comments=data.get("descendants", 0),
                created_at=iso_from_epoch(data.get("time")),
                summary=data.get("text", ""),
                extra={"hn_url": f"https://news.ycombinator.com/item?id={story_id}"},
            )
        )
    write_json("hackernews.json", raw)
    return items


def fetch_lobsters():
    eprint("Fetching Lobsters...")
    items = []
    try:
        payload = curl_json("https://lobste.rs/hottest.json", headers={"User-Agent": BROWSER_UA})
    except Exception as exc:
        ERRORS.append(f"lobsters: {exc}")
        write_json("lobsters.json", {"error": str(exc)})
        return items
    for entry in payload[: LIMIT]:
        title = entry.get("title", "")
        if looks_spam(title, entry.get("description_plain", "")):
            continue
        if entry.get("score", 0) < 8:
            continue
        items.append(
            normalized_item(
                source="lobsters",
                channel="lobste.rs/hottest",
                title=title,
                url=entry.get("url") or entry.get("comments_url", ""),
                author=entry.get("submitter_user", ""),
                score=entry.get("score", 0),
                comments=entry.get("comment_count", 0),
                created_at=parse_iso(entry.get("created_at")).isoformat() if parse_iso(entry.get("created_at")) else None,
                summary=entry.get("description_plain", ""),
                extra={"comments_url": entry.get("comments_url", ""), "tags": entry.get("tags", [])},
            )
        )
    write_json("lobsters.json", payload)
    return items


def fetch_devto():
    eprint("Fetching dev.to...")
    url = f"https://dev.to/api/articles?top={7 if PERIOD == 'week' else 2}&per_page={LIMIT}"
    items = []
    try:
        payload = curl_json(
            url,
            headers={
                "User-Agent": BROWSER_UA,
                "Accept": "application/json",
                "Referer": "https://dev.to/",
            },
        )
    except Exception as exc:
        ERRORS.append(f"devto: {exc}")
        write_json("devto.json", {"error": str(exc)})
        return items
    for entry in payload:
        title = entry.get("title", "")
        if looks_spam(title, entry.get("description", "")):
            continue
        if entry.get("public_reactions_count", 0) < 20:
            continue
        tags = entry.get("tag_list", []) or entry.get("tags", "")
        if isinstance(tags, str):
            tags = [part.strip().lower() for part in tags.split(",") if part.strip()]
        tags = [tag.lower() for tag in tags]
        if not (
            matches_theme_signal(title, entry.get("description", ""), entry.get("url", ""))
            or DEVTO_THEME_TAGS.intersection(tags)
        ):
            continue
        items.append(
            normalized_item(
                source="devto",
                channel="dev.to/top",
                title=title,
                url=entry.get("url", ""),
                author=(entry.get("user") or {}).get("name", ""),
                score=entry.get("public_reactions_count", 0),
                comments=entry.get("comments_count", 0),
                reactions=entry.get("positive_reactions_count", 0),
                created_at=parse_iso(entry.get("published_timestamp")).isoformat()
                if parse_iso(entry.get("published_timestamp"))
                else None,
                summary=entry.get("description", ""),
                extra={"tags": tags},
            )
        )
    write_json("devto.json", payload)
    return items


def github_star_floor():
    return ">20" if PERIOD == "week" else ">5"


def fetch_github_with_gh():
    raw = {}
    items = []
    for topic in GITHUB_TOPICS:
        command = [
            "gh",
            "search",
            "repos",
            "--topic",
            topic["topic"],
            "--created",
            f">{CUTOFF_DATE}",
            "--stars",
            github_star_floor(),
            "--sort",
            "stars",
            "--order",
            "desc",
            "--limit",
            str(LIMIT),
            "--json",
            "name,owner,description,stargazersCount,url,updatedAt,createdAt",
        ]
        completed = run_command(command)
        if completed.returncode != 0:
            raise RuntimeError(completed.stderr.strip() or f"gh search failed for {topic['topic']}")
        data = json.loads(completed.stdout or "[]")
        raw[topic["label"]] = data
        for repo in data:
            title = f"{repo['owner']['login']}/{repo['name']}"
            summary = repo.get("description", "") or ""
            if looks_spam(title, summary):
                continue
            items.append(
                normalized_item(
                    source="github",
                    channel=f"GitHub/{topic['topic']}",
                    title=title,
                    url=repo.get("url", ""),
                    author=repo["owner"]["login"],
                    stars=repo.get("stargazersCount", 0),
                    created_at=parse_iso(repo.get("createdAt")).isoformat()
                    if parse_iso(repo.get("createdAt"))
                    else None,
                    summary=summary,
                    extra={"updated_at": repo.get("updatedAt")},
                )
            )
    write_json("github.json", raw)
    return items


def fetch_github_with_rest():
    raw = {}
    items = []
    for topic in GITHUB_TOPICS:
        query = urllib.parse.quote_plus(
            f"topic:{topic['topic']} created:>{CUTOFF_DATE} stars:{github_star_floor()} archived:false"
        )
        url = (
            "https://api.github.com/search/repositories?"
            f"q={query}&sort=stars&order=desc&per_page={LIMIT}"
        )
        payload = curl_json(
            url,
            headers={
                "User-Agent": "trend-scout/1.2.0",
                "Accept": "application/vnd.github+json",
            },
        )
        raw[topic["label"]] = payload
        for repo in payload.get("items", []):
            title = repo.get("full_name", "")
            summary = repo.get("description", "") or ""
            if looks_spam(title, summary):
                continue
            items.append(
                normalized_item(
                    source="github",
                    channel=f"GitHub/{topic['topic']}",
                    title=title,
                    url=repo.get("html_url", ""),
                    author=(repo.get("owner") or {}).get("login", ""),
                    stars=repo.get("stargazers_count", 0),
                    created_at=parse_iso(repo.get("created_at")).isoformat()
                    if parse_iso(repo.get("created_at"))
                    else None,
                    summary=summary,
                    extra={"updated_at": repo.get("updated_at")},
                )
            )
    write_json("github.json", raw)
    return items


def fetch_github():
    eprint("Fetching GitHub launch radar...")
    gh = run_command(["gh", "auth", "status"])
    try:
        if gh.returncode == 0:
            return fetch_github_with_gh()
        ERRORS.append("github: gh auth unavailable, using REST fallback")
        return fetch_github_with_rest()
    except Exception as exc:
        ERRORS.append(f"github: {exc}")
        return []


def fetch_stackoverflow():
    eprint("Fetching Stack Overflow...")
    raw = {}
    items = []
    score_floor = 5 if PERIOD == "week" else 3
    for tag in STACKOVERFLOW_TAGS:
        url = (
            "https://api.stackexchange.com/2.3/questions?"
            f"order=desc&sort=votes&tagged={urllib.parse.quote(tag)}"
            f"&site=stackoverflow&pagesize={LIMIT}&fromdate={CUTOFF_TS}"
        )
        try:
            payload = http_json(url, headers={"User-Agent": BROWSER_UA})
        except Exception as exc:
            ERRORS.append(f"stackoverflow:{tag}: {exc}")
            raw[tag] = {"error": str(exc)}
            continue
        raw[tag] = payload
        for entry in payload.get("items", []):
            title = clean_title(entry.get("title", ""))
            if looks_spam(title):
                continue
            if entry.get("score", 0) < score_floor:
                continue
            items.append(
                normalized_item(
                    source="stackoverflow",
                    channel=f"StackOverflow/{tag}",
                    title=title,
                    url=entry.get("link", ""),
                    author=(entry.get("owner") or {}).get("display_name", ""),
                    score=entry.get("score", 0),
                    comments=entry.get("answer_count", 0),
                    created_at=iso_from_epoch(entry.get("creation_date")),
                    summary=" / ".join(entry.get("tags", [])),
                    extra={"tags": entry.get("tags", [])},
                )
            )
    write_json("stackoverflow.json", raw)
    return items


def fetch_npm():
    eprint("Fetching npm package radar...")
    raw = {}
    items = []
    for query in NPM_QUERIES:
        url = (
            "https://registry.npmjs.org/-/v1/search?"
            f"text={urllib.parse.quote(query)}&size={min(LIMIT, 3)}"
        )
        try:
            payload = http_json(url, headers={"User-Agent": BROWSER_UA})
        except Exception as exc:
            ERRORS.append(f"npm:{query}: {exc}")
            raw[query] = {"error": str(exc)}
            continue
        raw[query] = payload
        for entry in payload.get("objects", []):
            package = entry.get("package") or {}
            title = clean_title(package.get("name", ""))
            summary = package.get("description", "") or ""
            weekly_downloads = int((entry.get("downloads") or {}).get("weekly", 0) or 0)
            pseudo_stars = max(1, weekly_downloads // 5000)
            updated_at = parse_iso(entry.get("updated"))
            if looks_spam(title, summary):
                continue
            if not matches_theme_signal(title, summary, (package.get("links") or {}).get("repository", "")):
                continue
            if updated_at and updated_at < CUTOFF:
                continue
            items.append(
                normalized_item(
                    source="npm",
                    channel=f"npm/{query}",
                    title=title,
                    url=(package.get("links") or {}).get("npm", ""),
                    author=(package.get("publisher") or {}).get("username", ""),
                    comments=min(20, int(str(entry.get("dependents", "0")).replace(",", "") or 0)),
                    stars=pseudo_stars,
                    created_at=updated_at.isoformat() if updated_at else package.get("date"),
                    summary=summary,
                    extra={
                        "version": package.get("version"),
                        "repository": (package.get("links") or {}).get("repository", ""),
                        "weekly_downloads": weekly_downloads,
                        "search_score": round(float(entry.get("searchScore", 0)), 2),
                    },
                )
            )
    write_json("npm.json", raw)
    return items


def fetch_bluesky():
    eprint("Fetching Bluesky author feeds...")
    raw = {}
    items = []
    for source in BLUESKY_HANDLES:
        url = (
            "https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?"
            f"actor={urllib.parse.quote(source['handle'])}&limit={min(LIMIT, 5)}"
        )
        try:
            payload = http_json(url, headers={"User-Agent": BROWSER_UA})
        except Exception as exc:
            ERRORS.append(f"bluesky:{source['handle']}: {exc}")
            raw[source["handle"]] = {"error": str(exc)}
            continue
        raw[source["handle"]] = payload
        for entry in payload.get("feed", []):
            post = entry.get("post") or {}
            record = post.get("record") or {}
            created_at = parse_iso(record.get("createdAt") or post.get("indexedAt") or "")
            if created_at and created_at < CUTOFF:
                continue
            text = clean_text(record.get("text", ""))
            embed = post.get("embed") or {}
            external = embed.get("external") or {}
            title = clean_title(external.get("title") or text)
            summary = clean_text((text + " " + external.get("description", "")).strip())
            if not title:
                title = clean_title(summary[:140])
            if not title or looks_spam(title, summary):
                continue
            if not matches_theme_signal(title, summary, external.get("uri", "")):
                continue
            post_uri = post.get("uri", "")
            post_id = post_uri.rsplit("/", 1)[-1] if post_uri else ""
            post_url = external.get("uri") or (
                f"https://bsky.app/profile/{source['handle']}/post/{post_id}" if post_id else ""
            )
            items.append(
                normalized_item(
                    source="bluesky",
                    channel=source["channel"],
                    title=title,
                    url=post_url,
                    author=(post.get("author") or {}).get("displayName", "") or source["handle"],
                    score=post.get("likeCount", 0),
                    comments=post.get("replyCount", 0),
                    reactions=post.get("repostCount", 0),
                    created_at=created_at.isoformat() if created_at else None,
                    summary=summary or external.get("title", ""),
                )
            )
    write_json("bluesky.json", raw)
    return items


def fetch_mastodon():
    eprint("Fetching Mastodon tag timelines...")
    raw = {}
    items = []
    for source in MASTODON_TIMELINES:
        try:
            payload = http_json(source["url"], headers={"User-Agent": BROWSER_UA})
        except Exception as exc:
            ERRORS.append(f"mastodon:{source['channel']}: {exc}")
            raw[source["channel"]] = {"error": str(exc)}
            continue
        raw[source["channel"]] = payload
        for entry in payload[: LIMIT]:
            created_at = parse_iso(entry.get("created_at", ""))
            if created_at and created_at < CUTOFF:
                continue
            summary = clean_text(entry.get("content", ""))
            title = clean_title(summary[:140])
            if not title or looks_spam(title, summary):
                continue
            if not matches_theme_signal(title, summary, entry.get("url", "")):
                continue
            items.append(
                normalized_item(
                    source="mastodon",
                    channel=source["channel"],
                    title=title,
                    url=entry.get("url", ""),
                    author=(entry.get("account") or {}).get("display_name", "")
                    or (entry.get("account") or {}).get("acct", ""),
                    score=entry.get("favourites_count", 0),
                    comments=entry.get("replies_count", 0),
                    reactions=entry.get("reblogs_count", 0),
                    created_at=created_at.isoformat() if created_at else None,
                    summary=summary,
                )
            )
    write_json("mastodon.json", raw)
    return items


def fetch_geeknews():
    eprint("Fetching GeekNews...")
    items = []
    try:
        feed = parse_feed_entries("https://news.hada.io/rss/news")
    except Exception as exc:
        ERRORS.append(f"geeknews: {exc}")
        write_json("geeknews.json", {"error": str(exc)})
        return items
    for index, entry in enumerate(feed[: LIMIT * 2]):
        title = clean_title(entry["title"])
        if looks_spam(title, entry["summary"]):
            continue
        items.append(
            normalized_item(
                source="geeknews",
                channel="GeekNews/frontpage",
                title=title,
                url=entry["url"],
                score=position_score(index, 18),
                created_at=entry["published"],
                summary=entry["summary"],
            )
        )
    write_json("geeknews.json", feed)
    return items


def fetch_yozm():
    eprint("Fetching Yozm IT feeds...")
    raw = {}
    items = []
    for feed in YOZM_FEEDS:
        try:
            entries = parse_feed_entries(feed["url"])
        except Exception as exc:
            ERRORS.append(f"yozm:{feed['channel']}: {exc}")
            raw[feed["channel"]] = {"error": str(exc)}
            continue
        raw[feed["channel"]] = entries
        for index, entry in enumerate(entries[: LIMIT]):
            title = clean_title(entry["title"])
            if looks_spam(title, entry["summary"]):
                continue
            items.append(
                normalized_item(
                    source="yozm",
                    channel=feed["channel"],
                    title=title,
                    url=entry["url"],
                    score=position_score(index, 16),
                    created_at=entry["published"],
                    summary=entry["summary"],
                )
            )
    write_json("yozm.json", raw)
    return items


def fetch_google_news():
    eprint("Fetching Google News RSS...")
    raw = {}
    items = []
    for feed in GOOGLE_NEWS_FEEDS:
        try:
            entries = parse_feed_entries(feed["url"])
        except Exception as exc:
            ERRORS.append(f"google_news:{feed['channel']}: {exc}")
            raw[feed["channel"]] = {"error": str(exc)}
            continue
        raw[feed["channel"]] = entries
        for index, entry in enumerate(entries[: LIMIT * 2]):
            title = clean_title(entry["title"])
            if looks_spam(title, entry["summary"]):
                continue
            if not matches_theme_signal(title, entry["summary"], entry["url"]):
                continue
            items.append(
                normalized_item(
                    source="google_news",
                    channel=feed["channel"],
                    title=title,
                    url=entry["url"],
                    score=position_score(index, 14),
                    created_at=entry["published"],
                    summary=entry["summary"],
                )
            )
    write_json("google-news.json", raw)
    return items


def fetch_naver_blog():
    eprint("Fetching Naver Blog via Naver search...")
    raw = {}
    items = []
    for query in NAVER_BLOG_QUERIES:
        search_url = (
            "https://search.naver.com/search.naver?"
            f"where=post&query={urllib.parse.quote(query)}"
        )
        try:
            html_text = http_text(search_url, headers=NAVER_HEADERS)
        except Exception as exc:
            ERRORS.append(f"naver_blog:{query}: {exc}")
            raw[query] = {"error": str(exc)}
            continue
        links = []
        for title, href in extract_links(html_text, search_url):
            if not re.search(r"https?://blog\.naver\.com/[^/]+/\d+", href):
                continue
            cleaned = clean_title(title)
            if len(cleaned) < 8 or looks_spam(cleaned):
                continue
            links.append({"title": cleaned, "url": href})
        ordered = []
        seen = set()
        for link in links:
            key = link["url"]
            if key in seen:
                continue
            seen.add(key)
            ordered.append(link)
        raw[query] = ordered[: LIMIT]
        for index, link in enumerate(ordered[: min(LIMIT, 3)]):
            summary = ""
            mobile_url = naver_blog_to_mobile(link["url"])
            final_title = link["title"]
            if mobile_url:
                try:
                    mobile_html = http_text(
                        mobile_url,
                        headers={
                            "User-Agent": MOBILE_UA,
                            "Accept-Language": "ko-KR,ko;q=0.9",
                            "Referer": "https://m.naver.com/",
                        },
                    )
                    final_title = extract_meta_content(mobile_html, "og:title") or final_title
                    summary = (
                        extract_meta_content(mobile_html, "og:description")
                        or extract_meta_content(mobile_html, "description")
                    )
                except Exception as exc:
                    ERRORS.append(f"naver_blog:post:{link['url']}: {exc}")
            if not matches_theme_signal(final_title, summary, link["url"]):
                continue
            items.append(
                normalized_item(
                    source="naver_blog",
                    channel=f"NaverBlog/{query}",
                    title=final_title,
                    url=link["url"],
                    score=position_score(index, 15),
                    summary=summary,
                )
            )
    write_json("naver-blog.json", raw)
    return items


def _naver_search_fallback(site_name, site_domain, source_name, channel_prefix, limit):
    query = f"site:{site_domain} AI OR 개발 OR 오픈소스"
    search_url = (
        "https://search.naver.com/search.naver?"
        f"where=web&query={urllib.parse.quote(query)}"
    )
    html_body = http_text(search_url, headers=NAVER_HEADERS)
    links = []
    for title, href in extract_links(html_body, search_url):
        if site_domain not in href:
            continue
        cleaned = clean_title(title)
        if len(cleaned) < 6 or looks_spam(cleaned):
            continue
        links.append({"title": cleaned, "url": href})
    seen = set()
    ordered = []
    for link in links:
        if link["url"] in seen:
            continue
        seen.add(link["url"])
        ordered.append(link)
    items = []
    for index, link in enumerate(ordered[:limit]):
        items.append(
            normalized_item(
                source=source_name,
                channel=f"{channel_prefix}/NaverFallback",
                title=link["title"],
                url=link["url"],
                score=position_score(index, 10),
            )
        )
    return items if items else None


def fetch_clien():
    eprint("Fetching Clien boards...")
    raw = {}
    items = []
    for source in CLIEN_SOURCES:
        def _direct(src=source):
            return extract_page_candidates(src["url"], src["pattern"])

        def _cffi(src=source):
            if not has_curl_cffi():
                raise RuntimeError("curl_cffi not available")
            html_body = curl_cffi_request(src["url"], headers={"User-Agent": BROWSER_UA})
            matches = []
            for text, href in extract_links(html_body, src["url"]):
                href_key = href.split("#", 1)[0]
                if not re.search(src["pattern"], href_key):
                    continue
                title = clean_title(text)
                if is_counter_text(title) or looks_spam(title) or title_excluded(title):
                    continue
                matches.append({"title": title, "url": href_key})
            seen = set()
            ordered = []
            for m in matches:
                key = (m["title"], m["url"])
                if key in seen:
                    continue
                seen.add(key)
                ordered.append(m)
            return ordered or None

        def _naver(src=source):
            return _naver_search_fallback("Clien", "clien.net", "clien", "Clien", LIMIT)

        chain = FallbackChain([_direct, _cffi, _naver], f"clien:{source['channel']}")
        matches, event = chain.execute()
        if matches is None:
            ERRORS.append(f"clien:{source['channel']}: all phases failed ({event['reason']})")
            raw[source["channel"]] = {"error": event["reason"]}
            continue
        raw[source["channel"]] = matches[: LIMIT * 2]
        source_items = []
        for index, match in enumerate(matches[: LIMIT * 2]):
            title = match["title"]
            if source["require_theme"] and not matches_theme_signal(title, "", match["url"]):
                continue
            source_items.append(
                normalized_item(
                    source="clien",
                    channel=source["channel"],
                    title=title,
                    url=match["url"],
                    score=position_score(index, 14),
                )
            )
        source_items = _batch_enrich(source_items)
        items.extend(source_items)
    write_json("clien.json", raw)
    return items


def fetch_ruliweb():
    eprint("Fetching Ruliweb tech boards...")
    raw = {}
    items = []
    for source in RULIWEB_SOURCES:
        def _direct(src=source):
            return extract_page_candidates(src["url"], src["pattern"]) or None

        def _cffi(src=source):
            if not has_curl_cffi():
                raise RuntimeError("curl_cffi not available")
            html_body = curl_cffi_request(src["url"], headers={"User-Agent": BROWSER_UA})
            matches = []
            for text, href in extract_links(html_body, src["url"]):
                href_key = href.split("#", 1)[0]
                if not re.search(src["pattern"], href_key):
                    continue
                title = clean_title(text)
                if is_counter_text(title) or looks_spam(title) or title_excluded(title):
                    continue
                matches.append({"title": title, "url": href_key})
            seen = set()
            ordered = []
            for m in matches:
                key = (m["title"], m["url"])
                if key in seen:
                    continue
                seen.add(key)
                ordered.append(m)
            return ordered or None

        def _naver(src=source):
            return _naver_search_fallback("Ruliweb", "ruliweb.com", "ruliweb", "Ruliweb", LIMIT)

        chain = FallbackChain([_direct, _cffi, _naver], f"ruliweb:{source['channel']}")
        matches, event = chain.execute()
        if matches is None:
            ERRORS.append(f"ruliweb:{source['channel']}: all phases failed ({event['reason']})")
            raw[source["channel"]] = {"error": event["reason"]}
            continue
        raw[source["channel"]] = matches[: LIMIT * 2]
        source_items = []
        for index, match in enumerate(matches[: LIMIT * 2]):
            if looks_spam(match["title"]):
                continue
            source_items.append(
                normalized_item(
                    source="ruliweb",
                    channel=source["channel"],
                    title=match["title"],
                    url=match["url"],
                    score=position_score(index, 13),
                )
            )
        source_items = _batch_enrich(source_items)
        items.extend(source_items)
    write_json("ruliweb.json", raw)
    return items


def fetch_ppomppu():
    eprint("Fetching Ppomppu hot board...")
    items = []
    ppomppu_url = "https://www.ppomppu.co.kr/hot.php"
    ppomppu_pattern = r"/zboard/(?:view\.php\?id=[^&]+&no=\d+|zboard\.php\?id=freeboard&no=\d+)"

    def _direct():
        return extract_page_candidates(ppomppu_url, ppomppu_pattern, fallback_encodings=["euc-kr", "cp949"]) or None

    def _cffi():
        if not has_curl_cffi():
            raise RuntimeError("curl_cffi not available")
        html_body = curl_cffi_request(ppomppu_url, headers={"User-Agent": BROWSER_UA})
        matches = []
        for text, href in extract_links(html_body, ppomppu_url):
            href_key = href.split("#", 1)[0]
            if not re.search(ppomppu_pattern, href_key):
                continue
            title = clean_title(text)
            if is_counter_text(title) or looks_spam(title) or title_excluded(title):
                continue
            matches.append({"title": title, "url": href_key})
        seen = set()
        ordered = []
        for m in matches:
            key = (m["title"], m["url"])
            if key in seen:
                continue
            seen.add(key)
            ordered.append(m)
        return ordered or None

    def _naver():
        return _naver_search_fallback("Ppomppu", "ppomppu.co.kr", "ppomppu", "Ppomppu", LIMIT)

    chain = FallbackChain([_direct, _cffi, _naver], "ppomppu")
    matches, event = chain.execute()
    if matches is None:
        ERRORS.append(f"ppomppu: all phases failed ({event['reason']})")
        write_json("ppomppu.json", {"error": event["reason"]})
        return items
    selected = []
    for match in matches:
        if matches_theme_signal(match["title"], "", match["url"]):
            selected.append(match)
    source_items = []
    for index, match in enumerate(selected[: LIMIT]):
        source_items.append(
            normalized_item(
                source="ppomppu",
                channel="Ppomppu/hot",
                title=match["title"],
                url=urllib.parse.urljoin("https://www.ppomppu.co.kr", match["url"]),
                score=position_score(index, 12),
            )
        )
    source_items = _batch_enrich(source_items)
    items.extend(source_items)
    write_json("ppomppu.json", selected[: LIMIT * 2])
    return items


def fetch_dcinside():
    eprint("Fetching DCInside HIT gallery...")
    items = []
    dc_url = "https://gall.dcinside.com/board/lists/?id=hit"
    dc_pattern = r"(?:/board/view/\?id=hit&no=\d+|https://gall\.dcinside\.com/list\.php\?id=[^&]+&no=\d+)"

    def _direct():
        return extract_page_candidates(dc_url, dc_pattern) or None

    def _cffi():
        if not has_curl_cffi():
            raise RuntimeError("curl_cffi not available")
        html_body = curl_cffi_request(dc_url, headers={"User-Agent": BROWSER_UA})
        matches = []
        for text, href in extract_links(html_body, dc_url):
            href_key = href.split("#", 1)[0]
            if not re.search(dc_pattern, href_key):
                continue
            title = clean_title(text)
            if is_counter_text(title) or looks_spam(title) or title_excluded(title):
                continue
            matches.append({"title": title, "url": href_key})
        seen = set()
        ordered = []
        for m in matches:
            key = (m["title"], m["url"])
            if key in seen:
                continue
            seen.add(key)
            ordered.append(m)
        return ordered or None

    def _naver():
        return _naver_search_fallback("DCInside", "dcinside.com", "dcinside", "DCInside", LIMIT)

    chain = FallbackChain([_direct, _cffi, _naver], "dcinside")
    matches, event = chain.execute()
    if matches is None:
        ERRORS.append(f"dcinside: all phases failed ({event['reason']})")
        write_json("dcinside.json", {"error": event["reason"]})
        return items
    selected = []
    for match in matches:
        if matches_theme_signal(match["title"], "", match["url"]):
            selected.append(match)
    source_items = []
    for index, match in enumerate(selected[: LIMIT]):
        source_items.append(
            normalized_item(
                source="dcinside",
                channel="DCInside/hit",
                title=match["title"],
                url=match["url"],
                score=position_score(index, 12),
            )
        )
    source_items = _batch_enrich(source_items)
    items.extend(source_items)
    write_json("dcinside.json", selected[: LIMIT * 2])
    return items


def fetch_fmkorea():
    eprint("Fetching FMKorea (direct probe → curl_cffi → Naver search)...")
    raw = {}
    items = []

    def _fmkorea_direct():
        url = "https://www.fmkorea.com/index.php?mid=best&listStyle=list&page=1"
        html_body = http_text(url, headers={"User-Agent": BROWSER_UA}, )
        links = []
        for title, href in extract_links(html_body, "https://www.fmkorea.com"):
            if not re.search(r"https?://www\.fmkorea\.com/\d{6,}", href):
                continue
            cleaned = clean_title(title)
            if len(cleaned) < 6 or looks_spam(cleaned):
                continue
            links.append({"title": cleaned, "url": href})
        seen = set()
        ordered = []
        for link in links:
            if link["url"] in seen:
                continue
            seen.add(link["url"])
            ordered.append(link)
        return ordered or None

    def _fmkorea_cffi():
        if not has_curl_cffi():
            raise RuntimeError("curl_cffi not available")
        url = "https://www.fmkorea.com/index.php?mid=best&listStyle=list&page=1"
        html_body = curl_cffi_request(url, headers={"User-Agent": BROWSER_UA})
        links = []
        for title, href in extract_links(html_body, "https://www.fmkorea.com"):
            if not re.search(r"https?://www\.fmkorea\.com/\d{6,}", href):
                continue
            cleaned = clean_title(title)
            if len(cleaned) < 6 or looks_spam(cleaned):
                continue
            links.append({"title": cleaned, "url": href})
        seen = set()
        ordered = []
        for link in links:
            if link["url"] in seen:
                continue
            seen.add(link["url"])
            ordered.append(link)
        return ordered or None

    def _fmkorea_naver():
        all_links = []
        for query in FMKOREA_SEARCH_QUERIES:
            search_url = (
                "https://search.naver.com/search.naver?"
                f"where=web&query={urllib.parse.quote(query)}"
            )
            html_body = http_text(search_url, headers=NAVER_HEADERS)
            for title, href in extract_links(html_body, search_url):
                if not re.search(r"https?://www\.fmkorea\.com/\d{6,}", href):
                    continue
                cleaned = clean_title(title)
                if len(cleaned) < 6 or looks_spam(cleaned):
                    continue
                all_links.append({"title": cleaned, "url": href})
        seen = set()
        ordered = []
        for link in all_links:
            if link["url"] in seen:
                continue
            seen.add(link["url"])
            ordered.append(link)
        return ordered or None

    chain = FallbackChain([_fmkorea_direct, _fmkorea_cffi, _fmkorea_naver], "fmkorea")
    result, event = chain.execute()
    if result is None:
        ERRORS.append(f"fmkorea: all phases failed ({event['reason']})")
        write_json("fmkorea.json", {"error": event["reason"]})
        return items

    raw["result"] = result[: LIMIT * 3]
    for index, link in enumerate(result[: min(LIMIT, 3)]):
        items.append(
            normalized_item(
                source="fmkorea",
                channel=f"FMKorea/best",
                title=link["title"],
                url=link["url"],
                score=position_score(index, 11),
            )
        )
    write_json("fmkorea.json", raw)
    return items


def fetch_v2ex():
    eprint("Fetching V2EX nodes...")
    raw = {}
    items = []
    for node in V2EX_NODES:
        url = "https://www.v2ex.com/api/topics/show.json?node_name=" + urllib.parse.quote(node)
        try:
            payload = http_json(url, headers={"User-Agent": BROWSER_UA})
        except Exception as exc:
            ERRORS.append(f"v2ex:{node}: {exc}")
            raw[node] = {"error": str(exc)}
            continue
        raw[node] = payload
        for entry in payload[: LIMIT]:
            title = clean_title(entry.get("title", ""))
            if looks_spam(title):
                continue
            if node != "openai" and not matches_theme_signal(title, "", entry.get("url", "")):
                continue
            if entry.get("replies", 0) < (2 if node == "openai" else 5):
                continue
            items.append(
                normalized_item(
                    source="v2ex",
                    channel=f"V2EX/{node}",
                    title=title,
                    url=entry.get("url", ""),
                    author=(entry.get("member") or {}).get("username", ""),
                    comments=entry.get("replies", 0),
                    created_at=iso_from_epoch(entry.get("created")),
                    summary=(entry.get("node") or {}).get("title", ""),
                )
            )
    write_json("v2ex.json", raw)
    return items


def fetch_arxiv():
    eprint("Fetching arXiv...")
    items = []
    query = urllib.parse.quote("cat:cs.AI OR cat:cs.CL OR cat:cs.LG")
    url = (
        "http://export.arxiv.org/api/query?"
        f"search_query={query}&max_results={LIMIT}&sortBy=submittedDate&sortOrder=descending"
    )
    try:
        entries = parse_feed_entries(url)
    except Exception as exc:
        ERRORS.append(f"arxiv: {exc}")
        write_json("arxiv.json", {"error": str(exc)})
        return items
    for index, entry in enumerate(entries[: LIMIT]):
        title = clean_title(entry["title"])
        if looks_spam(title, entry["summary"]):
            continue
        items.append(
            normalized_item(
                source="arxiv",
                channel="arXiv/AI",
                title=title,
                url=entry["url"],
                score=position_score(index, 10),
                created_at=entry["published"],
                summary=entry["summary"],
            )
        )
    write_json("arxiv.json", entries)
    return items


all_items = []
all_items.extend(fetch_reddit())
all_items.extend(fetch_hackernews())
all_items.extend(fetch_lobsters())
all_items.extend(fetch_devto())
all_items.extend(fetch_github())
all_items.extend(fetch_stackoverflow())
all_items.extend(fetch_npm())
all_items.extend(fetch_bluesky())
all_items.extend(fetch_mastodon())
all_items.extend(fetch_geeknews())
all_items.extend(fetch_yozm())
all_items.extend(fetch_google_news())
all_items.extend(fetch_naver_blog())
all_items.extend(fetch_clien())
all_items.extend(fetch_ruliweb())
all_items.extend(fetch_ppomppu())
all_items.extend(fetch_dcinside())
all_items.extend(fetch_fmkorea())
all_items.extend(fetch_v2ex())
all_items.extend(fetch_arxiv())

deduped = dedupe_items(all_items)
raw_counts = {}
for item in all_items:
    raw_counts[item["source"]] = raw_counts.get(item["source"], 0) + 1
deduped_counts = {}
for item in deduped:
    deduped_counts[item["source"]] = deduped_counts.get(item["source"], 0) + 1
metadata = {
    "generated_at": NOW.isoformat(),
    "period": PERIOD,
    "limit_per_source": LIMIT,
    "cutoff": CUTOFF.isoformat(),
    "output_dir": OUTDIR,
    "sources": sorted(raw_counts),
    "raw_counts": raw_counts,
    "deduped_counts": deduped_counts,
    "counts": {
        "raw_items": len(all_items),
        "deduped_items": len(deduped),
        "raw_by_source": raw_counts,
        "deduped_by_source": deduped_counts,
    },
    "errors": ERRORS,
    "fallback_events": FALLBACK_EVENTS,
}
payload = {
    "metadata": metadata,
    "topics": deduped,
    "meta": metadata,
    "items": deduped,
}
write_json("all.json", payload)
print(json.dumps(payload, ensure_ascii=False, indent=2))
PY
