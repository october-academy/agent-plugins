---
name: ship
description: Anthropic Harness 연구 기반 3-Agent 장시간 자율 개발. 1-4문장 아이디어를 완성된 풀스택 앱으로 변환. Planner→Generator→Evaluator 아키텍처 + GAN 피드백 루프 + 스프린트 계약.
user-invocable: true
argument-hint: "1-4문장 프로덕트 아이디어"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Agent, WebSearch, AskUserQuestion
---

# Ship

Anthropic의 Harness 연구에서 영감을 받은 3-Agent 장시간 자율 개발 워크플로우.

Anthropic 연구에서 제시한 핵심 원칙(작업 분해, 생성-평가 분리, 아티팩트 기반 핸드오프)을 Claude Code 플러그인 형태로 구현하고, ICP(1인 개발자) 맞춤 기능을 추가했습니다. 1-4문장의 프로덕트 아이디어를 입력하면, Planner→Generator→Evaluator 아키텍처가 스프린트 단위로 풀스택 앱을 자율 구현합니다.

## Core Architecture

```
User Prompt (1-4 sentences)
        │
        ▼
  ┌─────────────┐
  │   PLANNER   │  Opus — 아이디어 → 풀 프로덕트 스펙
  │             │  산출물: .harness/spec.md
  └──────┬──────┘
         │
         ▼
  ┌──────────────────────────────────┐
  │     SPRINT LOOP (per feature)    │
  │                                  │
  │  ┌───────────┐  Contract  ┌────────────┐
  │  │ GENERATOR │◄──────────►│ EVALUATOR  │
  │  │ (Sonnet)  │  Feedback  │ (Sonnet)   │
  │  └─────┬─────┘    Loop    └─────┬──────┘
  │        │                        │
  │        │  Build Sprint          │  QA + Grade
  │        │  .harness/sprints/     │  Score ≥ threshold?
  │        │                        │
  │        └──── iterate if fail ───┘
  │                                  │
  └──────────────────────────────────┘
         │
         ▼
  Ship-ready application
```

## When to Use

- 사용자가 "앱 만들어줘", "프로덕트 빌드", "harness" 등을 요청할 때
- 1인 개발자가 아이디어를 완성된 앱으로 빠르게 전환하고 싶을 때
- 장시간(1-6시간) 자율 코딩 세션이 필요할 때
- 프론트엔드+백엔드를 포함한 풀스택 빌드가 필요할 때

## When NOT to Use

- 단일 버그 수정이나 작은 변경 — 직접 수정하거나 executor 에이전트 사용
- 기존 코드 리뷰나 분석 — `/review` 또는 code-reviewer 에이전트 사용
- 이미 상세한 스펙이 있는 경우 — `/feature-dev` 또는 `/opsx:ship` 사용

## Input

$ARGUMENTS

## Artifacts Directory

모든 아티팩트는 프로젝트 루트의 `.harness/` 디렉토리에 저장됩니다.

```
.harness/
├── state.json                       # 머신 리더블 상태 (현재 Phase, Sprint, 점수)
├── spec.md                          # Planner 산출물: 풀 프로덕트 스펙
├── sprints/
│   ├── sprint-1/
│   │   ├── contract.md              # Generator-Evaluator 합의 문서
│   │   ├── progress.md              # Generator 구현 진행 상황
│   │   ├── evaluation.md            # Evaluator 채점 + 피드백
│   │   └── iterations/
│   │       ├── iteration-1.md       # 첫 번째 피드백 반영
│   │       └── iteration-2.md       # 두 번째 피드백 반영
│   ├── sprint-2/
│   │   └── ...
│   └── ...
└── ship-report.md                   # 최종 출하 보고서
```

## State Management

`.harness/state.json`은 세션 간 상태를 보존하는 머신 리더블 파일입니다. 모든 Phase 전환 시 업데이트합니다.

```json
{
  "phase": "build",
  "current_sprint": 2,
  "total_sprints": 3,
  "sprints": [
    { "id": 1, "status": "passed", "iterations": 2, "final_score": 8.2 },
    { "id": 2, "status": "in_progress", "iterations": 0, "final_score": null },
    { "id": 3, "status": "pending", "iterations": 0, "final_score": null }
  ],
  "last_updated": "2026-03-25T12:00:00Z"
}
```

**Phase 값:** `spec`, `contract`, `build`, `qa`, `feedback`, `ship`, `complete`

세션 재개 시:
1. `.harness/state.json` 읽기
2. `phase`와 `current_sprint` 기반으로 중단된 지점부터 재개
3. `status: "in_progress"`인 스프린트부터 계속

## Phase 1: Spec Expansion (Planner Agent)

Planner 에이전트에게 사용자의 아이디어를 전달하여 풀 프로덕트 스펙을 생성합니다.

**실행:**

```
Agent(subagent_type="ship:harness-planner", model="opus", prompt="<user idea>")
```

**Planner 지침:**
- 사용자의 1-4문장 아이디어를 야심찬 범위의 풀 프로덕트 스펙으로 확장
- 프로덕트 컨텍스트와 하이레벨 기술 설계에 집중 (세부 구현은 Generator에게 위임)
- AI 기능을 제품에 자연스럽게 녹여넣을 기회 탐색
- 스프린트 단위로 분해 (각 스프린트 = 독립 가능한 하나의 기능 단위)
- PMF 검증 관점 포함: 핵심 가치 제안, 타겟 사용자, 성공 지표

**산출물:** `.harness/spec.md` 작성 후 사용자에게 스펙 요약 제시

**사용자 확인:** 스펙을 보여주고 진행 여부를 AskUserQuestion으로 확인합니다.
- 승인 → Phase 2로 진행
- 수정 요청 → Planner 재실행
- 거부 → 중단

## Phase 2: Sprint Contract (Orchestrator 주도 협상)

각 스프린트 시작 전, 오케스트레이터(이 SKILL.md를 실행하는 메인 에이전트)가 Generator와 Evaluator 간 계약 협상을 중재합니다.

**프로세스 (오케스트레이터가 주도):**

1. **제안 생성**: 오케스트레이터가 spec.md에서 현재 스프린트 범위를 읽고, Generator 에이전트를 호출하여 제안서 초안을 작성하게 합니다:

   ```
   Agent(subagent_type="ship:harness-generator", model="sonnet",
     prompt="spec.md의 Sprint N 범위를 읽고 구현 제안서를 작성하라:
       - 구현할 기능 목록
       - 각 기능의 검증 가능한 성공 기준
       - 예상 파일 변경 목록
       .harness/sprints/sprint-N/contract-draft.md에 작성하라.")
   ```

2. **제안 검토**: 오케스트레이터가 Evaluator 에이전트를 호출하여 제안서를 검토하게 합니다:

   ```
   Agent(subagent_type="ship:harness-evaluator", model="sonnet",
     prompt="contract-draft.md를 검토하라:
       - 성공 기준이 구체적이고 검증 가능한지 확인
       - 누락된 엣지 케이스나 사용자 시나리오 추가
       - 검증 불가능한 기준 지적
       .harness/sprints/sprint-N/contract-review.md에 작성하라.")
   ```

3. **합의 또는 재협상**: 오케스트레이터가 review를 읽고:
   - 이슈 없음 → draft를 contract.md로 확정
   - 이슈 있음 → Generator에게 review 피드백을 전달하여 수정 요청
   - 최대 3회 반복 후 오케스트레이터가 최종 결정

4. **state.json 업데이트**: `phase: "contract"` → `phase: "build"`

**산출물:** `.harness/sprints/sprint-N/contract.md`

```markdown
# Sprint N Contract

## Scope
[구현할 기능 목록]

## Acceptance Criteria
- [ ] 기준 1: [구체적, 검증 가능한 조건]
- [ ] 기준 2: ...

## Grading Thresholds (Evaluator PASS 조건과 동일)
- 모든 기준: ≥ 5/10 (hard threshold)
- 가중 평균: ≥ 7/10
- Product Depth (30%), Functionality (30%), Visual Design (20%), Code Quality (20%)

## Verification Method
[Evaluator가 어떻게 검증할지 — 테스트 명령, 확인할 URL, 검증 시나리오]
```

## Phase 3: Build (Generator Agent)

Generator 에이전트가 스프린트 계약에 따라 구현합니다.

**실행:**

```
Agent(subagent_type="ship:harness-generator", model="sonnet", prompt="Sprint N 구현: <contract 내용>")
```

**Generator 지침:**
- 스프린트 계약의 범위만 구현 (scope creep 금지)
- 각 기능 구현 후 자체 검증 (빌드, 린트, 테스트)
- Git 커밋으로 버전 관리
- 진행 상황을 `.harness/sprints/sprint-N/progress.md`에 기록
- 완료 후 Evaluator에게 핸드오프

**기술 스택 기본값** (사용자가 별도 지정하지 않은 경우):
- Frontend: React + Vite + TypeScript
- Backend: FastAPI (Python) 또는 Next.js API Routes
- Database: SQLite (프로토타입) → PostgreSQL (프로덕션)
- 스타일: Tailwind CSS

## Phase 4: QA & Grading (Evaluator Agent)

Evaluator 에이전트가 실행 중인 앱을 실제 사용자처럼 테스트하고 채점합니다.

**실행:**

```
Agent(subagent_type="ship:harness-evaluator", model="sonnet", prompt="Sprint N 평가: <contract + progress 내용>")
```

**Evaluator 채점 기준** (Anthropic Harness 연구에서 차용, ICP에 맞게 조정):

### 1. Product Depth (가중치: 높음)
프로덕트가 실제 문제를 해결하는가? 핵심 기능이 end-to-end로 작동하는가?
- 10: 모든 핵심 기능이 실제 워크플로우에서 완벽하게 작동
- 7: 주요 기능은 작동하나 일부 엣지 케이스 미처리
- 4: 기능이 표면적으로만 존재, 실제 사용 시 깨짐
- 1: 데모 수준, 실제 사용 불가

### 2. Functionality (가중치: 높음)
사용자가 버그 없이 핵심 태스크를 완수할 수 있는가?
- 10: 모든 기능이 예상대로 작동, 에러 핸들링 완비
- 7: 주요 플로우는 작동, 마이너 UI 버그 존재
- 4: 핵심 플로우가 깨짐
- 1: 앱이 실행되지 않음

### 3. Visual Design (가중치: 중간)
프로페셔널하고 사용 가능한 디자인인가? AI slop이 아닌가?
- 10: 일관된 디자인 시스템, 의도적 창의적 선택이 보임
- 7: 깔끔하고 기능적이나 generic
- 4: 레이아웃 깨짐, 일관성 없음
- 1: 스타일링 없음

**AI Slop 패턴 감점:**
- 보라색 그라디언트 + 흰색 카드 조합
- 수정 없는 기본 컴포넌트 라이브러리 사용
- "Hero section + 3 feature cards + CTA" 패턴의 무비판적 적용

### 4. Code Quality (가중치: 중간)
클린 코드인가? 유지보수 가능한가? 테스트가 있는가?
- 10: 잘 구조화된 코드, 적절한 테스트, 타입 안전
- 7: 읽기 쉬운 코드, 기본 테스트 존재
- 4: 작동하나 스파게티 코드
- 1: 복사-붙여넣기, 하드코딩 값

**PASS 조건 (contract.md의 Grading Thresholds와 동일):**
- 모든 기준: ≥ 5/10 (hard threshold — 어느 하나라도 미달 시 FAIL)
- 가중 평균: ≥ 7/10 (가중치: Product Depth 30%, Functionality 30%, Visual Design 20%, Code Quality 20%)
- FAIL 시 → 피드백 루프 진입

**산출물:** `.harness/sprints/sprint-N/evaluation.md`

```markdown
# Sprint N Evaluation

## Scores
| Criterion      | Score | Notes |
|----------------|-------|-------|
| Product Depth  | 8/10  | ...   |
| Functionality  | 7/10  | ...   |
| Visual Design  | 6/10  | ...   |
| Code Quality   | 7/10  | ...   |

## Bugs Found
- [bug description + reproduction steps]

## Detailed Feedback
[specific, actionable feedback for Generator]

## Verdict: PASS / FAIL
```

## Phase 5: Feedback Loop (GAN-inspired Iteration)

평가 실패 시, 오케스트레이터가 Evaluator→Generator 피드백 루프를 실행합니다.

**루프 실행 (최대 5회 반복):**

```
For iteration M = 1 to 5:

  1. evaluation.md 읽기 — Verdict 확인
     If Verdict == PASS: break → Phase 6으로 진행

  2. 이전 iteration 점수와 비교하여 추세 판단

  3. Generator에게 수정 요청:
     Agent(subagent_type="ship:harness-generator", model="sonnet",
       prompt="Iteration M: evaluation.md의 피드백을 반영하여 수정하라.
              이전 점수 추이: [M-1: X.X, M-2: X.X]
              전략: 점수 상승 추세면 Refine, 정체/하락이면 Pivot.
              수정 내용을 .harness/sprints/sprint-N/iterations/iteration-M.md에 기록하라.")

  4. Evaluator에게 재평가 요청:
     Agent(subagent_type="ship:harness-evaluator", model="sonnet",
       prompt="Sprint N을 iteration M 수정 후 재평가하라.
              .harness/sprints/sprint-N/evaluation.md를 업데이트하라.")

  5. state.json 업데이트: phase="feedback", 현재 iteration 기록

  6. 동일 이슈가 3회 연속 발생하면:
     AskUserQuestion으로 사용자에게 에스컬레이션:
     "동일 이슈가 반복됩니다: [이슈]. 수동 개입이 필요할 수 있습니다."

If iteration 5까지 FAIL:
  AskUserQuestion: "5회 반복 후에도 통과하지 못했습니다. 계속/중단?"
```

## Phase 6: Sprint Completion & Next Sprint

스프린트가 PASS하면:
1. `.harness/sprints/sprint-N/` 아카이브
2. spec.md에서 다음 스프린트 선택
3. Phase 2로 돌아가 다음 스프린트 계약 협상

모든 스프린트가 완료되면:
1. 전체 앱 통합 테스트 실행
2. `.harness/ship-report.md` 작성
3. 사용자에게 최종 보고 제시

## Phase 7: Ship Report

최종 보고서에 포함할 항목:

```markdown
# Ship Report

## Product Summary
[무엇을 만들었는지]

## Sprint History
| Sprint | Feature          | Iterations | Final Score |
|--------|-----------------|------------|-------------|
| 1      | Auth + Landing  | 2          | 8.5/10      |
| 2      | Core Feature    | 3          | 7.8/10      |
| 3      | Dashboard       | 1          | 9.0/10      |

## Technical Stack
[사용된 기술 스택]

## Deployment Readiness
- [ ] 빌드 성공
- [ ] 테스트 통과
- [ ] 환경 변수 문서화
- [ ] README 작성

## PMF Validation Checklist (ICP: 1인 개발자)
- [ ] 핵심 가치 제안이 랜딩페이지에 명확히 드러남
- [ ] 사용자 가입 플로우 완성
- [ ] 핵심 기능 end-to-end 작동
- [ ] 배포 가능 상태
```

## Execution Protocol

1. `.harness/` 디렉토리 생성 + `.gitignore`에 `.harness/` 추가 (사용자에게 추적 여부 확인)
2. `state.json` 초기화: `{ "phase": "spec", "current_sprint": 0, "total_sprints": 0, "sprints": [], "last_updated": "<now>" }`
3. Phase 1 실행 → 사용자 확인 대기
3. 각 스프린트에 대해 Phase 2→3→4→5 루프
4. 모든 스프린트 완료 → Phase 7
5. 장시간 실행 시 컨텍스트 관리:
   - Opus 4.5+: compaction으로 충분 (context anxiety 감소)
   - 이전 모델: 스프린트 간 context reset + handoff artifact

## Error Handling

- **Generator가 빌드 실패**: 에러 로그를 Evaluator에게 전달, Generator에게 수정 요청
- **Evaluator가 앱 접근 불가**: Generator에게 서버 시작 확인 요청
- **5회 반복 후에도 실패**: 사용자에게 에스컬레이션 — 수동 개입 필요 항목 보고
- **스프린트 간 충돌**: 이전 스프린트 코드가 깨진 경우 회귀 테스트 실행

## Guardrails

- Planner는 프로덕트 컨텍스트에만 집중 (세부 구현 지정 금지)
- Generator와 Evaluator는 반드시 분리 (자체 평가 편향 방지)
- 파일 기반 통신만 사용 (`.harness/` 디렉토리)
- 스프린트 계약 없이 구현 시작 금지
- 채점 기준 임계값 하향 조정 금지
