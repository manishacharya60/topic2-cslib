# Parametric counter verification in Lean 4 and CSLib

Course project: Topic 2 — Lean 4 + CSLib.

## Goal

We will generalize the on/off counter from the course's fixed bound
`count_max = 10` to an arbitrary natural-number bound `N`. Our main
goal is to prove in Lean that every reachable state satisfies `x ≤ N`.

The course already provides a completed Lean proof for bound 10. Our
new work is the parameterized system and proof, a connection to
CSLib's labelled transition systems, and a recorded experiment on
AI assistance with individual proof lemmas.

## Course references

-   Day 2 model: https://github.com/ttj/fmaiv/blob/main/day02/examples/counter.smv
-   Day 3 fixed-bound Lean solution: https://github.com/ttj/fmaiv/blob/main/day03/examples/CounterDemo/CounterDemo/Counter.lean
-   Day 3 transition-system framework: https://github.com/ttj/fmaiv/blob/main/day03/examples/CounterDemo/CounterDemo/TransitionSystem.lean

The Day 2 model specifies `x <= count_max` as a safety property. We
have not yet recorded an independent local model-checker run.

## Team

-   Manish Acharya: parameterized model, invariant, theorem statements,
    proof architecture, and review or repair of final proofs.
-   Brantley Payne: AI proof trials, saved prompts and outputs, Lean
    compilation results, and per-lemma experiment log.
-   Avash Aryal: reproducible setup and build, CSLib connection with
    Manish, independent final checks, and experiment summary.

## Current status

The project and source models have been selected. The parameterized
Lean implementation, CSLib connection, and AI trials are planned.
Manish has completed the Natural Number Game.

## Planned verification

The final project should build from a clean checkout with `lake build`.
Its main theorem must be checked without `sorry` or project-specific
axioms. AI-generated attempts and human repairs will be distinguished
in a per-lemma log.
