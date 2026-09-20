# JSP-000301 — verification record

## Environment

| component | value |
| --- | --- |
| Lean | 4.34.0 (`leanprover/lean4:v4.34.0`) |
| mathlib | v4.34.0 (`leanprover-community/mathlib4`, rev `v4.34.0`) |
| OS | windows-x86_64 (build host) · ubuntu-latest (CI) |

## Commands

```bash
lake exe cache get   # downloads prebuilt mathlib oleans
lake build
lake env lean JSP000301.lean
```

The CI workflow (`.github/workflows/ci.yml`) runs `leanprover/lean-action@v1`
with `use-mathlib-cache: true`, then fails the build if any `sorry`/`admit` is
present, and finally runs `lake env lean JSP000301.lean` to surface the axiom
audit.

## Result

- `lake build`: exit 0
- `sorry`: 0 · `admit`: 0 · new axioms: 0
- `#print axioms JSP000301.jsp_000301`:
  ```
  [propext, Classical.choice, Quot.sound]
  ```

`Classical.choice` and `Quot.sound` are inherited from Mathlib core lemmas used
by this proof (`Nat.eq_sqrt`, `Nat.Prime.dvd_mul`, `Nat.Prime.dvd_of_dvd_pow`).
They are not introduced by this project and are a standard, sanctioned Mathlib
axiom profile — there is no `sorryAx` and no custom/fake axiom.

## Statement correspondence

The official catalog question — "If two consecutive positive integers are
powerful, must at least one be a perfect square?" — is answered **NO** by

```
theorem jsp_000301 :
    ∃ (n : ℕ), Powerful n ∧ Powerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1)
```

with the explicit witness `(12167, 12168)`. This is the exact negation of "every
pair of consecutive powerful numbers has at least one perfect square", which is
the catalog statement. No quantifier, hypothesis, or scope of the original is
dropped.

## Reproducibility

- GitHub Actions rebuilds this repository from a clean checkout on every push
  (`.github/workflows/ci.yml`).
- The pinned toolchain is `leanprover/lean4:v4.34.0` (`lean-toolchain`).
- mathlib is pinned to `v4.34.0` in `lakefile.toml`.

## Independent audit bridge (`Audit301.lean`)

The official `lean-verify` self-check asks for "a minimal target statement and
`example : IntendedStatement := ...` in a separate audit file, connecting it to
the submitted theorem". `Audit301.lean` supplies this. It does three separate
things:

1. **Independent restatement.** The target is re-written from the original
   problem text in formulations deliberately *different* from `JSP000301.lean`:
   - "powerful" is restated by the classical `a^2 * b^3` representation
     (`PowerfulRep`), an existential over two explicit witnesses, instead of an
     unbounded universal over the primes;
   - "not a perfect square" is restated as a bounded exhaustive check
     (`NotSquareByCheck`): no `k < n + 1` satisfies `k * k = n`, instead of a
     `Nat.sqrt` argument.
2. **Independent re-verification.** The witness is re-established from scratch
   under these new definitions: `12167 = 1^2 * 23^3` and `12168 = 39^2 * 2^3` by
   `norm_num`, and non-square-ness by kernel computation (`by decide`) over
   `Finset.range (n + 1)`. No theorem of `JSP000301.lean` is used for this.
3. **Bridge to the submitted theorem.** `PowerfulRep.powerful` and
   `NotSquareByCheck.not_square` prove the alternative formulations sound
   against the submitted ones; `intended_yields_submitted` transports the
   independently verified statement to the submitted statement;
   `submitted_theorem_yields_intended` applies that bridge to the published
   proof term `JSP000301.jsp_000301`. `submitted_pos` shows the submitted
   statement does carry the positivity the wording requires (`n = 0` is
   excluded because `0` is a perfect square).

Axioms for every bridge theorem: `[propext, Classical.choice, Quot.sound]`.
No `sorry`, no `admit`, no custom axiom, no `native_decide`.
`JSP000301.lean` is untouched; the pinned proof commit `4726b8cb...` remains
the verification target.

Reproduce with:

```bash
lake build JSP000301 Audit301
lake env lean Audit301.lean
```
