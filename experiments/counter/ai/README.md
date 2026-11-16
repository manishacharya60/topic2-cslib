# AI trial: increment-branch preservation

**November 15, 2026.** The obligation asks whether an increment step preserves
`x ≤ N ∧ (mode = off → x = 0)`. `Frozen.lean.in` fixes the statement and the
minimal state/invariant definitions from our parameterized counter. It imports
only `Init`. The allowed context/tactics are stated in `prompt.txt`; no existing
solution or upstream proof was supplied.

| Attempt | Exact prompt | Raw response | Extracted proof | Lean output |
| --- | --- | --- | --- | --- |
| 1 | [prompt.txt](prompt.txt) | [JSONL](attempt1.raw.jsonl) | [proof](attempt1.proof.txt) | [output](attempt1.lean-output.txt) |
| 2 | [retry prompt](attempt2.prompt.txt) | [JSONL](attempt2.raw.jsonl) | [proof](attempt2.proof.txt) | [output](attempt2.lean-output.txt) |

- **First strict attempt: failed.** Lean accepted the proof logically, but
  `-DwarningAsError=true` rejected three unused hypotheses (`hs`, `hm`, `hp`).
- **First retry: passed unchanged.** The model received the original context,
  its previous candidate, and the exact compiler feedback. Only one of the two
  permitted retries was used.
- **Invalid lemma references: none. Human proof repairs: none.** The successful
  proof is AI-authored. Its axiom dependencies are `propext` and `Quot.sound`.

Runner: **Codex CLI 0.160.0**. The model identifier was not exposed in its output.
[runner.txt](runner.txt) records the original invocations and timestamps. Each
attempt ran in a fresh empty directory, without project context or history, and
with tools, apps, and web disabled. The runner also supplied its standard system
context; this was not a bare API request containing only our prompt. The raw
response includes a code-mode-disabled diagnostic and no tool executions.

From the repository root, replay the successful candidate offline:

```sh
python3 scripts/replay-ai.py
```

To inspect the failed attempt's behavior: `python3 scripts/replay-ai.py --attempt 1`
(expected exit 1). Replay substitutes the saved proof into the frozen template
and invokes Lean; it does not call the model or edit either candidate. Both
candidates and their original outputs are preserved outside the normal build.
The core safety proof does not depend on this experiment.

This is one small proof trial, not a benchmark of general AI reliability.
Brantley's review is still pending. Setup failures before the trial (Claude not
logged in, sandboxed Codex startup, and a corrected Lean CLI option spelling)
were infrastructure issues, not model proof attempts.
