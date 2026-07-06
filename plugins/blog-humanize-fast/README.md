# Blog Humanize Fast

블로그 최종 원고를 보수적으로 윤문하는 병렬 strict 워크플로 플러그인이다.
`humanize-korean --strict`의 검증 분리(윤문과 fidelity/naturalness 검증 분리)를
유지하면서, 본문을 청크로 나눠 병렬 처리해 wall-clock을 줄인다.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install blog-humanize-fast@agent-plugins

# 4. Restart Claude Code
```

## Usage

```bash
/blog-humanize-fast path/to/draft-body.md
/blog-humanize-fast "이 한국어 블로그 초안을 최종 윤문해줘"
```

### Auto-triggers

- "블로그 최종 윤문", "윤문 빠르게", "blog-humanize-fast"
- "humanize-korean strict 너무 느려", "병렬 strict 윤문"
- "AI 티 줄이되 의미는 건드리지 마", "최종 교열 후 윤문"

## How It Works

1. 입력 텍스트나 파일 경로를 받는다.
2. 코드펜스는 보호하고, 나머지 본문을 문단 기준 청크로 나눈다.
3. 각 청크에서 S1/S2 중심 AI 티를 탐지하고 보수적으로 윤문한다.
4. 청크별 fidelity 감사가 실패하면 1회 재시도하고, 다시 실패하면 원문으로 롤백한다.
5. 조립된 본문을 전역 naturalness와 잔존 S1/S2 탐지로 병렬 검증한다.
6. 지적 span만 표적 수정 1라운드를 수행한다.
7. 최종본, 변경 통계, 잔존 탐지 수를 보고한다.

## Contract

- 의미 불변이 최상위 규칙이다.
- 수치, 날짜, 금액, 고유명사, 직접 인용, 코드, URL, 마크다운 구조, JSX 태그는
  Do-NOT span이다.
- 기본 강도는 `보수`다. 저자가 쓴 초안을 과하게 갈아엎지 않는다.
- 워크플로 실패나 정밀 재검증 요구 시 `humanize-korean --strict`를 폴백으로 쓴다.

## Files

- Skill entrypoint: `skills/blog-humanize-fast/SKILL.md`
- Workflow source: `skills/blog-humanize-fast/workflows/blog-humanize-fast.js`
- Bundled rules snapshot: `skills/blog-humanize-fast/references/quick-rules.md`
