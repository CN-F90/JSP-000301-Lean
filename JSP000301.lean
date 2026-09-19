import Mathlib

/- JSP-000301 — Lean formalization (independent).

  Official problem: "If two consecutive positive integers are powerful, must at
  least one be a perfect square?"  Answer: NO. The pair (12167, 12168) consists
  of two consecutive powerful numbers, and neither is a perfect square:

    * 12167 = 23^3              (powerful)
    * 12168 = 2^3 * 3^2 * 13^2  (powerful)
    * 12168 = 12167 + 1         (consecutive)
    * sqrt 12167 = sqrt 12168 = 110, and 110^2 = 12100 ≠ 12167, 12168

  This is an INDEPENDENT formalization written from the published mathematics
  (Golomb 1970; Walker 1976), not from any existing Lean source. See
  INDEPENDENCE.md.

  Axiom gate: 0 sorry, 0 admit; #print axioms reports only
  [propext, Classical.choice, Quot.sound] (the standard Mathlib profile;
  Classical.choice is inherited from Mathlib core lemmas such as Nat.eq_sqrt and
  Nat.Prime.dvd_mul, not introduced here). -/

namespace JSP000301

/-- A positive integer n is *powerful* when every prime dividing n has exponent at
    least 2, i.e. for every prime p, p^2 divides n whenever p divides n. -/
def Powerful (n : ℕ) : Prop :=
  ∀ (p : ℕ), Nat.Prime p → p ∣ n → p ^ 2 ∣ n

------------------------------------------------------------------------------
-- The two numbers are powerful
------------------------------------------------------------------------------

lemma powerful_12167 : Powerful 12167 := by
  intro p hp hdiv
  rw [show 12167 = 23 ^ 3 by norm_num] at hdiv
  have : p = 23 := by
    apply (Nat.prime_dvd_prime_iff_eq hp (by decide : Nat.Prime 23)).mp
    exact Nat.Prime.dvd_of_dvd_pow hp hdiv
  rw [this]
  decide

lemma powerful_12168 : Powerful 12168 := by
  intro p hp hdiv
  rw [show 12168 = 2 ^ 3 * 3 ^ 2 * 13 ^ 2 by norm_num] at hdiv
  obtain h_a | h13 := (Nat.Prime.dvd_mul hp).mp hdiv
  · obtain h2 | h3 := (Nat.Prime.dvd_mul hp).mp h_a
    · have : p = 2 := by
        apply (Nat.prime_dvd_prime_iff_eq hp (by decide : Nat.Prime 2)).mp
        exact Nat.Prime.dvd_of_dvd_pow hp h2
      rw [this]
      decide
    · have : p = 3 := by
        apply (Nat.prime_dvd_prime_iff_eq hp (by decide : Nat.Prime 3)).mp
        exact Nat.Prime.dvd_of_dvd_pow hp h3
      rw [this]
      decide
  · have : p = 13 := by
      apply (Nat.prime_dvd_prime_iff_eq hp (by decide : Nat.Prime 13)).mp
      exact Nat.Prime.dvd_of_dvd_pow hp h13
    rw [this]
    decide

------------------------------------------------------------------------------
-- The two numbers are NOT perfect squares
------------------------------------------------------------------------------

-- If n = r^2 then r = sqrt n, so n = (sqrt n)^2; hence if (sqrt n)^2 ≠ n then
-- n cannot be a square.
lemma not_square_of_sqrt {n a : ℕ} (h : Nat.sqrt n = a) (hne : a * a ≠ n) :
    ¬ IsSquare n := by
  rw [IsSquare]
  intro ⟨r, hr⟩
  have : r = a := by rw [← Nat.sqrt_eq r, ← hr, h]
  rw [this] at hr
  exact hne (Eq.symm hr)

lemma sqrt_12167 : Nat.sqrt 12167 = 110 :=
  Eq.symm (Nat.eq_sqrt.mpr (by norm_num))

lemma sqrt_12168 : Nat.sqrt 12168 = 110 :=
  Eq.symm (Nat.eq_sqrt.mpr (by norm_num))

lemma not_square_12167 : ¬ IsSquare 12167 :=
  not_square_of_sqrt sqrt_12167 (by norm_num)

lemma not_square_12168 : ¬ IsSquare 12168 :=
  not_square_of_sqrt sqrt_12168 (by norm_num)

------------------------------------------------------------------------------
-- Main theorem
------------------------------------------------------------------------------

/-- There exist two consecutive positive integers that are both powerful and
    neither of which is a perfect square. Equivalently, it is NOT the case that
    at least one of two consecutive powerful numbers must be a square. -/
theorem jsp_000301 :
    ∃ (n : ℕ), Powerful n ∧ Powerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1) :=
  ⟨12167, powerful_12167, powerful_12168, not_square_12167, not_square_12168⟩

#print axioms JSP000301.jsp_000301

end JSP000301
