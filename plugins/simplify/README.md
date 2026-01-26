# Simplify

코드를 명확성, 일관성, 유지보수성을 위해 단순화하고 정제합니다. 기능은 그대로 유지합니다.

## 설치

```bash
claude plugin install simplify@october-plugins
```

## 사용법

```bash
/simplify                 # 최근 수정된 코드 단순화
/simplify src/utils.ts    # 특정 파일 단순화
```

## 아키텍처

멀티-에이전트 병렬 분석 및 개선 워크플로우:

```
┌─────────────────────────────────────────────────────────┐
│  1. Determine Scope (git diff or user input)            │
├─────────────────────────────────────────────────────────┤
│  2. Phase 1: 4 Analysis Agents (Parallel)               │
│     ┌─────────────────┬─────────────────┐               │
│     │  complexity-    │  pattern-       │               │
│     │  analyzer       │  checker        │               │
│     ├─────────────────┼─────────────────┤               │
│     │  naming-        │  readability-   │               │
│     │  reviewer       │  analyzer       │               │
│     └─────────────────┴─────────────────┘               │
├─────────────────────────────────────────────────────────┤
│  3. Consolidate Issues                                  │
├─────────────────────────────────────────────────────────┤
│  4. Phase 2: Issue Simplifiers (Parallel)               │
│     ┌────────┬────────┬────────┬────────┐               │
│     │ issue1 │ issue2 │ issue3 │ ...    │               │
│     └────────┴────────┴────────┴────────┘               │
├─────────────────────────────────────────────────────────┤
│  5. Present Changes & User Selection                    │
├─────────────────────────────────────────────────────────┤
│  6. Apply Selected Changes                              │
└─────────────────────────────────────────────────────────┘
```

## Phase 1 에이전트

| 에이전트 | 역할 |
|---------|------|
| **complexity-analyzer** | 중첩 삼항, 깊은 중첩, 과도한 추상화 탐지 |
| **pattern-checker** | 프로젝트 표준 위반, 일관성 문제 탐지 |
| **naming-reviewer** | 변수/함수명 개선점, 명확성 문제 탐지 |
| **readability-analyzer** | 가독성 문제, 불필요한 주석, 구조 개선점 탐지 |

## Phase 2

Phase 1에서 발견된 각 이슈에 대해 **issue-simplifier** 에이전트가 병렬로 실행되어 구체적인 코드 변경안을 생성합니다.

## 원칙

1. **명확성 > 간결성**: 한 줄 코드보다 읽기 쉬운 코드 선호
2. **중첩 삼항 금지**: switch문이나 if/else 체인 사용
3. **복잡도 감소**: 불필요한 중첩과 추상화 제거
4. **기능 보존**: 코드 동작은 절대 변경하지 않음

## 개선 대상

- 불필요한 복잡성과 깊은 중첩
- 중복 코드와 과도한 추상화
- 불명확한 변수/함수명
- 프로젝트 표준 위반
- 가독성을 희생한 밀집된 코드

## 예시

**Before:**
```javascript
const result = items.length > 0 ? items[0].active ? items[0].value : items[0].fallback ?? null : defaultValue;
```

**After:**
```javascript
function getItemValue(items, defaultValue) {
  if (items.length === 0) {
    return defaultValue;
  }

  const firstItem = items[0];
  if (firstItem.active) {
    return firstItem.value;
  }

  return firstItem.fallback ?? null;
}
```
