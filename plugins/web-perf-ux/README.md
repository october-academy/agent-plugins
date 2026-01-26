# Web Performance & UX Optimization

웹 애플리케이션의 성능과 UX를 자동화된 분석으로 최적화하는 플러그인입니다.

## 주요 기능

- **Lighthouse 기반 측정**: CLI 또는 Playwright MCP를 통한 성능 측정
- **Core Web Vitals 분석**: LCP, CLS, INP 문제의 근본 원인 진단
- **UX 이슈 탐지**: 레이아웃 시프트, 느린 인터랙션 등 사용자 경험 문제 파악
- **실행 가능한 개선 계획**: 코드 레벨의 구체적인 수정 제안

## 워크플로우

```
측정 (Measure) → 분석 (Analyze) → 설명 (Explain) → 계획 (Plan)
```

1. Lighthouse CLI 또는 Web Vitals 스크립트로 성능 측정
2. 결과를 이슈 카탈로그 및 프레임워크 패턴과 대조 분석
3. 구조화된 마크다운 리포트 생성 (Executive Summary, Scorecard, Findings)
4. Plan/Task 도구를 통해 우선순위화된 작업 목록 생성

## 사용 예시

- "페이지 성능 분석해줘"
- "왜 페이지가 느린지 진단해줘"
- "CLS 문제 해결해줘"
- "Core Web Vitals 최적화"
- "Lighthouse 실행해줘"

## 포함된 리소스

### Scripts
- `lighthouse-runner.sh` - Lighthouse CLI 래퍼 (모바일/데스크톱, 스로틀링 옵션)
- `collect-vitals.js` - Playwright용 Web Vitals 수집 스크립트

### References
- `core-web-vitals.md` - CWV 임계값 및 해석 가이드
- `common-issues.md` - 일반적인 성능 이슈 카탈로그 (증거 → 원인 → 해결책)
- `nextjs.md` - Next.js 전용 최적화 패턴
- `react.md` - React 성능 패턴

## 요구사항

- Playwright MCP 서버 (브라우저 자동화용)
- Lighthouse CLI (`npm install -g lighthouse`)

## 설치

```bash
# 1. 마켓플레이스 추가 (최초 1회)
claude plugin marketplace add october/claude-plugins

# 2. 마켓플레이스 업데이트
claude plugin marketplace update

# 3. 플러그인 설치
claude plugin install web-perf-ux@october-plugins

# 4. Claude Code 재시작
```

## License

MIT
