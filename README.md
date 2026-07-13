# S-Loop — a Specification-Driven Development Coach for Claude Code

S-Loop is a Claude Code skill that guides you through the complete specification-driven development workflow—from requirements gathering through implementation and validation. The name is the shape of the method: a spec loop that runs Principles → Spec → Clarify → Plan → Tests → Implementation → Validation and back around on every change.

## What is S-Loop?

S-Loop is a disciplined approach to software development where **specifications are the single source of truth**, guided by **established principles**. Everything flows from principles through specs:

```
Principles → Requirements → Specification (WHAT) → Clarify → Plan (HOW) → Tests → Implementation
```

**The core discipline:**
1. NO code without tests
2. NO tests without specifications
3. NO specifications without understanding requirements
4. NO requirements without established principles
5. The specification says WHAT and WHY; the plan says HOW — keep them in separate documents
6. EVERY change starts with updating the spec (as a delta, checked against principles)
7. Traceability is ENFORCED by a build-failing check, not maintained by hand

**The three principle domains** (together, the project's **constitution**):
- **Architecture Principles** — Structural patterns, module boundaries, data flow
- **Development Principles** — Code style, testing approach, patterns to follow
- **Security Principles** — Secrets handling, input validation, audit requirements

This skill acts as your S-Loop coach, guiding you through each phase and enforcing the methodology — while **scaling the ceremony to your team's maturity** (see The Maturity Dial below).

## The Maturity Dial

The same rigour that steadies a junior team slows a senior one into resentment. S-Loop keeps a **fixed spine** — specs are truth, traceability is enforced, a change always starts with the spec — but a **variable amount of ceremony**. Choose a tier per feature (or let the coach infer and confirm one):

| Tier | Fits | Behaviour |
|------|------|-----------|
| **Guided** | Junior/unfamiliar teams, role-split teams (PO vs dev), high-stakes or greenfield 0→1 | Every phase runs. Clarify mandatory, plan written explicitly, checklist generated, constitution check explicit. The coach teaches and gates. |
| **Standard** | Most teams and features (the default) | Principles → Spec → Clarify (recommended) → Plan → Tests → Implementation → Validation. Traceability always enforced; checklist optional. |
| **Lean** | Senior teams, brownfield 1→n, small well-understood deltas | Actions, not phases: spec-delta → tests → implement → validate, in any order. Clarify and a separate plan doc optional; the coach gets out of the way. |

Two rules hold in **every** tier: the build-failing traceability check is never skipped, and a change always starts by touching the spec, never the code.

## Installation

### Quick Install (Recommended)

Copy the skill to your Claude Code skills directory:

```bash
# Create the skills directory if it doesn't exist
mkdir -p ~/.claude/skills

# Clone or copy the S-Loop skill
cp -r /path/to/s-loop ~/.claude/skills/
```

### Manual Install

1. Create the directory structure:
```bash
mkdir -p ~/.claude/skills/s-loop/templates
mkdir -p ~/.claude/skills/s-loop/examples
```

2. Copy these files:
```
~/.claude/skills/s-loop/
├── SKILL.md                    # Main skill file
├── README.md                   # This guide
├── templates/
│   ├── spec-template.md        # SPEC.md template
│   └── traceability.md         # TRACEABILITY.md template
└── examples/
    └── sample-spec.md          # Example specifications
```

### Verify Installation

Start Claude Code and type `/s-loop`. You should see the S-Loop workflow begin.

## Usage

### Starting a New Feature

Simply invoke the skill with your feature description:

```
/s-loop user authentication with email and password
```

The skill will guide you through (at the tier that fits your team — see The Maturity Dial):
0. **Principles & Constitution** — Setting up or reviewing the governing principles
1. **Requirements Discovery** — Understanding what you want to build (validated against principles)
2. **Specification (WHAT)** — Creating precise, testable, technology-independent specs
3. **Clarify** — Asking up to 5 targeted questions to close ambiguity *before* planning
4. **Plan (HOW)** — The technical approach and stack, with a constitution-check gate
5. **Test Derivation** — Generating tests from specs
6. **Implementation** — Writing code to pass tests (following the plan and principles)
7. **Validation** — Enforced traceability + advisory cross-artifact analysis + optional checklists
8. **Iteration** — Handling changes as deltas (ADDED/MODIFIED/REMOVED) against living truth

### Available Commands

| Command | Description |
|---------|-------------|
| `/s-loop` | Start workflow (at the chosen tier) or assess current state |
| `/s-loop init` | Initialize S-Loop files (SPEC.md, TRACEABILITY.md, plan.md, constitution documents) |
| `/s-loop principles` | Review or amend the constitution (versioned) |
| `/s-loop spec` | Add or edit specifications (WHAT only, technology-independent) |
| `/s-loop clarify` | Ask ≤5 targeted questions and write answers back into the spec |
| `/s-loop plan` | Create the technical plan (HOW) with a constitution-check gate |
| `/s-loop derive` | Generate tests from specifications (test-side SPEC markers) |
| `/s-loop enforce` | Generate/refresh the build-failing traceability check |
| `/s-loop analyze` | Advisory cross-artifact consistency & coverage report (writes nothing) |
| `/s-loop checklist` | Generate a "unit tests for the requirements" quality checklist |
| `/s-loop validate` | Run the suite + traceability check, report alignment |
| `/s-loop status` | Show coverage, health, tier, and principle compliance |
| `/s-loop iterate` | Handle a change as a delta (supersede, don't renumber) |

### Typical Workflow

**0. Establish principles (first time or when needed):**
```
/s-loop principles
```
Sets up or reviews architecture, development, and security principles.

**1. Initialize your project:**
```
/s-loop init
```
Creates `SPEC.md`, `TRACEABILITY.md`, and principle documents in your project.

**2. Add specifications:**
```
/s-loop spec
```
The skill will ask questions to help you write precise, testable specs that comply with your principles.

**3. Derive tests:**
```
/s-loop derive
```
Generates test cases from your specifications with traceability markers.

**4. Implement:**
Write code to make the tests pass. The skill guides you through red-green-refactor while ensuring principle compliance.

**5. Validate:**
```
/s-loop validate
```
Verifies specs, tests, and implementation are aligned—including principle compliance.

**6. Iterate:**
```
/s-loop iterate
```
When requirements or principles change, this ensures changes flow properly through the system.

## Files Created

### Principle Documents

Located in `specs/` directory:

**principles-architecture.md** — Defines structural patterns, module boundaries, and data flow rules.

**principles-development.md** — Defines code style, testing requirements, and patterns to follow.

**principles-security.md** — Defines secrets handling, input validation, and audit requirements.

These documents are established at project start and referenced throughout the workflow.

### SPEC.md

Your specifications document. Example:

```markdown
## Feature: User Authentication

### REQ-001: Login with valid credentials

Users can log in with email and password.

**Preconditions:**
- User account exists
- Account is not locked

**Trigger:**
- User submits login form

**Expected Behavior:**
- Validates credentials against stored hash
- Returns JWT session token on success

**Acceptance Criteria:**
- [ ] Valid credentials return JWT token
- [ ] Token contains user ID and expiration

**Edge Cases:**
- Invalid email: Returns 401 "Invalid credentials"
- Invalid password: Returns 401 "Invalid credentials"

**Principles Compliance:**
- Architecture: Auth module handles all authentication (single responsibility)
- Development: Uses typed error responses, follows async/await patterns
- Security: Passwords never logged, generic error messages prevent enumeration
```

### TRACEABILITY.md

Maps specifications to their tests:

```markdown
| Spec ID | Title | Test Location | Status |
|---------|-------|---------------|--------|
| REQ-001 | Login with valid credentials | tests/auth.test.ts:15 | PASS |
| REQ-002 | Login failure handling | tests/auth.test.ts:42 | PASS |
```

### Test Files

Tests include traceability markers:

```typescript
// SPEC: AC-001-01 - Valid credentials return JWT token
test('login with valid credentials returns JWT token', () => {
  // Arrange
  const credentials = { email: 'user@test.com', password: 'valid123' };

  // Act
  const result = login(credentials);

  // Assert
  expect(result.token).toBeDefined();
});
```

## The S-Loop Philosophy

### Why Principles First?

- **Establishes guardrails** — Decisions are made once, enforced everywhere
- **Resolves ambiguity** — When uncertain, principles provide the answer
- **Ensures consistency** — All code follows the same patterns
- **Prevents debates** — Architectural arguments are settled upfront

### Why Specifications First?

- **Forces clarity** — You must understand what you're building before coding
- **Prevents scope creep** — If it's not in the spec, don't build it
- **Enables traceability** — Every test links to a requirement
- **Controls change** — Changes flow through specs first
- **Ensures principle compliance** — Each spec explicitly addresses relevant principles

### How It Differs from TDD

| Aspect | TDD | S-Loop |
|--------|-----|-----|
| Starting point | Write a failing test | Establish principles, then write specs |
| Test purpose | Drive design | Verify specification compliance |
| Change trigger | Refactor freely | Update spec first, check principles |
| Traceability | Optional | Required and build-enforced |
| Design constraints | Emerge from tests | Defined by principles |

S-Loop is TDD with two additional layers: principles that define HOW decisions are made, and specifications that define WHAT before tests define HOW TO VERIFY.

### How It Relates to spec-kit and OpenSpec

Two well-known open-source spec-driven development toolkits sit at opposite ends of a ceremony spectrum, and — usefully — they map onto team maturity:

| | **GitHub spec-kit** | **OpenSpec** | **This skill** |
|---|---|---|---|
| Stance | Rigid phase gates | Actions, not phases | Phased coach with a maturity dial |
| Runtime | Python + `uv` | Node + npm | None — a pure Claude Code skill |
| Change model | Regenerate per feature | Delta: ADDED/MODIFIED/REMOVED, merged into living truth | Deltas against living truth (adopted from OpenSpec) |
| Signature gates | `/clarify`, `/plan`, `/analyze`, `/checklist`, constitution check | delta proposals, `validate --strict` | Clarify + plan split + analyze + checklist (adopted from spec-kit) |
| Enforcement | `/analyze` is advisory only | `validate` checks structure only | **Build-failing traceability check** (neither tool has this) |
| Best for | Juniors, role-split teams, greenfield | Seniors, small teams, brownfield | Any — the tier is chosen per feature |

This skill deliberately does **not** replace either tool. It is the methodology-and-enforcement layer that neither provides:

- **From spec-kit** it borrows the `/clarify` gate (de-risk under-specification before planning), the WHAT/HOW split (a technology-independent spec vs a separate plan), the advisory `/analyze` pass, the "checklist as unit tests for the *requirements*" idea, and the versioned constitution.
- **From OpenSpec** it borrows the delta change-proposal model — one living spec, changes expressed as ADDED/MODIFIED/REMOVED and merged back — and the "actions, not phases" fluidity that powers the Lean tier.
- **What it keeps that neither has** is the crown jewel: **enforced, build-failing traceability**. spec-kit's analysis is advisory; OpenSpec validates only structure. Neither fails your build when a spec has no test. This skill does.

If a client team already standardises on spec-kit or OpenSpec, keep their tool and run this skill's methodology and traceability enforcement *on top* — they compose, they don't compete. If a team uses neither, this skill is self-contained and needs no external toolchain.

### The Skill as Coach

This skill doesn't just manage files—it actively coaches you:

- **Asks probing questions** during requirements discovery
- **Enforces ordering** (won't let you skip to implementation)
- **Catches violations** ("This adds behavior not in specs...")
- **Teaches as it goes** (explains why each step matters)

## Best Practices

### Establishing Good Principles

Principles should be established before writing specifications. Good principles are:

- **Actionable** — Clear enough to guide decisions
- **Specific** — Not so vague they apply to everything
- **Justified** — Explain why, not just what
- **Reviewable** — Can be updated when they no longer serve the project

**Review principles when:**
- You consistently work around a principle
- New team members question a principle
- Technology or requirements have shifted significantly
- You've completed a major milestone

### Writing Good Specifications

✅ **Do:**
- Describe observable behavior, not implementation
- Include preconditions, triggers, and expected outcomes
- Cover both happy path and edge cases
- Make each criterion independently testable
- Explicitly address relevant principles in each spec

❌ **Don't:**
- Specify algorithms or data structures
- Leave acceptance criteria vague
- Skip edge cases "for now"
- Couple specifications together
- Ignore principle compliance (address it even if to note "no specific principles apply")

### Maintaining Traceability

The hard-won lesson from real projects: **a traceability matrix you maintain by hand rots.** Make it executable instead.

- Every test MUST carry a `// SPEC: AC-XXX-NN` marker (Style A) or `// CONTRACT: C-area-NNN` marker (Style B)
- `// IMPLEMENTS:` markers in source are OPTIONAL — they fall out of date; rely on the test-side marker
- Generate a traceability check (`tests/traceability.<ext>`) that runs in the normal suite and **fails the build** on: untested specs, orphan markers, or a `TRACEABILITY.md` that drifts from the spec
- `TRACEABILITY.md` is machine-generated — never hand-edit it
- Run `/s-loop validate` regularly; in CI, the check runs on every push

### Handling Changes

When requirements change:
1. Update the spec FIRST
2. Update affected tests
3. Update implementation
4. Run validation

Never change implementation without going through specs.

## Troubleshooting

### Skill not appearing

Verify the skill is in the correct location:
```bash
ls ~/.claude/skills/s-loop/SKILL.md
```

### Tests not being detected

Ensure tests have proper traceability markers:
```
// SPEC: REQ-001 - [title]
```

### Framework not detected

If auto-detection fails, the skill will ask which framework you're using. You can also specify in SPEC.md metadata.

## Contributing

Found a bug or have a suggestion? Open an issue or PR on GitHub. Contributions are accepted under the project's license (CC BY-SA 4.0) — by contributing you agree your changes are licensed under the same terms.

## License

**S-Loop by Justin Arbuckle (dromologue)** is licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).

You are free to use, share, and adapt it — including commercially — provided you:

- **give attribution** to "S-Loop by Justin Arbuckle (dromologue.com)" with a link to the license and a note of any changes, and
- **share alike** — license any derivative work under the same CC BY-SA 4.0 terms.

See [LICENSE](./LICENSE) for the full legal code.
