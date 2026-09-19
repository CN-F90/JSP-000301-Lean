# INDEPENDENCE.md — JSP-000301 (Erdős problem #365 / #366)

This document satisfies the **independence requirement** of the Justin Sun Prize
unattended autopilot: every independently-produced Lean formalization must record
its mathematical source, declare that no existing Lean proof was copied, list the
Mathlib lemmas used, and disclose AI assistance and authorship.

## 1. Mathematical statement and result

- **Catalog problem (verbatim intent):** "If two consecutive positive integers
  are both powerful, must at least one of them be a perfect square?"
- **Answer proved here: NO.** There exist two consecutive powerful integers,
  neither of which is a perfect square.
- **Witness (Golomb's smallest example):** `(12167, 12168)`
  - `12167 = 23³`
  - `12168 = 2³ · 3² · 13²`
  - `12168 = 12167 + 1` (consecutive)
  - Both are *powerful* (every prime divisor occurs with exponent ≥ 2).
  - Neither is a perfect square (`sqrt 12167 = sqrt 12168 = 110`, and
    `110² = 12100 ≠ 12167, 12168`).

## 2. Mathematical proof source (public, pre-existing)

This formalization was derived **independently from the published mathematics**,
not from any existing Lean source. Primary references:

- Golomb, S. W. (1970). *Powerful numbers*. The American Mathematical Monthly,
  77(8), 848–855. — Introduced "powerful numbers" and established the existence
  of infinitely many consecutive powerful pairs; the pair `(12167, 12168)` is the
  smallest such pair (OEIS A227297).
- Walker, D. T. (1976). *Consecutive integer pairs of powerful numbers*.
  — Independent treatment of the same phenomenon.
- The underlying problem is Erdős problem #365 / #366 in the Erdős problem bank
  (the "Erdős–Graham prize" / "Questions I would like answered" collection),
  mirrored as **JSP-000301** in the official Justin Sun Prize catalog.

The mathematical fact (existence of consecutive powerful non-squares) is well
known and is **not** claimed as our discovery. We claim only the independent Lean
formalization of it.

## 3. Known earlier Lean formalizations (prior art)

- **Prior-art classification for this problem: `PRIOR_ART_EXISTS`** (per the
  updated autopilot policy; at least one earlier Lean formalization of this
  problem / counterexample is known to exist in the community).
- **We did NOT access, read the body of, or copy any existing Lean proof of this
  result.** No existing repository's theorem statement was used as a template for
  the proof term. We consulted only the public *mathematical* literature above
  and Mathlib's general API documentation.
- Under the current policy, prior art affects priority and award probability only;
  it does **not** prohibit an independent formalization. This project is one such
  independent formalization and discloses all known parallel/earlier work in its
  Award Claim.

## 4. Mathlib lemmas / API used

All lemmas are from the local Mathlib v4.34.0 checkout; none were modified.

- `Nat.Prime.dvd_mul` — prime dividing a product.
- `Nat.Prime.dvd_of_dvd_pow` — prime dividing a power.
- `Nat.prime_dvd_prime_iff_eq` — two primes, one divides the other ⇒ equal.
- `Nat.eq_sqrt` / `Nat.sqrt_eq` / `Nat.sqrt` — integer square root.
- `IsSquare` (root namespace) — the square predicate.
- `norm_num` and `decide` — concrete arithmetic / divisibility discharge.

## 5. AI assistance disclosure

This formalization was produced with the assistance of an AI coding agent
(WorkBuddy, operating as the "Justin Sun Prize unattended autopilot" under the
CN-F90 account). The agent selected the problem from the re-ranked "easy /
prior-art-rejected" pool, wrote the Lean proof, built it against the local
Mathlib cache, and verified the build (0 `sorry`, 0 `admit`). The mathematical
content and the witness are standard and predate this work.

## 6. Authorship and publication

- **Formalization author / contributor:** CN-F90 (GitHub account).
- **Contact email used for Award Claim (user-authorized):**
  `2698837476@qq.com`
- **Repository:** `CN-F90/JSP-000301-Lean` (public), with pinned commit SHA and
  a clean-checkout GitHub Actions build.
- **Catalog correction PR:** flips `lean` field for JSP-000301 from `No` to
  `Yes` (this is a genuinely new, independent formalization, so the flip is
  warranted) and attributes CN-F90 as a formalization contributor.
- **Award Claim:** submitted per the official form, disclosing the known earlier
  / parallel Lean formalizations of JSP-000301 and claiming only CN-F90's
  independent Lean contribution (not the underlying mathematics).

## 7. Start time and commit history

- **Start of independent formalization:** 2026-09-19 17:18 GMT+8.
- **First green build:** 2026-09-19 17:29 GMT+8 (Lean 4.34.0, `lake build`
  exit 0, `#print axioms jsp_000301` = `[propext, Classical.choice, Quot.sound]`).
- **Commits:**
  - `JSP_WORK/JSP000301/Main.lean` — initial independent formalization.
  - `JSP_WORK/JSP000301/INDEPENDENCE.md` — this independence declaration.

## 8. Axiom statement

The proof depends only on the standard Mathlib axiom profile
`[propext, Classical.choice, Quot.sound]`. It contains **no** `sorry`, **no**
`admit`, and **no** custom/fake axioms. `Classical.choice` is inherited from
Mathlib core lemmas (e.g. `Nat.eq_sqrt`, `Nat.Prime.dvd_mul`) and is a
sanctioned, non-fake axiom in Mathlib; it is not introduced by this project.
