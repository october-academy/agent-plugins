"""Naver fetchers: Naver Blog, FMKorea (via Naver search)."""
import datetime as dt
import re
import urllib.parse

from lib import (
    BROWSER_UA, MOBILE_UA, NAVER_HEADERS,
    FallbackChain, has_curl_cffi, curl_cffi_request,
    http_text, write_json, eprint,
    clean_title, looks_spam, matches_theme_signal,
    normalized_item, position_score,
    extract_links, extract_meta_content, naver_blog_to_mobile,
)


def fetch_naver_blog(config, period, limit, outdir, errors, fallback_events):
    eprint("Fetching Naver Blog via Naver search...")
    now = dt.datetime.now(dt.timezone.utc)
    days = 7 if period == "week" else 1
    queries = config.get("naver_blog_queries", [])
    raw = {}
    items = []
    for query in queries:
        search_url = (
            "https://search.naver.com/search.naver?"
            f"where=post&query={urllib.parse.quote(query)}"
        )
        try:
            html_text = http_text(search_url, headers=NAVER_HEADERS)
        except Exception as exc:
            errors.append(f"naver_blog:{query}: {exc}")
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
        raw[query] = ordered[: limit]
        for index, link in enumerate(ordered[: min(limit, 3)]):
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
                    errors.append(f"naver_blog:post:{link['url']}: {exc}")
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
                    now=now,
                    days=days,
                )
            )
    write_json(outdir, "naver-blog.json", raw)
    return items


def fetch_fmkorea(config, period, limit, outdir, errors, fallback_events):
    eprint("Fetching FMKorea (direct probe -> curl_cffi -> Naver search)...")
    now = dt.datetime.now(dt.timezone.utc)
    days = 7 if period == "week" else 1
    search_queries = config.get("fmkorea_search_queries", [])
    raw = {}
    items = []

    def _fmkorea_direct():
        url = "https://www.fmkorea.com/index.php?mid=best&listStyle=list&page=1"
        html_body = http_text(url, headers={"User-Agent": BROWSER_UA})
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
        for query in search_queries:
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
    result, event = chain.execute(fallback_events=fallback_events)
    if result is None:
        errors.append(f"fmkorea: all phases failed ({event['reason']})")
        write_json(outdir, "fmkorea.json", {"error": event["reason"]})
        return items

    raw["result"] = result[: limit * 3]
    for index, link in enumerate(result[: min(limit, 3)]):
        items.append(
            normalized_item(
                source="fmkorea",
                channel="FMKorea/best",
                title=link["title"],
                url=link["url"],
                score=position_score(index, 11),
                now=now,
                days=days,
            )
        )
    write_json(outdir, "fmkorea.json", raw)
    return items
