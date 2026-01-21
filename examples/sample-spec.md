# Specifications

> Example specification document for a user authentication feature.

## Metadata

- **Created:** 2024-01-15
- **Test Framework:** Jest
- **Last Updated:** 2024-01-15

---

## Feature: User Authentication

> Allows users to register, log in, and manage their sessions.

### REQ-001: User Registration

Users can create a new account by providing email and password.
The system validates the email format and password strength before creating the account.

**Acceptance Criteria:**
- [x] Email must be valid format (contains @ and domain)
- [x] Password must be at least 8 characters
- [x] Password must contain at least one number
- [x] Duplicate emails are rejected with clear error message
- [x] Successful registration returns user ID

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
- [x] Valid credentials return JWT token
- [x] Invalid email returns 401 with "Invalid credentials"
- [x] Invalid password returns 401 with "Invalid credentials"
- [x] Locked accounts return 403 with "Account locked"
- [x] Token expires after 24 hours

**Constraints:**
- Rate limit: 5 failed attempts per 15 minutes
- JWT secret rotates monthly

---

### REQ-003: Session Validation

The system validates JWT tokens on protected endpoints.
Expired or invalid tokens are rejected.

**Acceptance Criteria:**
- [ ] Valid token allows access to protected routes
- [ ] Expired token returns 401 with "Token expired"
- [ ] Malformed token returns 401 with "Invalid token"
- [ ] Missing token returns 401 with "Authentication required"

**Constraints:**
- Token validation must complete within 10ms

---

### REQ-004: Password Reset

Users can request a password reset via email.
Reset links expire after 1 hour.

**Acceptance Criteria:**
- [ ] Reset request sends email with unique link
- [ ] Link contains secure, single-use token
- [ ] Token expires after 1 hour
- [ ] Used token cannot be reused
- [ ] New password must meet strength requirements

**Constraints:**
- Rate limit: 3 reset requests per hour
- Email delivery within 30 seconds

---

## Feature: User Profile

> Allows users to view and update their profile information.

### REQ-005: View Profile

Authenticated users can view their profile information.

**Acceptance Criteria:**
- [ ] Returns user email, name, and created date
- [ ] Does not return password hash
- [ ] Requires valid authentication

**Constraints:**
- None

---

### REQ-006: Update Profile

Authenticated users can update their display name.

**Acceptance Criteria:**
- [ ] Can update display name
- [ ] Name must be 1-100 characters
- [ ] Cannot update email (separate flow)
- [ ] Returns updated profile

**Constraints:**
- Rate limit: 10 updates per hour
