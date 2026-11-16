# Topic 2 — Lean 4 and CSLib verification

**Manish Acharya · Brantley Payne · Avash Aryal**

Tuesday milestone: **November 17, 2026**. Start with the
[original counter](models/leansmv/counter.smv), its
[parameterized safety proof](Topic2/Counter/Safety.lean), and the
[recorded AI trial](experiments/counter/ai/README.md).
GCD and two-process mutual exclusion provide two additional checked systems.

## Run

From the repository root after setup:

```sh
python3 scripts/demo.py                 # finite counter check, then all Lean proofs
python3 scripts/replay-ai.py            # check the saved counter AI proof, offline
python3 scripts/demo.py --system all    # finite checks for all three, then Lean
```

Use `--system gcd` or `--system mutex` for just one additional finite check.
Every demo option runs `lake build`, which checks all project modules and prints
the main theorems' axiom dependencies. No command above calls an AI model live.
The finite checks have no execution-depth cutoff; no BMC result is claimed.

## Observed results

All three finite checks and the Lean build passed with **nuXmv 2.2.0,
Lean 4.33.0, and CSLib v4.33.0**.

| System | Finite check on the unchanged SMV source | Lean result |
| --- | --- | --- |
| Counter | `x <= count_max` at threshold 10: **true** | Every reachable count is at most N, for every natural N, including zero. |
| GCD | `pc = l5 -> a = b`, initial operands in 0..10: **true** | For arbitrary initial A, B, gcd is preserved, operands never exceed their initial values, and reaching l5 yields `a = b = gcd(A,B)`. |
| Mutex | `!(process1 = critical & process2 = critical)`: **true** | The original two processes cannot both be critical in a reachable state. |

Exact finite commands, versions, and outputs: [counter](experiments/counter/baseline.txt),
[GCD](experiments/gcd/baseline.txt), [mutex](experiments/mutex/baseline.txt).
GCD's statement is **partial correctness**, not guaranteed termination: the
source permits a zero operand and can loop forever. Mutex is **two-process**;
we do not claim an arbitrary-process theorem or starvation freedom.

The headline Lean proofs have no `sorryAx` or project-specific axioms. GCD and
counter use standard `propext` and `Quot.sound`; mutex uses `propext` only.
The AI trial is **counter-only**: attempt 1 was logically accepted but rejected
by the strict unused-hypothesis warning policy; attempt 2 passed unchanged after
exact feedback. No human proof repairs. Runner: Codex CLI 0.160.0; model ID was
not exposed. New GCD/mutex development was AI-assisted, but is not a separate
controlled AI trial.

## Repository map

| Path | Purpose |
| --- | --- |
| `Topic2.lean` | Root imports and axiom reports |
| `Topic2/TransitionSystem.lean` | Professor's shared framework, unchanged |
| `Topic2/Counter/` | Parameterized counter, proof, CSLib connection, upstream comparison |
| `Topic2/GCD/Model.lean`, `Safety.lean` | Original control flow, arbitrary initial operands, partial correctness |
| `Topic2/Mutex/Model.lean`, `Safety.lean` | Two-process synchronous protocol and exclusion proof |
| `models/leansmv/`, `models/nusmv/` | Original inputs grouped by source |
| `models/README.md` | Local inventory: 14 grouped systems, three now checked, 11 future candidates |
| `experiments/counter/` | Baseline, translator output, and AI trial |
| `experiments/gcd/`, `experiments/mutex/` | Baseline and short explanation of each added experiment |
| `scripts/` | The existing demo and AI replay commands; no new scripts |
| `docs/demo.md` | Presentation runbook |

The final benchmark still needs at least ten distinct systems with completed
experiments. Collected inputs alone do not count as completed verification.
Queue and other models remain future work. MCMT inputs are not yet collected.

## Setup once

Install Python 3, Git, and elan for the pinned Lean/Lake toolchain. Keep
`lean-toolchain` and `lake-manifest.json`; do not update the dependency pins.
CSLib is pinned to `3951377e5a3f5772737f11cd62bc5bb6a72f95d1`.

Obtain [LeanSMV](https://github.com/ttj/leansmv) at commit
`2349edc2eddb9a4f479f98c23f3d257a72945472`. Set `LEANSMV` to that checkout
(our development copy is `../leansmv`), then copy the required upstream files:

```sh
LEANSMV=../leansmv
git -C "$LEANSMV" rev-parse HEAD
mkdir -p models/leansmv
cp "$LEANSMV"/models/*.smv models/leansmv/
cp "$LEANSMV/VerifDemo/TransitionSystem.lean" Topic2/TransitionSystem.lean
sed 's/import VerifDemo.TransitionSystem/import Topic2.TransitionSystem/' \
  "$LEANSMV/VerifDemo/NuXMV/Counter.lean" > Topic2/Counter/Reference.lean
lake exe cache get
lake build
```

Install [nuXmv](https://nuxmv.fbk.eu/download.html) or
[NuSMV](https://nusmv.fbk.eu/downloads.html) manually, including its platform
dependencies. The demo finds `NuSMV`/`nuXmv` on PATH or the existing local
`.tools/nuXmv-2.2.0-macos64/usr/local/bin/nuXmv`. To choose another executable:

```sh
SMV_CHECKER=/absolute/path/to/nuXmv python3 scripts/demo.py --system all
```

Ordinary demo runs are offline and use the local copies; they do not depend on
the sibling checkout or require translator dependencies.

## Attribution and scope

We reuse LeanSMV's transition-system framework and `scripts/smv2lean.py` unchanged.
Counter `Reference.lean` changes only the upstream import path. The GCD and mutex
models adapt the same upstream SMV/Lean encodings; their safety proofs follow
the invariant ideas in `GcdProofs.lean` and `MutexProofs.lean`, credited in the
source files. They are not claims of inventing Euclid's algorithm or mutex proofs.

Our counter adds arbitrary thresholds and the CSLib correspondence. Our GCD
theorem connects arbitrary initial operands to the preserved gcd and returned
value. The new mutex proof uses compact case analysis over the original two-process
protocol. Counter's comparison with upstream Lean is mechanical; GCD/mutex source
correspondence was reviewed by inspection. The translator is not formally verified.

Course references: [Day 2 model](https://github.com/ttj/fmaiv/blob/main/day02/examples/counter.smv),
[Day 3 solution](https://github.com/ttj/fmaiv/blob/main/day03/examples/CounterDemo/CounterDemo/Counter.lean),
[Day 3 framework](https://github.com/ttj/fmaiv/blob/main/day03/examples/CounterDemo/CounterDemo/TransitionSystem.lean).

## Team

-   Manish Acharya: parameterized model, invariant, theorem statements,
    proof architecture, and review or repair of final proofs.
-   Brantley Payne: AI proof trials, saved prompts and outputs, Lean
    compilation results, and per-lemma experiment log.
-   Avash Aryal: reproducible setup and build, CSLib connection with
    Manish, independent final checks, and experiment summary.
