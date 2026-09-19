# JSP-000301 — official problem statement

- **Official statement (verbatim from the Justin Sun Prize catalog):**
  "If two consecutive positive integers are powerful, must at least one be a
  perfect square?"

- **Catalog link:**
  https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0301-0400.md#jsp-000301

- **Mathematical area:** Number theory / Powerful numbers

- **Original proof / publication:**
  - [Go70] S. W. Golomb, *Powerful numbers*, Amer. Math. Monthly **77**(8)
    (1970), 848–855.
  - [Wa76] D. T. Walker, *Consecutive integer pairs of powerful numbers*,
    Fibonacci Quart. **14** (1976), 111–116.
  - [Gu04] R. K. Guy, *Unsolved Problems in Number Theory* (2004), xviii+437.

- **Current catalog status:** Solved (disproved): `12167 = 23³` and
  `12168 = 2³ × 3² × 13²` are consecutive powerful numbers, and neither is a
  perfect square. (This problem is Erdős problem #365 / #366 in the Erdős
  problem bank.)

- **Lean top-level theorem:** `JSP000301.jsp_000301`

## Fidelity checklist

- [x] Verbatim official statement pasted above
- [x] Every quantifier and hypothesis of the original is present in the theorem:
      `∃ n, Powerful n ∧ Powerful (n+1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n+1)`
      — i.e. the negation of "for all consecutive powerful pairs, at least one
      is a square", exactly the catalog question.
- [x] No "first N terms" / fixed-parameter weakening
- [x] Prior-art sweep done (awards issues + PRs + plby/lean-proofs + global Lean
      search); prior art is disclosed in `INDEPENDENCE.md` and the Award Claim.
