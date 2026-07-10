#!/usr/bin/env python3
"""Mechanical grader for interview-skill eval runs.

Usage: python3 mech_grade.py <run_dir> <prompt>

Checks the 6 mechanically-verifiable assertions against a run directory
(outputs/ + project/.claude/) and writes mechanical_grades.json into run_dir.
Qualitative assertions are left to the grader agent.
"""
import json
import re
import sys
from pathlib import Path

COMPLETION_RE = re.compile(
    r"clarification complete|proceed with current understanding|현재 이해로 진행|명확화 완료|이대로 진행",
    re.IGNORECASE,
)
ISO_RE = re.compile(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?([+-]\d{2}:?\d{2}|Z)$")


def check(run_dir: Path, prompt: str) -> list[dict]:
    outputs = run_dir / "outputs"
    results = []

    # --- gather rounds ---
    round_files = sorted(outputs.glob("questions_round_*.json"))
    rounds = []
    parse_errors = []
    for f in round_files:
        try:
            rounds.append((f.name, json.loads(f.read_text())))
        except json.JSONDecodeError as e:
            parse_errors.append(f"{f.name}: {e}")

    def questions_of(payload):
        qs = payload.get("questions", []) if isinstance(payload, dict) else []
        return qs if isinstance(qs, list) else []

    # A1: state file with required frontmatter. Since v3.0.0 the skill mandates
    # post-promise self-deletion in hookless runtimes, so a missing live file is
    # not by itself a failure: fall back to an audit copy under outputs/, then to
    # lifecycle evidence in run_log.md (creation + deletion documented).
    state_candidates = list((run_dir / "project" / ".claude").glob("clarify-*.local.md"))
    audit_note = ""
    if not state_candidates:
        audit = sorted(p for p in outputs.glob("*state*") if p.suffix == ".md")
        if audit:
            state_candidates = audit[:1]
            audit_note = f" (live file deleted post-promise per SKILL.md; validated from audit copy {audit[0].name})"
    if state_candidates:
        text = state_candidates[0].read_text()
        m = re.search(r"^---\n(.*?)\n---", text, re.DOTALL)
        fm = m.group(1) if m else ""
        fields = {}
        for line in fm.splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                fields[k.strip()] = v.strip().strip('"')
        missing = [k for k in ("iteration", "max_iterations", "original_requirement", "started_at") if k not in fields]
        iso_ok = ISO_RE.match(fields.get("started_at", "")) is not None
        passed = not missing and iso_ok
        ev = f"{state_candidates[0].name}: fields={list(fields)}; started_at ISO valid={iso_ok}{audit_note}"
        if missing:
            ev += f"; missing={missing}"
    else:
        final_p = outputs / "final_summary.md"
        log_p = outputs / "run_log.md"
        promise_ok = final_p.exists() and "<promise>CLARIFICATION COMPLETE</promise>" in final_p.read_text()
        log_text = log_p.read_text() if log_p.exists() else ""
        lifecycle = bool(
            re.search(r"clarify-interview\.local\.md|state file", log_text, re.IGNORECASE)
            and re.search(r"delet|삭제", log_text, re.IGNORECASE)
            and re.search(r"creat|생성|만들", log_text, re.IGNORECASE)
        )
        if promise_ok and lifecycle:
            passed = True
            ev = (
                "state file deleted post-promise per SKILL.md; creation/updates/deletion documented in run_log.md; "
                "frontmatter fields not mechanically verifiable — grader must confirm from round records"
            )
        else:
            passed, ev = False, "no clarify-*.local.md under project/.claude/ and no audit copy or lifecycle evidence"
    results.append({
        "text": "State file created in project/.claude/ with iteration, max_iterations, original_requirement, and ISO-8601 started_at frontmatter",
        "passed": passed, "evidence": ev,
    })

    # A2:每 round ≤4 questions, single batched payload per round
    if rounds:
        counts = {name: len(questions_of(p)) for name, p in rounds}
        bad = {n: c for n, c in counts.items() if c < 1 or c > 4}
        passed = not bad and not parse_errors
        ev = f"question counts per round: {counts}"
        if parse_errors:
            ev += f"; parse errors: {parse_errors}"
    else:
        passed, ev = False, "no questions_round_*.json files found"
    results.append({
        "text": "Every question round has at most 4 questions, batched as a single payload",
        "passed": passed, "evidence": ev,
    })

    # A3: every question has 2-4 concrete options
    if rounds:
        bad_qs = []
        total_qs = 0
        for name, p in rounds:
            for i, q in enumerate(questions_of(p)):
                total_qs += 1
                opts = q.get("options", []) if isinstance(q, dict) else []
                labels = [o.get("label", "") for o in opts if isinstance(o, dict)]
                if not (2 <= len(labels) <= 4) or any(not l.strip() for l in labels):
                    bad_qs.append(f"{name}#q{i+1}(opts={len(labels)})")
        passed = total_qs > 0 and not bad_qs
        ev = f"{total_qs} questions checked; violations: {bad_qs or 'none'}"
    else:
        passed, ev = False, "no question rounds to check"
    results.append({
        "text": "Every question offers 2-4 concrete hypothesis options (no open-ended-only questions)",
        "passed": passed, "evidence": ev,
    })

    # A4 (exit handling) is grader-judged from iteration-2 onward.

    # A5: final summary structure
    fs = outputs / "final_summary.md"
    if fs.exists():
        t = fs.read_text()
        has_before = re.search(r"###\s*Before", t) is not None
        has_after = re.search(r"###\s*After", t) is not None
        verbatim = prompt.strip() in t
        sections = all(re.search(rf"\*\*{s}\*\*", t) for s in ("Goal", "Scope", "Constraints", "Success Criteria"))
        table = re.search(r"\|\s*(Question|질문)\s*\|\s*(Decision|결정)\s*\|", t) is not None
        passed = has_before and has_after and verbatim and sections and table
        ev = (f"Before={has_before} After={has_after} verbatim-original={verbatim} "
              f"Goal/Scope/Constraints/SuccessCriteria={sections} decisions-table={table}")
    else:
        passed, ev = False, "outputs/final_summary.md missing"
    results.append({
        "text": "Final output contains Before (verbatim original) and After sections with Goal/Scope/Constraints/Success Criteria and a decisions table",
        "passed": passed, "evidence": ev,
    })

    # A6: promise tag
    if fs.exists():
        passed = "<promise>CLARIFICATION COMPLETE</promise>" in fs.read_text()
        ev = "promise tag found in final_summary.md" if passed else "promise tag absent from final_summary.md"
    else:
        passed, ev = False, "outputs/final_summary.md missing"
    results.append({
        "text": "Promise tag <promise>CLARIFICATION COMPLETE</promise> emitted at the end",
        "passed": passed, "evidence": ev,
    })

    return results


def main():
    run_dir = Path(sys.argv[1])
    prompt = sys.argv[2]
    results = check(run_dir, prompt)
    out = run_dir / "mechanical_grades.json"
    out.write_text(json.dumps({"expectations": results}, ensure_ascii=False, indent=2))
    passed = sum(1 for r in results if r["passed"])
    print(f"{run_dir}: {passed}/{len(results)} mechanical assertions passed")


if __name__ == "__main__":
    main()
