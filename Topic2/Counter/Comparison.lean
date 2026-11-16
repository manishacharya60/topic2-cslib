import Topic2.Counter.Safety
import Topic2.Counter.Reference

namespace Topic2.Counter

def toUpstream (s : State) : CounterState :=
  ⟨match s.mode with | .off => .off | .on => .on, s.press, s.x⟩

theorem init_matches (s : State) :
    (CounterTS 10).init s ↔ _root_.CounterTS.init (toUpstream s) := by
  cases s with
  | mk m p x => cases m <;> simp [CounterTS, _root_.CounterTS, toUpstream]

/-- Mechanical equality of relations for all Nat counts, even unreachable ones. -/
theorem next_matches (s t : State) :
    (CounterTS 10).next s t ↔ _root_.CounterTS.next (toUpstream s) (toUpstream t) := by
  rcases s with ⟨m, p, x⟩
  rcases t with ⟨m', p', x'⟩
  cases m <;> cases m' <;> cases p <;>
    by_cases h : x < 10 <;>
    simp [CounterTS, _root_.CounterTS, toUpstream, modeNext, countNext, h,
      Nat.le_of_not_lt] <;> omega

/-- The Nat encoding cannot leave the original finite domain from an initial state. -/
theorem original_range (s : State) (h : Reachable (CounterTS 10) s) : s.x ≤ 25 := by
  have := reachable_safe 10 s h
  omega

end Topic2.Counter
