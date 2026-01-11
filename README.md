# Claude Plugins

Claude Code용 커스텀 플러그인 마켓플레이스입니다.

## 설치 방법

```bash
# 1. 마켓플레이스 추가
claude plugin marketplace add october/claude-plugins

# 2. 마켓플레이스 업데이트
claude plugin marketplace update

# 3. 플러그인 설치
claude plugin install <plugin-name>@october-plugins

# 4. Claude Code 재시작
```

## 사용 가능한 플러그인

### [clarify](./plugins/clarify)

모호한 요구사항을 구조화된 질문을 통해 정확한 명세로 변환합니다.

```bash
claude plugin install clarify@october-plugins
```

**사용법:**
```
/clarify "로그인 기능 추가"
/clarify "REST API 구축" --max-iterations 5
```

**특징:**
- 반복당 4개 질문 × 4개 옵션
- 기본 3회 반복 (--max-iterations로 조정)
- Before/After 요구사항 요약 출력

---

### [feature-dev](./plugins/feature-dev)

7단계 체계적 기능 개발 워크플로우입니다.

```bash
claude plugin install feature-dev@october-plugins
```

**사용법:**
```
/feature-dev OAuth 인증 추가
```

**7단계 워크플로우:**
1. Discovery - 요구사항 이해
2. Codebase Exploration - 기존 패턴 분석
3. Clarifying Questions - 모호함 해소
4. Architecture Design - 구현 방식 설계
5. Implementation - 구현
6. Quality Review - 코드 리뷰
7. Summary - 결과 문서화

**에이전트:**
- `code-explorer`: 코드베이스 분석
- `code-architect`: 아키텍처 설계
- `code-reviewer`: 코드 리뷰

---

### [wrap](./plugins/wrap)

세션 마무리 워크플로우입니다. 멀티 에이전트 분석으로 문서화, 자동화, 학습 포인트, 후속 작업을 제안합니다.

```bash
claude plugin install wrap@october-plugins
```

**사용법:**
```
/wrap                     # 인터랙티브 세션 마무리
/wrap README 오타 수정     # 빠른 커밋
```

**2-Phase 아키텍처:**
- Phase 1 (병렬): doc-updater, automation-scout, learning-extractor, followup-suggester
- Phase 2 (순차): duplicate-checker

---

## 빠른 참조

### 터미널 명령어 (CLI)

| 명령어 | 설명 |
|--------|------|
| `claude plugin marketplace add october/claude-plugins` | 마켓플레이스 추가 |
| `claude plugin marketplace update` | 마켓플레이스 업데이트 |
| `claude plugin install clarify@october-plugins` | clarify 설치 |
| `claude plugin install feature-dev@october-plugins` | feature-dev 설치 |
| `claude plugin install wrap@october-plugins` | wrap 설치 |
| `claude plugin uninstall <name>` | 플러그인 제거 |

### 슬래시 명령어 (Claude Code 내부)

| 명령어 | 설명 |
|--------|------|
| `/clarify "<요구사항>"` | 요구사항 명확화 루프 시작 |
| `/cancel` | clarify 루프 취소 |
| `/feature-dev <기능>` | 7단계 기능 개발 시작 |
| `/wrap` | 세션 마무리 분석 |

## 마켓플레이스 구조

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── clarify/
│   ├── feature-dev/
│   └── wrap/
└── README.md
```

## 라이선스

MIT
