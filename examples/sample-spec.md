# Specifications

> Example specification document for a user authentication feature.

## Metadata

- **Created:** 2024-01-15
- **Test Framework:** Jest
- **Last Updated:** 2024-01-15
- **SDD Version:** 1.2
- **Spec Style:** A (REQ + acceptance criteria)

> Each acceptance criterion carries a stable ID (`AC-XXX-NN`). Tests reference it
> in a `// SPEC:` marker, and the enforced traceability check fails the build if
> any criterion lacks a test or any marker references a missing ID.

---

## Feature: User Authentication

> Allows users to register, log in, and manage their sessions.

### REQ-001: User Registration

Users can create a new account by providing email and password.
The system validates the email format and password strength before creating the account.

**Acceptance Criteria:**
- [x] **AC-001-01** Email must be valid format (contains @ and domain)
- [x] **AC-001-02** Password must be at least 8 characters
- [x] **AC-001-03** Password must contain at least one number
- [x] **AC-001-04** Duplicate emails are rejected with clear error message
- [x] **AC-001-05** Successful registration returns user ID

**Constraints:**
- Passwords are hashed before storage (bcrypt, cost factor 10)
- Email verification is sent but not required for initial login

**Notes:**
- See design doc: `/docs/auth-design.md`

---

### REQ-002: User Login

Registered users can log in with their email and password.
Successful login returns a JWT session token.

**Acceptance Criteria:**
- [x] **AC-002-01** Valid credentials return JWT token
- [x] **AC-002-02** Invalid email returns 401 with "Invalid credentials"
- [x] **AC-002-03** Invalid password returns 401 with "Invalid credentials"
- [x] **AC-002-04** Locked accounts return 403 with "Account locked"
- [x] **AC-002-05** Token expires after 24 hours

**Constraints:**
- Rate limit: 5 failed attempts per 15 minutes
- JWT secret rotates monthly

---

### REQ-003: Session Validation

The system validates JWT tokens on protected endpoints.
Expired or invalid tokens are rejected.

**Acceptance Criteria:**
- [ ] **AC-003-01** Valid token allows access to protected routes
- [ ] **AC-003-02** Expired token returns 401 with "Token expired"
- [ ] **AC-003-03** Malformed token returns 401 with "Invalid token"
- [ ] **AC-003-04** Missing token returns 401 with "Authentication required"

**Constraints:**
- Token validation must complete within 10ms

---

### REQ-004: Password Reset

Users can request a password reset via email.
Reset links expire after 1 hour.

**Acceptance Criteria:**
- [ ] **AC-004-01** Reset request sends email with unique link
- [ ] **AC-004-02** Link contains secure, single-use token
- [ ] **AC-004-03** Token expires after 1 hour
- [ ] **AC-004-04** Used token cannot be reused
- [ ] **AC-004-05** New password must meet strength requirements

**Constraints:**
- Rate limit: 3 reset requests per hour
- Email delivery within 30 seconds

---

## Feature: User Profile

> Allows users to view and update their profile information.

### REQ-005: View Profile

Authenticated users can view their profile information.

**Acceptance Criteria:**
- [ ] **AC-005-01** Returns user email, name, and created date
- [ ] **AC-005-02** Does not return password hash
- [ ] **AC-005-03** Requires valid authentication

**Constraints:**
- None

---

### REQ-006: Update Profile

Authenticated users can update their display name.

**Acceptance Criteria:**
- [ ] **AC-006-01** Can update display name
- [ ] **AC-006-02** Name must be 1-100 characters
- [ ] **AC-006-03** Cannot update email (separate flow)
- [ ] **AC-006-04** Returns updated profile

**Constraints:**
- Rate limit: 10 updates per hour
