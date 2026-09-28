import Cslib.Foundations.Semantics.LTS.Basic

-- Toy example: a number steps to its successor, with one label.
def toyLTS : Cslib.LTS Nat Unit where
  Tr := fun s _ t => t = s + 1

theorem toy_step : toyLTS.Tr 0 () 1 := by
  rfl

theorem toy_unlabelled_step : toyLTS.UnlabelledTr 0 1 := by
  exact ⟨(), toy_step⟩

#check toyLTS.UnlabelledTr
#eval 2 + 2
#print axioms toy_unlabelled_step
