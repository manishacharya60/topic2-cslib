# Mutex — additional formal-methods experiment

Source: unchanged `models/leansmv/mutex.smv` from
[LeanSMV](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/mutex.smv).

```sh
python3 scripts/demo.py --system mutex
```

nuXmv 2.2.0 reported `!(process1 = critical & process2 = critical)` **true**
in a full finite invariant check. See [baseline.txt](baseline.txt) for the actual
command and output. Only this selected original property was checked; comments
claiming that other source properties should pass are not experimental results.

`Topic2/Mutex/Model.lean` represents the original **two-process synchronous**
protocol. Both process updates read current flags and turn. Independent Boolean
choices represent each idle process's `{idle, waiting}` alternatives. The flag
updates intentionally use the chosen next process states. The turn update reads
current process states and retains the original first-branch priority.

`Safety.lean` proves the stronger invariant:

```text
(flag1 = true ↔ process1 ≠ idle) ∧
(flag2 = true ↔ process2 ≠ idle) ∧
¬(process1 = critical ∧ process2 = critical)
```

The flag relationships matter: two waiting processes both have their flags set,
so simultaneous entry would require turn = 1 and turn = 2, which is impossible.
Initialization and every transition preserve this invariant; the shared framework
then gives mutual exclusion for all reachable states. The result does not assert
starvation freedom or generalize the protocol to arbitrary process counts.

During development the unchanged upstream translator was run with:

```sh
.venv/bin/python ../leansmv/scripts/smv2lean.py models/leansmv/mutex.smv /tmp/topic2-mutex-generated.lean
```

Its output matched upstream `VerifDemo/NuXMV/Mutex.lean`. The new model's enum
types and Boolean choices are a compact adaptation; source correspondence was
reviewed by inspection, not a formal equivalence proof. No duplicate generated
file is needed for the demo.

The flag-coupling argument comes from upstream `MutexProofs.lean`. Our compact
case proof uses ordinary Lean checking, not `native_decide`. `lake build` prints
only `[propext]` for the safety theorem, with no `sorryAx` or added axioms.
This is AI-assisted implementation work, not a new frozen AI trial. The recorded
AI experiment remains under `counter/ai/`.
