# Figure Patterns — Data Visualization

Data visualization patterns (10): Data Viz, Waffle, Slope, Treemap, Radar, Dumbbell, Heatmap, Bullet, Sparkline Grid, Waterfall.

All use `assets/figure.css`. **핵심 원칙**: 텍스트는 최소한으로. 색상과 면적으로 구조 전달. 모바일 25% 축소에서도 인식 가능.

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

## 21. Waffle (SVG 인라인)

Best for: 비율 체감, 퍼센트 시각화, 100칸 중 N칸으로 비율을 직관적으로 표현

Approach: **SVG inline** — 10x10 `<rect>` 그리드 (100개 셀). 셀 52x52, gap 4px.

Max: **2 카테고리**, 총 ~8단어 (범례 포함)

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .waffle-cell { stroke: #0a0a0a; stroke-width: 2.5; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Waffle grid: 10x10 = 100 cells, 72 filled (blue), 28 empty (muted) -->
  <!-- Cell size: 52x52, gap: 4px. Grid origin: (280, 85) -->
  <!-- Row 0 (top) -->
  <rect class="waffle-cell" x="280" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="336" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="392" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="448" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="504" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="560" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="616" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="672" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="728" y="85" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="784" y="85" width="52" height="52" fill="#3B82F6"/>
  <!-- Row 1 -->
  <rect class="waffle-cell" x="280" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="336" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="392" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="448" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="504" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="560" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="616" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="672" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="728" y="141" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="784" y="141" width="52" height="52" fill="#3B82F6"/>
  <!-- Row 2 -->
  <rect class="waffle-cell" x="280" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="336" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="392" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="448" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="504" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="560" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="616" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="672" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="728" y="197" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="784" y="197" width="52" height="52" fill="#3B82F6"/>
  <!-- Row 3 -->
  <rect class="waffle-cell" x="280" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="336" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="392" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="448" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="504" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="560" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="616" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="672" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="728" y="253" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="784" y="253" width="52" height="52" fill="#3B82F6"/>
  <!-- Row 4 -->
  <rect class="waffle-cell" x="280" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="336" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="392" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="448" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="504" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="560" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="616" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="672" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="728" y="309" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="784" y="309" width="52" height="52" fill="#3B82F6"/>
  <!-- Row 5 -->
  <rect class="waffle-cell" x="280" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="336" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="392" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="448" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="504" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="560" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="616" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="672" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="728" y="365" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="784" y="365" width="52" height="52" fill="#3B82F6"/>
  <!-- Row 6 -->
  <rect class="waffle-cell" x="280" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="336" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="392" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="448" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="504" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="560" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="616" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="672" y="421" width="52" height="52" fill="#3B82F6"/>
  <rect class="waffle-cell" x="728" y="421" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="784" y="421" width="52" height="52" fill="#e5e5e5"/>
  <!-- Row 7 -->
  <rect class="waffle-cell" x="280" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="336" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="392" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="448" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="504" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="560" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="616" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="672" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="728" y="477" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="784" y="477" width="52" height="52" fill="#e5e5e5"/>
  <!-- Row 8 -->
  <rect class="waffle-cell" x="280" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="336" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="392" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="448" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="504" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="560" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="616" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="672" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="728" y="533" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="784" y="533" width="52" height="52" fill="#e5e5e5"/>
  <!-- Row 9 (bottom) -->
  <rect class="waffle-cell" x="280" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="336" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="392" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="448" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="504" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="560" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="616" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="672" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="728" y="589" width="52" height="52" fill="#e5e5e5"/>
  <rect class="waffle-cell" x="784" y="589" width="52" height="52" fill="#e5e5e5"/>

  <!-- Legend (right side) -->
  <rect x="900" y="260" width="28" height="28" fill="#3B82F6" stroke="#0a0a0a" stroke-width="2.5"/>
  <text x="940" y="282" font-size="28" font-weight="900">72%</text>
  <text x="940" y="316" font-size="24" font-weight="700" fill="#737373">채택</text>

  <rect x="900" y="370" width="28" height="28" fill="#e5e5e5" stroke="#0a0a0a" stroke-width="2.5"/>
  <text x="940" y="392" font-size="28" font-weight="900">28%</text>
  <text x="940" y="426" font-size="24" font-weight="700" fill="#737373">미채택</text>
</svg>
</body>
```

Notes: 10x10 그리드로 100% 비율 표현. 좌상단부터 채워나감. 셀 크기 52x52, gap 4px (총 560x560). 2 카테고리만 사용 (채운 셀 vs 빈 셀). fill 색상으로 카테고리 구분 (#3B82F6 = 활성, #e5e5e5 = 비활성). 퍼센트를 바꾸려면 채운 셀 수만 조정.

---

## 23. Slope (SVG 인라인)

Best for: 전후 정량 변화, 순위 변동, 랭킹 이동, 두 시점 비교

Approach: **SVG inline** — `<line>` + `<circle>` + `<text>`. Y좌표 = rank 기반 배치. JS 불필요.

Max: **5항목**, 2시점 (좌/우 칼럼)

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .slope-line { stroke-width: 3; fill: none; }
      .slope-dot { stroke: #0a0a0a; stroke-width: 2.5; }
      .header-box { fill: white; stroke: #0a0a0a; stroke-width: 3; }
      .mono { font-family: 'JetBrains Mono', monospace; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Column headers -->
  <rect class="header-box" x="240" y="60" width="180" height="56" rx="0"/>
  <text x="330" y="97" text-anchor="middle" font-size="28" font-weight="900">2023</text>
  <rect class="header-box" x="1020" y="60" width="180" height="56" rx="0"/>
  <text x="1110" y="97" text-anchor="middle" font-size="28" font-weight="900">2024</text>

  <!-- Y positions: 5 items, y = 180 + (rank-1) * 110 -->
  <!-- Item 1: React — rank 1→3 (y: 180→400) -->
  <line class="slope-line" x1="380" y1="180" x2="1060" y2="400" stroke="#3B82F6"/>
  <circle class="slope-dot" cx="380" cy="180" r="10" fill="#3B82F6"/>
  <circle class="slope-dot" cx="1060" cy="400" r="10" fill="#3B82F6"/>
  <text x="360" y="186" text-anchor="end" font-size="24" font-weight="700">React</text>
  <text x="220" y="186" text-anchor="end" font-size="20" font-weight="700" class="mono" fill="#737373">1</text>
  <text x="1080" y="406" font-size="24" font-weight="700">React</text>
  <text x="1220" y="406" font-size="20" font-weight="700" class="mono" fill="#737373">3</text>

  <!-- Item 2: Svelte — rank 2→1 (y: 290→180) -->
  <line class="slope-line" x1="380" y1="290" x2="1060" y2="180" stroke="#a3e635"/>
  <circle class="slope-dot" cx="380" cy="290" r="10" fill="#a3e635"/>
  <circle class="slope-dot" cx="1060" cy="180" r="10" fill="#a3e635"/>
  <text x="360" y="296" text-anchor="end" font-size="24" font-weight="700">Svelte</text>
  <text x="220" y="296" text-anchor="end" font-size="20" font-weight="700" class="mono" fill="#737373">2</text>
  <text x="1080" y="186" font-size="24" font-weight="700">Svelte</text>
  <text x="1220" y="186" font-size="20" font-weight="700" class="mono" fill="#737373">1</text>

  <!-- Item 3: Vue — rank 3→2 (y: 400→290) -->
  <line class="slope-line" x1="380" y1="400" x2="1060" y2="290" stroke="#FF6B35"/>
  <circle class="slope-dot" cx="380" cy="400" r="10" fill="#FF6B35"/>
  <circle class="slope-dot" cx="1060" cy="290" r="10" fill="#FF6B35"/>
  <text x="360" y="406" text-anchor="end" font-size="24" font-weight="700">Vue</text>
  <text x="220" y="406" text-anchor="end" font-size="20" font-weight="700" class="mono" fill="#737373">3</text>
  <text x="1080" y="296" font-size="24" font-weight="700">Vue</text>
  <text x="1220" y="296" font-size="20" font-weight="700" class="mono" fill="#737373">2</text>

  <!-- Item 4: Angular — rank 4→5 (y: 510→620) -->
  <line class="slope-line" x1="380" y1="510" x2="1060" y2="620" stroke="#ff5c8d"/>
  <circle class="slope-dot" cx="380" cy="510" r="10" fill="#ff5c8d"/>
  <circle class="slope-dot" cx="1060" cy="620" r="10" fill="#ff5c8d"/>
  <text x="360" y="516" text-anchor="end" font-size="24" font-weight="700">Angular</text>
  <text x="220" y="516" text-anchor="end" font-size="20" font-weight="700" class="mono" fill="#737373">4</text>
  <text x="1080" y="626" font-size="24" font-weight="700">Angular</text>
  <text x="1220" y="626" font-size="20" font-weight="700" class="mono" fill="#737373">5</text>

  <!-- Item 5: Solid — rank 5→4 (y: 620→510) -->
  <line class="slope-line" x1="380" y1="620" x2="1060" y2="510" stroke="#8B5CF6"/>
  <circle class="slope-dot" cx="380" cy="620" r="10" fill="#8B5CF6"/>
  <circle class="slope-dot" cx="1060" cy="510" r="10" fill="#8B5CF6"/>
  <text x="360" y="626" text-anchor="end" font-size="24" font-weight="700">Solid</text>
  <text x="220" y="626" text-anchor="end" font-size="20" font-weight="700" class="mono" fill="#737373">5</text>
  <text x="1080" y="516" font-size="24" font-weight="700">Solid</text>
  <text x="1220" y="516" font-size="20" font-weight="700" class="mono" fill="#737373">4</text>
</svg>
</body>
```

Notes: Y좌표 = `180 + (rank-1) * 110` (5항목 기준). JS 불필요 — 순수 SVG. `--tl-*` 팔레트에서 항목별 색상 배정. 좌 칼럼 = 이전 시점, 우 칼럼 = 이후 시점. 기울기 방향으로 변화 시각화 (상승 = 순위 향상, 하강 = 하락). rank 숫자를 JetBrains Mono로 표시.

---

## 24. Treemap (D3)

Best for: 면적 비례 구성비, 카테고리별 비중, 2D 면적으로 비율 비교

Approach: **D3 v7 CDN** — `d3.treemap().tile(d3.treemapSquarify)`. flat data `{children: [{name, value, color}]}`.

Max: **6~8 leaf nodes**, 라벨 1단어. 셀 폭 80px 미만이면 라벨 숨김.

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
    .cell { stroke: #0a0a0a; stroke-width: 3; }
    .cell-label { font-family: 'Noto Sans KR', sans-serif; font-weight: 900; font-size: 28px;
                  fill: #0a0a0a; text-anchor: middle; dominant-baseline: central; }
    .cell-value { font-family: 'JetBrains Mono', monospace; font-weight: 700; font-size: 22px;
                  fill: #0a0a0a; text-anchor: middle; opacity: 0.7; }
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
const data = {
  children: [
    { name: 'React', value: 40, color: '#3B82F6' },
    { name: 'Vue',   value: 25, color: '#a3e635' },
    { name: 'Svelte',value: 18, color: '#FF6B35' },
    { name: 'Angular',value:10, color: '#ff5c8d' },
    { name: 'Solid', value: 5,  color: '#8B5CF6' },
    { name: 'Qwik',  value: 2,  color: '#fde047' },
  ]
};

const svg = d3.select('svg');
const margin = { top: 80, right: 80, bottom: 80, left: 80 };
const W = 1440 - margin.left - margin.right;
const H = 810 - margin.top - margin.bottom;

const g = svg.append('g').attr('transform', `translate(${margin.left},${margin.top})`);

const root = d3.hierarchy(data).sum(d => d.value);
d3.treemap().size([W, H]).tile(d3.treemapSquarify).padding(6)(root);

// Draw cell shadows (hard shadow)
g.selectAll('.shadow').data(root.leaves()).join('rect')
  .attr('x', d => d.x0 + 4).attr('y', d => d.y0 + 4)
  .attr('width', d => d.x1 - d.x0).attr('height', d => d.y1 - d.y0)
  .attr('fill', '#0a0a0a').attr('opacity', 0.08);

// Draw cells
g.selectAll('.cell').data(root.leaves()).join('rect')
  .attr('class', 'cell')
  .attr('x', d => d.x0).attr('y', d => d.y0)
  .attr('width', d => d.x1 - d.x0).attr('height', d => d.y1 - d.y0)
  .attr('fill', d => d.data.color);

// Draw labels (hide if cell width < 80px)
g.selectAll('.cell-label').data(root.leaves()).join('text')
  .attr('class', 'cell-label')
  .attr('x', d => (d.x0 + d.x1) / 2).attr('y', d => (d.y0 + d.y1) / 2 - 10)
  .text(d => (d.x1 - d.x0) >= 80 ? d.data.name : '');

// Draw values
g.selectAll('.cell-value').data(root.leaves()).join('text')
  .attr('class', 'cell-value')
  .attr('x', d => (d.x0 + d.x1) / 2).attr('y', d => (d.y0 + d.y1) / 2 + 20)
  .text(d => (d.x1 - d.x0) >= 80 ? d.data.value + '%' : '');
</script>
</body>
```

Notes: D3 treemap은 `d3.treemapSquarify` 타일링으로 정사각형에 가까운 셀을 생성. `data.children` 배열만 수정하면 내용 변경 가능. Hard shadow는 offset된 검정 rect (opacity 0.08). 셀 폭 80px 미만이면 라벨과 값 모두 숨김. `padding(6)`으로 셀 간 간격 확보.

---

## 25. Radar (SVG + JS)

Best for: 다축 프로파일 비교, 역량 평가, 3~5개 축 지표 비교

Approach: **SVG + inline `<script>`** — cos/sin 좌표 계산. CDN 불필요. 12시 시작 (`-PI/2` offset).

Max: **5축**, 1~2 data series, 축 라벨 1단어

```html
<body>
<svg id="radar" viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .guide { fill: none; stroke: #e5e5e5; stroke-width: 1.5; }
      .axis { stroke: #e5e5e5; stroke-width: 1.5; }
      .data-poly { stroke-width: 3; }
      .data-dot { stroke: #0a0a0a; stroke-width: 2.5; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>
</svg>
<script>
// === CONFIG ===
const axes = ['속도', 'DX', '생태계', '유연성', '안정성'];
const series = [
  { name: 'React',  values: [0.7, 0.8, 0.95, 0.85, 0.9], color: '#3B82F6' },
  { name: 'Svelte', values: [0.95, 0.9, 0.5, 0.7, 0.6],  color: '#a3e635' },
];

const svg = document.getElementById('radar');
const ns = 'http://www.w3.org/2000/svg';
const cx = 720, cy = 405, R = 280;
const n = axes.length;

function pt(i, r) {
  const angle = (2 * Math.PI * i / n) - Math.PI / 2;
  return [cx + r * Math.cos(angle), cy + r * Math.sin(angle)];
}

function polyPoints(values, radius) {
  return values.map((v, i) => pt(i, v * radius).join(',')).join(' ');
}

// Guide polygons: 25%, 50%, 75%, 100%
[0.25, 0.5, 0.75, 1.0].forEach(pct => {
  const poly = document.createElementNS(ns, 'polygon');
  poly.setAttribute('class', 'guide');
  poly.setAttribute('points', polyPoints(Array(n).fill(pct), R));
  svg.appendChild(poly);
});

// Axis lines
for (let i = 0; i < n; i++) {
  const [x, y] = pt(i, R);
  const line = document.createElementNS(ns, 'line');
  line.setAttribute('class', 'axis');
  line.setAttribute('x1', cx); line.setAttribute('y1', cy);
  line.setAttribute('x2', x);  line.setAttribute('y2', y);
  svg.appendChild(line);
}

// Axis labels
axes.forEach((label, i) => {
  const [x, y] = pt(i, R + 40);
  const txt = document.createElementNS(ns, 'text');
  txt.setAttribute('x', x); txt.setAttribute('y', y);
  txt.setAttribute('text-anchor', 'middle');
  txt.setAttribute('dominant-baseline', 'central');
  txt.setAttribute('font-size', '24'); txt.setAttribute('font-weight', '900');
  txt.textContent = label;
  svg.appendChild(txt);
});

// Data series
series.forEach(s => {
  // Filled polygon
  const poly = document.createElementNS(ns, 'polygon');
  poly.setAttribute('class', 'data-poly');
  poly.setAttribute('points', polyPoints(s.values, R));
  poly.setAttribute('fill', s.color.replace(')', ',0.2)').replace('rgb', 'rgba').replace('#3B82F6', 'rgba(59,130,246,0.2)').replace('#a3e635', 'rgba(163,230,53,0.2)'));
  // Simpler: use hex to rgba
  const r2 = parseInt(s.color.slice(1,3),16), g2 = parseInt(s.color.slice(3,5),16), b2 = parseInt(s.color.slice(5,7),16);
  poly.setAttribute('fill', `rgba(${r2},${g2},${b2},0.2)`);
  poly.setAttribute('stroke', s.color);
  svg.appendChild(poly);

  // Dots
  s.values.forEach((v, i) => {
    const [x, y] = pt(i, v * R);
    const dot = document.createElementNS(ns, 'circle');
    dot.setAttribute('class', 'data-dot');
    dot.setAttribute('cx', x); dot.setAttribute('cy', y);
    dot.setAttribute('r', '8'); dot.setAttribute('fill', s.color);
    svg.appendChild(dot);
  });
});

// Legend (bottom right)
series.forEach((s, i) => {
  const lx = 1100, ly = 650 + i * 40;
  const rect = document.createElementNS(ns, 'rect');
  rect.setAttribute('x', lx); rect.setAttribute('y', ly - 12);
  rect.setAttribute('width', '20'); rect.setAttribute('height', '20');
  rect.setAttribute('fill', s.color); rect.setAttribute('stroke', '#0a0a0a'); rect.setAttribute('stroke-width', '2');
  svg.appendChild(rect);
  const txt = document.createElementNS(ns, 'text');
  txt.setAttribute('x', lx + 30); txt.setAttribute('y', ly + 4);
  txt.setAttribute('font-size', '22'); txt.setAttribute('font-weight', '700');
  txt.textContent = s.name;
  svg.appendChild(txt);
});
</script>
</body>
```

Notes: `pt(i, r)` 함수로 극좌표→직교좌표 변환. `-PI/2` offset으로 12시 방향 시작. 가이드 다각형 4단계 (25%, 50%, 75%, 100%). 데이터 다각형 fill은 `rgba(color, 0.2)` — flat semi-transparent, gradient 아님. 축 라벨은 R+40px 위치에 배치. 범례는 우하단.

---

## 26. Dumbbell (SVG 인라인)

Best for: 두 값 사이의 갭/범위 비교, 전후 변화량, 격차 시각화

Approach: **SVG inline** — `<circle>` x2 + `<line>` per row. 공유 x축 선형 매핑. JS 불필요.

Max: **5 rows**, 라벨 max 3단어

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .db-line { stroke: #e5e5e5; stroke-width: 4; stroke-linecap: round; }
      .db-dot { stroke: #0a0a0a; stroke-width: 2.5; }
      .mono { font-family: 'JetBrains Mono', monospace; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Legend (top) -->
  <circle cx="860" cy="60" r="10" fill="#3B82F6" stroke="#0a0a0a" stroke-width="2.5"/>
  <text x="880" y="67" font-size="22" font-weight="700">2023</text>
  <circle cx="1000" cy="60" r="10" fill="#FF6B35" stroke="#0a0a0a" stroke-width="2.5"/>
  <text x="1020" y="67" font-size="22" font-weight="700">2024</text>

  <!-- X axis scale: 0%—100%, mapped to x: 400—1300 -->
  <!-- Scale ticks -->
  <line x1="400" y1="740" x2="1300" y2="740" stroke="#e5e5e5" stroke-width="1.5"/>
  <text class="mono" x="400" y="770" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">0%</text>
  <text class="mono" x="625" y="770" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">25%</text>
  <text class="mono" x="850" y="770" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">50%</text>
  <text class="mono" x="1075" y="770" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">75%</text>
  <text class="mono" x="1300" y="770" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">100%</text>

  <!-- Row 1: React — 2023: 72%, 2024: 85% → x: 1048, 1165 -->
  <text x="360" y="180" text-anchor="end" font-size="24" font-weight="700">React</text>
  <line class="db-line" x1="1048" y1="174" x2="1165" y2="174"/>
  <circle class="db-dot" cx="1048" cy="174" r="12" fill="#3B82F6"/>
  <circle class="db-dot" cx="1165" cy="174" r="12" fill="#FF6B35"/>

  <!-- Row 2: Vue — 2023: 45%, 2024: 62% → x: 805, 958 -->
  <text x="360" y="310" text-anchor="end" font-size="24" font-weight="700">Vue</text>
  <line class="db-line" x1="805" y1="304" x2="958" y2="304"/>
  <circle class="db-dot" cx="805" cy="304" r="12" fill="#3B82F6"/>
  <circle class="db-dot" cx="958" cy="304" r="12" fill="#FF6B35"/>

  <!-- Row 3: Svelte — 2023: 28%, 2024: 55% → x: 652, 895 -->
  <text x="360" y="440" text-anchor="end" font-size="24" font-weight="700">Svelte</text>
  <line class="db-line" x1="652" y1="434" x2="895" y2="434"/>
  <circle class="db-dot" cx="652" cy="434" r="12" fill="#3B82F6"/>
  <circle class="db-dot" cx="895" cy="434" r="12" fill="#FF6B35"/>

  <!-- Row 4: Angular — 2023: 60%, 2024: 42% → x: 940, 778 -->
  <text x="360" y="570" text-anchor="end" font-size="24" font-weight="700">Angular</text>
  <line class="db-line" x1="778" y1="564" x2="940" y2="564"/>
  <circle class="db-dot" cx="940" cy="564" r="12" fill="#3B82F6"/>
  <circle class="db-dot" cx="778" cy="564" r="12" fill="#FF6B35"/>

  <!-- Row 5: Solid — 2023: 10%, 2024: 35% → x: 490, 715 -->
  <text x="360" y="670" text-anchor="end" font-size="24" font-weight="700">Solid</text>
  <line class="db-line" x1="490" y1="664" x2="715" y2="664"/>
  <circle class="db-dot" cx="490" cy="664" r="12" fill="#3B82F6"/>
  <circle class="db-dot" cx="715" cy="664" r="12" fill="#FF6B35"/>
</svg>
</body>
```

Notes: x축 범위 400~1300px, 값 0~100%를 선형 매핑 (`x = 400 + value/100 * 900`). 각 행에 연결 선(muted) + 양끝 dot(colored)으로 갭 시각화. JS 불필요 — 좌표를 직접 계산하여 SVG에 배치. 범례는 상단에 두 색상 dot + 라벨.

---

## 27. Heatmap (Canvas/JS)

Best for: 2D 색상 강도, 빈도/밀도 맵, 시간별·카테고리별 분포 패턴

Approach: **Canvas + JS** (Network 패턴과 동일 구조). retina 2x (2880×1620). `lerp` 색상 보간.

Max: **7x5 grid** (35 cells), 셀 ~110x90px

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=1440">
  <link rel="stylesheet" href="file://{SKILL_DIR}/assets/figure.css">
  <style>
    body { width:1440px;height:810px;margin:0;overflow:hidden;background:#f5f5f5; }
    canvas { width:1440px;height:810px; }
  </style>
</head>
<body>
<canvas id="c" width="2880" height="1620"></canvas>
<script>
document.fonts.ready.then(() => {
  const canvas = document.getElementById('c');
  const ctx = canvas.getContext('2d');
  const S = 2; // retina scale

  // === CONFIG ===
  const cols = ['월', '화', '수', '목', '금', '토', '일'];
  const rows = ['9am', '12pm', '3pm', '6pm', '9pm'];
  const values = [
    [0.2, 0.6, 0.7, 0.6, 0.3, 0.1, 0.1],
    [0.5, 0.9, 0.95, 0.7, 0.6, 0.2, 0.1],
    [0.3, 0.7, 0.85, 0.9, 0.5, 0.15, 0.1],
    [0.2, 0.4, 0.6, 0.65, 0.3, 0.1, 0.05],
    [0.1, 0.2, 0.3, 0.3, 0.15, 0.05, 0.02],
  ];

  const lowColor = [229, 229, 229];  // #e5e5e5
  const highColor = [59, 130, 246];  // #3B82F6

  function lerp(a, b, t) { return Math.round(a + (b - a) * t); }
  function cellColor(v) {
    const r = lerp(lowColor[0], highColor[0], v);
    const g = lerp(lowColor[1], highColor[1], v);
    const b = lerp(lowColor[2], highColor[2], v);
    return `rgb(${r},${g},${b})`;
  }

  // Dot grid background
  ctx.fillStyle = '#f5f5f5';
  ctx.fillRect(0, 0, 2880, 1620);
  ctx.fillStyle = 'rgba(10,10,10,0.06)';
  for (let x = 0; x < 2880; x += 16 * S) {
    for (let y = 0; y < 1620; y += 16 * S) {
      ctx.beginPath();
      ctx.arc(x + 8 * S, y + 8 * S, 1 * S, 0, Math.PI * 2);
      ctx.fill();
    }
  }

  // Grid layout
  const ox = 320 * S, oy = 140 * S;
  const cellW = 110 * S, cellH = 90 * S;
  const gap = 6 * S;

  // Column headers
  ctx.font = `900 ${24 * S}px 'Noto Sans KR', sans-serif`;
  ctx.fillStyle = '#0a0a0a';
  ctx.textAlign = 'center';
  cols.forEach((c, i) => {
    ctx.fillText(c, ox + i * (cellW + gap) + cellW / 2, oy - 20 * S);
  });

  // Row headers
  ctx.font = `700 ${20 * S}px 'JetBrains Mono', monospace`;
  ctx.fillStyle = '#737373';
  ctx.textAlign = 'right';
  rows.forEach((r, j) => {
    ctx.fillText(r, ox - 20 * S, oy + j * (cellH + gap) + cellH / 2 + 8 * S);
  });

  // Draw cells
  ctx.lineWidth = 3 * S;
  ctx.strokeStyle = '#0a0a0a';
  values.forEach((row, j) => {
    row.forEach((v, i) => {
      const x = ox + i * (cellW + gap);
      const y = oy + j * (cellH + gap);
      ctx.fillStyle = cellColor(v);
      ctx.fillRect(x, y, cellW, cellH);
      ctx.strokeRect(x, y, cellW, cellH);
    });
  });

  // Legend: gradient bar
  const lx = ox, ly = oy + rows.length * (cellH + gap) + 40 * S;
  const lw = 300 * S, lh = 20 * S;
  const grad = ctx.createLinearGradient(lx, ly, lx + lw, ly);
  grad.addColorStop(0, `rgb(${lowColor})`);
  grad.addColorStop(1, `rgb(${highColor})`);
  ctx.fillStyle = grad;
  ctx.fillRect(lx, ly, lw, lh);
  ctx.strokeRect(lx, ly, lw, lh);

  ctx.font = `700 ${20 * S}px 'Noto Sans KR', sans-serif`;
  ctx.fillStyle = '#737373';
  ctx.textAlign = 'left';
  ctx.fillText('낮음', lx, ly + lh + 30 * S);
  ctx.textAlign = 'right';
  ctx.fillText('높음', lx + lw, ly + lh + 30 * S);
});
</script>
</body>
```

Notes: `document.fonts.ready.then()` 래핑 필수 (Canvas에서 Google Fonts 렌더링). retina 2x (canvas 2880×1620 → CSS 1440×810). `lerp` 색상 보간으로 continuous gradient (#e5e5e5 → #3B82F6). 대안으로 5단계 discrete stops도 가능 (값 구간별 고정 색). dot grid 배경은 Network 패턴과 동일 방식.

---

## 28. Bullet (SVG 인라인)

Best for: 실적 vs 목표, KPI 달성률, 맥락 포함 정량 지표

Approach: **SVG inline** — 중첩 `<rect>` (배경 범위 3단계) + 전경 actual 바 + 타겟 `<line>`.

Max: **3~4 charts** 수직 배치

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .mono { font-family: 'JetBrains Mono', monospace; }
      .range { stroke: none; }
      .actual { stroke: #0a0a0a; stroke-width: 3; }
      .target { stroke: #0a0a0a; stroke-width: 4; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Bullet chart layout: x range 350-1300, bar height 60, spacing 190 -->
  <!-- Scale: 0-100 mapped to x: 350-1300 (950px range) -->

  <!-- Chart 1: 매출 — ranges: poor 0-40, ok 40-75, good 75-100 | actual: 82 | target: 90 -->
  <text x="320" y="180" text-anchor="end" font-size="28" font-weight="900">매출</text>
  <!-- Range backgrounds (back-to-front: widest=lightest first) -->
  <rect class="range" x="350" y="150" width="950" height="60" fill="#e5e5e5"/>
  <rect class="range" x="350" y="150" width="713" height="60" fill="#d4d4d4"/>
  <rect class="range" x="350" y="150" width="380" height="60" fill="#a3a3a3"/>
  <!-- Actual bar (narrower: 60% height = 36px, centered) -->
  <rect class="actual" x="350" y="162" width="779" height="36" fill="#3B82F6"/>
  <!-- Target marker -->
  <line class="target" x1="1205" y1="145" x2="1205" y2="215"/>
  <text class="mono" x="1205" y="238" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">90</text>

  <!-- Chart 2: 성장률 — ranges: poor 0-30, ok 30-60, good 60-100 | actual: 68 | target: 50 -->
  <text x="320" y="370" text-anchor="end" font-size="28" font-weight="900">성장률</text>
  <rect class="range" x="350" y="340" width="950" height="60" fill="#e5e5e5"/>
  <rect class="range" x="350" y="340" width="570" height="60" fill="#d4d4d4"/>
  <rect class="range" x="350" y="340" width="285" height="60" fill="#a3a3a3"/>
  <rect class="actual" x="350" y="352" width="646" height="36" fill="#a3e635"/>
  <line class="target" x1="825" y1="335" x2="825" y2="405"/>
  <text class="mono" x="825" y="428" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">50</text>

  <!-- Chart 3: NPS — ranges: poor 0-30, ok 30-70, good 70-100 | actual: 55 | target: 70 -->
  <text x="320" y="560" text-anchor="end" font-size="28" font-weight="900">NPS</text>
  <rect class="range" x="350" y="530" width="950" height="60" fill="#e5e5e5"/>
  <rect class="range" x="350" y="530" width="665" height="60" fill="#d4d4d4"/>
  <rect class="range" x="350" y="530" width="285" height="60" fill="#a3a3a3"/>
  <rect class="actual" x="350" y="542" width="523" height="36" fill="#FF6B35"/>
  <line class="target" x1="1015" y1="525" x2="1015" y2="595"/>
  <text class="mono" x="1015" y="618" text-anchor="middle" font-size="20" font-weight="700" fill="#737373">70</text>

  <!-- Legend (bottom) -->
  <rect x="350" y="720" width="20" height="20" fill="#a3a3a3"/>
  <text x="380" y="737" font-size="20" font-weight="700" fill="#737373">부진</text>
  <rect x="460" y="720" width="20" height="20" fill="#d4d4d4"/>
  <text x="490" y="737" font-size="20" font-weight="700" fill="#737373">보통</text>
  <rect x="570" y="720" width="20" height="20" fill="#e5e5e5"/>
  <text x="600" y="737" font-size="20" font-weight="700" fill="#737373">양호</text>
  <line x1="700" y1="720" x2="700" y2="740" stroke="#0a0a0a" stroke-width="4"/>
  <text x="715" y="737" font-size="20" font-weight="700" fill="#737373">목표</text>
</svg>
</body>
```

Notes: Back-to-front 레이어링으로 3단계 범위 표현 (가장 넓은 rect = lightest, 점점 좁고 진함). Actual 바는 전체 높이의 60% (36px/60px)로 범위 배경 위에 겹침. Target marker는 `<line>` (stroke-width: 4). x축 스케일: `x = 350 + (value/100) * 950`. 범례는 하단에 범위 색상 + 타겟 마커 설명.

---

## 29. Sparkline Grid (SVG + JS)

Best for: 다수 항목의 트렌드 요약, 소형 라인차트 그리드, 시계열 비교 대시보드

Approach: **SVG + inline `<script>`** — `<polyline>` + `<polygon>` (area fill) + 굵은 엔드포인트. 프로그래밍 방식으로 그리드 생성.

Max: **6 sparklines** (3x2 grid), 항목당 라벨 1단어 + 값 1개

```html
<body>
<svg id="spark" viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .spark-line { fill: none; stroke-width: 3; stroke-linecap: round; stroke-linejoin: round; }
      .spark-area { stroke: none; opacity: 0.15; }
      .spark-dot { stroke: #0a0a0a; stroke-width: 2.5; }
      .mono { font-family: 'JetBrains Mono', monospace; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>
</svg>
<script>
// === CONFIG ===
const items = [
  { name: 'React',   values: [60,65,70,68,75,80,82,85], color: '#3B82F6' },
  { name: 'Vue',     values: [40,42,45,50,52,55,58,62], color: '#a3e635' },
  { name: 'Svelte',  values: [15,20,28,35,40,45,50,55], color: '#FF6B35' },
  { name: 'Angular', values: [70,68,65,60,55,50,48,42], color: '#ff5c8d' },
  { name: 'Solid',   values: [5,8,12,18,22,28,32,35],   color: '#8B5CF6' },
  { name: 'Qwik',    values: [2,3,5,8,10,12,15,18],     color: '#fde047' },
];
const cols = 3, rows = 2;
const margin = { left: 80, top: 60, right: 80, bottom: 60 };
const gapX = 40, gapY = 40;
const cellW = (1440 - margin.left - margin.right - (cols - 1) * gapX) / cols;
const cellH = (810 - margin.top - margin.bottom - (rows - 1) * gapY) / rows;
const padX = 20, padTop = 60, padBot = 20;

const svg = document.getElementById('spark');
const ns = 'http://www.w3.org/2000/svg';

function el(tag, attrs) {
  const e = document.createElementNS(ns, tag);
  for (const [k, v] of Object.entries(attrs)) e.setAttribute(k, v);
  return e;
}

items.forEach((item, idx) => {
  const col = idx % cols, row = Math.floor(idx / cols);
  const cx = margin.left + col * (cellW + gapX);
  const cy = margin.top + row * (cellH + gapY);

  // Card background
  svg.appendChild(el('rect', { x: cx + 4, y: cy + 4, width: cellW, height: cellH, fill: '#0a0a0a', opacity: '0.06' }));
  svg.appendChild(el('rect', { x: cx, y: cy, width: cellW, height: cellH, fill: 'white', stroke: '#0a0a0a', 'stroke-width': '3' }));

  // Chart area within card
  const chartX = cx + padX, chartY = cy + padTop;
  const chartW = cellW - 2 * padX, chartH = cellH - padTop - padBot;

  const vals = item.values;
  const minV = Math.min(...vals) * 0.8, maxV = Math.max(...vals) * 1.1;
  const range = maxV - minV || 1;
  const n = vals.length;

  const points = vals.map((v, i) => {
    const x = chartX + (i / (n - 1)) * chartW;
    const y = chartY + chartH - ((v - minV) / range) * chartH;
    return [x, y];
  });

  const lineStr = points.map(p => p.join(',')).join(' ');

  // Area fill (polygon: line points + bottom corners)
  const areaStr = lineStr + ` ${chartX + chartW},${chartY + chartH} ${chartX},${chartY + chartH}`;
  svg.appendChild(el('polygon', { class: 'spark-area', points: areaStr, fill: item.color }));

  // Line
  svg.appendChild(el('polyline', { class: 'spark-line', points: lineStr, stroke: item.color }));

  // Endpoint dot (last point, larger)
  const last = points[points.length - 1];
  svg.appendChild(el('circle', { class: 'spark-dot', cx: last[0], cy: last[1], r: '8', fill: item.color }));

  // Label (top-left of card)
  const label = el('text', { x: cx + 20, y: cy + 36, 'font-size': '24', 'font-weight': '900' });
  label.textContent = item.name;
  svg.appendChild(label);

  // Current value (top-right of card)
  const valText = el('text', { x: cx + cellW - 20, y: cy + 36, 'text-anchor': 'end', 'font-size': '22', 'font-weight': '700', class: 'mono', fill: '#737373' });
  valText.textContent = vals[vals.length - 1];
  svg.appendChild(valText);
});
</script>
</body>
```

Notes: 3x2 그리드로 6개 sparkline 배치. 각 셀은 white 카드 + hard shadow. `<polygon>`으로 area fill (opacity 0.15) + `<polyline>`으로 트렌드 선. 마지막 데이터 포인트에 큰 dot (r=8)을 배치하여 모바일 25% 축소에서도 인식 가능. 값 범위는 각 sparkline 독립적으로 자동 계산 (`minV * 0.8 ~ maxV * 1.1`). `items` 배열의 `values`만 수정하면 데이터 변경 가능.

---

## 30. Waterfall (SVG 인라인)

Best for: 증감 분해, 누적 변화, 수익 분석, 요인별 기여도

Approach: **SVG inline** — floating `<rect>` (증가/감소) + grounded `<rect>` (시작/합계) + connector `<line>`. JS 불필요.

Max: **6~8 bars**, 라벨 1~2단어

```html
<body>
<svg viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .bar { stroke: #0a0a0a; stroke-width: 3; }
      .bar-sh { fill: #0a0a0a; opacity: 0.08; stroke: none; }
      .connector { stroke: #a3a3a3; stroke-width: 1.5; stroke-dasharray: 6 4; }
      .mono { font-family: 'JetBrains Mono', monospace; }
      .pos { fill: #a3e635; }
      .neg { fill: #ff5c8d; }
      .total { fill: #3B82F6; }
    </style>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="8" r="1" fill="rgba(10,10,10,0.06)"/>
    </pattern>
  </defs>
  <rect width="1440" height="810" fill="url(#dots)"/>

  <!-- Scale: value 0-180 → y: 650→120 (530px). y(v) = 650 - (v/180)*530 -->
  <!-- Bar width: 120px, spacing: 180px, starting x: 200 -->
  <!-- Data: Start=100, +Revenue=40, +Services=25, -COGS=30, -OpEx=20, Total=115 -->

  <!-- Bar 1: 시작 (grounded: 0→100) y(100)=356, h=294 -->
  <rect class="bar-sh" x="204" y="360" width="120" height="294"/>
  <rect class="bar total" x="200" y="356" width="120" height="294"/>
  <text class="mono" x="260" y="340" text-anchor="middle" font-size="22" font-weight="700">100</text>
  <text x="260" y="700" text-anchor="middle" font-size="22" font-weight="900">시작</text>

  <!-- Connector: y=356 from x=320 to x=380 -->
  <line class="connector" x1="320" y1="356" x2="380" y2="356"/>

  <!-- Bar 2: +매출 (floating: 100→140) y(140)=238, h=118 -->
  <rect class="bar-sh" x="384" y="242" width="120" height="118"/>
  <rect class="bar pos" x="380" y="238" width="120" height="118"/>
  <text class="mono" x="440" y="222" text-anchor="middle" font-size="22" font-weight="700" fill="#4d7c0f">+40</text>
  <text x="440" y="700" text-anchor="middle" font-size="22" font-weight="900">매출</text>

  <!-- Connector: y=238 from x=500 to x=560 -->
  <line class="connector" x1="500" y1="238" x2="560" y2="238"/>

  <!-- Bar 3: +서비스 (floating: 140→165) y(165)=164, h=74 -->
  <rect class="bar-sh" x="564" y="168" width="120" height="74"/>
  <rect class="bar pos" x="560" y="164" width="120" height="74"/>
  <text class="mono" x="620" y="148" text-anchor="middle" font-size="22" font-weight="700" fill="#4d7c0f">+25</text>
  <text x="620" y="700" text-anchor="middle" font-size="22" font-weight="900">서비스</text>

  <!-- Connector: y=164 from x=680 to x=740 -->
  <line class="connector" x1="680" y1="164" x2="740" y2="164"/>

  <!-- Bar 4: -원가 (floating: 165→135) top=y(165)=164, bottom=y(135)=252, h=88 -->
  <rect class="bar-sh" x="744" y="168" width="120" height="88"/>
  <rect class="bar neg" x="740" y="164" width="120" height="88"/>
  <text class="mono" x="800" y="272" text-anchor="middle" font-size="22" font-weight="700" fill="#d6336c">-30</text>
  <text x="800" y="700" text-anchor="middle" font-size="22" font-weight="900">원가</text>

  <!-- Connector: y=252 from x=860 to x=920 -->
  <line class="connector" x1="860" y1="252" x2="920" y2="252"/>

  <!-- Bar 5: -운영비 (floating: 135→115) top=y(135)=252, bottom=y(115)=311, h=59 -->
  <rect class="bar-sh" x="924" y="256" width="120" height="59"/>
  <rect class="bar neg" x="920" y="252" width="120" height="59"/>
  <text class="mono" x="980" y="331" text-anchor="middle" font-size="22" font-weight="700" fill="#d6336c">-20</text>
  <text x="980" y="700" text-anchor="middle" font-size="22" font-weight="900">운영비</text>

  <!-- Connector: y=311 from x=1040 to x=1100 -->
  <line class="connector" x1="1040" y1="311" x2="1100" y2="311"/>

  <!-- Bar 6: 합계 (grounded: 0→115) y(115)=311, h=339 -->
  <rect class="bar-sh" x="1104" y="315" width="120" height="339"/>
  <rect class="bar total" x="1100" y="311" width="120" height="339"/>
  <text class="mono" x="1160" y="295" text-anchor="middle" font-size="22" font-weight="700">115</text>
  <text x="1160" y="700" text-anchor="middle" font-size="22" font-weight="900">합계</text>

  <!-- Baseline -->
  <line x1="170" y1="650" x2="1250" y2="650" stroke="#e5e5e5" stroke-width="1.5"/>

  <!-- Legend -->
  <rect x="200" y="760" width="20" height="20" fill="#a3e635" stroke="#0a0a0a" stroke-width="2"/>
  <text x="230" y="777" font-size="20" font-weight="700" fill="#737373">증가</text>
  <rect x="310" y="760" width="20" height="20" fill="#ff5c8d" stroke="#0a0a0a" stroke-width="2"/>
  <text x="340" y="777" font-size="20" font-weight="700" fill="#737373">감소</text>
  <rect x="420" y="760" width="20" height="20" fill="#3B82F6" stroke="#0a0a0a" stroke-width="2"/>
  <text x="450" y="777" font-size="20" font-weight="700" fill="#737373">합계</text>
</svg>
</body>
```

Notes: Floating rect로 증감 표현 — 증가 바는 이전 누적값 위에 쌓이고, 감소 바는 이전 누적값에서 아래로 내려감. Grounded bar (시작/합계)는 baseline(y=650)에서 시작. Connector (dashed line)가 이전 바의 끝점과 다음 바의 시작점을 연결. 값 라벨: 증가는 바 위 (#4d7c0f), 감소는 바 아래 (#d6336c). `y(v) = 650 - (v/180) * 530` 스케일. JS 불필요.

---
