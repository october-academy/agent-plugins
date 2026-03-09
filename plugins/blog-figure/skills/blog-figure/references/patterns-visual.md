# Figure Patterns — Visual / Generative

Visual & generative patterns (5): Isometric, IconDiagram, Network, Graph, Typographic Statement.

All use `assets/figure.css`. SVG 인라인, Canvas, D3 등 기술별 접근 방식이 다름.

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
ctx.font = `500 ${20 * S}px 'JetBrains Mono'`;
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

## 22. Typographic Statement (SVG 인라인)

Best for: 에디토리얼 인용, 핵심 정의, 선언적 메시지, 한 문장으로 임팩트

Approach: **SVG inline** — `<text>` + `<tspan>` 정밀 배치. 장식적 큰따옴표 + Neo-Brutalism 카드.

Max: **primary text max 8단어**, attribution max 4단어. 총 ~12단어.

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .attr { font-family: 'JetBrains Mono', monospace; fill: #737373; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Decorative quote mark (background) -->
  <text x="240" y="400" font-family="Georgia, serif" font-size="300" fill="#0a0a0a" opacity="0.06">"</text>

  <!-- Card: white rect + 3px border + hard shadow -->
  <rect x="274" y="194" width="900" height="380" rx="0" fill="#0a0a0a" opacity="0.08"/>
  <rect x="270" y="190" width="900" height="380" rx="0" fill="white" stroke="#0a0a0a" stroke-width="3"/>

  <!-- Highlight bar under key phrase -->
  <rect x="340" y="370" width="420" height="16" fill="#fde047" opacity="0.7"/>

  <!-- Primary text (multi-line with tspan) -->
  <text x="720" y="320" text-anchor="middle" font-size="56" font-weight="900">
    <tspan x="720" dy="0">사용자가 말하는 것과</tspan>
    <tspan x="720" dy="72">실제 행동은 다르다</tspan>
  </text>

  <!-- Attribution -->
  <text class="attr" x="720" y="640" text-anchor="middle" font-size="24" font-weight="700">— Jakob Nielsen</text>
</svg>
</body>
```

Notes: 장식적 큰따옴표 (font-size: 300, opacity 0.06)로 인용 느낌 연출. Neo-Brutalism 카드: white rect + 3px border + 4px offset hard shadow. 강조 바(highlight bar)를 핵심 구절 아래에 배치 (`#fde047` yellow). `<tspan>`으로 multi-line 텍스트 구현. Attribution은 JetBrains Mono. 텍스트 길이에 따라 short (1줄, 120px) vs medium (2줄, 56px) 선택.

---
