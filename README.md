# Specification-Driven Development (SDD) Skill for Claude Code

A Claude Code skill that guides you through the complete specification-driven development workflow—from requirements gathering through implementation and validation.

## What is Specification-Driven Development?

SDD is a disciplined approach to software development where **specifications are the single source of truth**, guided by **established principles**. Everything flows from principles through specs:

```
Principles → Requirements → Specifications → Tests → Implementation
```

**The core discipline:**
1. NO code without tests
2. NO tests without specifications
3. NO specifications without understanding requirements
4. NO requirements without established principles
5. EVERY change starts with updating the spec (and checking against principles)
6. Traceability is ENFORCED by a build-failing check, not maintained by hand

**The three principle domains:**
- **Architecture Principles** — Structural patterns, module boundaries, data flow
- **Development Principles** — Code style, testing approach, patterns to follow
- **Security Principles** — Secrets handling, input validation, audit requirements

This skill acts as your SDD coach, guiding you through each phase and enforcing the methodology.

## Installation

### Quick Install (Recommended)

Copy the skill to your Claude Code skills directory:

```bash
# Create the skills directory if it doesn't exist
mkdir -p ~/.claude/skills

# Clone or copy the sdd skill
cp -r /path/to/sdd ~/.claude/skills/
```

### Manual Install

1. Create the directory structure:
```bash
mkdir -p ~/.claude/skills/sdd/templates
mkdir -p ~/.claude/skills/sdd/examples
```

2. Copy these files:
```
~/.claude/skills/sdd/
├── SKILL.md                    # Main skill file
├── README.md                   # This guide
├── templates/
│   ├── spec-template.md        # SPEC.md template
│   └── traceability.md         # TRACEABILITY.md template
└── examples/
    └── sample-spec.md          # Example specifications
```

### Verify Installation

Start Claude Code and type `/sdd`. You should see the SDD workflow begin.

## Usage

### Starting a New Feature

Simply invoke the skill with your feature description:

```
/sdd user authentication with email and password
```

The skill will guide you through:
0. **Principles Establishment** — Setting up or reviewing project principles
1. **Requirements Discovery** — Understanding what you want to build (validated against principles)
2. **Specification Writing** — Creating precise, testable specs (principle-compliant)
3. **Test Derivation** — Generating tests from specs
4. **Implementation** — Writing code to pass tests (following principles)
5. **Validation** — Verifying everything aligns (including principle compliance)

### Available Commands

| Command | Description |
|---------|-------------|
| `/sdd` | Start full workflow or assess current state |
| `/sdd init` | Initialize SDD files (SPEC.md, TRACEABILITY.md, principle documents) |
| `/sdd principles` | Review or update project principles |
| `/sdd spec` | Add or edit specifications (with principle compliance) |
| `/sdd derive` | Generate tests from specifications (test-side SPEC markers) |
| `/sdd enforce` | Generate/refresh the build-failing traceability check |
| `/sdd validate` | Run the suite + traceability check, report alignment |
| `/sdd status` | Show coverage, health, and principle compliance report |
| `/sdd iterate` | Handle requirement or principle changes properly |

### Typical Workflow

**0. Establish principles (first time or when needed):**
```
/sdd principles
```
Sets up or reviews architecture, development, and security principles.

**1. Initialize your project:**
```
/sdd init
```
Creates `SPEC.md`, `TRACEABILITY.md`, and principle documents in your project.

**2. Add specifications:**
```
/sdd spec
```
The skill will ask questions to help you write precise, testable specs that comply with your principles.

**3. Derive tests:**
```
/sdd derive
```
Generates test cases from your specifications with traceability markers.

**4. Implement:**
Write code to make the tests pass. The skill guides you through red-green-refactor while ensuring principle compliance.

**5. Validate:**
```
/sdd validate
```
Verifies specs, tests, and implementation are aligned—including principle compliance.

**6. Iterate:**
```
/sdd iterate
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

## The SDD Philosophy

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

| Aspect | TDD | SDD |
|--------|-----|-----|
| Starting point | Write a failing test | Establish principles, then write specs |
| Test purpose | Drive design | Verify specification compliance |
| Change trigger | Refactor freely | Update spec first, check principles |
| Traceability | Optional | Required and build-enforced |
| Design constraints | Emerge from tests | Defined by principles |

SDD is TDD with two additional layers: principles that define HOW decisions are made, and specifications that define WHAT before tests define HOW TO VERIFY.

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
- Run `/sdd validate` regularly; in CI, the check runs on every push

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
ls ~/.claude/skills/sdd/SKILL.md
```

### Tests not being detected

Ensure tests have proper traceability markers:
```
// SPEC: REQ-001 - [title]
```

### Framework not detected

If auto-detection fails, the skill will ask which framework you're using. You can also specify in SPEC.md metadata.

## Contributing

Found a bug or have a suggestion? Open an issue or PR on GitHub.

## License

MIT License - Use freely in your projects.
