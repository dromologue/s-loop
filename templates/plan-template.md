# Implementation Plan

> The plan is the HOW. It is a **separate document from the specification**, which
> is the WHAT. Technology, architecture, and sequencing enter here — never in the
> spec. Keeping them apart lets the spec stay stable while the implementation varies.
>
> Changes flow: Principles → Spec (WHAT) → Clarify → **Plan (HOW)** → Tests → Implementation

## Metadata

- **Feature / Change:** [Name or change-id]
- **Spec reference:** [Link to the REQ-XXX / contracts this plan implements]
- **Created:** [DATE]
- **Tier:** Guided | Standard | Lean
- **S-Loop Version:** 2.0

---

## Technical Approach & Stack

> The first document where technology is named. State each choice and *why* —
> tie it to a constraint or a principle. A choice with no rationale is a smell.

| Area | Choice | Rationale |
|------|--------|-----------|
| Language / runtime | [e.g. TypeScript / Node 20] | [why] |
| Framework | [e.g. Fastify] | [why] |
| Data store | [e.g. Postgres] | [why] |
| Key libraries | [list] | [why] |

---

## Architecture

> Components, boundaries, and data flow. Must obey the architecture principles.

```
[ASCII diagram: components and their relationships / data flow]
```

- **Module boundaries:** [how responsibilities are split]
- **Data flow:** [how data moves through the system]
- **State / source of truth:** [where state lives]

---

## Data Model
*(where relevant)*

- **Entities:** [entity → fields, types]
- **Relationships:** [how entities relate]
- **Schema / migration notes:** [if applicable]

---

## Contracts / Interfaces
*(where relevant — APIs, function signatures, protocol details)*

- [Operation → inputs, outputs, error conditions]
- For Style B specs, the plan's contracts should line up with the spec's `[C-area-NNN]` markers.

---

## Task Breakdown (Sequencing)

> Ordered, dependency-aware. In **Guided**, make this an explicit numbered list the
> implementation phase works through. In **Lean**, a few lines or omit for a small delta.

1. [ ] [Task] — depends on: [none | task #]
2. [ ] [Task] — depends on: [#1]
3. [ ] [Task]

---

## Constitution Check (GATE)

> Must pass before implementation begins. Re-check after any material design change.
> An unjustified violation of a **non-negotiable (MUST)** principle blocks the plan —
> adjust the plan, not the principle.

| Principle domain | Compliant? | If not: justification & remediation |
|------------------|-----------|-------------------------------------|
| Architecture | ✅ / ⚠️ / ❌ | [violation + why justified, or how it will be fixed] |
| Development | ✅ / ⚠️ / ❌ | [...] |
| Security | ✅ / ⚠️ / ❌ | [...] |

**Gate status:** PASS | PASS-WITH-JUSTIFICATION | BLOCKED

---

## Risks & Open Questions

- [Risk / unknown the plan can't yet resolve — and how it will be closed]

---

## See Also

- [Specification](./SPEC.md) — the WHAT this plan implements
- [Architecture Principles](./principles-architecture.md)
- [Development Principles](./principles-development.md)
- [Security Principles](./principles-security.md)
