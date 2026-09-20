/-
  Independent audit bridge — Justin Sun Prize JSP-000301
  ======================================================

  Official problem (Justin Sun Prize catalog, JSP-000301):

      "If two consecutive positive integers are powerful, must at least one be
       a perfect square?"

  Answer: NO.  The pair (12167, 12168) is a counterexample.

  Purpose of this file
  --------------------
  It performs the official `lean-verify` self-check step: "write a minimal
  target statement and `example : IntendedStatement := ...` in a separate audit
  file, connecting it to the submitted theorem."  Renaming a definition is NOT
  an independent check, so the restatement below uses genuinely different
  formulations and a genuinely different verification route.

  (A) INDEPENDENT RESTATEMENT.
      `JSP000301.lean` defines "powerful" as an UNBOUNDED universal over the
      primes (`∀ p, Nat.Prime p → p ∣ n → p ^ 2 ∣ n`) and refutes
      square-ness through `Nat.sqrt`.  Here:

        * "powerful" is restated by the classical a^2 * b^3 REPRESENTATION
          (`PowerfulRep`) — an existential over two explicit witnesses rather
          than a universal over all primes;
        * "not a square" is restated as a BOUNDED EXHAUSTIVE CHECK
          (`NotSquareByCheck`): no k < n + 1 satisfies k * k = n.

      Both are reformulations of the same mathematics, obtained from the
      original problem text, not by renaming the submitted predicates.

  (B) INDEPENDENT RE-VERIFICATION.
      The witness is re-established from scratch under these new definitions:
      a^2 b^3 representations are given explicitly and checked by `norm_num`
      (12167 = 1^2 * 23^3, 12168 = 39^2 * 2^3), and non-square-ness is
      decided by kernel computation over `Finset.range (n + 1)` with `by
      decide`.  No theorem of `JSP000301.lean` is used for any of this.

  (C) BRIDGE.
      `PowerfulRep.powerful` and `NotSquareByCheck.not_square` prove the
      alternative formulations SOUND against the submitted ones;
      `intended_yields_submitted` transports the independently verified
      statement to the statement actually submitted;
      `submitted_pos` + `submitted_theorem_yields_intended` go the other way
      and show that the submitted statement does carry the positivity that the
      wording "positive integers" requires (n = 0 is excluded because 0 is a
      square).
-/

import Mathlib
import JSP000301

set_option maxHeartbeats 0
set_option maxRecDepth 200000

namespace Audit301

open JSP000301

--------------------------------------------------------------------------------
-- (A) Independent restatement of the target
--------------------------------------------------------------------------------

/-- Classical representation form of "n is powerful": n = a^2 * b^3.
    (Equivalent to "every prime divisor occurs with exponent at least 2";
    only the soundness direction needed here is proved, see
    `PowerfulRep.powerful`.) -/
def PowerfulRep (n : ℕ) : Prop :=
  ∃ a b : ℕ, n = a ^ 2 * b ^ 3

/-- Bounded-exhaustive form of "n is not a perfect square": no k below n + 1
    squares to n.  Every square root of n is at most n, so this finite check is
    equivalent to `¬ IsSquare n`; see `NotSquareByCheck.not_square`. -/
abbrev NotSquareByCheck (n : ℕ) : Prop :=
  ∀ k ∈ Finset.range (n + 1), k * k ≠ n

/-- The INTENDED statement, read straight off the official problem text:
    two consecutive POSITIVE integers, both powerful, neither a square. -/
def IntendedStatement : Prop :=
  ∃ n : ℕ, 0 < n ∧ PowerfulRep n ∧ PowerfulRep (n + 1) ∧
    NotSquareByCheck n ∧ NotSquareByCheck (n + 1)

/-- The statement actually submitted in `JSP000301.lean`
    (`JSP000301.jsp_000301`), quoted here in order to bridge to it. -/
def SubmittedStatement : Prop :=
  ∃ n : ℕ, Powerful n ∧ Powerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1)

--------------------------------------------------------------------------------
-- (C) Soundness of the alternative formulations
--------------------------------------------------------------------------------

/-- A number of the form a^2 * b^3 is powerful in the submitted sense.
    Proved by splitting the prime across the two factors and exhibiting the
    divisibility witnesses by direct computation. -/
lemma PowerfulRep.powerful {n : ℕ} (h : PowerfulRep n) : Powerful n := by
  rcases h with ⟨a, b, rfl⟩
  intro p hp hdiv
  rcases (Nat.Prime.dvd_mul hp).mp hdiv with hA | hB
  · have hpa : p ∣ a := Nat.Prime.dvd_of_dvd_pow hp hA
    rcases hpa with ⟨c, hc⟩
    refine ⟨c ^ 2 * b ^ 3, ?_⟩
    rw [hc]
    ring_nf
  · have hpb : p ∣ b := Nat.Prime.dvd_of_dvd_pow hp hB
    rcases hpb with ⟨c, hc⟩
    refine ⟨a ^ 2 * p * c ^ 3, ?_⟩
    rw [hc]
    ring_nf

/-- A bounded exhaustive check below n + 1 really does refute `IsSquare n`:
    any square root r of n satisfies r ≤ n, hence r lies in the checked range. -/
lemma NotSquareByCheck.not_square {n : ℕ} (H : NotSquareByCheck n) : ¬ IsSquare n := by
  intro hs
  rcases hs with ⟨r, hr⟩
  have hrlt : r < n + 1 := by
    by_cases h0 : r = 0
    · subst r
      simp at hr
      subst n
      simp
    · have h1 : 1 ≤ r := Nat.succ_le_of_lt (Nat.pos_of_ne_zero h0)
      have hle : r ≤ r * r := by
        calc
          r = r * 1 := by rw [mul_one]
          _ ≤ r * r := Nat.mul_le_mul_left r h1
      have : r ≤ n := by simpa [hr] using hle
      exact Nat.lt_succ_of_le this
  exact (H r (Finset.mem_range.mpr hrlt)) hr.symm

--------------------------------------------------------------------------------
-- (B) Independent re-verification of the witness 12167 / 12168
--------------------------------------------------------------------------------

/-- 12167 = 1^2 * 23^3 — verified by computation, not by the submitted proof. -/
lemma rep_12167 : PowerfulRep 12167 := ⟨1, 23, by norm_num⟩

/-- 12168 = 39^2 * 2^3 — verified by computation, not by the submitted proof. -/
lemma rep_12168 : PowerfulRep 12168 := ⟨39, 2, by norm_num⟩

/-- 12167 is not a square: kernel computation over k < 12168. -/
lemma check_12167 : NotSquareByCheck 12167 := by decide

/-- 12168 is not a square: kernel computation over k < 12169. -/
lemma check_12168 : NotSquareByCheck 12168 := by decide

/-- The intended statement holds, established entirely inside this file. -/
theorem intended_holds : IntendedStatement :=
  ⟨12167, by norm_num, rep_12167, rep_12168, check_12167, check_12168⟩

-- The `example : IntendedStatement := ...` form required by `lean-verify` §2.
example : IntendedStatement := intended_holds

--------------------------------------------------------------------------------
-- (C) Bridge to and from the submitted theorem
--------------------------------------------------------------------------------

/-- The independently verified statement entails the submitted one. -/
theorem intended_yields_submitted : IntendedStatement → SubmittedStatement := by
  rintro ⟨n, _hpos, hr1, hr2, hn1, hn2⟩
  exact ⟨n, hr1.powerful, hr2.powerful, hn1.not_square, hn2.not_square⟩

/-- The submitted statement does force positivity of the first number, as the
    wording "positive integers" requires: n = 0 would be a perfect square. -/
lemma submitted_pos {n : ℕ}
    (h : Powerful n ∧ Powerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1)) :
    0 < n := by
  by_contra hn
  have hn0 : n = 0 := Nat.eq_zero_of_not_pos hn
  subst n
  exact h.2.2.1 ⟨0, by simp⟩

/-- The submitted theorem yields the intended statement (with the submitted
    definitions), including the positivity the problem text asks for. -/
theorem submitted_yields_intended (h : SubmittedStatement) :
    ∃ n : ℕ, 0 < n ∧ Powerful n ∧ Powerful (n + 1) ∧
      ¬ IsSquare n ∧ ¬ IsSquare (n + 1) := by
  rcases h with ⟨n, hn⟩
  exact ⟨n, submitted_pos hn, hn.1, hn.2.1, hn.2.2.1, hn.2.2.2⟩

/-- Connection to the submitted theorem: the proof term actually published in
    `JSP000301.lean` type-checks against `SubmittedStatement` exactly, so the
    bridge above applies to it verbatim. -/
theorem submitted_theorem_yields_intended :
    ∃ n : ℕ, 0 < n ∧ Powerful n ∧ Powerful (n + 1) ∧
      ¬ IsSquare n ∧ ¬ IsSquare (n + 1) :=
  submitted_yields_intended (_root_.JSP000301.jsp_000301)

/-- The submitted theorem proves the statement this audit bridges from. -/
example : SubmittedStatement := _root_.JSP000301.jsp_000301

/-- The submitted theorem, transported through the independent bridge. -/
example : SubmittedStatement := intended_yields_submitted intended_holds

--------------------------------------------------------------------------------
-- Axiom audit
--------------------------------------------------------------------------------

#print axioms Audit301.PowerfulRep.powerful
#print axioms Audit301.NotSquareByCheck.not_square
#print axioms Audit301.rep_12167
#print axioms Audit301.rep_12168
#print axioms Audit301.check_12167
#print axioms Audit301.check_12168
#print axioms Audit301.intended_holds
#print axioms Audit301.intended_yields_submitted
#print axioms Audit301.submitted_pos
#print axioms Audit301.submitted_theorem_yields_intended

end Audit301
