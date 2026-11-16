import Topic2.Counter.Model

namespace Topic2.Counter

-- The second conjunct rules out unreachable off states with a stale nonzero count.
def counterInv (N : Nat) (s : State) : Prop :=
  s.x ≤ N ∧ (s.mode = .off → s.x = 0)

theorem init_preserves (N : Nat) (s : State) (h : (CounterTS N).init s) :
    counterInv N s := by
  obtain ⟨_, hx⟩ := h
  exact ⟨by simp [hx], fun _ => hx⟩

theorem step_preserves (N : Nat) (s t : State)
    (hi : counterInv N s) (ht : (CounterTS N).next s t) : counterInv N t := by
  obtain ⟨hx, hoff⟩ := hi
  obtain ⟨_, _, hm, hc⟩ := ht
  cases hmode : s.mode <;> cases hp : s.press <;>
    by_cases hlt : s.x < N <;>
    simp [modeNext, countNext, hmode, hp, hlt, Nat.le_of_not_lt,
      counterInv] at hm hc ⊢ <;>
    constructor <;> first
    | omega
    | intro htmode; simp_all

theorem invariant_inductive (N : Nat) : InductiveInvariant (CounterTS N) (counterInv N) :=
  ⟨init_preserves N, step_preserves N⟩

/-- Every finite reachable state is safe, for every natural threshold. -/
theorem reachable_safe (N : Nat) : Invariant (CounterTS N) (fun s => s.x ≤ N) :=
  invariant_strengthening (CounterTS N) (counterInv N) _ (invariant_inductive N) (fun _ h => h.1)

theorem zero_threshold (s : State) (h : Reachable (CounterTS 0) s) : s.x = 0 := by
  have := reachable_safe 0 s h
  omega

-- At N=0, pressing while off still turns on; the next on step resets to off.
example (p : Bool) : (CounterTS 0).next ⟨.off, true, 0⟩ ⟨.on, p, 0⟩ := by
  exact ⟨p, rfl, rfl, rfl⟩
example (p q : Bool) : (CounterTS 0).next ⟨.on, p, 0⟩ ⟨.off, q, 0⟩ := by
  refine ⟨q, rfl, ?_, ?_⟩ <;> cases p <;> rfl

end Topic2.Counter
