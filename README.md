# JSP-000301 — Lean formalization

| | |
| --- | --- |
| **Justin Sun Prize ID** | JSP-000301 |
| **Original problem** | see [`STATEMENT.md`](STATEMENT.md) |
| **Mathematics** | proved by the original authors cited in `STATEMENT.md` |
| **This repository contributes** | the **Lean 4 formalization only** — no claim of original mathematical discovery |
| **AI assistance** | AI-assisted work; the formalization was produced with AI assistance and is kernel-checked |
| **Lean** | 4.34.0 (`leanprover/lean4:v4.34.0`) |
| **mathlib** | v4.34.0 (`leanprover-community/mathlib4`, rev `v4.34.0`) |

## Build

```bash
lake exe cache get   # optional, downloads prebuilt mathlib oleans
lake build
```

## Verify

[`VERIFICATION.md`](VERIFICATION.md) records the exact commands, the Lean/mathlib
versions, the top-level theorem, and the `#print axioms` output.

## Attribution

The mathematical proof is **not** ours. This repository merely certifies it in
Lean. If an earlier complete public Lean formalization of JSP-000301 exists, that
formalization has priority and this one does not claim first formalization.
