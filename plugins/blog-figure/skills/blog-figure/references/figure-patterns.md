# Figure Pattern Reference

Each pattern includes a minimal HTML example. All use `assets/figure.css`.

## 1. Comparison (좌우 비교)

Best for: X vs Y, 나쁜 예시 vs 좋은 예시, 이전 vs 이후

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

Between columns use optional `<div class="arrow-dashed">` with label "출시 후".

## 2. Flow (수직 플로우 비교)

Best for: 프로세스 비교, 단계별 차이, 방법론 대비

```html
<body>
  <div class="split relative" style="height:auto;min-height:75%">
    <div class="split-left" style="background:var(--bad-bg)">
      <div class="figure-title" style="font-size:1.75rem">나쁜 인터뷰 (Pitching)</div>
      <p style="color:var(--bad-accent);margin-bottom:1rem">미래와 가설을 묻는다</p>
      <div class="flex flex-col items-center">
        <div class="flow-card bad"><div class="icon bad">📢</div><div><strong>아이디어 설명</strong><br><span class="text-sm">"제가 이런 걸 만들 건데요..."</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card bad"><div class="icon bad">❓</div><div><strong>평가 요청</strong><br><span class="text-sm">"어떻게 생각하세요?"</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card bad" style="border-color:var(--bad-accent)"><div class="icon bad">❌</div><div><strong style="color:var(--bad-accent)">착각 (Delusion)</strong><br><span class="text-sm">시장성이 있다고 오해함</span></div></div>
      </div>
    </div>
    <div class="split-right" style="background:var(--good-bg)">
      <div class="figure-title" style="font-size:1.75rem">좋은 인터뷰 (Learning)</div>
      <p style="color:var(--good-accent);margin-bottom:1rem">과거와 행동을 캔다</p>
      <div class="flex flex-col items-center">
        <div class="flow-card good"><div class="icon good">🔍</div><div><strong>맥락 확인</strong><br><span class="text-sm">"그 문제를 언제 겪으셨나요?"</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card good"><div class="icon good">🔄</div><div><strong>최근 사례</strong><br><span class="text-sm">"마지막으로 해결하려 했을 때..."</span></div></div>
        <div class="arrow-down"></div>
        <div class="flow-card good" style="border-color:var(--good-accent)"><div class="icon good">✅</div><div><strong style="color:var(--good-accent)">현재 해결 방식</strong><br><span class="text-sm">진짜 니즈(Needs) 발견</span></div></div>
      </div>
    </div>
  </div>
</body>
```

## 3. Timeline (수평 타임라인)

Best for: 시간 배분, 단계 순서, 비율 시각화

```html
<body>
  <div class="figure-title">15분 인터뷰 타임라인</div>
  <div class="timeline">
    <div class="tl-block" style="flex:2;background:var(--tl-blue)">
      <div class="tl-label">맥락</div>
      <div class="tl-time">2분</div>
    </div>
    <div class="tl-block" style="flex:6;background:var(--tl-green)">
      <div class="tl-label">사례 복기</div>
      <div class="tl-time">6분</div>
    </div>
    <div class="tl-block" style="flex:4;background:var(--tl-orange)">
      <div class="tl-label">비용</div>
      <div class="tl-time">4분</div>
    </div>
    <div class="tl-block" style="flex:3;background:var(--tl-purple)">
      <div class="tl-label">우선순위</div>
      <div class="tl-time">3분</div>
    </div>
  </div>
  <div class="tl-annotations">
    <div class="tl-anno" style="flex:2;color:var(--info-accent)">↓<br>"요즘 이 문제를<br>언제 겪나요?"</div>
    <div class="tl-anno" style="flex:6;color:var(--good-accent)">↓<br>"마지막 상황을<br>순서대로 말해 주세요"</div>
    <div class="tl-anno" style="flex:4;color:var(--orange)">↓<br>"시간, 사람, 돈을<br>얼마나 썼나요?"</div>
    <div class="tl-anno" style="flex:3;color:#7C3AED">↓<br>"다른 문제와<br>비교하면 몇 위?"</div>
  </div>
</body>
```

## 4. Concept Diagram (개념도)

Best for: 관계도, 벤 다이어그램 스타일, 개념 비교

Use `concept-block` with absolute positioning and z-index for overlapping effects.

```html
<body>
  <div class="figure-title">TDD vs SDD vs IDD</div>
  <div style="position:relative;width:900px;height:500px">
    <div class="concept-block" style="position:absolute;left:0;top:80px;width:300px;height:350px;background:#FCD34D;z-index:1">
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

## Design Rules (Quick Reference)

- **Border**: Always 3px solid #0a0a0a
- **Shadow**: 4px 4px 0px #0a0a0a (no blur, ever)
- **Fonts**: Black Han Sans for titles/labels, Noto Sans KR for body
- **Colors**: Use CSS variables only, never hardcode
- **No gradients, no blur shadows, no rounded-full on cards**
- **Slight rotation** on badges/labels: rotate(-1deg) to rotate(5deg)
- **Icon circles**: 48px, border-radius 50%, 3px border
