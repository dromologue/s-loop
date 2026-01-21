# Specifications

> This file is the single source of truth for this project.
> All tests and implementation derive from these specifications.
> Changes flow: Spec → Tests → Implementation

## Metadata

- **Project:** [Project Name]
- **Created:** [DATE]
- **Test Framework:** [FRAMEWORK]
- **Last Updated:** [DATE]
- **SDD Version:** 1.0

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
- [ ] [Testable criterion 1 - specific, measurable]
- [ ] [Testable criterion 2 - can be verified by code]

**Edge Cases:**
- [Edge case 1]: [Expected behavior for this case]
- [Edge case 2]: [Expected behavior for this case]

**Constraints:**
- [Performance requirements]
- [Security considerations]
- [Technical limitations]

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

=== END TEMPLATE ===
-->

---

## Specification Quality Checklist

Before finalizing any spec, verify:

- [ ] **Observable:** Describes external behavior, not internal implementation
- [ ] **Testable:** Each criterion can be verified by automated test
- [ ] **Unambiguous:** Only one way to interpret the requirement
- [ ] **Complete:** Covers happy path AND failure cases
- [ ] **Independent:** Minimal coupling to other specifications
- [ ] **Traceable:** Clear ID for linking to tests (REQ-XXX)
