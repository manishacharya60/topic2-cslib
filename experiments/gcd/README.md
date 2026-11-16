# GCD — additional formal-methods experiment

Source: unchanged `models/leansmv/gcd.smv` from
[LeanSMV](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/gcd.smv).
Original operands are independently initialized anywhere in `0..10`; only the
program counter is initialized to `l1`.

```sh
python3 scripts/demo.py --system gcd
```

nuXmv 2.2.0 reported `pc = l5 -> a = b` **true** in a full finite invariant
check. This selected property is supplied by the command, not an added source
`INVARSPEC`. See [baseline.txt](baseline.txt) for the actual command and output.
We did not run all the original temporal specifications or claim they all pass.

`Topic2/GCD/Model.lean` retains the five program locations, simultaneous updates,
guarded subtraction, and the terminal self-loop. `GcdTS A B` fixes arbitrary
natural initial operands; taking all A, B in 0..10 covers the original finite
initial states. `Safety.lean` proves:

- `gcd(a,b) = gcd(A,B)` in every reachable state;
- `a ≤ A` and `b ≤ B`, so finite-source runs remain in their original domain;
- reaching `l5` implies `a = b = gcd(A,B)`.

This is **partial correctness**: `Reach(s) ∧ s.pc = l5 → correct_result(s)`.
It does not assert eventual termination. In particular, `(a,b) = (0,1)` cycles
through l1, l2, l4 without changing either operand. Zero/zero reaches l5 directly.
The finite check establishes exit equality; the stronger gcd statement is proved
in Lean, not measured by that nuXmv command.

During development the unchanged upstream translator was run with:

```sh
.venv/bin/python ../leansmv/scripts/smv2lean.py models/leansmv/gcd.smv /tmp/topic2-gcd-generated.lean
```

Its output matched upstream `VerifDemo/NuXMV/Gcd.lean`. It is a translation with
commented proof exercises, not a completed proof, and need not be kept or rebuilt
for the demo. The source-to-model initialization and guards were reviewed by
inspection; no theorem of translator correctness is claimed.

The proof adapts the invariant ideas from upstream `GcdProofs.lean` and uses core
Lean gcd identities. `lake build` checks it and prints `[propext, Quot.sound]`,
with no `sorryAx` or added axioms. This is AI-assisted implementation work, not
a new frozen AI trial. The recorded AI experiment remains under `counter/ai/`.
