# Specifications

> This file is the single source of truth for this project — the **WHAT and WHY**.
> It is technology-independent: no framework, library, database, or language choices
> belong here. Those live in the **plan** (`plan.md`, the HOW). A well-written spec
> could be implemented in two different stacks without changing a word.
> All tests derive from these specifications.
> Changes flow: Principles → Spec (WHAT) → Clarify → Plan (HOW) → Tests → Implementation

## Metadata

- **Project:** [Project Name]
- **Created:** [DATE]
- **Test Framework:** [FRAMEWORK]
- **Last Updated:** [DATE]
- **S-Loop Version:** 2.0
- **Spec Style:** A (REQ + acceptance criteria) | B (contracts + pins)
- **Tier:** Guided | Standard | Lean

## Governing Principles

This specification is governed by the following principle documents:

- [Architecture Principles](./principles-architecture.md) — Module boundaries, data flow, structural patterns
- [Development Principles](./principles-development.md) — Code style, testing approach, required patterns
- [Security Principles](./principles-security.md) — Secrets handling, validation, audit requirements

All specifications must comply with these principles. Non-compliance requires explicit justification or principle update.

## ID Conventions

- **Band requirement numbers by concern** so the ID locates the area (e.g. `001–019` tools, `020–039` transport, `070–089` security). Leave gaps for insertion.
- **Decompose with letters** (`REQ-001a`, `REQ-001b`), never by renumbering.
- **Supersede, don't delete:** retire a requirement with a dated note, leave the ID and the gap in place.
- Each acceptance criterion gets a stable ID (`AC-001-01`) — this is the string that tests carry in their `// SPEC:` marker and that the enforced traceability check pins against.
- Once this file passes ~30 requirements, split it into `specs/<area>.md` and keep an index here.

---

## Feature: [Feature Name]

> [Brief description of what this feature does and why it exists]

### REQ-001: [Requirement Title]

[Clear description of the expected behavior. Focus on WHAT, not HOW.
Describe the behavior from the user's perspective.]

**Preconditions:**
- [What must be true before this behavior can occur]
- [Required state, data, or context]

**Trigger:**
- [What action or event initiates this behavior]

**Expected Behavior:**
- [Step-by-step what should happen]
- [Be specific about outputs, state changes, side effects]

**Acceptance Criteria:**
- [ ] **AC-001-01** [Testable criterion 1 - specific, measurable]
- [ ] **AC-001-02** [Testable criterion 2 - can be verified by code]

> For conditional/stateful behavior, prefer a **Given/When/Then scenario** — it
> removes ambiguity and maps one-to-one onto a test's Arrange/Act/Assert:
>
> - [ ] **AC-001-03** [Scenario name]
>   - GIVEN [precondition / starting state]
>   - WHEN [the trigger action]
>   - THEN [the observable outcome]
>   - AND [any additional outcome]
>
> Keep plain one-line criteria for simple facts; use scenarios where a reader could
> otherwise disagree about the behavior.

**Edge Cases:**
- [Edge case 1]: [Expected behavior for this case]
- [Edge case 2]: [Expected behavior for this case]

**Constraints:**
- [Performance requirements]
- [Security considerations]
- [Technical limitations]

**Principles Compliance:**
- Architecture: [Which architecture principles apply and how this spec honors them]
- Development: [Which development principles apply and how this spec honors them]
- Security: [Which security principles apply and how this spec honors them]

---

<!--
=== TEMPLATE FOR NEW REQUIREMENTS ===

### REQ-XXX: [Title]

[Description of behavior]

**Preconditions:**
- [Precondition]

**Trigger:**
- [What initiates this]

**Expected Behavior:**
- [What happens]

**Acceptance Criteria:**
- [ ] [Criterion]

**Edge Cases:**
- [Case]: [Behavior]

**Constraints:**
- [Constraint]

**Principles Compliance:**
- Architecture: [Applicable principles and compliance]
- Development: [Applicable principles and compliance]
- Security: [Applicable principles and compliance]

=== END TEMPLATE ===
-->

<!--
=== STYLE B: CONTRACT TEMPLATE (libraries / APIs / MCP / CLI) ===

State the contract inline next to the behavior it governs, pin it to a test:

**[C-auth-001]** Logging in with valid credentials returns a signed session token
whose expiry is honored on subsequent requests. Pinned by `test_login_valid`.

**[C-auth-002]** Logging in with an unknown email or wrong password returns a
generic 401 with no account-existence signal. Pinned by `test_login_rejected`.

The test carries a matching marker: `// CONTRACT: C-auth-001`.
The enforced check fails the build if a contract has no pin, a pin names a
missing test, or the matrix drifts.

=== END STYLE B ===
-->

<!--
=== DELTA / CHANGE-PROPOSAL TEMPLATE (Phase 8: Iteration) ===

The spec is living truth. Express a change as a delta against it, review the delta,
then merge it back so this file always describes the system as it is now. Use only
the sections that apply.

## ADDED Requirements
### REQ-045: [New requirement]
[Full requirement with acceptance criteria / scenarios. Takes the next banded ID.]

## MODIFIED Requirements
### REQ-002: [Requirement being changed]
[The new behavior, edited in place.]
(Previously: [old behavior] — changed YYYY-MM-DD, reason: [why].)

## REMOVED Requirements
### REQ-018: [Requirement being retired]
Superseded by REQ-045 on YYYY-MM-DD. Removal rationale: [why].
(Leave the ID and the gap in place — never renumber. Retire its tests, remove the code.)

=== END DELTA TEMPLATE ===
-->

---

## Specification Quality Checklist

Before finalizing any spec, verify:

- [ ] **Observable:** Describes external behavior, not internal implementation
- [ ] **Testable:** Each criterion can be verified by automated test
- [ ] **Unambiguous:** Only one way to interpret the requirement
- [ ] **Complete:** Covers happy path AND failure cases
- [ ] **Independent:** Minimal coupling to other specifications
- [ ] **Traceable:** Each criterion has a stable ID (`AC-XXX-NN`) carried by a test marker
- [ ] **Enforced:** Covered by the build-failing traceability check, not a hand-kept matrix
- [ ] **Principle-Compliant:** Explicitly addresses relevant architecture, development, and security principles
