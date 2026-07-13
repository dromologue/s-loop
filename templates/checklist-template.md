# Requirements Checklist: [Feature / Domain]

> **A checklist is a unit-test suite for the requirements, not for the code.**
> If the spec is code written in English, this is its test suite. Every item is a
> question about whether the *specification* is complete, clear, and consistent —
> never an assertion about whether the implementation works.
>
> ✅ "Are error states defined for every operation?" (tests the spec)
> ❌ "Does the login button work?" (tests the code — belongs in Phase 5/6, not here)

- **Spec reference:** [REQ-XXX range / contracts covered]
- **Generated:** [DATE]
- **Tier:** Guided (default) | Standard (high-stakes features)

---

## Completeness — is anything missing?

- [ ] Is a failure / error behavior defined for every operation?
- [ ] Are empty, null, and boundary inputs specified?
- [ ] Are all actors and triggers named (who can do this, and when)?
- [ ] Is every referenced entity / data shape defined somewhere?
- [ ] Are non-functional requirements (performance, concurrency, rate limits) stated where they apply?

## Clarity — could two readers disagree?

- [ ] Is every vague qualifier quantified? ("fast" → a number; "secure" → a specific control)
- [ ] Does each requirement have exactly one interpretation?
- [ ] Are acceptance criteria testable as written (ideally Given/When/Then)?
- [ ] Are there any leftover placeholders (TODO, ???, "decide later")?

## Consistency — does the spec agree with itself?

- [ ] Is terminology used consistently across requirements (no synonym drift)?
- [ ] Are similar features specified in consistent ways?
- [ ] Do any two requirements contradict each other?
- [ ] Does the spec agree with the plan on entities and terms? (no WHAT/HOW leakage)

## Coverage — does it address the whole domain?

- [ ] Accessibility requirements stated where user-facing?
- [ ] Security requirements stated at every trust boundary?
- [ ] Edge cases from Phase 3 (Clarify) all captured back in the spec?
- [ ] [Domain-specific coverage question]

---

## Findings

| # | Question | Gap found | Action (which requirement to fix) |
|---|----------|-----------|-----------------------------------|
| 1 | | | |

> Resolve gaps by editing the **spec**, then re-run. A checklist that passes means
> the requirements are well-written — it says nothing yet about the implementation,
> which the enforced traceability check (Phase 7) verifies separately.
