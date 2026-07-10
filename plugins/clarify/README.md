# Clarify

모호함을 다루는 3가지 렌즈를 제공합니다.

- `interview`: 모호한 요구사항을 인터뷰로 실행 가능한 스펙까지 명확화
- `unknown`: 전략/계획의 숨은 가정과 맹점을 4분면으로 점검
- `metamedium`: 내용(content) 최적화 vs 형식(form) 전환 의사결정

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install clarify@agent-plugins

# 4. Restart Claude Code
```

Codex CLI(0.144+)에서도 같은 마켓플레이스로 설치합니다:

```bash
codex plugin marketplace add october-academy/agent-plugins
codex plugin add clarify@agent-plugins
```

## Commands

```bash
/clarify:interview "Add a login feature"
/clarify:unknown "B2B growth strategy for next quarter"
/clarify:metamedium "Our content output is high but outcomes are flat"
```

Codex에서는 스킬이 `clarify:interview` / `clarify:unknown` / `clarify:metamedium`
이름으로 등록됩니다 — 프롬프트에서 스킬 이름을 지목해 호출하세요. interview의
반복 루프(Stop 훅)와 옵션 질문은 Codex에서도 동일하게 동작합니다
(`request_user_input` 폴백).

## 1) `interview` - Requirement Clarification

요구사항이 애매할 때 가설 기반 옵션 인터뷰로 명세를 고도화합니다.

- 질문 전에 코드베이스를 먼저 조사(영토 스윕) — 조사로 답할 수 있는 건 묻지 않음
- 아키텍처를 바꾸는 질문 우선, 라운드당 최대 4문항 가설 옵션(추천 기본값 `(Recommended)` 표시)
- 사용자가 생각 못 한 맹점(unknown unknowns)을 최소 1개 발굴해 결정/가정으로 착지
- Before/After 요약이 결정·가정·잔존 unknown을 구분 기록
- 라운드별 상태 파일 기록 + 반복 루프 훅으로 중단·컨텍스트 압축에도 재개

## 2) `unknown` - Strategy Blind Spot Analysis

Known/Unknown 4분면으로 전략 맹점을 찾아 실행 가능한 플레이북으로 변환합니다.

- KK/KU/UK/UU 분류
- 3라운드 질문 심화 (R1 탐색, R2 약한 고리, R3 실행 디테일)
- KU 항목별 실험/승격 조건/중단 조건 도출
- `무엇을 시작할지`뿐 아니라 `무엇을 멈출지` 포함

## 3) `metamedium` - Content vs Form Lens

결과 정체 구간에서 내용(content) 개선과 형식(form) 전환 중 레버리지가 더 큰 선택을 돕습니다.

- 현재 작업을 CONTENT/FORM으로 라벨링
- AskUserQuestion으로 분기 결정
- 형식 전환 시 2-3개 대안 + 최소 실험안 제시
- 내용을 택해도 Form Opportunity를 기록

## Comparison

| Lens | Input | Output |
|------|-------|--------|
| `interview` | 기능/버그/작업 요구사항 | 실행 가능한 요구사항 스펙 |
| `unknown` | 전략 문서/의사결정 초안 | 4분면 플레이북 + 실행 로드맵 |
| `metamedium` | 결과 정체 문제/기획 작업 | content/form 의사결정 + 전환 실험 |

## Reference

이 플러그인은 아래 저장소의 `clarify` 시리즈를 벤치마킹해 개선했습니다.

- https://github.com/team-attention/plugins-for-claude-natives

## License

MIT
