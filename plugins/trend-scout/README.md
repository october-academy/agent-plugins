# trend-scout

> insane-search로 뚫고, trend-scout로 캐낸다.

`insane-search`의 공개 소스 전략을 벤치마킹해서, Threads 소재용 트렌드 후보를 자동 수집하는 리서치 스킬.

기본 큐는 영어권 테크 커뮤니티 + 한국 커뮤니티 + RSS + 일부 공개 API를 함께 긁어와서 `trend_score`로 정렬한다.

## Features

- 소스 병렬 수집 — 모든 fetcher를 동시에 돌리고(최대 8 workers) fetcher별 예외를 격리해 부분 실패가 전체 결과를 막지 않음. 네트워크 대기 지배 구간을 직렬에서 병렬로 접어 실행 시간 대폭 단축
- 전역 데드라인 — `TREND_SCOUT_TIMEOUT_TOTAL`(기본 240s)을 파이프라인 예산으로 적용, 초과한 미완료 소스는 실패로 기록하고 수집된 것만 출력
- HTTP 재시도 — 429/5xx/timeout에 1회 지수 백오프 재시도(per-request timeout은 `TREND_SCOUT_TIMEOUT_PER_SOURCE`, 기본 20s)
- Adaptive 3-phase fallback chain (direct → TLS impersonation → alternate route), 실패 원인 분류(blocked_403·rate_limited_429·waf_challenge 등)
- 20+ sources across 6 families (JSON API, HTML scraper, RSS, social, Naver, GitHub)
- npm 실주간 다운로드 스코어링 — downloads point API 병렬 조회로 주간 다운로드를 확정(registry 검색 응답의 downloads.weekly와 근소 차이가 날 수 있어 point API 값을 기준으로 쓴다)
- Universal metadata enrichment (og:description, ld+json)
- Configurable scoring via `TREND_SCOUT_CONFIG` env var — `source_weights`·`signal_keywords`·`spam_patterns`를 config에서 실제 소비(`_add`/`_remove` semantics)
- Optional curl_cffi TLS impersonation for WAF-blocked sources

## Optional Dependencies

WAF-blocked Korean community sites (FMKorea, DCInside 등)에서 TLS impersonation을 활성화하려면:

```bash
pip install curl_cffi
```

설치하지 않아도 파이프라인은 정상 동작한다. curl_cffi가 없으면 fallback chain의 Phase 2(TLS impersonation)를 건너뛰고 Phase 3(Naver search fallback)으로 넘어간다.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install trend-scout@agent-plugins

# 4. Restart Claude Code
```

## 사용법

`/trend-scout` 또는 "오늘 뭐 올리지", "threads 소재", "인기글", "깃허브 트렌드", "오픈소스 소재" 등으로 트리거.

## 기본 수집 소스

- 글로벌 커뮤니티: Reddit, Hacker News, Lobsters, dev.to, GitHub, Stack Overflow, Bluesky, Mastodon, V2EX, arXiv
- 패키지 레이더: npm
- 한국 소스: GeekNews, Yozm IT, Naver Blog, Clien, Ruliweb, Ppomppu, DCInside, FMKorea(네이버 검색 폴백)
- RSS/뉴스: Google News RSS

## 벤치마킹 후 기본 큐에서 제외한 소스군

- `PyPI`, `CrossRef`, `Wikipedia`, `OpenLibrary`, `Wayback`
  - 공개 조회는 되지만 "무엇이 지금 뜨는가"를 자율적으로 발견하는 피드 성격이 약해서 기본 랭킹에는 넣지 않음
- `X syndication`, `yt-dlp`, `Jina Reader`, `curl_cffi`, `Playwright`
  - URL이 먼저 있어야 의미가 있는 보강/우회 계층이라 트렌드 seed source로는 부적합

세부 매트릭스는 [sources.md](skills/trend-scout/references/sources.md)에 정리돼 있다.

## 출력

`/tmp/trend-scout/all.json`에 정규화된 후보 풀이 저장된다.

- 기본 키: `metadata`, `topics`
- 호환 alias: `meta`, `items`

각 후보는 `source`, `channel`, `title`, `url`, `summary`, `trend_score`를 가진다.
