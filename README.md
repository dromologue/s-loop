# Specification-Driven Development (SDD) Skill for Claude Code

A Claude Code skill that guides you through the complete specification-driven development workflow—from requirements gathering through implementation and validation.

## What is Specification-Driven Development?

SDD is a disciplined approach to software development where **specifications are the single source of truth**. Everything flows from specs:

```
Requirements → Specifications → Tests → Implementation
```

**The core discipline:**
1. NO code without tests
2. NO tests without specifications
3. NO specifications without understanding requirements
4. EVERY change starts with updating the spec

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
1. **Requirements Discovery** — Understanding what you want to build
2. **Specification Writing** — Creating precise, testable specs
3. **Test Derivation** — Generating tests from specs
4. **Implementation** — Writing code to pass tests
5. **Validation** — Verifying everything aligns

### Available Commands

| Command | Description |
|---------|-------------|
| `/sdd` | Start full workflow or assess current state |
| `/sdd init` | Initialize SDD files (SPEC.md, TRACEABILITY.md) |
| `/sdd spec` | Add or edit specifications |
| `/sdd derive` | Generate tests from specifications |
| `/sdd validate` | Check spec-test-implementation alignment |
| `/sdd status` | Show coverage and health report |
| `/sdd iterate` | Handle requirement changes properly |

### Typical Workflow

**1. Initialize your project:**
```
/sdd init
```
Creates `SPEC.md` and `TRACEABILITY.md` in your project.

**2. Add specifications:**
```
/sdd spec
```
The skill will ask questions to help you write precise, testable specs.

**3. Derive tests:**
```
/sdd derive
```
Generates test cases from your specifications with traceability markers.

**4. Implement:**
Write code to make the tests pass. The skill guides you through red-green-refactor.

**5. Validate:**
```
/sdd validate
```
Verifies specs, tests, and implementation are aligned.

**6. Iterate:**
```
/sdd iterate
```
When requirements change, this ensures changes flow properly through the system.

## Files Created

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
// SPEC: REQ-001 - Login with valid credentials
// Criteria: Valid credentials return JWT token
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

### Why Specifications First?

- **Forces clarity** — You must understand what you're building before coding
- **Prevents scope creep** — If it's not in the spec, don't build it
- **Enables traceability** — Every test links to a requirement
- **Controls change** — Changes flow through specs first

### How It Differs from TDD

| Aspect | TDD | SDD |
|--------|-----|-----|
| Starting point | Write a failing test | Write a specification |
| Test purpose | Drive design | Verify specification |
| Change trigger | Refactor freely | Update spec first |
| Traceability | Optional | Required |

SDD is TDD with an additional layer: specifications that define WHAT before tests define HOW TO VERIFY.

### The Skill as Coach

This skill doesn't just manage files—it actively coaches you:

- **Asks probing questions** during requirements discovery
- **Enforces ordering** (won't let you skip to implementation)
- **Catches violations** ("This adds behavior not in specs...")
- **Teaches as it goes** (explains why each step matters)

## Best Practices

### Writing Good Specifications

✅ **Do:**
- Describe observable behavior, not implementation
- Include preconditions, triggers, and expected outcomes
- Cover both happy path and edge cases
- Make each criterion independently testable

❌ **Don't:**
- Specify algorithms or data structures
- Leave acceptance criteria vague
- Skip edge cases "for now"
- Couple specifications together

### Maintaining Traceability

- Every test MUST have a `// SPEC: REQ-XXX` marker
- Run `/sdd validate` regularly
- Treat orphan tests as bugs (tests without specs)
- Treat untested specs as incomplete work

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
