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
