# Interview Spec Plugin

심층 인터뷰를 통해 모호한 요구사항을 명확한 스펙 문서(SPEC.md)로 변환합니다.

## Installation

```bash
# 1. Add marketplace (first time only)
claude plugin marketplace add october-academy/agent-plugins

# 2. Update marketplace
claude plugin marketplace update

# 3. Install plugin
claude plugin install interview-spec@agent-plugins

# 4. Restart Claude Code
```

## Usage

`/interview-spec` 또는 아래와 같은 트리거로 실행:

- "요구사항을 정리하고 싶어"
- "스펙 문서를 만들고 싶어"
- "뭘 만들어야 할지 명확하지 않아"

## 인터뷰 범위

단순 요구사항 수집이 아닌 심층적 접근:

| 영역 | 질문 예시 |
|------|----------|
| 서비스 기획 | 무엇을 만들려 하는가? 왜 필요한가? |
| 사용자 문제 | 누가 어떤 상황에서 어떤 고통을 겪는가? |
| 핵심 가치 | 본질적 가치 제안은 무엇인가? |
| 기능 범위 | 포함/제외 항목은? |
| 기술적 선택 | 기술 스택 선택 근거는? |
| 제약사항 | 시간, 예산, 인력 한계는? |
| 트레이드오프 | 무엇을 포기하고 무엇을 얻는가? |

## 인터뷰 진행 방식

- 한 번에 **3-4개 질문**만 제시
- 모호한 답변에는 **구체적 사례/근거 요구**
- **숨겨진 가정과 암묵적 결정** 드러내기
- 목표: "좋은 아이디어"가 아닌 **명시적 결정과 근거**

## 출력물: SPEC.md

인터뷰 완료 후 구조화된 스펙 문서 생성:

```markdown
# [프로젝트명] 스펙 문서

## 1. 개요
## 2. 사용자 정의
## 3. 기능 범위 (In/Out of Scope)
## 4. 기술적 결정
## 5. 제약사항
## 6. 트레이드오프
## 7. 리스크 및 우려사항
## 8. 미결정 항목 [TBD]
```

## When to Use

**Use when:**
- 요구사항이 모호하거나 불완전할 때
- 중요한 결정들의 근거를 문서화해야 할 때
- 프로젝트 시작 전 스펙을 명확히 해야 할 때

**Skip when:**
- 요구사항이 이미 명확할 때
- 단순하고 명확한 태스크

## License

MIT
