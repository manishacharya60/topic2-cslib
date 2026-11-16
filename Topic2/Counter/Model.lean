import Topic2.TransitionSystem

/- Parameterization of LeanSMV's course counter.
   Branch order is identical to the SMV case statements. All guards read s.press;
   the existential chooses s'.press independently, including in initial states.
   Nat deliberately does not bake in the SMV range 0..25 or the desired bound. -/
namespace Topic2.Counter

inductive Mode where
  | off | on
  deriving DecidableEq, Repr

structure State where
  mode : Mode
  press : Bool
  x : Nat
  deriving DecidableEq, Repr

def modeNext (N : Nat) (s : State) : Mode :=
  if s.mode = .off ∧ s.press = false then .off
  else if s.mode = .off ∧ s.press = true then .on
  else if (s.mode = .on ∧ s.press = false) ∧ s.x < N then .on
  else if s.mode = .on ∧ (s.press = true ∨ s.x ≥ N) then .off
  else s.mode

def countNext (N : Nat) (s : State) : Nat :=
  if (s.mode = .on ∧ s.press = false) ∧ s.x < N then s.x + 1
  else if s.mode = .on ∧ (s.press = true ∨ s.x ≥ N) then 0
  else s.x

def CounterTS (N : Nat) : TransitionSystem State where
  init s := s.mode = .off ∧ s.x = 0
  next s t := ∃ press' : Bool,
    t.press = press' ∧ t.mode = modeNext N s ∧ t.x = countNext N s

end Topic2.Counter
