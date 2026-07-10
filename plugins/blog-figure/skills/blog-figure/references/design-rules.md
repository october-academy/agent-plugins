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
- **Contrast**: 유색 면 위 텍스트는 `--dark` 기본 (white는 진한 accent 위만). `--muted-fg`는 흰·연회색 배경 전용 — [색상 대비](#색상-대비--유색-면-위-텍스트) 참조
- **Connectors**: 화살표·연결선 샤프트 ≥6px + 화살촉 ≥20px — [커넥터](#커넥터--화살표연결선-두께) 참조
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

## 컴포넌트 수량 제한

**적은 수의 큰 컴포넌트 > 많은 수의 작은 컴포넌트.** 이 표가 컴포넌트 캡의 SSoT다 —
`validate_figure.py`도 여기 명시된 수량으로 캡을 검사한다.

| 패턴 | 최대 수량 | 이유 |
|------|---------|------|
| Flow | **3단계** | 3개면 비교 충분, 5개면 텍스트 덩어리 |
| Timeline | **3블록** | 블록 크기↑, 라벨 가독성↑ |
| Storyboard | **4패널 (2×2)** | 패널 크기 2배 확보 |
| Bar chart | **4행** | 바 높이 충분히 확보 |
| Architecture | **3레이어, 레이어당 3노드** (2노드면 너무 빈약) | 시스템 구조의 풍부함 |
| Split 비교 | **양쪽 각 2~3카드** | 카드 크기 유지 |
| Journey | **4단계** | dot 간 여백 확보 |
| Schema | **3테이블, 테이블당 3~4필드** | 글자 크기 유지 |
| Terminal | **3카드, 카드당 옵션 2개 (max 3)** | 질문 max 12자 1줄, `<br>` 금지 |
| Matrix | **2×2 (셀 max 4). 코너 4자 이내 또는 빈칸** | 축 라벨이 의미 전달 |
| Waffle | **1 grid (10x10), 2 카테고리 (범례 2)** | 총 ~8단어 (범례 포함) |
| Typographic | **1 primary text (max 8단어)** | attribution max 4단어 |
| Slope | **max 5항목, 2시점** | 항목명 1단어 |
| Treemap | **max 6~8 cells** | 라벨 1단어. 작은 잔여 항목은 "기타"로 병합 — 무라벨 색면 금지 |
| Radar | **max 5축, 1~2 series** | 축 라벨 1단어 |
| Dumbbell | **max 5 rows** | 라벨 max 3단어 |
| Heatmap | **max 7x5 grid (35 cells)** | 셀 ~110x90px |
| Bullet | **max 3~4 charts** | 범위 3단계 + 타겟 마커 |
| Sparkline Grid | **max 6 sparklines (3x2)** | 항목당 라벨 1단어 + 값 1개 |
| Waterfall | **max 6~8 bars** | 라벨 1~2단어, 시작/합계 포함 |

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

## 색상 대비 — 유색 면 위 텍스트

25% 축소에서 살아남는 것은 대비뿐이다. WCAG 실측 기준으로 지킬 것:

- **유색 면 위 `--muted-fg` 금지.** `--muted-fg`(#737373)는 `--white`/`--card`/`--muted` 같은
  흰·연회색 배경 전용이다. 유색 카드·노드 위 보조 텍스트는 `--dark`가 기본이고, 배경이 진한
  accent(`--info-accent`, `--bad-accent`, `--good-accent`, `--dark`)일 때만 `--white`를 쓴다.
  실측: blue #3B82F6 위 muted-fg = **1.29:1** — 사실상 안 보인다.
- **accent 텍스트 색(`.text-bad`/`.text-good`/`.text-info`)은 흰색·tint 배경 전용.** 같은 계열
  카드 색 위에 올리면 무너진다 — `--bad-card` 위 `--bad-accent` = **1.58:1**.
- **lime(#a3e635)·yellow(#fde047)는 선(stroke)·글자색 금지.** 연회색 배경(#f5f5f5) 위
  1.38:1/1.21:1이라 선이 통째로 사라진다. 이 둘은 **채움면 + `--dark` 텍스트** 조합
  전용(13~15:1). **선 팔레트**: blue #3B82F6 · orange #FF6B35 · pink #ff5c8d · purple #8B5CF6 ·
  dark green #4d7c0f — lime 슬롯의 선 버전이 dark green이다(6번째가 필요하면 `--dark`).
- **핵심 수치는 가장 큰 시각 무게.** Content Brief의 강조점(예: "0건", 전환 %)은 figure에서
  가장 크고 진해야 한다 — 크게 + `--dark` 900 (어두운 면 위면 `--white` 900). 핵심 수치가
  라벨보다 작거나 muted로 들어가는 **강조 역전 금지** — Journey의 %, Comparison의 대비 수치가
  대표 사례다.

## 커넥터 — 화살표·연결선 두께

3px 보더 시스템과 균형을 맞춘다: 정보를 나르는 커넥터는 25% 축소 후에도 1.5px 이상 남아야 한다.

- **샤프트 최소 6px, 화살촉 최소 20px.** figure.css의 `.arrow-*`, `.journey-line`,
  `.tree-vline`/`.tree-hline`, `.seq-msg-line`이 이 기본값이다 — 인라인 스타일로 얇게 덮어쓰지 마라.
- **SVG 커넥터도 동일**: `stroke-width` ≥ 6(점선 보조 커넥터는 ≥5), 화살촉 `<marker>`는
  `markerUnits="userSpaceOnUse"` + 20px 이상. 기본 markerUnits는 stroke 굵기에 비례해
  화살촉이 왜곡된다.
- **보조 가이드선은 예외**: 축·눈금·베이스라인·라이프라인처럼 구조 배경인 선은 1.5~3px를
  유지한다 — 커넥터와의 두께 위계가 오히려 정보를 만든다.
- **순환(Loop)은 직선 4개 금지에 준한다**: 링(6px 보더 + 큰 corner radius) 또는 코너 곡선 +
  방향 화살촉으로 회전이 형태 자체로 보이게 하라 (patterns-layout.md §13).

## Composition — 정형화 피하기

- `.figure-title` + `.insight-box`를 **매번 넣지 마라**. 컨텐츠만으로 의미가 전달되면 생략
- 제목이 필요하면 `.figure-title` 대신 패턴 내부에 자연스럽게 포함
- 하단 요약이 필요하면 `.insight-box` 대신 `.callout`이나 `.mark`로 변주
- 같은 블로그 포스트 내 여러 Figure는 각각 다른 구성을 사용할 것

## 캔버스 활용

콘텐츠는 1440×810 캔버스를 **균형 있게** 채워야 한다. 상단에 몰리고 하단이 텅 비는 배치는
축소 시 "떠 있는" 인상을 준다.

- **수직 채움**: 본문 컨테이너를 세로 중앙 정렬(`justify-content: center`)하거나 flex로 남은
  공간을 흡수(`flex: 1`)해 810px 높이를 고르게 쓴다. 상단 몰림 + 하단 공백 금지
- **가장자리 여백**: 요소가 캔버스 모서리에 붙거나 잘리지 않게 좌우(그리고 상하) 여백을
  **균등하게** 준다. 한쪽만 붙는 비대칭 배치 금지
- **면적으로 말하기**: 빈 공간이 남으면 컴포넌트를 늘리지 말고(수량 캡 유지) 기존 컴포넌트의
  크기·여백을 키워 캔버스를 채운다 — 모바일 축소에서 구조가 더 잘 잡힌다

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

**Funnel**
- 각 스테이지 폭은 **값에 비례**한다 — 100→60→25면 폭도 그 비율로 좁아져 전환 손실이 형태로 보인다
- 단, 라벨 가독을 위해 **최소폭 하한**을 허용한다: 값이 아주 작아도 스테이지 라벨(단계명·수치)이
  읽히는 폭 아래로는 줄이지 마라. 비례가 우선이되 하한에서 클램프
- 스테이지는 상단 중앙 정렬로 쌓아 좌우 대칭 사다리꼴을 유지(한쪽만 정렬해 기울지 않게)

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
blog/public/blog/images/{blog-slug}/{blog-slug}-{figure-name}.png
```

Repo root(`agentic30-greenfield`) 기준 상대 경로다. 실행 중인 리포에 이 디렉터리가 없으면
임의로 추측하지 말고 사용자에게 저장 위치를 물어라.

## MDX Usage

```mdx
<Figure src="/blog/images/{slug}/{filename}.png" alt="..." caption="..." />
```

## Output Spec

- **해상도**: 출력 PNG는 2880×1620 (1440×810의 retina 2x)이 표준. retina 캡처가 불가능한
  폴백 경로(Playwright — deviceScaleFactor 지정 불가)에서는 1440×810(1x)을 최후 수단으로 허용
- **용량 가이드**: 300KB를 넘으면 압축을 고려하라 — 단, 압축은 해상도를 보존해야 한다.
  `sips -Z 1440` 같은 리샘플은 해상도를 절반(1440×810)으로 낮춰 규격을 깨므로 최종 산출물에
  쓰지 마라
  - PNG 팔레트 압축(해상도 유지, 평면 단색 다이어그램에 효과적): `pngquant --force --quality=65-80 input.png -o output.png`
    (quality 하한 미달 시 exit 99로 파일을 저장하지 않는다 — 그땐 무손실 압축으로 폴백)
  - 완전 무손실: `oxipng -o max input.png`
  - 사진/스크린샷 성격 한정: `cwebp -q 80 input.png -o output.webp`
  - 위 도구는 별도 설치가 필요할 수 있다 — 없으면 압축을 건너뛰고 사용자에게 고지하라
- 사진/스크린샷 성격의 콘텐츠는 WebP를 고려할 수 있다. 다이어그램(도형·텍스트 위주)은
  선명도 손실을 피하기 위해 PNG를 유지하라
