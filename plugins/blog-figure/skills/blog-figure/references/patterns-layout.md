# Figure Patterns — Layout

Structure & flow patterns (15): Comparison, Flow, Timeline, Concept, Architecture, Interaction, State, Schema, Hierarchy, Matrix, Journey, Funnel, Loop, Storyboard, Terminal.

All use `assets/figure.css`. **핵심 원칙**: 텍스트는 최소한으로. 색상과 면적으로 구조 전달. 모바일 25% 축소에서도 인식 가능.

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
      <div class="flex flex-col gap-2" style="width:100%">
        <div class="data-card">가입 <span class="text-bad">0건</span></div>
        <div class="data-card">결제 <span class="text-bad">0건</span></div>
      </div>
    </div>
  </div>
</body>
```

Notes: 카드 내 텍스트는 키워드만. 문장 금지. 양쪽 카드 컨테이너는 동일한 시작점(flex-start)에서 시작해야 한다.

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

Max: **3레이어, 레이어당 3노드** (2노드면 빈약해 보임)

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
        <div class="arch-node">S3</div>
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

Max: **2테이블, 테이블당 3필드**

```html
<body>
  <div class="schema-container">
    <div class="schema-table">
      <div class="schema-header" style="background:var(--tl-blue)">User</div>
      <div class="schema-field"><span>id</span> <span class="schema-pk">PK</span></div>
      <div class="schema-field"><span>email</span></div>
      <div class="schema-field"><span>name</span></div>
    </div>
    <div class="schema-table">
      <div class="schema-header" style="background:var(--tl-lime)">Post</div>
      <div class="schema-field"><span>id</span> <span class="schema-pk">PK</span></div>
      <div class="schema-field"><span>user_id</span> <span class="schema-fk">FK</span></div>
      <div class="schema-field"><span>title</span></div>
    </div>
  </div>
</body>
```

Notes: 필드명 + PK/FK 뱃지만 유지. 타입 표시 생략이 기본. 필요 시 `.schema-field` 내 우측에 1.5rem으로. 테이블 2개 권장 (공간 제한).

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
  <div class="matrix" style="grid-template-columns:160px 1fr 1fr;grid-template-rows:auto 1fr 1fr;width:80%;background:var(--dark);gap:3px">
    <div class="matrix-corner" style="background:var(--white)"></div>
    <div class="matrix-label-x" style="background:var(--good-card);border:none">높은 임팩트</div>
    <div class="matrix-label-x" style="background:var(--info-card);color:var(--white);border:none">낮은 임팩트</div>
    <div class="matrix-label-y" style="background:var(--white);border:none">쉬움</div>
    <div class="matrix-cell" style="background:var(--good-bg)">
      <div class="text-xl"><strong>Quick Win</strong></div>
    </div>
    <div class="matrix-cell" style="background:var(--info-bg)">
      <div class="text-xl"><strong>채워넣기</strong></div>
    </div>
    <div class="matrix-label-y" style="background:var(--white);border:none">어려움</div>
    <div class="matrix-cell" style="background:var(--good-bg)">
      <div class="text-xl"><strong>Big Bet</strong></div>
    </div>
    <div class="matrix-cell" style="background:var(--info-bg)">
      <div class="text-xl"><strong>하지 말것</strong></div>
    </div>
  </div>
</body>
```

Notes: 셀 내 텍스트는 **키워드 1~2단어**만. **열별 색상 통일** — 1열과 2열은 서로 다른 색상 계열, 같은 열 내 셀은 동일 색상. 헤더는 진한 톤, 셀은 연한 톤. **코너·행라벨은 흰색**. **구분선은 grid gap 기법**: `.matrix`에 `background:var(--dark);gap:3px` 적용, 개별 셀 border 제거.

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

## 16. Terminal (터미널 UI)

Best for: CLI 도구 시각화, 터미널 명령어 시퀀스, AskUserQuestion UI, 개발자 도구 데모

Key classes: `.terminal`, `.terminal-card`, `.terminal-card-header`, `.terminal-card-tag`, `.terminal-option`, `.terminal-radio`, `.terminal-answer`

Max: **3 Step 카드 (가로)**, 카드당 옵션 **2개 (max 3)**

```html
<body>
<div class="terminal">
  <div style="margin-bottom:20px">
    <div class="terminal-path"><span style="color:var(--good-card)">~</span> /project</div>
    <div class="terminal-prompt">
      <span style="color:var(--good-card);font-weight:700">&#10095;</span>
      <span style="color:var(--accent);font-weight:600">@SPEC.md</span>를 읽고
      <span style="color:var(--tl-purple);font-weight:600">AskUserQuestionTool</span>로 인터뷰해 주세요.
    </div>
  </div>

  <div class="terminal-tool">
    <span class="terminal-dot" style="background:var(--accent)"></span>
    <span>Read</span>
    <span style="color:var(--muted-fg)">SPEC.md</span>
  </div>

  <div class="terminal-text">핵심 결정 인터뷰</div>

  <div class="terminal-steps">
    <div class="terminal-card">
      <div class="terminal-card-header">
        <span>Step 1 / 3</span>
        <span class="terminal-card-tag">성공 기준</span>
      </div>
      <div class="terminal-card-question">성공 기준은?</div>
      <div class="flex flex-col" style="gap:10px;margin-bottom:18px">
        <div class="terminal-option selected">
          <span class="terminal-radio checked"></span>
          <span>WAU 활성만</span>
        </div>
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>결제 전환만</span>
        </div>
      </div>
      <hr class="terminal-divider">
      <div class="terminal-answer">
        <span style="font-weight:700;flex-shrink:0">✔</span>
        <span>WAU 활성만</span>
      </div>
    </div>

    <div class="terminal-connector">&#8250;</div>

    <div class="terminal-card">
      <div class="terminal-card-header">
        <span>Step 2 / 3</span>
        <span class="terminal-card-tag">좌절 관리</span>
      </div>
      <div class="terminal-card-question">좌절 관리법?</div>
      <div class="flex flex-col" style="gap:10px;margin-bottom:18px">
        <div class="terminal-option selected">
          <span class="terminal-radio checked"></span>
          <span>실시간 가이드</span>
        </div>
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>숫자 숨기기</span>
        </div>
      </div>
      <hr class="terminal-divider">
      <div class="terminal-answer">
        <span style="font-weight:700;flex-shrink:0">✔</span>
        <span>실시간 가이드</span>
      </div>
    </div>

    <div class="terminal-connector">&#8250;</div>

    <div class="terminal-card">
      <div class="terminal-card-header">
        <span>Step 3 / 3</span>
        <span class="terminal-card-tag">목표 재정의</span>
      </div>
      <div class="terminal-card-question">진짜 목표는?</div>
      <div class="flex flex-col" style="gap:10px;margin-bottom:18px">
        <div class="terminal-option selected">
          <span class="terminal-radio checked"></span>
          <span>첫 매출</span>
        </div>
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>단계적 접근</span>
        </div>
      </div>
      <hr class="terminal-divider">
      <div class="terminal-answer">
        <span style="font-weight:700;flex-shrink:0">✔</span>
        <span>첫 매출</span>
      </div>
    </div>
  </div>

  <div style="margin-top:28px">
    <div class="terminal-tool" style="margin:0">
      <span class="terminal-dot" style="background:var(--good-card)"></span>
      <span style="color:var(--good-card)">Write</span>
      <span style="color:var(--muted-fg)">SPEC-v2.md</span>
    </div>
  </div>
  <div class="terminal-text" style="color:var(--good-card);margin-top:8px;margin-bottom:0">
    ✔ 인터뷰 완료
  </div>
</div>
</body>
```

Notes: figure.css 기반이므로 외부 @import 없이 동작. 다크 테마는 `.terminal` 클래스가 body 대신 적용. 질문 텍스트에 `<br>` 사용 금지 — `.terminal-card-question`의 `text-wrap: balance`가 자동으로 균등 줄바꿈 처리. 질문은 **max 12자, 1줄 권장**. 옵션은 **max 8자**.

---
