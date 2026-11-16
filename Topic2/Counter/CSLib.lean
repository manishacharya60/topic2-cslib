import Topic2.Counter.Safety
import Cslib.Foundations.Semantics.LTS.Basic

namespace Topic2.Counter

/-- The label records the freely chosen next input, not the current guard input. -/
def counterLTS (N : Nat) : Cslib.LTS State Bool where
  Tr s input t := t.press = input ∧ t.mode = modeNext N s ∧ t.x = countNext N s

theorem unlabelled_iff (N : Nat) (s t : State) :
    (counterLTS N).UnlabelledTr s t ↔ (CounterTS N).next s t := Iff.rfl

theorem trace_reachable (N : Nat) {s t : State} {inputs : List Bool}
    (h : (counterLTS N).MTr s inputs t) :
    Reachable (CounterTS N) s → Reachable (CounterTS N) t := by
  induction h with
  | refl => exact id
  | stepL hstep _ ih =>
    intro hr
    exact ih (.step _ _ hr ⟨_, hstep⟩)

theorem reachable_iff_trace (N : Nat) (t : State) :
    Reachable (CounterTS N) t ↔
      ∃ s inputs, (CounterTS N).init s ∧ (counterLTS N).MTr s inputs t := by
  constructor
  · intro h
    induction h with
    | init s hi => exact ⟨s, [], hi, .refl⟩
    | step s t _ hn ih =>
      obtain ⟨start, inputs, hi, trace⟩ := ih
      obtain ⟨input, hn⟩ := hn
      exact ⟨start, inputs ++ [input], hi, trace.stepR _ hn⟩
  · rintro ⟨s, inputs, hi, trace⟩
    exact trace_reachable N trace (.init s hi)

theorem labelled_safe (N : Nat) {s t : State} {inputs : List Bool}
    (hi : (CounterTS N).init s) (h : (counterLTS N).MTr s inputs t) : t.x ≤ N :=
  reachable_safe N t (trace_reachable N h (.init s hi))

end Topic2.Counter
