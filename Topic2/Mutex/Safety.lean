import Topic2.Mutex.Model

namespace Topic2.Mutex

/- LeanSMV VerifDemo/NuXMV/MutexProofs.lean supplies the flag-coupling idea:
   a waiting/critical process has its flag set. We use the same strengthening
   with a compact finite case proof for our encoding. All cases are checked by
   Lean; no external solver or native-decision axiom is used. -/
def mutexInv (s : State) : Prop :=
  (s.flag1 = true ↔ s.process1 ≠ .idle) ∧
  (s.flag2 = true ↔ s.process2 ≠ .idle) ∧
  ¬(s.process1 = .critical ∧ s.process2 = .critical)

theorem init_preserves (s : State) (hi : MutexTS.init s) : mutexInv s := by
  cases hi
  simp [mutexInv]

theorem step_preserves (s t : State)
    (hi : mutexInv s) (ht : MutexTS.next s t) : mutexInv t := by
  obtain ⟨r1, r2, rfl⟩ := ht
  rcases s with ⟨p1, p2, turn, f1, f2⟩
  cases p1 <;> cases p2 <;> cases turn <;> cases f1 <;> cases f2 <;>
    cases r1 <;> cases r2 <;>
    simp_all [mutexInv, step, processNext, flagNext]

theorem invariant_inductive : InductiveInvariant MutexTS mutexInv :=
  ⟨init_preserves, step_preserves⟩

/-- The selected original INVARSPEC: the two processes are never both critical. -/
theorem reachable_safe :
    Invariant MutexTS (fun s => ¬(s.process1 = .critical ∧ s.process2 = .critical)) :=
  invariant_strengthening MutexTS mutexInv _ invariant_inductive (fun _ h => h.2.2)

end Topic2.Mutex
