# Claude Plugins

Claude Code용 커스텀 플러그인 마켓플레이스입니다.

## 설치 방법

### 1. 마켓플레이스 추가 (터미널)

```bash
claude plugin marketplace add zettalyst/claude-plugins
```

### 2. 마켓플레이스 업데이트 (터미널)

```bash
claude plugin marketplace update
```

### 3. 플러그인 설치 (터미널)

```bash
claude plugin install clarify-ralph@zettalyst-plugins
```

### 4. Claude Code 재시작

플러그인을 로드하려면 Claude Code를 재시작하세요.

## 사용 가능한 플러그인

### [clarify-ralph](./plugins/clarify-ralph)

Ralph Wiggum 스타일 루프를 사용한 반복적 요구사항 명확화 도구입니다.

**사용법 (Claude Code 내부):**
```
/clarify-ralph "로그인 기능 추가" --max-iterations 5
```

모호한 요구사항을 구조화된 질문을 통해 정확한 명세로 변환합니다.

**특징:**
- 반복당 4개 질문 × 4개 옵션 (AskUserQuestion 사용)
- "Clarification complete" 옵션으로 사용자 제어 완료
- 최대 반복 횟수 안전 제한
- Before/After 요구사항 요약 출력

**작동 방식:**
1. `/clarify-ralph`로 모호한 요구사항 입력
2. Claude가 한 번에 4개 질문 (각 4개 옵션)
3. 각 질문에 옵션 선택 또는 커스텀 입력
4. 4번째 질문의 4번째 옵션이 항상 "Clarification complete"
5. 완료 또는 최대 반복까지 루프 계속
6. 최종 Before/After 비교 출력

## 빠른 참조

### 터미널 명령어 (CLI)

| 명령어 | 설명 |
|--------|------|
| `claude plugin marketplace add zettalyst/claude-plugins` | 마켓플레이스 추가 |
| `claude plugin marketplace update` | 마켓플레이스 캐시 업데이트 |
| `claude plugin install clarify-ralph@zettalyst-plugins` | clarify-ralph 설치 |
| `claude plugin uninstall clarify-ralph` | 플러그인 제거 |

### 슬래시 명령어 (Claude Code 내부)

| 명령어 | 설명 |
|--------|------|
| `/clarify-ralph "<요구사항>"` | 명확화 루프 시작 |
| `/cancel-clarify` | 활성 루프 취소 |
| `/help` | 플러그인 도움말 표시 |

## 마켓플레이스 구조

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json    # 마켓플레이스 매니페스트
├── plugins/
│   └── clarify-ralph/      # 플러그인 디렉토리
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── commands/
│       ├── hooks/
│       └── README.md
└── README.md
```

## 기여하기

1. 이 저장소를 포크하세요
2. `plugins/<your-plugin-name>/`에 플러그인을 생성하세요
3. `.claude-plugin/marketplace.json`에 항목을 추가하세요
4. Pull Request를 제출하세요

## 라이선스

MIT
