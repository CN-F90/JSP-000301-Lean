# SubmitTemplate self-test — 2026-09-19 08:43 GMT+8

The template was instantiated and elaborated against the **existing** mathlib
v4.34.0 build cache on this machine (no rebuild, ~0 extra disk):

```
python tools/make_submission.py TMPL-SELFTEST Selftest sum_first_n_odd

cd lean-libs/mathlib4
export PATH="$PWD/../../toolchains/lean-4.34.0-windows/bin:$PATH"
lake env lean ../../lean-projects/TMPL-SELFTEST-Lean/Selftest.lean
```

Result:

```
'Selftest.sum_first_n_odd' depends on axioms: [propext, Classical.choice, Quot.sound]
'Selftest.decide_sample' does not depend on any axioms
exit 0, 21.5 s
```

So the instantiate → elaborate → `#print axioms` path is proven working. A real
submission replaces the two sample theorems with the official statement; the
remaining steps (public repo push, GitHub Actions clean-checkout rebuild,
catalog PR) are unchanged.

The instantiated self-test directory was removed after this run.
