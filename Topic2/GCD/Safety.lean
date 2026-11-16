import Topic2.GCD.Model

namespace Topic2.GCD

/- The subtraction identity and exit-condition invariant follow the approach in
   LeanSMV VerifDemo/NuXMV/GcdProofs.lean at the commit cited in Model.lean.
   Here we connect them to arbitrary initial operands A, B, prove operand bounds,
   and derive the returned value if the program reaches l5. -/
def gcdInv (A B : Nat) (s : State) : Prop :=
  Nat.gcd s.a s.b = Nat.gcd A B ∧
  s.a ≤ A ∧ s.b ≤ B ∧ (s.pc = .l5 → s.a = s.b)

theorem step_gcd (s : State) :
    Nat.gcd (step s).a (step s).b = Nat.gcd s.a s.b := by
  cases hpc : s.pc with
  | l3 =>
    by_cases ha : s.a > s.b
    · simpa [step, hpc, ha] using Nat.gcd_sub_self_left (Nat.le_of_lt ha)
    · simp [step, hpc, ha]
  | l4 =>
    by_cases hb : s.b > s.a
    · simpa [step, hpc, hb] using Nat.gcd_sub_self_right (Nat.le_of_lt hb)
    · simp [step, hpc, hb]
  | l1 | l2 | l5 => simp [step, hpc]

theorem init_preserves (A B : Nat) (s : State) (hi : (GcdTS A B).init s) :
    gcdInv A B s := by
  cases hi
  simp [gcdInv]

theorem step_preserves (A B : Nat) (s t : State)
    (hi : gcdInv A B s) (ht : (GcdTS A B).next s t) : gcdInv A B t := by
  change t = step s at ht
  subst t
  obtain ⟨hgcd, ha, hb, hexit⟩ := hi
  have ha' : (step s).a ≤ s.a := by
    dsimp [step]
    split <;> omega
  have hb' : (step s).b ≤ s.b := by
    dsimp [step]
    split <;> omega
  refine ⟨(step_gcd s).trans hgcd, Nat.le_trans ha' ha, Nat.le_trans hb' hb, ?_⟩
  cases hpc : s.pc <;> by_cases heq : s.a = s.b <;>
    by_cases hgt : s.a > s.b <;> simp_all [step, pcNext, Nat.not_lt_of_ge]

theorem invariant_inductive (A B : Nat) : InductiveInvariant (GcdTS A B) (gcdInv A B) :=
  ⟨init_preserves A B, step_preserves A B⟩

theorem reachable_safe (A B : Nat) : Invariant (GcdTS A B) (gcdInv A B) :=
  inductive_invariant_holds (GcdTS A B) (gcdInv A B) (invariant_inductive A B)

/-- Partial correctness: IF execution reaches l5, both operands are the initial gcd.
    No claim that every execution terminates: for example (0, 1) loops forever. -/
theorem result_correct (A B : Nat) (s : State)
    (hr : Reachable (GcdTS A B) s) (hdone : s.pc = .l5) :
    s.a = Nat.gcd A B ∧ s.b = Nat.gcd A B := by
  obtain ⟨hgcd, _, _, hexit⟩ := reachable_safe A B s hr
  have hab := hexit hdone
  have ha : s.a = Nat.gcd A B := by simpa [← hab] using hgcd
  exact ⟨ha, hab ▸ ha⟩

-- The all-natural theorem includes the zero/zero initial case without a positivity assumption.
example : (GcdTS 0 0).next ⟨0, 0, .l1⟩ ⟨0, 0, .l5⟩ := rfl

end Topic2.GCD
