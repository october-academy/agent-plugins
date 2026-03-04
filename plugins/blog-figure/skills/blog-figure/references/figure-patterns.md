# Figure Pattern Reference

Each pattern includes a minimal HTML example. All use `assets/figure.css`.

**핵심 원칙**: 텍스트는 최소한으로. 색상과 면적으로 구조 전달. 모바일 25% 축소에서도 인식 가능.

---

## 1. Comparison (좌우 비교)

Best for: X vs Y, 나쁜 예시 vs 좋은 예시, 이전 vs 이후

Key classes: `.split`, `.split-left`, `.split-right`, `.vs-badge`, `.section-label`, `.quote-card`, `.data-card`

Max: 양쪽 각 2~3개 카드

```html
<body>
  <div class="split relative">
    <div class="vs-badge">VS</div>
    <div class="split-left bg-info">
      <div class="section-label" style="background:var(--info-accent)">말하는 것</div>
      <div class="flex flex-col gap-2" style="width:100%">
        <div class="quote-card">"좋은데요!"</div>
        <div class="quote-card">"써볼게요"</div>
      </div>
    </div>
    <div class="split-right bg-bad">
      <div class="section-label" style="background:var(--bad-accent)">실제 행동</div>
      <div class="flex flex-col gap-2" style="width:100%;margin-top:2rem">
        <div class="data-card">가입 <span class="text-bad">0건</span></div>
        <div class="data-card">결제 <span class="text-bad">0건</span></div>
      </div>
    </div>
  </div>
</body>
```

Notes: 카드 내 텍스트는 키워드만. 문장 금지.

---

## 2. Flow (수직 플로우 비교)

Best for: 프로세스 비교, 단계별 차이, 방법론 대비

Key classes: `.flow-card`, `.flow-card.bad`, `.flow-card.good`, `.arrow-down`

Max: **3단계**. 설명 텍스트 생략 — 제목만 사용.

```html
<body>
  <div class="split relative" style="height:auto;min-height:75%">
    <div class="split-left bg-bad">
      <div class="section-label" style="background:var(--bad-accent)">나쁜 방법</div>
      <div class="flex flex-col items-center">
        <div class="flow-card bad"><strong>아이디어 설명</strong></div>
        <div class="arrow-down"></div>
        <div class="flow-card bad"><strong>평가 요청</strong></div>
        <div class="arrow-down"></div>
        <div class="flow-card bad" style="border-color:var(--bad-accent)"><strong style="color:var(--bad-accent)">착각</strong></div>
      </div>
    </div>
    <div class="split-right bg-good">
      <div class="section-label" style="background:var(--good-accent)">좋은 방법</div>
      <div class="flex flex-col items-center">
        <div class="flow-card good"><strong>맥락 확인</strong></div>
        <div class="arrow-down"></div>
        <div class="flow-card good"><strong>사례 복기</strong></div>
        <div class="arrow-down"></div>
        <div class="flow-card good" style="border-color:var(--good-accent)"><strong style="color:var(--good-accent)">니즈 발견</strong></div>
      </div>
    </div>
  </div>
</body>
```

Notes: Flow는 split 없이 단일 칼럼으로도 사용 가능. 설명 텍스트(`<span>`) 대신 제목(`<strong>`)만 사용할 것.

---

## 3. Timeline (수평 타임라인)

Best for: 시간 배분, 단계 순서, 비율 시각화

Key classes: `.timeline`, `.tl-block`, `.tl-label`, `.tl-time`

Max: **3블록**. `.tl-annotations` 사용 자제 — 쓸 경우 키워드 1개만.

```html
<body>
  <div class="timeline">
    <div class="tl-block" style="flex:3;background:var(--tl-blue)">
      <div class="tl-label">맥락</div><div class="tl-time">3분</div>
    </div>
    <div class="tl-block" style="flex:5;background:var(--tl-lime)">
      <div class="tl-label">사례 복기</div><div class="tl-time">5분</div>
    </div>
    <div class="tl-block" style="flex:4;background:var(--tl-orange)">
      <div class="tl-label">비용 확인</div><div class="tl-time">4분</div>
    </div>
  </div>
</body>
```

Notes: `flex` 비율로 시간 비율을 직관적으로 표현. 색상은 `--tl-*` 토큰 사용. annotation 생략이 기본.

---

## 4. Concept (개념도)

Best for: 관계도, 벤 다이어그램 스타일, 개념 비교

Key classes: `.concept-block`, absolute positioning, z-index

```html
<body>
  <div style="position:relative;width:900px;height:500px">
    <div class="concept-block" style="position:absolute;left:0;top:80px;width:300px;height:350px;background:var(--yellow);z-index:1">
      <div class="text-4xl">TDD</div>
      <div class="text-xl">테스트 중심</div>
    </div>
    <div class="concept-block" style="position:absolute;left:250px;top:0;width:400px;height:500px;background:var(--orange);z-index:2">
      <div class="text-4xl">IDD</div>
      <div class="text-xl">인터뷰 중심</div>
    </div>
    <div class="concept-block" style="position:absolute;right:0;top:80px;width:300px;height:350px;background:var(--info-accent);color:white;z-index:3">
      <div class="text-4xl">SDD</div>
      <div class="text-xl">스펙 중심</div>
    </div>
  </div>
</body>
```

Notes: `z-index`로 겹침 순서 제어. 블록 내 텍스트는 약어+한줄 키워드만.

---

## 5. Architecture (시스템 구성도)

Best for: 시스템 아키텍처, 컴포넌트 관계, 레이어 구조

Key classes: `.arch`, `.arch-layer`, `.arch-label`, `.arch-nodes`, `.arch-node`

Max: **3레이어, 레이어당 3노드**

```html
<body>
  <div class="arch">
    <div class="arch-layer">
      <div class="arch-label" style="background:var(--tl-blue)">Client</div>
      <div class="arch-nodes">
        <div class="arch-node">Web</div>
        <div class="arch-node">Mobile</div>
        <div class="arch-node">CLI</div>
      </div>
    </div>
    <div class="arch-layer">
      <div class="arch-label" style="background:var(--tl-lime)">Service</div>
      <div class="arch-nodes">
        <div class="arch-node">API</div>
        <div class="arch-node">Auth</div>
        <div class="arch-node">Analytics</div>
      </div>
    </div>
    <div class="arch-layer">
      <div class="arch-label" style="background:var(--tl-orange)">Data</div>
      <div class="arch-nodes">
        <div class="arch-node">PostgreSQL</div>
        <div class="arch-node">Redis</div>
      </div>
    </div>
  </div>
</body>
```

Notes: 노드 텍스트는 단어 1~2개. `figure-title` 생략 — 컨텐츠가 자명하면 불필요.

---

## 6. Interaction (시퀀스 다이어그램)

Best for: 요청/응답, 사용자-시스템 상호작용, API 플로우

Key classes: `.seq`, `.seq-entities`, `.seq-entity`, `.seq-messages`, `.seq-msg`, `.seq-msg-line`, `.seq-msg-label`, `.seq-msg-arrow`

```html
<body>
  <div class="seq">
    <div class="seq-entities">
      <div class="seq-entity" style="background:var(--tl-blue)">사용자</div>
      <div class="seq-entity" style="background:var(--tl-lime)">서버</div>
    </div>
    <div class="seq-messages">
      <div class="seq-msg right">
        <div class="seq-msg-label">로그인 요청</div>
        <div class="seq-msg-line"></div>
        <div class="seq-msg-arrow"></div>
      </div>
      <div class="seq-msg left">
        <div class="seq-msg-arrow"></div>
        <div class="seq-msg-line dashed"></div>
        <div class="seq-msg-label">토큰 반환</div>
      </div>
    </div>
  </div>
</body>
```

Notes: `.right`은 →방향(요청), `.left`는 ←방향(응답). 메시지 라벨은 2~3단어. 엔티티 2~3개.

---

## 7. State (상태 머신)

Best for: 상태 전이, 라이프사이클, 워크플로우 상태

Key classes: `.state-chain`, `.state-node`, `.state-node.active/.initial/.final`, `.state-transition`, `.arrow-right`, `.arrow-label`

```html
<body>
  <div class="state-chain">
    <div class="state-node initial">장바구니</div>
    <div class="state-transition">
      <div class="arrow-label">결제</div>
      <div class="arrow-right" style="width:60px"></div>
    </div>
    <div class="state-node active">결제 완료</div>
    <div class="state-transition">
      <div class="arrow-label">배송</div>
      <div class="arrow-right" style="width:60px"></div>
    </div>
    <div class="state-node final">수령</div>
  </div>
</body>
```

Notes: 수평 체인이 기본. **상태 4개 이내** 권장. `.initial`(시작), `.active`(강조), `.final`(종료) 변형 사용.

---

## 8. Schema (데이터 스키마)

Best for: DB 테이블 구조, 데이터 모델, 엔티티 관계

Key classes: `.schema-container`, `.schema-table`, `.schema-header`, `.schema-field`, `.schema-pk`, `.schema-fk`

Max: **3테이블, 테이블당 4필드**

```html
<body>
  <div class="schema-container">
    <div class="schema-table">
      <div class="schema-header" style="background:var(--tl-blue)">User</div>
      <div class="schema-field"><span>id</span> <span class="schema-pk">PK</span></div>
      <div class="schema-field"><span>email</span> <span class="text-sm">string</span></div>
      <div class="schema-field"><span>name</span> <span class="text-sm">string</span></div>
    </div>
    <div class="schema-table">
      <div class="schema-header" style="background:var(--tl-lime)">Post</div>
      <div class="schema-field"><span>id</span> <span class="schema-pk">PK</span></div>
      <div class="schema-field"><span>author_id</span> <span class="schema-fk">FK</span></div>
      <div class="schema-field"><span>title</span> <span class="text-sm">string</span></div>
    </div>
  </div>
</body>
```

Notes: FK 뱃지는 간결하게 "FK"만. 테이블 2~3개 권장 (공간 제한).

---

## 9. Hierarchy (계층 구조)

Best for: 조직도, 트리 구조, 분류 체계, 상속 관계

Key classes: `.tree`, `.tree-node`, `.tree-level`, `.tree-branch`, `.tree-vline`, `.tree-hline`

```html
<body>
  <div class="tree">
    <div class="tree-node" style="background:var(--yellow)">App</div>
    <div class="tree-vline"></div>
    <div class="tree-hline" style="width:400px"></div>
    <div class="tree-level">
      <div class="tree-branch">
        <div class="tree-vline"></div>
        <div class="tree-node" style="background:var(--tl-blue)">Layout</div>
      </div>
      <div class="tree-branch">
        <div class="tree-vline"></div>
        <div class="tree-node" style="background:var(--tl-lime)">Pages</div>
      </div>
      <div class="tree-branch">
        <div class="tree-vline"></div>
        <div class="tree-node" style="background:var(--tl-orange)">Shared</div>
      </div>
    </div>
  </div>
</body>
```

Notes: **깊이 2단계** 권장. 노드 텍스트는 단어 1개.

---

## 10. Matrix (매트릭스)

Best for: 2x2 분석, 의사결정 매트릭스, 기능 비교표

Key classes: `.matrix`, `.matrix-header`, `.matrix-cell`, `.matrix-corner`, `.matrix-label-x`, `.matrix-label-y`

```html
<body>
  <div class="matrix" style="grid-template-columns:160px 1fr 1fr;grid-template-rows:auto 1fr 1fr;width:80%">
    <div class="matrix-corner">난이도 / 임팩트</div>
    <div class="matrix-label-x bg-good">높은 임팩트</div>
    <div class="matrix-label-x bg-bad">낮은 임팩트</div>
    <div class="matrix-label-y bg-good">쉬움</div>
    <div class="matrix-cell" style="background:var(--good-card)">
      <div class="text-xl"><strong>Quick Win</strong></div>
    </div>
    <div class="matrix-cell bg-info">
      <div class="text-xl"><strong>채워넣기</strong></div>
    </div>
    <div class="matrix-label-y bg-bad">어려움</div>
    <div class="matrix-cell" style="background:var(--yellow)">
      <div class="text-xl"><strong>Big Bet</strong></div>
    </div>
    <div class="matrix-cell" style="background:var(--bad-card)">
      <div class="text-xl"><strong>하지 말것</strong></div>
    </div>
  </div>
</body>
```

Notes: 셀 내 텍스트는 **키워드 1~2단어**만. 부연 설명(`.text-sm`) 생략.

---

## 11. Journey (사용자 여정)

Best for: 사용자 경험 흐름, 터치포인트 맵, 온보딩 과정

Key classes: `.journey`, `.journey-line`, `.journey-step`, `.journey-dot`, `.journey-label`, `.journey-desc`

Max: **4단계**

```html
<body>
  <div class="journey">
    <div class="journey-line"></div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-blue)">1</div>
      <div class="journey-label">발견</div>
      <div class="journey-desc">서비스 인지</div>
    </div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-lime)">2</div>
      <div class="journey-label">가입</div>
      <div class="journey-desc">빠른 시작</div>
    </div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-orange)">3</div>
      <div class="journey-label">Aha!</div>
      <div class="journey-desc">가치 인식</div>
    </div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-purple)">4</div>
      <div class="journey-label">재방문</div>
      <div class="journey-desc">습관 형성</div>
    </div>
  </div>
</body>
```

Notes: `.journey-desc`는 **4자 이내** 키워드. timeline과 달리 비율이 아닌 이산 포인트.

---

## 12. Funnel (퍼널)

Best for: 전환율, 단계별 감소, 마케팅 퍼널, 파이프라인

Key classes: `.funnel`, `.funnel-stage`, `.funnel-label`, `.funnel-value`

Max: **4단계**

```html
<body>
  <div class="funnel">
    <div class="funnel-stage" style="width:100%;background:var(--tl-blue)">
      <span class="funnel-label">방문</span>
      <span class="funnel-value">10,000</span>
    </div>
    <div class="funnel-stage" style="width:75%;background:var(--tl-lime)">
      <span class="funnel-label">가입</span>
      <span class="funnel-value">3,200</span>
    </div>
    <div class="funnel-stage" style="width:50%;background:var(--tl-orange)">
      <span class="funnel-label">첫 사용</span>
      <span class="funnel-value">720</span>
    </div>
    <div class="funnel-stage" style="width:30%;background:var(--tl-purple)">
      <span class="funnel-label">결제</span>
      <span class="funnel-value">180</span>
    </div>
  </div>
</body>
```

Notes: `width`를 inline style로 점진적 감소. 라벨은 2자 내외. 퍼센트 표기 생략 가능.

---

## 13. Loop (순환 루프)

Best for: 피드백 루프, PDCA 사이클, 반복 프로세스

Key classes: `.loop`, `.loop-node`, `.loop-center`, `.arrow-right`, `.arrow-down`, `.arrow-left`, `.arrow-up`

```html
<body>
  <div class="loop" style="gap:1.5rem">
    <div class="loop-node" style="background:var(--tl-blue)">아이디어</div>
    <div class="arrow-right" style="width:80px"></div>
    <div class="loop-node" style="background:var(--tl-lime)">Build</div>
    <div class="arrow-up" style="height:40px"></div>
    <div class="loop-center" style="font-size:2.5rem">↻</div>
    <div class="arrow-down" style="height:40px"></div>
    <div class="loop-node" style="background:var(--tl-purple)">Learn</div>
    <div class="arrow-left" style="width:80px"></div>
    <div class="loop-node" style="background:var(--tl-orange)">Measure</div>
  </div>
</body>
```

Notes: 3x3 CSS grid로 4개 노드를 정사각형 배치. 노드 텍스트는 단어 1개.

---

## 14. Data Viz (데이터 시각화)

Best for: 수치 비교, 비율, 설문 결과, 벤치마크

Key classes: `.bar-chart`, `.bar-row`, `.bar-label`, `.bar-track`, `.bar-fill`, `.bar-value`

Max: **4행**

```html
<body>
  <div class="bar-chart">
    <div class="bar-row">
      <div class="bar-label">React</div>
      <div class="bar-track"><div class="bar-fill" style="width:85%;background:var(--tl-blue)">85%</div></div>
    </div>
    <div class="bar-row">
      <div class="bar-label">Vue</div>
      <div class="bar-track"><div class="bar-fill" style="width:78%;background:var(--tl-lime)">78%</div></div>
    </div>
    <div class="bar-row">
      <div class="bar-label">Svelte</div>
      <div class="bar-track"><div class="bar-fill" style="width:92%;background:var(--tl-orange)">92%</div></div>
    </div>
    <div class="bar-row">
      <div class="bar-label">Angular</div>
      <div class="bar-track"><div class="bar-fill" style="width:54%;background:var(--tl-purple)">54%</div></div>
    </div>
  </div>
</body>
```

Notes: `width` 퍼센트로 바 길이 설정. 라벨은 단어 1~2개.

---

## 15. Storyboard (스토리보드)

Best for: 시나리오 설명, 단계별 장면, 사용자 시나리오, 기능 소개

Key classes: `.storyboard`, `.story-panel`, `.story-number`, `.story-caption`, `.story-desc`

Max: **4패널 (2×2)**

```html
<body>
  <div class="storyboard" style="grid-template-columns:repeat(2,1fr)">
    <div class="story-panel">
      <div class="story-number">1</div>
      <div class="story-caption">앱 열기</div>
      <div class="story-desc">알림 확인</div>
    </div>
    <div class="story-panel">
      <div class="story-number">2</div>
      <div class="story-caption">내역 확인</div>
      <div class="story-desc">금액 검토</div>
    </div>
    <div class="story-panel">
      <div class="story-number">3</div>
      <div class="story-caption">결제 승인</div>
      <div class="story-desc">슬라이드</div>
    </div>
    <div class="story-panel">
      <div class="story-number">4</div>
      <div class="story-caption">완료</div>
      <div class="story-desc">영수증 표시</div>
    </div>
  </div>
</body>
```

Notes: `grid-template-columns`로 열 수 조정. **2×2 기본**. `.story-desc`는 2~4자 키워드만.

---

## Design Rules (Quick Reference)

- **Size**: 1440×810 (16:9)
- **Border**: Always 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur, ever)
- **Fonts**: Black Han Sans (titles), Noto Sans KR 700 (body default), JetBrains Mono (code)
- **Colors**: Use CSS variables only, never hardcode hex in HTML
- **Emoji**: 의미 전달에 필수일 때만 사용. 장식용 금지
- **No**: gradients, blur shadows, soft edges, rounded-full on cards
- **Slight rotation** on badges/labels: rotate(-1deg) to rotate(5deg)
- **구성**: `.figure-title` + `.insight-box`를 매번 쓰지 말 것. 컨텐츠가 스스로 말하게 하기
- **텍스트**: Figure 전체 max 20~25단어. 문장 금지, 키워드만. 최소 폰트 1.25rem

### Utilities (reduce inline styles)

| Category | Classes |
|----------|---------|
| Background | `.bg-white`, `.bg-card`, `.bg-dark`, `.bg-accent`, `.bg-highlight`, `.bg-good`, `.bg-bad`, `.bg-info`, `.bg-warm` |
| Text Color | `.text-dark`, `.text-white`, `.text-accent`, `.text-muted`, `.text-good`, `.text-bad`, `.text-info` |
| Spacing | `.p-1`~`.p-4`, `.px-*`, `.py-*`, `.m-1`~`.m-3`, `.mt-*`, `.mb-*` |
| Badge/Tag | `.badge` (bold label), `.tag` (mono rounded pill) |
| Code | `.code` (inline monospace), `.mono` (font class) |

### Textures (CSS-only patterns)

| Class | Effect | Best for |
|-------|--------|----------|
| `.bg-dots` | Dot grid 16px | 배경 텍스처, 카드 뒤 |
| `.bg-dots-lg` | Dot grid 24px | 넓은 배경 |
| `.bg-lines` | Diagonal hatch (dark) | 금지/위험 영역 |
| `.bg-lines-light` | Diagonal hatch (muted) | 은은한 패턴 배경 |
| `.bg-grid` | Graph paper | 기술 다이어그램 배경 |
| `.bg-grid-dark` | Graph paper (darker) | 어두운 배경 위 |
| `.bg-crosshatch` | X자 해치 | 빈 영역, 플레이스홀더 |

### Decorations (handmade feel)

| Class | Effect | Usage |
|-------|--------|-------|
| `.tape` | Washi tape on top center | 카드 상단에 테이프 효과 |
| `.tape-left` / `.tape-right` | 좌/우 치우친 테이프 | 비대칭 배치 |
| `.sticker` / `.sticker-sm` / `.sticker-lg` | Circular sticker | 강조 뱃지, 코너 장식 |
| `.stamp` + `.stamp-red/green/blue` | Rubber stamp | 상태 표시 (APPROVED, REJECTED 등) |
| `.mark` | Yellow marker underline | 텍스트 강조 (형광펜) |
| `.mark-accent/good/bad` | Color marker variants | 색상별 강조 |
| `.callout` | Left-border attention box | 주의사항, 팁, 경고 |
| `.divider` / `.divider-dashed` | Horizontal separator | 섹션 구분 |

## Color Palette (agentic30 design system)

Source: `docs/design-system.md`, `apps/web/src/app/globals.css`

### Base Tokens (사이트 직접 사용)

| figure.css | agentic30 토큰 | 값 | 용도 |
|-----------|---------------|-----|------|
| `--dark` | `--foreground` | `#0a0a0a` | 텍스트, 테두리, 섀도우 |
| `--white` | `--background` | `#ffffff` | 배경 |
| `--accent` | `--accent` | `#FF6B35` | 주 악센트 (배지, CTA, 링크) |
| `--highlight` | `--highlight` | `#fde047` | 텍스트 하이라이트 노랑 |
| `--card` | `--card` | `#f5f5f5` | 카드 배경 |
| `--muted` | `--muted` | `#e5e5e5` | 보더, 비활성 배경 |
| `--muted-fg` | `--muted-foreground` | `#737373` | 보조 텍스트 |
| `--warm-bg` | `--hero-card` | `#fffbf5` | 따뜻한 크림 배경 |

### Phase Colors (커리큘럼)

| 토큰 | 값 | 주차 |
|------|-----|------|
| `--phase-1` | `#ff8f50` | Week 1 — Orange |
| `--phase-2` | `#ff5c8d` | Week 2 — Pink |
| `--phase-3` | `#a3e635` | Week 3 — Lime |
| `--phase-4` | `#0a0a0a` | Week 4 — Black |

### Palette (timeline, funnel, bars)

사이트 색상 5개 + 보충 2개 = 총 7색

| 토큰 | 값 | 출처 |
|------|-----|------|
| `--tl-orange` | `#FF6B35` | = `--accent` |
| `--tl-amber` | `#ff8f50` | = `--phase-1` |
| `--tl-pink` | `#ff5c8d` | = `--phase-2` |
| `--tl-lime` | `#a3e635` | = `--phase-3` |
| `--tl-yellow` | `#fde047` | = `--highlight` |
| `--tl-blue` | `#3B82F6` | 보충: info 대비 |
| `--tl-purple` | `#8B5CF6` | 보충: 다양성 |

### Semantic

| 용도 | bg (틴트) | card (fill) | accent (텍스트) | 출처 |
|------|----------|-------------|----------------|------|
| Bad/Negative | `--bad-bg` #FFD5E0 | `--bad-card` = phase-2 | `--bad-accent` #d6336c | phase-2 파생 |
| Good/Positive | `--good-bg` #D9F99D | `--good-card` = phase-3 | `--good-accent` #4d7c0f | phase-3 파생 |
| Info/Neutral | `--info-bg` #BFDBFE | `--info-card` #3B82F6 | `--info-accent` #1D4ED8 | 보충 blue |
