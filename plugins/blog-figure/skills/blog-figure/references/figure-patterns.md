# Figure Pattern Reference

Each pattern includes a minimal HTML example. All use `assets/figure.css`.

---

## 1. Comparison (좌우 비교)

Best for: X vs Y, 나쁜 예시 vs 좋은 예시, 이전 vs 이후

Key classes: `.split`, `.split-left`, `.split-right`, `.vs-badge`, `.section-label`, `.quote-card`, `.data-card`

```html
<body>
  <div class="figure-title">인터뷰 데이터 vs 실제 수요 데이터</div>
  <div class="split relative">
    <div class="vs-badge">VS</div>
    <div class="split-left" style="background:var(--info-bg)">
      <div class="section-label" style="background:var(--info-accent)">사람들이 말하는 것</div>
      <div class="flex flex-col gap-1" style="width:100%">
        <div class="quote-card">"좋은데요!"</div>
        <div class="quote-card">"나오면 써볼게요"</div>
        <div class="quote-card">"대박이에요!"</div>
      </div>
    </div>
    <div class="split-right" style="background:var(--bad-bg)">
      <div class="section-label" style="background:var(--bad-accent)">사람들이 실제로 하는 것</div>
      <div class="flex flex-col gap-2" style="width:100%;margin-top:2rem">
        <div class="data-card">가입 신청 <span style="color:var(--bad-accent)">0건</span></div>
        <div class="data-card">결제 <span style="color:var(--bad-accent)">0건</span></div>
      </div>
    </div>
  </div>
</body>
```

Notes: Between columns use optional `<div class="arrow-dashed">` with label.

---

## 2. Flow (수직 플로우 비교)

Best for: 프로세스 비교, 단계별 차이, 방법론 대비

Key classes: `.flow-card`, `.flow-card.bad`, `.flow-card.good`, `.arrow-down`, `.icon`

```html
<body>
  <div class="split relative" style="height:auto;min-height:75%">
    <div class="split-left" style="background:var(--bad-bg)">
      <div class="figure-title" style="font-size:1.75rem">나쁜 인터뷰</div>
      <div class="flex flex-col items-center">
        <div class="flow-card bad"><div class="icon bad">📢</div><div><strong>아이디어 설명</strong><br><span class="text-sm">"이런 걸 만들 건데요..."</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card bad"><div class="icon bad">❓</div><div><strong>평가 요청</strong><br><span class="text-sm">"어떻게 생각하세요?"</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card bad" style="border-color:var(--bad-accent)"><div class="icon bad">❌</div><div><strong style="color:var(--bad-accent)">착각</strong></div></div>
      </div>
    </div>
    <div class="split-right" style="background:var(--good-bg)">
      <div class="figure-title" style="font-size:1.75rem">좋은 인터뷰</div>
      <div class="flex flex-col items-center">
        <div class="flow-card good"><div class="icon good">🔍</div><div><strong>맥락 확인</strong><br><span class="text-sm">"언제 겪으셨나요?"</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card good"><div class="icon good">🔄</div><div><strong>최근 사례</strong><br><span class="text-sm">"마지막으로 해결하려 했을 때..."</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card good" style="border-color:var(--good-accent)"><div class="icon good">✅</div><div><strong style="color:var(--good-accent)">니즈 발견</strong></div></div>
      </div>
    </div>
  </div>
</body>
```

Notes: Flow는 split 없이 단일 칼럼으로도 사용 가능. `.flow-card`만 `.arrow-down`으로 연결.

---

## 3. Timeline (수평 타임라인)

Best for: 시간 배분, 단계 순서, 비율 시각화

Key classes: `.timeline`, `.tl-block`, `.tl-label`, `.tl-time`, `.tl-annotations`, `.tl-anno`

```html
<body>
  <div class="figure-title">15분 인터뷰 타임라인</div>
  <div class="timeline">
    <div class="tl-block" style="flex:2;background:var(--tl-blue)">
      <div class="tl-label">맥락</div><div class="tl-time">2분</div>
    </div>
    <div class="tl-block" style="flex:6;background:var(--tl-lime)">
      <div class="tl-label">사례 복기</div><div class="tl-time">6분</div>
    </div>
    <div class="tl-block" style="flex:4;background:var(--tl-orange)">
      <div class="tl-label">비용</div><div class="tl-time">4분</div>
    </div>
    <div class="tl-block" style="flex:3;background:var(--tl-purple)">
      <div class="tl-label">우선순위</div><div class="tl-time">3분</div>
    </div>
  </div>
  <div class="tl-annotations">
    <div class="tl-anno" style="flex:2;color:var(--info-accent)">↓<br>"요즘 이 문제를 언제 겪나요?"</div>
    <div class="tl-anno" style="flex:6;color:var(--good-accent)">↓<br>"마지막 상황을 순서대로 말해 주세요"</div>
    <div class="tl-anno" style="flex:4;color:var(--orange)">↓<br>"시간, 돈을 얼마나 썼나요?"</div>
    <div class="tl-anno" style="flex:3;color:var(--tl-purple)">↓<br>"다른 문제와 비교하면?"</div>
  </div>
</body>
```

Notes: `flex` 비율로 시간 비율을 직관적으로 표현. 색상은 `--tl-*` 토큰 사용.

---

## 4. Concept (개념도)

Best for: 관계도, 벤 다이어그램 스타일, 개념 비교

Key classes: `.concept-block`, absolute positioning, z-index

```html
<body>
  <div class="figure-title">TDD vs SDD vs IDD</div>
  <div style="position:relative;width:900px;height:500px">
    <div class="concept-block" style="position:absolute;left:0;top:80px;width:300px;height:350px;background:var(--yellow);z-index:1">
      <div class="text-4xl">TDD</div>
      <div style="font-size:3rem">⚙️</div>
      <div class="text-xl">테스트 중심</div>
    </div>
    <div class="concept-block" style="position:absolute;left:250px;top:0;width:400px;height:500px;background:var(--orange);z-index:2">
      <div class="text-4xl">IDD</div>
      <div style="font-size:3rem">💬</div>
      <div class="text-xl">인터뷰 중심</div>
    </div>
    <div class="concept-block" style="position:absolute;right:0;top:80px;width:300px;height:350px;background:var(--info-accent);color:white;z-index:3">
      <div class="text-4xl">SDD</div>
      <div style="font-size:3rem">📄</div>
      <div class="text-xl">스펙 중심</div>
    </div>
  </div>
</body>
```

Notes: `z-index`로 겹침 순서 제어. 블록 크기와 위치는 내용에 맞게 inline style 조정.

---

## 5. Architecture (시스템 구성도)

Best for: 시스템 아키텍처, 컴포넌트 관계, 레이어 구조

Key classes: `.arch`, `.arch-layer`, `.arch-label`, `.arch-nodes`, `.arch-node`

```html
<body>
  <div class="figure-title">서비스 아키텍처</div>
  <div class="arch">
    <div class="arch-layer">
      <div class="arch-label" style="background:var(--tl-blue)">Client</div>
      <div class="arch-nodes">
        <div class="arch-node">🌐 Web App</div>
        <div class="arch-node">📱 Mobile App</div>
        <div class="arch-node">🤖 CLI</div>
      </div>
    </div>
    <div class="arch-layer">
      <div class="arch-label" style="background:var(--tl-lime)">Service</div>
      <div class="arch-nodes">
        <div class="arch-node">⚡ API Gateway</div>
        <div class="arch-node">🔐 Auth</div>
        <div class="arch-node">📊 Analytics</div>
        <div class="arch-node">💬 Notification</div>
      </div>
    </div>
    <div class="arch-layer">
      <div class="arch-label" style="background:var(--tl-orange)">Data</div>
      <div class="arch-nodes">
        <div class="arch-node">🗄️ PostgreSQL</div>
        <div class="arch-node">⚡ Redis</div>
        <div class="arch-node">📦 S3</div>
      </div>
    </div>
  </div>
</body>
```

Notes: 레이어 수는 2~4개 권장. `.arch-label` 색상으로 레이어 구분. 레이어 간 흐름은 위→아래 암묵적 방향.

---

## 6. Interaction (시퀀스 다이어그램)

Best for: 요청/응답, 사용자-시스템 상호작용, API 플로우

Key classes: `.seq`, `.seq-entities`, `.seq-entity`, `.seq-messages`, `.seq-msg`, `.seq-msg-line`, `.seq-msg-label`, `.seq-msg-arrow`

```html
<body>
  <div class="figure-title">OAuth 로그인 플로우</div>
  <div class="seq">
    <div class="seq-entities">
      <div class="seq-entity" style="background:var(--tl-blue)">👤 사용자</div>
      <div class="seq-entity" style="background:var(--tl-lime)">🖥️ 서버</div>
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
        <div class="seq-msg-label">OAuth URL 반환</div>
      </div>
      <div class="seq-msg right">
        <div class="seq-msg-label">인가 코드 전달</div>
        <div class="seq-msg-line"></div>
        <div class="seq-msg-arrow"></div>
      </div>
      <div class="seq-msg left">
        <div class="seq-msg-arrow"></div>
        <div class="seq-msg-line dashed"></div>
        <div class="seq-msg-label">토큰 + 사용자 정보</div>
      </div>
    </div>
  </div>
</body>
```

Notes: `.right`은 →방향(요청), `.left`는 ←방향(응답). `.dashed`로 응답 구분. 엔티티는 2~3개 권장.

---

## 7. State (상태 머신)

Best for: 상태 전이, 라이프사이클, 워크플로우 상태

Key classes: `.state-chain`, `.state-node`, `.state-node.active/.initial/.final`, `.state-transition`, `.arrow-right`, `.arrow-label`

```html
<body>
  <div class="figure-title">주문 상태 머신</div>
  <div class="state-chain">
    <div class="state-node initial">
      <div style="font-size:1.5rem">🛒</div>
      <div>장바구니</div>
    </div>
    <div class="state-transition">
      <div class="arrow-label">결제</div>
      <div class="arrow-right" style="width:60px"></div>
    </div>
    <div class="state-node active">
      <div style="font-size:1.5rem">💳</div>
      <div>결제 완료</div>
    </div>
    <div class="state-transition">
      <div class="arrow-label">출고</div>
      <div class="arrow-right" style="width:60px"></div>
    </div>
    <div class="state-node">
      <div style="font-size:1.5rem">📦</div>
      <div>배송 중</div>
    </div>
    <div class="state-transition">
      <div class="arrow-label">수령</div>
      <div class="arrow-right" style="width:60px"></div>
    </div>
    <div class="state-node final">
      <div style="font-size:1.5rem">✅</div>
      <div>완료</div>
    </div>
  </div>
  <div class="insight-box" style="margin-top:2rem">취소는 "결제 완료" → "장바구니"로 롤백</div>
</body>
```

Notes: 수평 체인이 기본. 상태 5개 이상이면 2행으로 분리. `.initial`(시작), `.active`(강조), `.final`(종료) 변형 사용.

---

## 8. Schema (데이터 스키마)

Best for: DB 테이블 구조, 데이터 모델, 엔티티 관계

Key classes: `.schema-container`, `.schema-table`, `.schema-header`, `.schema-field`, `.schema-pk`, `.schema-fk`

```html
<body>
  <div class="figure-title">블로그 데이터 모델</div>
  <div class="schema-container">
    <div class="schema-table">
      <div class="schema-header" style="background:var(--tl-blue)">👤 User</div>
      <div class="schema-field"><span>id</span> <span class="schema-pk">PK</span></div>
      <div class="schema-field"><span>email</span> <span class="text-sm">string</span></div>
      <div class="schema-field"><span>name</span> <span class="text-sm">string</span></div>
    </div>
    <div class="schema-table">
      <div class="schema-header" style="background:var(--tl-lime)">📝 Post</div>
      <div class="schema-field"><span>id</span> <span class="schema-pk">PK</span></div>
      <div class="schema-field"><span>author_id</span> <span class="schema-fk">FK → User</span></div>
      <div class="schema-field"><span>title</span> <span class="text-sm">string</span></div>
      <div class="schema-field"><span>content</span> <span class="text-sm">text</span></div>
      <div class="schema-field"><span>published_at</span> <span class="text-sm">datetime</span></div>
    </div>
    <div class="schema-table">
      <div class="schema-header" style="background:var(--tl-orange)">💬 Comment</div>
      <div class="schema-field"><span>id</span> <span class="schema-pk">PK</span></div>
      <div class="schema-field"><span>post_id</span> <span class="schema-fk">FK → Post</span></div>
      <div class="schema-field"><span>user_id</span> <span class="schema-fk">FK → User</span></div>
      <div class="schema-field"><span>body</span> <span class="text-sm">text</span></div>
    </div>
  </div>
</body>
```

Notes: 관계선 대신 `.schema-fk` 뱃지로 FK 관계 표시. 테이블 3~4개 권장 (공간 제한).

---

## 9. Hierarchy (계층 구조)

Best for: 조직도, 트리 구조, 분류 체계, 상속 관계

Key classes: `.tree`, `.tree-node`, `.tree-level`, `.tree-branch`, `.tree-vline`, `.tree-hline`

```html
<body>
  <div class="figure-title">컴포넌트 트리</div>
  <div class="tree">
    <!-- Root -->
    <div class="tree-node" style="background:var(--yellow)">🏠 App</div>
    <div class="tree-vline"></div>
    <!-- Level 1: horizontal connector + children -->
    <div class="tree-hline" style="width:500px"></div>
    <div class="tree-level">
      <div class="tree-branch">
        <div class="tree-vline"></div>
        <div class="tree-node" style="background:var(--tl-blue)">📐 Layout</div>
        <div class="tree-vline"></div>
        <div class="tree-hline" style="width:200px"></div>
        <div class="tree-level">
          <div class="tree-branch">
            <div class="tree-vline"></div>
            <div class="tree-node">🔝 Header</div>
          </div>
          <div class="tree-branch">
            <div class="tree-vline"></div>
            <div class="tree-node">🔚 Footer</div>
          </div>
        </div>
      </div>
      <div class="tree-branch">
        <div class="tree-vline"></div>
        <div class="tree-node" style="background:var(--tl-lime)">📄 Pages</div>
      </div>
      <div class="tree-branch">
        <div class="tree-vline"></div>
        <div class="tree-node" style="background:var(--tl-orange)">🧩 Shared</div>
      </div>
    </div>
  </div>
</body>
```

Notes: 깊이 3단계 이내 권장. `.tree-hline` 너비는 자식 노드 간격에 맞춰 inline style로 조정.

---

## 10. Matrix (매트릭스)

Best for: 2x2 분석, 의사결정 매트릭스, 기능 비교표

Key classes: `.matrix`, `.matrix-header`, `.matrix-cell`, `.matrix-corner`, `.matrix-label-x`, `.matrix-label-y`

```html
<body>
  <div class="figure-title">기술 선택 매트릭스</div>
  <div class="matrix" style="grid-template-columns:140px 1fr 1fr;grid-template-rows:auto 1fr 1fr;width:80%">
    <!-- Header row -->
    <div class="matrix-corner">난이도 ↓ / 임팩트 →</div>
    <div class="matrix-label-x" style="background:var(--good-bg)">🟢 높은 임팩트</div>
    <div class="matrix-label-x" style="background:var(--bad-bg)">🔴 낮은 임팩트</div>
    <!-- Row 1 -->
    <div class="matrix-label-y" style="background:var(--good-bg)">쉬움</div>
    <div class="matrix-cell" style="background:var(--good-card)">
      <div style="font-size:2rem">🎯</div>
      <div class="text-lg"><strong>바로 실행</strong></div>
      <div class="text-sm">Quick Win</div>
    </div>
    <div class="matrix-cell" style="background:var(--info-bg)">
      <div style="font-size:2rem">📋</div>
      <div class="text-lg"><strong>채워넣기</strong></div>
      <div class="text-sm">Fill-in</div>
    </div>
    <!-- Row 2 -->
    <div class="matrix-label-y" style="background:var(--bad-bg)">어려움</div>
    <div class="matrix-cell" style="background:var(--yellow)">
      <div style="font-size:2rem">🚀</div>
      <div class="text-lg"><strong>전략 과제</strong></div>
      <div class="text-sm">Big Bet</div>
    </div>
    <div class="matrix-cell" style="background:var(--bad-card)">
      <div style="font-size:2rem">🗑️</div>
      <div class="text-lg"><strong>하지 말것</strong></div>
      <div class="text-sm">Avoid</div>
    </div>
  </div>
</body>
```

Notes: `grid-template-columns/rows`를 inline style로 설정. 2x2가 기본이지만 3x3도 가능. `.matrix-corner`에 축 방향 표시.

---

## 11. Journey (사용자 여정)

Best for: 사용자 경험 흐름, 터치포인트 맵, 온보딩 과정

Key classes: `.journey`, `.journey-line`, `.journey-step`, `.journey-dot`, `.journey-label`, `.journey-desc`

```html
<body>
  <div class="figure-title">사용자 온보딩 여정</div>
  <div class="journey">
    <div class="journey-line"></div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-blue)">🔍</div>
      <div class="journey-label">발견</div>
      <div class="journey-desc">검색 / 추천으로 서비스 인지</div>
    </div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-lime)">📝</div>
      <div class="journey-label">가입</div>
      <div class="journey-desc">소셜 로그인으로 빠르게 시작</div>
    </div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-orange)">🎯</div>
      <div class="journey-label">첫 사용</div>
      <div class="journey-desc">핵심 기능 체험 가이드</div>
    </div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--tl-purple)">💡</div>
      <div class="journey-label">Aha!</div>
      <div class="journey-desc">핵심 가치 인식 순간</div>
    </div>
    <div class="journey-step">
      <div class="journey-dot" style="background:var(--yellow)">🔄</div>
      <div class="journey-label">재방문</div>
      <div class="journey-desc">습관 형성 루프 진입</div>
    </div>
  </div>
</body>
```

Notes: `.journey-line`은 모든 dot을 관통하는 수평선. 단계 4~6개 권장. timeline과 달리 비율이 아닌 이산 포인트.

---

## 12. Funnel (퍼널)

Best for: 전환율, 단계별 감소, 마케팅 퍼널, 파이프라인

Key classes: `.funnel`, `.funnel-stage`, `.funnel-label`, `.funnel-value`

```html
<body>
  <div class="figure-title">가입 전환 퍼널</div>
  <div class="funnel">
    <div class="funnel-stage" style="width:100%;background:var(--tl-blue)">
      <span class="funnel-label">🌐 랜딩 방문</span>
      <span class="funnel-value">10,000</span>
    </div>
    <div class="funnel-stage" style="width:80%;background:var(--tl-lime)">
      <span class="funnel-label">📝 가입 시작</span>
      <span class="funnel-value">3,200 (32%)</span>
    </div>
    <div class="funnel-stage" style="width:60%;background:var(--tl-orange)">
      <span class="funnel-label">✅ 가입 완료</span>
      <span class="funnel-value">1,800 (18%)</span>
    </div>
    <div class="funnel-stage" style="width:40%;background:var(--tl-purple)">
      <span class="funnel-label">🎯 첫 사용</span>
      <span class="funnel-value">720 (7.2%)</span>
    </div>
    <div class="funnel-stage" style="width:25%;background:var(--tl-pink)">
      <span class="funnel-label">💰 결제</span>
      <span class="funnel-value">180 (1.8%)</span>
    </div>
  </div>
</body>
```

Notes: `width`를 inline style로 점진적 감소. 단계 4~6개 권장. `--tl-*` 색상 순서대로 사용.

---

## 13. Loop (순환 루프)

Best for: 피드백 루프, PDCA 사이클, 반복 프로세스

Key classes: `.loop`, `.loop-node`, `.loop-center`, `.arrow-right`, `.arrow-down`, `.arrow-left`, `.arrow-up`

```html
<body>
  <div class="figure-title">린 스타트업 사이클</div>
  <div class="loop" style="gap:1.5rem">
    <!-- Row 1: Node — Arrow Right — Node -->
    <div class="loop-node" style="background:var(--tl-blue)">
      <div style="font-size:1.5rem">💡</div>
      <div>아이디어</div>
    </div>
    <div class="arrow-right" style="width:80px"></div>
    <div class="loop-node" style="background:var(--tl-lime)">
      <div style="font-size:1.5rem">🛠️</div>
      <div>Build</div>
    </div>
    <!-- Row 2: Arrow Up — Center Label — Arrow Down -->
    <div class="arrow-up" style="height:40px"></div>
    <div class="loop-center">🔄</div>
    <div class="arrow-down" style="height:40px"></div>
    <!-- Row 3: Node — Arrow Left — Node -->
    <div class="loop-node" style="background:var(--tl-purple)">
      <div style="font-size:1.5rem">📊</div>
      <div>Learn</div>
    </div>
    <div class="arrow-left" style="width:80px"></div>
    <div class="loop-node" style="background:var(--tl-orange)">
      <div style="font-size:1.5rem">📏</div>
      <div>Measure</div>
    </div>
  </div>
</body>
```

Notes: 3x3 CSS grid로 4개 노드를 정사각형 배치. 시계방향 흐름: 우→하→좌→상. 중앙에 순환 아이콘.

---

## 14. Data Viz (데이터 시각화)

Best for: 수치 비교, 비율, 설문 결과, 벤치마크

Key classes: `.bar-chart`, `.bar-row`, `.bar-label`, `.bar-track`, `.bar-fill`, `.bar-value`

```html
<body>
  <div class="figure-title">프레임워크 만족도</div>
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
    <div class="bar-row">
      <div class="bar-label">SolidJS</div>
      <div class="bar-track"><div class="bar-fill" style="width:89%;background:var(--tl-pink)">89%</div></div>
    </div>
  </div>
  <div class="insight-box" style="margin-top:2rem">Svelte가 만족도 1위, Angular은 유일한 60% 미만</div>
</body>
```

Notes: `width` 퍼센트로 바 길이 설정. 수평 바 차트 전용. 항목 4~8개 권장.

---

## 15. Storyboard (스토리보드)

Best for: 시나리오 설명, 단계별 장면, 사용자 시나리오, 기능 소개

Key classes: `.storyboard`, `.story-panel`, `.story-number`, `.story-icon`, `.story-caption`, `.story-desc`

```html
<body>
  <div class="figure-title">모바일 결제 시나리오</div>
  <div class="storyboard" style="grid-template-columns:repeat(3,1fr)">
    <div class="story-panel">
      <div class="story-number">1</div>
      <div class="story-icon">📱</div>
      <div class="story-caption">앱 열기</div>
      <div class="story-desc">알림 탭으로 결제 요청 확인</div>
    </div>
    <div class="story-panel">
      <div class="story-number">2</div>
      <div class="story-icon">🔍</div>
      <div class="story-caption">내역 확인</div>
      <div class="story-desc">금액, 상점, 날짜 확인</div>
    </div>
    <div class="story-panel">
      <div class="story-number">3</div>
      <div class="story-icon">👆</div>
      <div class="story-caption">결제 승인</div>
      <div class="story-desc">슬라이드하여 결제 확정</div>
    </div>
    <div class="story-panel">
      <div class="story-number">4</div>
      <div class="story-icon">🔐</div>
      <div class="story-caption">생체 인증</div>
      <div class="story-desc">Face ID / 지문으로 본인 확인</div>
    </div>
    <div class="story-panel">
      <div class="story-number">5</div>
      <div class="story-icon">✅</div>
      <div class="story-caption">완료</div>
      <div class="story-desc">결제 성공 + 영수증 표시</div>
    </div>
    <div class="story-panel">
      <div class="story-number">6</div>
      <div class="story-icon">📊</div>
      <div class="story-caption">기록</div>
      <div class="story-desc">월별 지출 통계에 자동 반영</div>
    </div>
  </div>
</body>
```

Notes: `grid-template-columns`로 열 수 조정 (2×3이면 `repeat(3,1fr)`, 3×2면 `repeat(2,1fr)`). 패널 4~9개 권장.

---

## Design Rules (Quick Reference)

- **Size**: 1440×810 (16:9)
- **Border**: Always 3px solid #0a0a0a
- **Shadow**: Npx Npx 0px #0a0a0a (no blur, ever)
- **Fonts**: Black Han Sans (titles), Noto Sans KR (body), JetBrains Mono (code/numbers)
- **Colors**: Use CSS variables only, never hardcode hex in HTML
- **Icons**: Emoji only (no FontAwesome — keeps HTML self-contained)
- **No**: gradients, blur shadows, soft edges, rounded-full on cards
- **Slight rotation** on badges/labels: rotate(-1deg) to rotate(5deg)
- **Icon circles**: 48px, border-radius 50%, 3px border

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
