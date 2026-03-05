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

## 16. Terminal (터미널 UI)

Best for: CLI 도구 시각화, 터미널 명령어 시퀀스, AskUserQuestion UI, 개발자 도구 데모

Key classes: `.terminal`, `.terminal-card`, `.terminal-card-header`, `.terminal-card-tag`, `.terminal-option`, `.terminal-radio`, `.terminal-answer`

Max: **3 Step 카드 (가로)**, 카드당 옵션 **2~4개**

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

  <div class="terminal-text">분석 완료. 핵심 결정 사항을 인터뷰합니다.</div>

  <div class="terminal-steps">
    <div class="terminal-card">
      <div class="terminal-card-header">
        <span>Step 1 / 3</span>
        <span class="terminal-card-tag">성공 기준</span>
      </div>
      <div class="terminal-card-question">허수 포함 시 거짓 성공감 위험은?</div>
      <div class="flex flex-col" style="gap:10px;margin-bottom:18px">
        <div class="terminal-option selected">
          <span class="terminal-radio checked"></span>
          <span>WAU 기준 활성 유저만</span>
        </div>
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>가입 수 기준</span>
        </div>
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>결제 전환만 유효</span>
        </div>
      </div>
      <hr class="terminal-divider">
      <div class="terminal-answer">
        <span style="font-weight:700;flex-shrink:0">✔</span>
        <span>WAU 기준 활성 유저만</span>
      </div>
    </div>

    <div class="terminal-connector">&#8250;</div>

    <div class="terminal-card">
      <div class="terminal-card-header">
        <span>Step 2 / 3</span>
        <span class="terminal-card-tag">좌절 관리</span>
      </div>
      <div class="terminal-card-question">Day 20에 "활성 12명" — 좌절 방지?</div>
      <div class="flex flex-col" style="gap:10px;margin-bottom:18px">
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>숫자를 숨기기</span>
        </div>
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>리얼타임 가이드</span>
        </div>
      </div>
      <hr class="terminal-divider">
      <div class="terminal-answer">
        <span style="font-weight:700;flex-shrink:0">✔</span>
        <span style="color:var(--white)">
          <span class="mono" style="color:var(--muted-fg)">Other:</span> 공개 + 그로스 가이드
        </span>
      </div>
    </div>

    <div class="terminal-connector">&#8250;</div>

    <div class="terminal-card">
      <div class="terminal-card-header">
        <span>Step 3 / 3</span>
        <span class="terminal-card-tag">목표 재정의</span>
      </div>
      <div class="terminal-card-question">"100명"보다 "첫 결제 1명"이 진짜?</div>
      <div class="flex flex-col" style="gap:10px;margin-bottom:18px">
        <div class="terminal-option selected">
          <span class="terminal-radio checked"></span>
          <span>첫 매출이 진짜 목표</span>
        </div>
        <div class="terminal-option">
          <span class="terminal-radio"></span>
          <span>단계적 접근</span>
        </div>
      </div>
      <hr class="terminal-divider">
      <div class="terminal-answer">
        <span style="font-weight:700;flex-shrink:0">✔</span>
        <span>첫 매출이 진짜 목표</span>
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
    ✔ 인터뷰 완료 — 스펙 작성됨
  </div>
</div>
</body>
```

Notes: figure.css 기반이므로 외부 @import 없이 동작. 다크 테마는 `.terminal` 클래스가 body 대신 적용. 질문 텍스트에 `<br>` 사용 금지 — `.terminal-card-question`의 `text-wrap: balance`가 자동으로 균등 줄바꿈 처리. 질문은 **2줄 이내**로 작성.

---

## 17. Isometric (SVG 인라인)

Best for: 3D 블록 구조, 레이어 시각화, 아이소메트릭 와이어프레임, 개념의 공간적 관계

Approach: **SVG inline** — 정밀한 도형 배치. 외부 의존성 없음. `<polygon>` 조합으로 아이소메트릭 큐브.

Max: **4 블록**. 블록당 라벨 1단어.

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .iso { stroke: #0a0a0a; stroke-width: 2.5; stroke-linejoin: round; }
    </style>
    <!-- Dot grid background -->
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Isometric cube: top=light, left=mid, right=dark of same hue
       Position with translate(cx, cy). cy = bottom center of cube. -->

  <!-- Layer 1: Infrastructure (bottom, largest) -->
  <g transform="translate(520, 550)">
    <polygon class="iso" fill="#BFDBFE" points="0,-50 200,-100 400,-50 200,0"/>
    <polygon class="iso" fill="#93C5FD" points="0,-50 0,30 200,80 200,0"/>
    <polygon class="iso" fill="#60A5FA" points="200,0 200,80 400,30 400,-50"/>
    <text x="200" y="-25" text-anchor="middle" font-size="28" font-weight="900">인프라</text>
  </g>

  <!-- Layer 2: Service (middle) -->
  <g transform="translate(580, 440)">
    <polygon class="iso" fill="#D9F99D" points="0,-45 140,-90 280,-45 140,0"/>
    <polygon class="iso" fill="#BEF264" points="0,-45 0,25 140,70 140,0"/>
    <polygon class="iso" fill="#A3E635" points="140,0 140,70 280,25 280,-45"/>
    <text x="140" y="-20" text-anchor="middle" font-size="26" font-weight="900">서비스</text>
  </g>

  <!-- Layer 3: UI (top, smallest) -->
  <g transform="translate(630, 340)">
    <polygon class="iso" fill="#FFD5E0" points="0,-40 90,-80 180,-40 90,0"/>
    <polygon class="iso" fill="#FCA5B8" points="0,-40 0,20 90,60 90,0"/>
    <polygon class="iso" fill="#FF5C8D" points="90,0 90,60 180,20 180,-40"/>
    <text x="90" y="-18" text-anchor="middle" font-size="24" font-weight="900">UI</text>
  </g>
</svg>
</body>
```

Notes: 각 면에 같은 색조의 3단계 명도를 적용(top=light, left=mid, right=dark). `translate(cx, cy)`로 블록 위치 조정. 블록을 쌓을 때 위 블록의 cy를 아래 블록보다 작게. `.iso` 클래스로 일관된 stroke. 텍스트는 블록 top face 중앙에 배치.

---

## 18. IconDiagram (SVG 인라인)

Best for: 시스템 다이어그램, 기술 구성도, 아이콘 기반 노드와 커넥터, 요청/응답 흐름

Approach: **SVG inline** — 노드(아이콘 + 라벨 박스) + 커넥터(화살표 `<marker>`) 조합.

Max: **4 노드**, **3 커넥터**. 아이콘은 기본 SVG 도형으로 구성 (circle, rect, path).

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .box { fill: white; stroke: #0a0a0a; stroke-width: 3; }
      .box-sh { fill: #0a0a0a; }
      .conn { stroke: #0a0a0a; stroke-width: 2.5; fill: none; }
    </style>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5"
            markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="#0a0a0a"/>
    </marker>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Node: User -->
  <g transform="translate(160, 310)">
    <rect class="box-sh" x="4" y="4" width="180" height="150" rx="12"/>
    <rect class="box" width="180" height="150" rx="12"/>
    <!-- Person icon: head + shoulders -->
    <circle cx="90" cy="45" r="20" fill="none" stroke="#3B82F6" stroke-width="3"/>
    <path d="M55 95 Q90 72 125 95" fill="none" stroke="#3B82F6" stroke-width="3"/>
    <text x="90" y="130" text-anchor="middle" font-size="24" font-weight="900">사용자</text>
  </g>

  <!-- Node: API -->
  <g transform="translate(630, 310)">
    <rect class="box-sh" x="4" y="4" width="180" height="150" rx="12"/>
    <rect class="box" width="180" height="150" rx="12"/>
    <!-- Gear icon: circle + center dot -->
    <circle cx="90" cy="50" r="24" fill="none" stroke="#a3e635" stroke-width="3"/>
    <circle cx="90" cy="50" r="8" fill="#a3e635"/>
    <text x="90" y="130" text-anchor="middle" font-size="24" font-weight="900">API</text>
  </g>

  <!-- Node: DB -->
  <g transform="translate(1100, 310)">
    <rect class="box-sh" x="4" y="4" width="180" height="150" rx="12"/>
    <rect class="box" width="180" height="150" rx="12"/>
    <!-- Cylinder icon: ellipse + body -->
    <ellipse cx="90" cy="40" rx="32" ry="14" fill="none" stroke="#FF6B35" stroke-width="3"/>
    <path d="M58 40 v35 a32 14 0 0 0 64 0 v-35" fill="none" stroke="#FF6B35" stroke-width="3"/>
    <text x="90" y="130" text-anchor="middle" font-size="24" font-weight="900">DB</text>
  </g>

  <!-- Connectors with arrow markers -->
  <line class="conn" x1="340" y1="385" x2="630" y2="385" marker-end="url(#arr)"/>
  <text x="485" y="370" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">요청</text>
  <line class="conn" x1="810" y1="385" x2="1100" y2="385" marker-end="url(#arr)"/>
  <text x="955" y="370" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">쿼리</text>
</svg>
</body>
```

Notes: 아이콘은 기본 SVG 도형(circle, ellipse, path, rect)으로 구성. 외부 아이콘 라이브러리 불필요. `<marker>` 로 화살표 정의하고 `marker-end="url(#arr)"`으로 적용. 노드 간 거리를 넉넉히 잡아 커넥터 라벨이 읽히도록. 커넥터 라벨은 `fill="#737373"` (muted).

---

## 19. Network (Canvas/JS)

Best for: 노드 네트워크, 결정론적 그리드 ↔ 확률적 스캐터 대비, 추상적 관계 시각화, 하이브리드 네트워크

Approach: **Canvas** — JS로 노드/엣지를 직접 그림. retina 2x. `document.fonts.ready`로 폰트 로드 후 렌더링.

참고: [Zed Agentic Engineering](https://zed.dev/agentic-engineering) FIG 1/2/3 스타일.

Config: `nodes` 배열과 `edges` 배열만 수정하면 내용 변경 가능.

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=1440">
  <link rel="stylesheet" href="file://{SKILL_DIR}/assets/figure.css">
</head>
<body style="margin:0;overflow:hidden;background:#f5f5f5">
<canvas id="c" width="2880" height="1620" style="width:1440px;height:810px;display:block"></canvas>
<script>
document.fonts.ready.then(() => {
const C = document.getElementById('c'), ctx = C.getContext('2d');
const S = 2; // retina scale

// === PALETTE (matches figure.css tokens) ===
const P = {
  dark:'#0a0a0a', muted:'#737373', bg:'#f5f5f5', card:'#e5e5e5',
  blue:'#3B82F6', lime:'#a3e635', orange:'#FF6B35',
  purple:'#8B5CF6', pink:'#ff5c8d', yellow:'#fde047'
};

// === CONFIG: Modify nodes/edges for your content ===

// Section A: Deterministic grid (left half)
const gridNodes = [];
for (let r = 0; r < 2; r++)
  for (let c = 0; c < 7; c++)
    gridNodes.push({
      x: 120 + c * 70, y: 380 + r * 80, r: 26,
      color: P.card, label: (c + r) % 2 ? '1' : '0', opacity: 0.85
    });

// Section B: Stochastic scatter (right half)
const scatterNodes = [
  { x:820,  y:180, r:42, color:P.blue,   label:'0.8', opacity:0.85 },
  { x:950,  y:250, r:22, color:P.lime,   label:'0.3', opacity:0.5 },
  { x:1070, y:200, r:28, color:P.orange, label:'0.9', opacity:0.7 },
  { x:1190, y:160, r:20, color:P.purple, label:'0.4', opacity:0.45 },
  { x:1290, y:240, r:32, color:P.pink,   label:'0.7', opacity:0.75 },
  { x:870,  y:360, r:18, color:P.yellow, label:'0.1', opacity:0.4 },
  { x:1000, y:410, r:50, color:P.blue,   label:'0',   opacity:0.6 },
  { x:1140, y:350, r:26, color:P.lime,   label:'0.5', opacity:0.55 },
  { x:1260, y:400, r:35, color:P.orange, label:'0.2', opacity:0.5 },
  { x:870,  y:510, r:24, color:P.purple, label:'0.6', opacity:0.6 },
  { x:1010, y:540, r:30, color:P.pink,   label:'0.2', opacity:0.45 },
  { x:1170, y:500, r:38, color:P.yellow, label:'0.8', opacity:0.7 },
  { x:1290, y:540, r:20, color:P.blue,   label:'0.3', opacity:0.4 },
  { x:940,  y:620, r:34, color:P.lime,   label:'0.9', opacity:0.8 },
  { x:1110, y:630, r:22, color:P.orange, label:'0.3', opacity:0.5 },
];

const all = [...gridNodes, ...scatterNodes];

// Auto-generate edges between nearby scatter nodes
const edges = [];
const sOff = gridNodes.length;
for (let i = sOff; i < all.length; i++)
  for (let j = i + 1; j < all.length; j++) {
    const d = Math.hypot(all[i].x - all[j].x, all[i].y - all[j].y);
    if (d < 220) edges.push([i, j, 0.06 + Math.random() * 0.12]);
  }

// === RENDER ===
ctx.fillStyle = P.bg;
ctx.fillRect(0, 0, 2880, 1620);

// Dot grid background
ctx.fillStyle = 'rgba(10,10,10,0.05)';
for (let x = 0; x < 2880; x += 32)
  for (let y = 0; y < 1620; y += 32) {
    ctx.beginPath(); ctx.arc(x, y, 1.5, 0, Math.PI * 2); ctx.fill();
  }

// Divider line (subtle)
ctx.strokeStyle = 'rgba(10,10,10,0.08)';
ctx.lineWidth = 1.5 * S;
ctx.setLineDash([8 * S, 6 * S]);
ctx.beginPath(); ctx.moveTo(720 * S, 130 * S); ctx.lineTo(720 * S, 700 * S); ctx.stroke();
ctx.setLineDash([]);

// Edges
edges.forEach(([i, j, a]) => {
  ctx.beginPath();
  ctx.moveTo(all[i].x * S, all[i].y * S);
  ctx.lineTo(all[j].x * S, all[j].y * S);
  ctx.strokeStyle = `rgba(10,10,10,${a})`;
  ctx.lineWidth = 2 * S;
  ctx.stroke();
});

// Nodes
all.forEach(n => {
  const x = n.x * S, y = n.y * S, r = n.r * S;
  ctx.globalAlpha = n.opacity;
  ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2);
  ctx.fillStyle = n.color; ctx.fill();
  ctx.globalAlpha = 1;
  ctx.strokeStyle = P.dark; ctx.lineWidth = 3 * S; ctx.stroke();
  // Label
  ctx.fillStyle = P.dark;
  ctx.font = `700 ${Math.max(14, n.r * 0.55) * S}px 'Noto Sans KR'`;
  ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
  ctx.fillText(n.label, x, y + S);
});

// Section labels (monospace, top)
ctx.font = `500 ${16 * S}px 'JetBrains Mono'`;
ctx.fillStyle = P.muted; ctx.textAlign = 'left';
ctx.fillText('[ FIG 1 ] \u2014 DETERMINISTIC', 100 * S, 100 * S);
ctx.fillText('[ FIG 2 ] \u2014 STOCHASTIC', 800 * S, 100 * S);

// Captions (bottom)
ctx.font = `700 ${18 * S}px 'Noto Sans KR'`;
ctx.textAlign = 'center';
ctx.fillText('\uADDC\uCE59 \uAE30\uBC18, \uC608\uCE21 \uAC00\uB2A5\uD55C \uACB0\uACFC', 370 * S, 730 * S);
ctx.fillText('\uC720\uB3D9\uC801, \uD655\uB960\uC801 \uD0D0\uC0C9', 1050 * S, 730 * S);
});
</script>
</body>
```

Notes: `document.fonts.ready.then()`으로 감싸야 Canvas에서 Google Fonts가 정상 렌더링됨. `S = 2`로 retina 해상도 출력 (canvas 2880×1620 → CSS 1440×810). 노드 `opacity`로 확률적 느낌 표현. 그리드 노드는 균일 크기/색상, 스캐터 노드는 다양한 크기/색상/투명도. edges는 가까운 노드 자동 연결. `\u` 이스케이프는 "규칙 기반, 예측 가능한 결과" / "유동적, 확률적 탐색" — 한글 텍스트를 Canvas에 직접 쓸 때 사용.

---

## 20. Graph (D3)

Best for: 포스-다이렉티드 그래프, 노드-링크 다이어그램, 개념 간 자동 배치 관계도

Approach: **D3 v7 CDN** — 물리 시뮬레이션으로 노드 자동 배치. `sim.tick()` 동기 실행 후 캡처.

Config: `nodes`와 `links` 배열만 수정하면 내용 변경 가능.

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=1440">
  <link rel="stylesheet" href="file://{SKILL_DIR}/assets/figure.css">
  <script src="https://d3js.org/d3.v7.min.js"></script>
  <style>
    body { width:1440px;height:810px;margin:0;overflow:hidden;background:#f5f5f5; }
    .link { stroke:#e5e5e5; stroke-width:2.5; }
    .node { stroke:#0a0a0a; stroke-width:3; }
    .label { font-family:'Noto Sans KR',sans-serif; font-weight:700; font-size:20px;
             fill:#0a0a0a; text-anchor:middle; dominant-baseline:central; }
  </style>
</head>
<body>
<svg width="1440" height="810">
  <defs>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>
</svg>
<script>
// === CONFIG: Modify for your content ===
const nodes = [
  { id: '문제 정의', group: 1, r: 40 },
  { id: '인터뷰',   group: 1, r: 35 },
  { id: 'SPEC',     group: 2, r: 30 },
  { id: '개발',     group: 2, r: 35 },
  { id: '배포',     group: 3, r: 30 },
  { id: '검증',     group: 3, r: 32 },
  { id: '피봇',     group: 1, r: 25 },
];
const links = [
  { source: '문제 정의', target: '인터뷰' },
  { source: '인터뷰',   target: 'SPEC' },
  { source: 'SPEC',     target: '개발' },
  { source: '개발',     target: '배포' },
  { source: '배포',     target: '검증' },
  { source: '검증',     target: '피봇' },
  { source: '피봇',     target: '문제 정의' },
  { source: '인터뷰',   target: '검증' },
];
const groupColor = { 1: '#3B82F6', 2: '#a3e635', 3: '#FF6B35' };

const svg = d3.select('svg');
const W = 1440, H = 810;

// Force simulation
const sim = d3.forceSimulation(nodes)
  .force('link', d3.forceLink(links).id(d => d.id).distance(140))
  .force('charge', d3.forceManyBody().strength(-600))
  .force('center', d3.forceCenter(W / 2, H / 2))
  .force('collision', d3.forceCollide().radius(d => d.r + 15));

// Run to completion synchronously (critical for screenshot capture)
for (let i = 0; i < 300; i++) sim.tick();
sim.stop();

// Draw links
svg.selectAll('.link').data(links).join('line')
  .attr('class', 'link')
  .attr('x1', d => d.source.x).attr('y1', d => d.source.y)
  .attr('x2', d => d.target.x).attr('y2', d => d.target.y);

// Draw node shadows (Neo-Brutalism hard shadow)
svg.selectAll('.shadow').data(nodes).join('circle')
  .attr('cx', d => d.x + 4).attr('cy', d => d.y + 4).attr('r', d => d.r)
  .attr('fill', '#0a0a0a').attr('opacity', 0.1);

// Draw nodes
svg.selectAll('.node').data(nodes).join('circle')
  .attr('class', 'node')
  .attr('cx', d => d.x).attr('cy', d => d.y).attr('r', d => d.r)
  .attr('fill', d => groupColor[d.group]);

// Draw labels
svg.selectAll('.label').data(nodes).join('text')
  .attr('class', 'label')
  .attr('x', d => d.x).attr('y', d => d.y)
  .text(d => d.id);
</script>
</body>
```

Notes: D3 v7을 CDN에서 로드. `for (let i=0; i<300; i++) sim.tick(); sim.stop();`으로 시뮬레이션을 동기 실행 — 스크린샷 캡처 시 레이아웃이 안정된 상태 보장. `nodes`의 `group`으로 색상 분류, `r`로 노드 크기 (중요도). `links`의 `source`/`target`은 노드 `id` 참조. Hard shadow는 동일 좌표에 offset된 검정 원으로 구현.

---

## Design Rules (Quick Reference)

- **Size**: 1440×810 (16:9)
- **Border**: Always 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur, ever)
- **Fonts**: Noto Sans KR 900 (titles), Noto Sans KR 700 (body default), JetBrains Mono (code)
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
