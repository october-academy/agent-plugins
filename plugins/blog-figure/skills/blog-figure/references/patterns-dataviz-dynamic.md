# Figure Patterns — Data Visualization (Dynamic)

JS/D3/Canvas patterns: Treemap, Radar, Heatmap, Sparkline Grid.

All use `assets/figure.css`. **핵심 원칙**:
- 텍스트는 최소화하되 **직접 라벨**을 우선한다.
- small multiple 비교는 **shared scale**을 기본값으로 둔다.
- 범례는 꼭 필요할 때만 쓰고, 가능하면 **차트 안에서 설명**한다.
- Radar는 **동일 스케일 축 5개 이하 / 시리즈 2개 이하**일 때만 사용한다.
- 모바일 25% 축소에서도 구조가 남도록, 색보다 **정렬·여백·두께**로 위계를 만든다.

## TOC

- 24. Treemap
- 25. Radar
- 27. Heatmap
- 29. Sparkline Grid

---

## 24. Treemap (D3)

Best for: 면적 비례 구성비, 카테고리별 비중, 2D 면적으로 비율 비교

Approach: **D3 v7 CDN** — `d3.treemap().tile(d3.treemapSquarify)`. flat data `{children: [{name, value, color}]}`.

Max: **6~8 leaf nodes**, 라벨 1단어. 라벨이 안 들어갈 만큼 작은 항목은 **"기타"로 병합** — 모든 셀이 라벨을 가져야 한다. threshold 숨김은 최후 방어선이지, 무라벨 색면을 정당화하지 않는다.

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
                  fill: #0a0a0a; dominant-baseline: hanging; }
    .cell-value { font-family: 'JetBrains Mono', monospace; font-weight: 700; font-size: 22px;
                  fill: rgba(10,10,10,0.72); dominant-baseline: hanging; }
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
// 작은 잔여 항목(Solid 5 + Qwik 2)은 '기타'로 병합 — 라벨 없는 정체불명 색면을 남기지 않는다
const data = {
  children: [
    { name: 'React', value: 40, color: '#3B82F6' },
    { name: 'Vue',   value: 25, color: '#a3e635' },
    { name: 'Svelte',value: 18, color: '#FF6B35' },
    { name: 'Angular',value:10, color: '#ff5c8d' },
    { name: '기타',  value: 7,  color: '#a3a3a3' },
  ]
};

const svg = d3.select('svg');
const margin = { top: 80, right: 80, bottom: 80, left: 80 };
const W = 1440 - margin.left - margin.right;
const H = 810 - margin.top - margin.bottom;

const g = svg.append('g').attr('transform', `translate(${margin.left},${margin.top})`);

data.children.sort((a, b) => d3.descending(a.value, b.value));
const root = d3.hierarchy(data).sum(d => d.value);
d3.treemap().size([W, H]).tile(d3.treemapSquarify).paddingInner(8).paddingOuter(0)(root);

// Draw cell shadows (hard shadow)
g.selectAll('.shadow').data(root.leaves()).join('rect')
  .attr('x', d => d.x0 + 4).attr('y', d => d.y0 + 4)
  .attr('width', d => d.x1 - d.x0).attr('height', d => d.y1 - d.y0)
  .attr('fill', '#0a0a0a').attr('opacity', 0.08);

const cells = g.selectAll('.cell-group').data(root.leaves()).join('g')
  .attr('class', 'cell-group')
  .attr('transform', d => `translate(${d.x0},${d.y0})`);

// Draw cells
cells.append('rect')
  .attr('class', 'cell')
  .attr('width', d => d.x1 - d.x0)
  .attr('height', d => d.y1 - d.y0)
  .attr('fill', d => d.data.color);

// Draw labels in top-left instead of centered
cells.append('text')
  .attr('class', 'cell-label')
  .attr('x', 18)
  .attr('y', 18)
  .text(d => ((d.x1 - d.x0) >= 130 && (d.y1 - d.y0) >= 76) ? d.data.name : '');

cells.append('text')
  .attr('class', 'cell-value')
  .attr('x', 18)
  .attr('y', 56)
  .text(d => ((d.x1 - d.x0) >= 150 && (d.y1 - d.y0) >= 110) ? d.data.value + '%' : '');
</script>
</body>
```

Notes: D3 treemap은 `d3.treemapSquarify` 타일링으로 정사각형에 가까운 셀을 생성. `data.children` 배열만 수정하면 내용 변경 가능. Hard shadow는 offset된 검정 rect (opacity 0.08). **중앙 정렬보다 좌상단 직접 라벨**이 면적 비교에 더 자연스럽다. **라벨이 숨겨질 크기의 항목은 데이터 단계에서 "기타"(#a3a3a3 gray)로 병합**하라 — threshold 숨김 규칙에 기대면 독자가 해석할 수 없는 무라벨 색면이 남는다. threshold는 병합 실수를 잡는 최후 방어선일 뿐이다. lime #a3e635은 여기서 채움면 + `--dark` 라벨(13:1)이라 허용된다.

---

## 25. Radar (SVG + JS)

Best for: 다축 프로파일 비교, 역량 평가, 3~5개 축 지표 비교

Approach: **SVG + inline `<script>`** — cos/sin 좌표 계산. CDN 불필요. 12시 시작 (`-PI/2` offset).

Max: **5축**, 1~2 data series, 축 라벨 1단어

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=1440">
  <link rel="stylesheet" href="file://{SKILL_DIR}/assets/figure.css">
</head>
<body>
<svg id="radar" viewBox="0 0 1440 810" xmlns="http://www.w3.org/2000/svg"
     style="width:1440px;height:810px;background:#f5f5f5">
  <defs>
    <style>
      text { font-family: 'Noto Sans KR', sans-serif; fill: #0a0a0a; }
      .guide { fill: none; stroke: #a3a3a3; stroke-width: 1.5; }
      .axis { stroke: #a3a3a3; stroke-width: 1.5; }
      .data-poly { stroke-width: 3; }
      .data-dot { stroke: #0a0a0a; stroke-width: 2.5; }
      .benchmark { fill: none; stroke-width: 3; stroke-dasharray: 10 8; }
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
const focus = { name: 'React', values: [0.7, 0.8, 0.95, 0.85, 0.9], color: '#3B82F6' };
const benchmark = { name: 'Benchmark', values: [0.65, 0.72, 0.75, 0.7, 0.78], color: '#737373' };

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

  const ringLabel = document.createElementNS(ns, 'text');
  ringLabel.setAttribute('x', cx + 14);
  ringLabel.setAttribute('y', cy - pct * R + 7);
  ringLabel.setAttribute('font-size', '22');
  ringLabel.setAttribute('font-weight', '700');
  ringLabel.setAttribute('fill', '#737373');
  ringLabel.textContent = Math.round(pct * 100);
  svg.appendChild(ringLabel);
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

// Focus polygon (filled)
const focusPoly = document.createElementNS(ns, 'polygon');
focusPoly.setAttribute('class', 'data-poly');
focusPoly.setAttribute('points', polyPoints(focus.values, R));
focusPoly.setAttribute('fill', 'rgba(59,130,246,0.2)');
focusPoly.setAttribute('stroke', focus.color);
svg.appendChild(focusPoly);

// Benchmark polygon (outline only)
const benchPoly = document.createElementNS(ns, 'polygon');
benchPoly.setAttribute('class', 'benchmark');
benchPoly.setAttribute('points', polyPoints(benchmark.values, R));
benchPoly.setAttribute('stroke', benchmark.color);
svg.appendChild(benchPoly);

focus.values.forEach((v, i) => {
  const [x, y] = pt(i, v * R);
  const dot = document.createElementNS(ns, 'circle');
  dot.setAttribute('class', 'data-dot');
  dot.setAttribute('cx', x); dot.setAttribute('cy', y);
  dot.setAttribute('r', '8'); dot.setAttribute('fill', focus.color);
  svg.appendChild(dot);
});

// Legend (bottom center, grouped directly under the chart)
const legendY = 748;
[
  { name: focus.name, color: focus.color, dashed: false, x: 565 },
  { name: benchmark.name, color: benchmark.color, dashed: true, x: 721 },
].forEach(s => {
  const line = document.createElementNS(ns, 'line');
  line.setAttribute('x1', s.x); line.setAttribute('y1', legendY);
  line.setAttribute('x2', s.x + 30); line.setAttribute('y2', legendY);
  line.setAttribute('stroke', s.color);
  line.setAttribute('stroke-width', '4');
  if (s.dashed) line.setAttribute('stroke-dasharray', '10 8');
  svg.appendChild(line);
  const txt = document.createElementNS(ns, 'text');
  txt.setAttribute('x', s.x + 42); txt.setAttribute('y', legendY + 7);
  txt.setAttribute('font-size', '22'); txt.setAttribute('font-weight', '700');
  txt.textContent = s.name;
  svg.appendChild(txt);
});
</script>
</body>
</html>
```

Notes: `pt(i, r)` 함수로 극좌표→직교좌표 변환. `-PI/2` offset으로 12시 방향 시작. Radar는 **같은 스케일의 축**만 섞고, **focus 1개 + benchmark 1개** 정도로 제한하는 편이 읽기 쉽다. 보조 시리즈는 **dashed outline**만 쓰고, 핵심 시리즈만 fill을 주면 겹침이 줄어든다.

---

## 27. Heatmap (Canvas/JS)

Best for: 2D 색상 강도, 빈도/밀도 맵, 시간별·카테고리별 분포 패턴

Approach: **Canvas + JS** (Network 패턴과 동일 구조). retina 2x (2880×1620). **5단계 sequential palette** + hotspot 직접 라벨.

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

  const palette = ['#E5E7EB', '#BFDBFE', '#93C5FD', '#60A5FA', '#2563EB'];

  function cellColor(v) {
    if (v >= 0.85) return palette[4];
    if (v >= 0.65) return palette[3];
    if (v >= 0.45) return palette[2];
    if (v >= 0.2) return palette[1];
    return palette[0];
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

      if (v >= 0.85) {
        ctx.font = `900 ${20 * S}px 'JetBrains Mono', monospace`;
        ctx.fillStyle = '#ffffff';
        ctx.textAlign = 'center';
        ctx.fillText(Math.round(v * 100), x + cellW / 2, y + cellH / 2 + 8 * S);
      }
    });
  });

  // Legend: 5-step swatches
  const lx = ox, ly = oy + rows.length * (cellH + gap) + 40 * S;
  const sw = 56 * S, sh = 24 * S, sg = 6 * S;
  palette.forEach((color, index) => {
    const x = lx + index * (sw + sg);
    ctx.fillStyle = color;
    ctx.fillRect(x, ly, sw, sh);
    ctx.strokeRect(x, ly, sw, sh);
  });

  ctx.font = `700 ${20 * S}px 'Noto Sans KR', sans-serif`;
  ctx.fillStyle = '#737373';
  ctx.textAlign = 'left';
  ctx.fillText('낮음', lx, ly + sh + 30 * S);
  ctx.textAlign = 'right';
  ctx.fillText('높음', lx + 5 * (sw + sg) - sg, ly + sh + 30 * S);

  // Hotspot legend: 그리드 셀과 같은 "사각형" 미니 셀 — 심볼과 실제 셀의 형태를 일치시킨다
  ctx.fillStyle = '#2563EB';
  ctx.fillRect(lx + 326 * S, ly - 3 * S, 36 * S, 30 * S);
  ctx.strokeRect(lx + 326 * S, ly - 3 * S, 36 * S, 30 * S);
  ctx.fillStyle = '#ffffff';
  ctx.font = `900 ${20 * S}px 'JetBrains Mono', monospace`;
  ctx.textAlign = 'center';
  ctx.fillText('95', lx + 344 * S, ly + 19 * S);
  ctx.fillStyle = '#737373';
  ctx.font = `700 ${20 * S}px 'Noto Sans KR', sans-serif`;
  ctx.textAlign = 'left';
  ctx.fillText('핫스팟', lx + 376 * S, ly + 19 * S);
});
</script>
</body>
```

Notes: `document.fonts.ready.then()` 래핑 필수 (Canvas에서 Google Fonts 렌더링). retina 2x (canvas 2880×1620 → CSS 1440×810). Heatmap은 연속 그라디언트도 가능하지만, **업무용 비교 패턴은 5단계 discrete palette + hotspot 직접 라벨**이 훨씬 빨리 읽힌다. 강한 셀만 숫자를 찍고 나머지는 색으로만 읽게 두는 편이 가장 안정적이다. **범례의 hotspot 심볼은 그리드 셀과 같은 사각형** — 그리드가 사각 셀인데 범례만 원형이면 다른 마크로 오독된다.

---

## 29. Sparkline Grid (SVG + JS)

Best for: 다수 항목의 트렌드 요약, 소형 라인차트 그리드, 시계열 비교 대시보드

Approach: **SVG + inline `<script>`** — `<polyline>` + `<polygon>` (area fill) + 굵은 엔드포인트. 프로그래밍 방식으로 그리드 생성.

Max: **6 sparklines** (3x2 grid), 항목당 라벨 1단어 + 값 1개

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=1440">
  <link rel="stylesheet" href="file://{SKILL_DIR}/assets/figure.css">
</head>
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
// 선 색은 선 팔레트만 (blue/orange/pink/purple/dark green + dark).
// lime #a3e635·yellow #fde047은 흰 카드 위 1.3~1.5:1이라 선(stroke) 금지 — lime 슬롯은 dark green으로.
const items = [
  { name: 'React',   values: [60,65,70,68,75,80,82,85], color: '#3B82F6' },
  { name: 'Vue',     values: [40,42,45,50,52,55,58,62], color: '#4d7c0f' },
  { name: 'Svelte',  values: [15,20,28,35,40,45,50,55], color: '#FF6B35' },
  { name: 'Angular', values: [70,68,65,60,55,50,48,42], color: '#ff5c8d' },
  { name: 'Solid',   values: [5,8,12,18,22,28,32,35],   color: '#8B5CF6' },
  { name: 'Qwik',    values: [2,3,5,8,10,12,15,18],     color: '#0a0a0a' },
];
const cols = 3, rows = 2;
const margin = { left: 80, top: 60, right: 80, bottom: 60 };
const gapX = 40, gapY = 40;
const cellW = (1440 - margin.left - margin.right - (cols - 1) * gapX) / cols;
const cellH = (810 - margin.top - margin.bottom - (rows - 1) * gapY) / rows;
const padX = 20, padTop = 60, padBot = 20;
const allValues = items.flatMap(item => item.values);
const globalMin = Math.min(...allValues) * 0.9;
const globalMax = Math.max(...allValues) * 1.05;
const globalRange = globalMax - globalMin || 1;

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
  const n = vals.length;

  const points = vals.map((v, i) => {
    const x = chartX + (i / (n - 1)) * chartW;
    const y = chartY + chartH - ((v - globalMin) / globalRange) * chartH;
    return [x, y];
  });

  const lineStr = points.map(p => p.join(',')).join(' ');

  // Shared baseline for cross-card comparison
  svg.appendChild(el('line', {
    x1: chartX,
    y1: chartY + chartH,
    x2: chartX + chartW,
    y2: chartY + chartH,
    stroke: '#d4d4d4',
    'stroke-width': '2'
  }));

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

  const delta = vals[vals.length - 1] - vals[0];
  const deltaText = el('text', {
    x: cx + cellW - 20,
    y: cy + cellH - 18,
    'text-anchor': 'end',
    'font-size': '20',
    'font-weight': '700',
    class: 'mono',
    fill: delta >= 0 ? '#4d7c0f' : '#d6336c'
  });
  deltaText.textContent = `${delta >= 0 ? '+' : ''}${delta}`;
  svg.appendChild(deltaText);
});
</script>
</body>
</html>
```

Notes: 3x2 그리드로 6개 sparkline 배치. 각 셀은 white 카드 + hard shadow. `<polygon>`으로 area fill (opacity 0.15) + `<polyline>`으로 트렌드 선. 마지막 데이터 포인트에 큰 dot (r=8)을 배치하여 모바일 25% 축소에서도 인식 가능. **선 색은 선 팔레트만** — lime/yellow는 흰 카드 위에서 선이 사라진다(1.3~1.5:1). 6번째 시리즈가 필요하면 `--dark`(#0a0a0a)를 쓴다. **비교 목적의 small multiple은 shared scale**을 써야 카드 간 높이 차이가 의미를 가진다. 변화량은 작은 delta 라벨로 직접 붙이고, 축은 카드 안 baseline 정도로만 남긴다.

---
