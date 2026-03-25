# ship

Anthropic의 [Harness 연구](https://www.anthropic.com/engineering/harness-design)(2026-03)에 기반한 3-Agent 장시간 자율 개발 플러그인.

1-4문장의 프로덕트 아이디어를 입력하면, **Planner→Generator→Evaluator** 아키텍처가 스프린트 단위로 풀스택 앱을 자율 구현합니다.

## 핵심 아이디어

Anthropic Labs의 실험에서 발견된 세 가지 핵심 인사이트:

1. **자기평가 편향**: 에이전트는 자기 산출물을 과대평가한다 → Generator와 Evaluator를 분리
2. **스프린트 계약**: 구현 전 "완료 기준"을 협상 → 스펙과 구현의 괴리 방지
3. **GAN-inspired 피드백 루프**: Evaluator의 비판적 피드백 → Generator 반복 개선

## 아키텍처

```
User Prompt → Planner (Opus) → Spec
                                  ↓
              ┌─── Sprint Contract ←──┐
              ↓                       ↑
         Generator (Sonnet)    Evaluator (Sonnet)
              ↓                       ↑
         Build Sprint ──── QA + Grade ┘
              ↓
         Ship-ready App
```

| Agent | Model | 역할 |
|-------|-------|------|
| **harness-planner** | Opus | 아이디어 → 풀 프로덕트 스펙 + 스프린트 분해 |
| **harness-generator** | Sonnet | 스프린트 단위 구현 + AI slop 회피 |
| **harness-evaluator** | Sonnet | 4가지 기준 채점 + 구체적 피드백 |

## 채점 기준

Harness 연구의 grading criteria를 ICP(1인 개발자)에 맞게 조정:

| 기준 | 가중치 | 평가 내용 |
|------|--------|----------|
| Product Depth | 30% | 실제 문제 해결, end-to-end 기능 |
| Functionality | 30% | 버그 없는 핵심 플로우, 에러 핸들링 |
| Visual Design | 20% | AI slop 회피, 의도적 디자인 |
| Code Quality | 20% | 구조, 테스트, 유지보수성 |

Hard threshold: 어느 기준이든 5/10 미만이면 스프린트 실패 → 피드백 루프.

## 사용법

```
/ship "일일 브리핑 앱 — 구글 캘린더 연동, 미팅 준비 자료 AI 생성"
```

## 워크플로우

1. **Spec Phase**: Planner가 아이디어를 풀 프로덕트 스펙으로 확장
2. **Sprint Contract**: Generator와 Evaluator가 "완료 기준" 협상
3. **Build Phase**: Generator가 스프린트 구현
4. **QA Phase**: Evaluator가 실행 앱 테스트 + 채점
5. **Feedback Loop**: 실패 시 최대 5회 반복 (refine 또는 pivot)
6. **Ship**: 모든 스프린트 통과 → 최종 보고서

## 아티팩트 구조

```
.harness/
├── spec.md                    # Planner 산출물
├── sprints/
│   ├── sprint-1/
│   │   ├── contract.md        # Generator↔Evaluator 합의
│   │   ├── progress.md        # Generator 진행 보고
│   │   ├── evaluation.md      # Evaluator 채점
│   │   └── iterations/        # 피드백 반복 기록
│   └── sprint-2/ ...
└── ship-report.md             # 최종 출하 보고서
```

## 참고 자료

- [Anthropic: Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design) — Planner→Generator→Evaluator 아키텍처의 이론적 근간
- [OpenSpec](https://github.com/Fission-AI/OpenSpec) — Artifact-guided spec framework
- [gstack](https://github.com/garrytan/gstack) — Multi-role slash command suite
- [oh-my-claudecode](https://github.com/yeachan-heo/oh-my-claudecode) — Multi-agent orchestration
- [agnt](https://github.com/october-academy/agnt) — 30-day solopreneur curriculum

## Installation

```bash
# Recommended: install as Skills (Claude Code + Codex)
npx skills add october-academy/agent-plugins -a claude-code -a codex --skill ship -y
```

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install ship@agent-plugins

# 4. Restart Claude Code
```
