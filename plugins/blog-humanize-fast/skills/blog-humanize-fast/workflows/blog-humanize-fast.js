export const meta = {
  name: 'blog-humanize-fast',
  description: '병렬 strict 윤문 — 청크 병렬 탐지+윤문 융합 → 청크 fidelity(재시도 1회 후 롤백) → 전역 naturalness·잔존 탐지 병렬 → 표적 수정 1라운드',
  whenToUse: '블로그 최종 윤문 엔진. args: { inputPath(권장 — frontmatter 제외 본문 파일 경로) 또는 text(짧은 본문만), genre(기본 블로그), intensity(기본 보수), quickRulesPath(권장 — 플러그인 번들 quick-rules.md) }.',
  phases: [
    { title: 'Rewrite', detail: '청크 병렬 탐지+윤문 융합 + 청크별 fidelity' },
    { title: 'GlobalReview', detail: '전역 naturalness + 잔존 S1/S2 탐지 (병렬)' },
    { title: 'TargetedFix', detail: '지적 span만 표적 수정 1라운드' },
  ],
}

let A = args
if (typeof A === 'string') {
  try { A = JSON.parse(A) } catch (e) { A = null }
}
if (A && typeof A === 'object' && A.args && !A.inputPath && !A.text) A = A.args
if (!A || typeof A !== 'object') A = {}
log(`args 진단: typeof=${typeof args}, keys=[${Object.keys(A).join(',')}], raw=${JSON.stringify(args).slice(0, 120)}`)

if (!A.quickRulesPath || typeof A.quickRulesPath !== 'string') {
  throw new Error('args.quickRulesPath 필요 — 플러그인 스킬은 {SKILL_DIR}/references/quick-rules.md를 전달해야 한다')
}
const QUICK_RULES = A.quickRulesPath

let text = typeof A.text === 'string' && A.text.length ? A.text : null
if (!text && A.inputPath) {
  const loaded = await agent(
    `${A.inputPath} 파일을 Read 도구로 읽고, 내용 전체를 한 글자도 바꾸지 말고 text 필드에 그대로 담아 반환하라. 요약·정리 금지.`,
    { label: 'read-input', model: 'haiku', schema: { type: 'object', required: ['text'], properties: { text: { type: 'string' } } } },
  )
  text = loaded ? loaded.text : null
}
if (!text || typeof text !== 'string') throw new Error(`args.inputPath(파일 경로) 또는 args.text 필요 — 도착한 args: ${JSON.stringify(args).slice(0, 200)}`)
const genre = A.genre || '블로그'
const intensity = A.intensity || '보수'

function chunkText(t) {
  const lines = t.split('\n')
  const blocks = []
  let cur = []
  let inFence = false
  for (const line of lines) {
    if (/^\s*```/.test(line)) {
      if (!inFence) {
        if (cur.length) { blocks.push({ text: cur.join('\n'), prot: false }); cur = [] }
        cur.push(line); inFence = true
      } else {
        cur.push(line); blocks.push({ text: cur.join('\n'), prot: true }); cur = []; inFence = false
      }
      continue
    }
    cur.push(line)
  }
  if (cur.length) blocks.push({ text: cur.join('\n'), prot: inFence })

  const chunks = []
  for (const b of blocks) {
    if (b.prot) { chunks.push({ text: b.text, prot: true }); continue }
    const paras = b.text.split(/\n{2,}/).filter((p) => p.trim().length)
    let buf = ''
    for (const p of paras) {
      if (buf && (buf.length + p.length + 2) > 1200) { chunks.push({ text: buf, prot: false }); buf = p }
      else buf = buf ? buf + '\n\n' + p : p
    }
    if (buf.trim()) chunks.push({ text: buf, prot: false })
  }
  return chunks.map((c, i) => ({ ...c, id: i }))
}

const chunks = chunkText(text)
log(`청크 ${chunks.length}개 (보호 ${chunks.filter((c) => c.prot).length}개 포함), 입력 ${text.length}자`)

const DO_NOT = `절대 건드리지 않는다(Do-NOT): 수치·날짜·금액, 고유명사·제품명, 직접 인용(따옴표 안), 코드·인라인 코드, URL·링크 텍스트의 목적지, 마크다운 구조(헤더 레벨·리스트·표), JSX 컴포넌트 태그와 속성(<Callout> 등 — 태그 안 한국어 산문만 윤문 가능), 영어 기술 용어 표기. 격식(register)과 장르(${genre})를 보존한다. 내용·주장·논리 순서는 한 글자 수준에서 불변 — 문체·리듬·표현만 바꾼다.`

const REWRITE_SCHEMA = {
  type: 'object', required: ['rewritten', 'changes'],
  properties: {
    rewritten: { type: 'string' },
    changes: { type: 'array', items: { type: 'object', required: ['before', 'after', 'category'], properties: { before: { type: 'string' }, after: { type: 'string' }, category: { type: 'string' }, severity: { type: 'string' } } } },
  },
}
const FIDELITY_SCHEMA = {
  type: 'object', required: ['pass', 'violations'],
  properties: { pass: { type: 'boolean' }, violations: { type: 'array', items: { type: 'string' } } },
}

function rewritePrompt(chunkText) {
  return `${QUICK_RULES} 파일을 Read로 읽고(다른 파일은 읽지 마라), 아래 한국어 블로그 본문 조각에서 AI 티 패턴(S1·S2 중심)을 탐지해 윤문하라. 강도: ${intensity} — 확신 없는 구간은 그대로 둔다. ${DO_NOT}

윤문 대상 조각(마크다운, 문서의 일부이므로 앞뒤 문맥 가정 금지·조각 경계 밖 언급 금지):
<<<CHUNK
${chunkText}
CHUNK>>>

rewritten에는 조각 전체(무변경 부분 포함)를 넣고, changes에는 실제 바꾼 지점만 before/after/category(taxonomy 카테고리)/severity로 나열하라. 바꿀 것이 없으면 rewritten=원문 그대로, changes=[].`
}

function fidelityPrompt(orig, rewritten) {
  return `한국어 윤문 전후의 의미 동등성을 감사하라. 사실·주장·수치·고유명사·인용·논리 순서·마크다운/JSX 구조가 하나라도 훼손됐으면 pass=false로 하고 violations에 훼손 지점을 구체적으로 나열하라. 문체·어순·리듬 변화는 위반이 아니다.

원문:
<<<A
${orig}
A>>>

윤문본:
<<<B
${rewritten}
B>>>`
}

phase('Rewrite')
const results = await pipeline(
  chunks,
  (c) => {
    if (c.prot) return { rewritten: c.text, changes: [], skipped: true }
    return agent(rewritePrompt(c.text), { label: `rewrite:${c.id}`, phase: 'Rewrite', model: 'sonnet', effort: 'high', schema: REWRITE_SCHEMA })
  },
  async (r, c) => {
    if (!r) return { id: c.id, final: c.text, status: 'agent-null-rollback' }
    if (r.skipped) return { id: c.id, final: c.text, status: 'protected' }
    if (!r.changes.length) return { id: c.id, final: c.text, status: 'unchanged' }
    const v = await agent(fidelityPrompt(c.text, r.rewritten), { label: `fidelity:${c.id}`, phase: 'Rewrite', model: 'sonnet', schema: FIDELITY_SCHEMA })
    if (v && v.pass) return { id: c.id, final: r.rewritten, status: 'pass', changes: r.changes.length }
    const r2 = await agent(
      rewritePrompt(c.text) + `\n\n1차 윤문이 의미 훼손으로 반려됐다. 반려 사유를 피해서 더 보수적으로 다시 윤문하라: ${JSON.stringify(v ? v.violations : ['agent error'])}`,
      { label: `rewrite2:${c.id}`, phase: 'Rewrite', model: 'opus', effort: 'high', schema: REWRITE_SCHEMA },
    )
    if (r2 && r2.changes.length) {
      const v2 = await agent(fidelityPrompt(c.text, r2.rewritten), { label: `fidelity2:${c.id}`, phase: 'Rewrite', model: 'sonnet', schema: FIDELITY_SCHEMA })
      if (v2 && v2.pass) return { id: c.id, final: r2.rewritten, status: 'retry-pass', changes: r2.changes.length }
    }
    return { id: c.id, final: c.text, status: 'rollback', violations: v ? v.violations : [] }
  },
)

const assembled = results.map((r) => r.final).join('\n\n')

phase('GlobalReview')
const NAT_SCHEMA = {
  type: 'object', required: ['verdict', 'findings'],
  properties: {
    verdict: { type: 'string', enum: ['accept', 'fix'] },
    findings: { type: 'array', items: { type: 'object', required: ['quote', 'issue'], properties: { quote: { type: 'string' }, issue: { type: 'string' }, suggestion: { type: 'string' } } } },
  },
}
const RESID_SCHEMA = {
  type: 'object', required: ['items'],
  properties: { items: { type: 'array', items: { type: 'object', required: ['quote', 'pattern', 'severity'], properties: { quote: { type: 'string' }, pattern: { type: 'string' }, severity: { type: 'string', enum: ['S1', 'S2', 'S3'] } } } } },
}
const [nat, resid] = await parallel([
  () => agent(
    `${QUICK_RULES} 파일을 Read로 읽은 뒤, 아래 윤문 완료본을 청크 경계를 넘는 전역 속성만 심사하라: 문장 리듬 균일성, 문두 표현 반복, 접속사 분포, 과윤문(부자연스러운 문학체·원문보다 어색해진 곳), 격식 일관성. 지역 패턴 재탐지는 하지 마라(별도 축이 한다). 고칠 곳이 있으면 verdict=fix로 findings(quote는 본문에서 정확히 복사)를 나열하라.\n\n<<<DOC\n${assembled}\nDOC>>>`,
    { label: 'global-naturalness', phase: 'GlobalReview', model: 'opus', effort: 'high', schema: NAT_SCHEMA },
  ),
  () => agent(
    `${QUICK_RULES} 파일을 Read로 읽은 뒤, 아래 본문에서 잔존 AI 티 패턴을 스캔해 S1/S2만 items로 보고하라(S3는 제외). quote는 본문에서 정확히 복사.\n\n<<<DOC\n${assembled}\nDOC>>>`,
    { label: 'residual-detect', phase: 'GlobalReview', model: 'sonnet', effort: 'high', schema: RESID_SCHEMA },
  ),
])

phase('TargetedFix')
const findings = [
  ...((nat && nat.verdict === 'fix') ? nat.findings : []),
  ...((resid ? resid.items : []).filter((i) => i.severity !== 'S3').map((i) => ({ quote: i.quote, issue: i.pattern, suggestion: '' }))),
]
let finalText = assembled
let fixedCount = 0
if (findings.length) {
  const capped = findings.slice(0, 20)
  if (findings.length > 20) log(`표적 수정 상한 20건 — ${findings.length - 20}건은 리포트로만 남김`)
  const fx = await agent(
    `아래 본문에서 나열된 지적 span만 수정하라 — 다른 부분은 한 글자도 바꾸지 마라. ${DO_NOT}\n\n지적 목록:\n${JSON.stringify(capped, null, 2)}\n\n<<<DOC\n${finalText}\nDOC>>>\n\nfixed에 본문 전체(수정 반영본)를 넣어라.`,
    { label: 'targeted-fix', phase: 'TargetedFix', model: 'opus', effort: 'high', schema: { type: 'object', required: ['fixed'], properties: { fixed: { type: 'string' } } } },
  )
  if (fx && fx.fixed && fx.fixed.length > finalText.length * 0.8) { finalText = fx.fixed; fixedCount = capped.length }
  else log('표적 수정 산출물 이상(길이 급감 또는 실패) — 수정 전 본문 유지')
} else {
  log('전역 심사·잔존 탐지 지적 0건 — 표적 수정 생략')
}

return {
  finalText,
  inputChars: text.length,
  outputChars: finalText.length,
  chunkStats: results.map(({ id, status, changes }) => ({ id, status, changes: changes || 0 })),
  naturalnessVerdict: nat ? nat.verdict : 'agent-null',
  residualS1S2: resid ? resid.items.filter((i) => i.severity !== 'S3').length : -1,
  findingsCount: findings.length,
  fixedCount,
}
