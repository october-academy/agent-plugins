# Design Rules Reference

HTML 구현 시 반드시 참고할 디자인 제약 모음. SKILL.md Workflow 4단계에서 읽어라.

---

## Core Rules

- **Size**: 1440×810 (16:9)
- **Border**: 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur ever)
- **Title font**: Noto Sans KR 900 (headings/labels only)
- **Body font**: Noto Sans KR, weight 700 (bold default). Use 400 only for minor annotations
- **Code/number font**: JetBrains Mono (`.mono`, `.code`, `.tag`)
- **Colors**: CSS variables only — never hardcode hex in HTML (Canvas/D3 패턴은 JS 내 hex 허용)
- **No**: gradients, blur shadows, soft edges

## 시각 패턴 (Isometric, IconDiagram, Network, Graph) 참고

- **SVG 패턴** (Isometric, IconDiagram): `<svg>` 인라인. 정밀한 좌표 배치. figure.css 색상 변수 사용 가능.
- **Canvas 패턴** (Network): `<canvas>` + JS. `document.fonts.ready.then()`으로 폰트 로드 후 렌더링. retina 2x (`width=2880, height=1620, style width=1440px`).
- **D3 패턴** (Graph): `<script src="https://d3js.org/d3.v7.min.js">`. 시뮬레이션 동기 실행: `for(let i=0;i<300;i++) sim.tick(); sim.stop();`
- **공통**: dot grid 배경 (`<pattern>` SVG 또는 Canvas 루프), 모노스페이스 섹션 라벨, 텍스트 최소화 — 도형과 연결선으로 구조 전달

## SVG/Canvas/D3 인라인 font-size 규칙

| 역할 | 최소 px | 비고 |
|------|---------|------|
| 콘텐츠 라벨 | 24px | `font-size="24"`, `ctx.font = '${24*S}px ...'` |
| 보조 라벨 (축 눈금, 순위 등) | 20px | 18px 이하 금지 |

## 텍스트 버짓 — 절대 한도

**Figure는 글의 설명을 대체하지 않는다. 시각적 앵커를 제공할 뿐이다.**

| 컴포넌트 | 최대 텍스트 | 예시 |
|---------|-----------|------|
| `.flow-card` | **제목 2~4단어**. 설명 생략 또는 max 6자 | "맥락 확인", "사례 복기" |
| `.quote-card` | **max 8자** (핵심 키워드만) | "좋은데요!", "0건" |
| `.section-label` | **max 6자** | "나쁜 예시", "좋은 방법" |
| `.tl-anno` | **사용 자제**. 쓸 경우 max 4자 키워드 | "맥락", "사례" |
| `.journey-desc` | **max 6자** | "서비스 인지" |
| `.story-desc` | **max 6자** | "결제 확인" |
| `.bar-label` | **max 4단어** | "React", "설문 응답률" |
| `.terminal-card-question` | **max 12자, 1줄 권장** (`<br>` 금지, balance 자동 줄바꿈) | "성공 기준은?" |
| `.terminal-option` | **max 8자** | "WAU 활성만" |
| `.terminal-answer` | **max 8자** | "첫 매출" |
| `.schema-field` | **필드명 max 8자. 타입 주석 생략** | "user_id FK" |
| `.matrix-corner` | **max 4자 또는 빈칸** | "" |
| Figure 전체 | **max 20단어** (Terminal 예외: 35단어) | — |

## 최소 폰트 크기 — 2-tier 시스템

1440px 캔버스에서 **1.25rem(20px) 미만 절대 금지**.
콘텐츠 텍스트(읽어야 하는 키워드)는 **1.5rem(24px) 이상**.

| Tier | 최소 크기 | 25% 환산 | 해당 요소 |
|------|---------|---------|----------|
| 콘텐츠 | 1.5rem (24px) | 6px | `.flow-card`, `.bar-label`, `.state-node`, `.arch-node`, `.schema-field`, `.arrow-label`, `.journey-desc`, `.story-desc`, `.tl-anno`, `.matrix-corner`, `.terminal-prompt`, `.terminal-card-question` |
| 장식 마커 | 1.25rem (20px) | 5px | `.tag`, `.badge`, `.schema-pk`, `.schema-fk` |
| 섹션 헤딩 | 2rem (32px) | 8px | `.section-label` |
| Figure 제목 | 3rem (48px) | 12px | `.figure-title` |

**장식 전용 클래스** (`.sticker`, `.sticker-sm`, `.code`)는 콘텐츠 용도 사용 금지.
**Terminal 보조 텍스트** (`.terminal-option`, `.terminal-answer` 등)는 1.4rem(22px) 허용.
**SVG/Canvas 인라인**: `font-size` 최소 20px. 18px 이하 금지.

## Weight Hierarchy

| Role | Weight | Example |
|------|--------|---------|
| 모든 텍스트 기본값 | 700 | body default, `.flow-card`, `.journey-desc` |
| 부연/보조 (드물게 사용) | 400 | 긴 설명이 불가피할 때만 |
| Display titles | Noto Sans KR 900 | `.figure-title`, `.section-label` |

## Composition — 정형화 피하기

- `.figure-title` + `.insight-box`를 **매번 넣지 마라**. 컨텐츠만으로 의미가 전달되면 생략
- 제목이 필요하면 `.figure-title` 대신 패턴 내부에 자연스럽게 포함
- 하단 요약이 필요하면 `.insight-box` 대신 `.callout`이나 `.mark`로 변주
- 같은 블로그 포스트 내 여러 Figure는 각각 다른 구성을 사용할 것

## 아이콘/이모지 원칙

- **텍스트만으로 충분하면 아이콘 생략**. `.icon` 원형은 선택 사항
- `.flow-card`는 아이콘 없이 `<strong>제목</strong>`만으로 충분. 설명 텍스트 최소화
- 이모지는 카테고리 구분이 반드시 필요할 때만 (예: `.arch-label`, `.journey-dot`)
- 장식용 이모지/아이콘 금지

## 패턴별 레이아웃 규칙

모바일 축소 상태에서도 구조가 한눈에 잡히려면, 각 패턴의 정렬과 색상 사용이 일관되어야 한다.

**Comparison (Split)**
- 양쪽 카드는 **동일한 상단 시작점**에서 시작. `margin-top` 등으로 한쪽만 아래로 밀지 마라
- `.split-left`와 `.split-right`에 `justify-content: flex-start`를 명시하고, 카드 컨테이너의 구조를 동일하게 유지

**Matrix (2×2)**
- **열별 색상 통일**: 1열은 하나의 색상 계열, 2열은 다른 색상 계열. 같은 열의 셀은 모두 동일 색상
- **헤더 ≠ 셀**: 헤더(`.matrix-label-x`)는 진한 톤(`--good-card`, `--info-card`), 본문 셀은 연한 톤(`--good-bg`, `--info-bg`)
- **셀 구분선**: `.matrix`에 `background:var(--dark);gap:3px` 적용 (grid gap 기법). 개별 셀에 border 넣지 마라 — 이중 테두리가 생긴다
- 예: 1열 헤더 `--good-card` → 1열 셀 `--good-bg`, 2열 헤더 `--info-card` → 2열 셀 `--info-bg`
- **코너(좌상단)는 흰색**: `background:var(--white)`. 검은색 금지

**Architecture**
- 레이어당 노드 **최소 3개**. 2개만 넣으면 레이어 영역 대비 노드가 빈약해 보인다
- 프롬프트에 2개만 명시되어 있어도, 맥락상 추가 가능한 노드를 보충하라 (예: Client 레이어에 Web, Mobile 외 CLI 추가)

**Waffle (SVG)**
- 제목은 **한국어**로, 그리드 상단 또는 좌측에 배치. 영문 부제목/서브타이틀 금지
- 범례(legend)는 그리드 우측에 컴팩트하게. 범례 텍스트도 한국어

**Typographic Statement (SVG)**
- 인용문은 캔버스(1440×810) 기준 **수직·수평 모두 중앙 정렬**
- SVG의 viewBox를 `0 0 1440 810`으로 설정하고, 텍스트 블록의 y 좌표를 중앙에 맞춰라

## Textures & Decorations

- `.bg-dots`, `.bg-lines`, `.bg-grid`, `.bg-crosshatch` — 시각적 깊이
- `.tape`, `.sticker`, `.stamp`, `.mark` — 수제 느낌
- `.bg-*`, `.p-*`, `.m-*`, `.badge`, `.tag` — inline style 최소화

## File Naming

```
apps/content/src/content/blog/images/{blog-slug}/{blog-slug}-{figure-name}.png
```

## MDX Usage

```mdx
<Figure src="/blog/images/{slug}/{filename}.png" alt="..." caption="..." />
```
