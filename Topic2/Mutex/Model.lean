import Topic2.TransitionSystem

/- Adapted from LeanSMV models/mutex.smv and VerifDemo/NuXMV/Mutex.lean,
   commit 2349edc2eddb9a4f479f98c23f3d257a72945472 (https://github.com/ttj/leansmv).
   This is the original TWO-process synchronous protocol, not an N-process claim.
   A Boolean choice for each idle process represents {idle, waiting} exactly.
   Turn.one / Turn.two represent the original finite range 1..2. -/
namespace Topic2.Mutex

inductive Process where
  | idle | waiting | critical
  deriving DecidableEq, Repr

inductive Turn where
  | one | two
  deriving DecidableEq, Repr

structure State where
  process1 : Process
  process2 : Process
  turn : Turn
  flag1 : Bool
  flag2 : Bool
  deriving DecidableEq, Repr

def processNext (p : Process) (otherFlag : Bool) (hasTurn request : Bool) : Process :=
  match p with
  | .idle => if request then .waiting else .idle
  | .waiting => if otherFlag = false ∨ hasTurn = true then .critical else .waiting
  | .critical => .idle

def flagNext (p nextP : Process) (flag : Bool) : Bool :=
  if p = .idle ∧ nextP = .waiting then true
  else if p = .critical ∧ nextP = .idle then false
  else flag

def step (s : State) (request1 request2 : Bool) : State :=
  let p1 := processNext s.process1 s.flag2 (s.turn == .one) request1
  let p2 := processNext s.process2 s.flag1 (s.turn == .two) request2
  { process1 := p1
    process2 := p2
    -- Preserve first-branch priority and current-state timing of next(turn).
    turn := if s.process1 = .critical then .two
            else if s.process2 = .critical then .one else s.turn
    -- These two updates intentionally depend on the chosen next process states.
    flag1 := flagNext s.process1 p1 s.flag1
    flag2 := flagNext s.process2 p2 s.flag2 }

def MutexTS : TransitionSystem State where
  init s := s = ⟨.idle, .idle, .one, false, false⟩
  next s t := ∃ request1 request2, t = step s request1 request2

end Topic2.Mutex
