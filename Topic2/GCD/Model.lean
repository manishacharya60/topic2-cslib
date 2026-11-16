import Topic2.TransitionSystem

/- Adapted from LeanSMV models/gcd.smv and VerifDemo/NuXMV/Gcd.lean,
   commit 2349edc2eddb9a4f479f98c23f3d257a72945472 (https://github.com/ttj/leansmv).
   The original program counter and guarded subtraction steps are preserved.
   A and B select initial operands; quantifying over them covers all original
   initial choices in 0..10, and generalizes them to arbitrary natural numbers.
   Zero is allowed: this is a safety model, not a claim of termination. -/
namespace Topic2.GCD

inductive PC where
  | l1 | l2 | l3 | l4 | l5
  deriving DecidableEq, Repr

structure State where
  a : Nat
  b : Nat
  pc : PC
  deriving DecidableEq, Repr

def pcNext (s : State) : PC :=
  match s.pc with
  | .l1 => if s.a = s.b then .l5 else .l2
  | .l2 => if s.a > s.b then .l3 else .l4
  | .l3 | .l4 => .l1
  | .l5 => .l5

-- All updates read the current state; no subtraction occurs at l2 itself.
def step (s : State) : State :=
  { a := if s.pc = .l3 ∧ s.a > s.b then s.a - s.b else s.a
    b := if s.pc = .l4 ∧ s.b > s.a then s.b - s.a else s.b
    pc := pcNext s }

def GcdTS (A B : Nat) : TransitionSystem State where
  init s := s = ⟨A, B, .l1⟩
  next s t := t = step s

end Topic2.GCD
