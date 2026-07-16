# A Worked Example: One Turn of the S-Loop

> A complete, small run of the loop on a photo-sharing app, from nothing to a shipped
> change with a verdict. Read it end to end once before your first real turn. Every
> step says what you type, what comes back, what lands on disk, and **why the step is
> there at all**.

The example runs at the **Guided** tier, because this is greenfield 0→1 and Guided
shows every inner phase. Most of your later turns will run at **Standard**, which is
the same spine with less ceremony. See the maturity dial in `SKILL.md`.

The app: **Frame**, a small photo-sharing service. People upload a photo, it appears
in a feed their followers can see. That is the whole ambition. What follows is the
**first turn** of the loop against it — not the whole product.

---

## Before you start

Install the skill and open a session in an empty repository:

```
/s-loop
```

The coach establishes the tier, checks for a constitution, and enters Scope. You can
also drive it step by step with `/s-loop scope`, `/s-loop scaffold` and so on; the
commands map onto the four S's and are listed in `SKILL.md`.

Two things that hold from the first keystroke and never relax, at any tier:

- A change starts by touching the **spec**, never the code.
- The **oracle comes before the behaviour**. The checks that will judge the change
  are stood up before the change is described in detail.

If you only take two things from this document, take those.

---

# STEP 1 — SCOPE

**What you type**

```
/s-loop scope
> I want people to be able to share photos with their followers.
```

## Phase 0 — The constitution

The coach looks for `specs/principles-*.md`, finds nothing, and walks you through
three short documents. For Frame they come out roughly as:

`specs/principles-architecture.md`
- The API server never talks to object storage directly; uploads go through a single
  media service. **MUST**: one module owns blob access.
- Feed reads must not depend on the upload path being available.

`specs/principles-development.md`
- Every acceptance criterion has a test carrying its marker. No exceptions for
  "obvious" behaviour.
- **MUST**: no behaviour in the running system that is not in the spec.

`specs/principles-security.md`
- **MUST**: uploaded files are never served from the same origin as the API.
- Image bytes are validated as images at the boundary, not trusted from the
  `Content-Type` header.
- No user-supplied filename ever reaches the filesystem unmodified.

Each gets a version and a ratification date. The `MUST:` lines are non-negotiable: a
later conflict with one is a blocker, not a trade-off.

**Why this phase exists.** The constitution is standing policy that Scope inherits
and every downstream step is checked against. Without it, "is this design acceptable?"
gets re-litigated on every feature and answered differently each time by whoever is in
the room. With it, the answer is written down once and the argument is about whether
to amend it, which is a much better argument to have. It also gives an agent writing
code a constraint set it cannot negotiate away.

## Phase 1 — Frame the change as a bet

The coach probes: who uploads, from what, how large, what happens on failure, what
"appears in a feed" means, what would tell you this was worth building. Then it
states the bet and writes Scope's artefact.

> **Problem.** People with a phone full of photos have no low-friction way to show a
> specific, small audience. Existing options force a public post or a chat thread.
>
> **In scope.** Authenticated upload of a single JPEG or PNG; the photo appears in the
> uploader's followers' feeds, newest first.
>
> **Out of scope.** Albums. Video. Comments. Likes. Editing. Deletion. Public
> profiles. Anything about who follows whom, which already exists.
>
> **Success condition.** Within two weeks of release, at least 30% of active users
> upload at least one photo, and p95 upload-to-visible is under 4 seconds.
>
> **Kill condition.** Under 10% upload at all, or p95 exceeds 10 seconds and the fix
> is architectural. Either settles the bet as lost and we abandon the feature rather
> than iterate on it.
>
> **Constraints inherited.** Media service owns blob access (architecture). Uploads
> served from a separate origin (security, non-negotiable). Storage cost under
> £0.02 per active user per month.

**GATE — a failure is definable.** There is an observable outcome that would mean
stop. The gate passes and Scaffold may start.

**Why this step exists.** Scope is where most projects quietly go wrong, because they
skip it and start with a wish-list. A wish-list cannot be wrong, so it can never be
settled, so the work never ends and nothing is ever learned. Framing the change as a
bet with a kill condition forces three admissions up front: what you are not doing,
what would count as success, and what would count as failure. Notice that the kill
condition is the hardest line to write and the most valuable. If no outcome would
count as failure, you do not have a bet, you have an aspiration, and the coach will
send you back for a sharper one.

---

# STEP 2 — SCAFFOLD

**What you type**

```
/s-loop scaffold
```

This is the step that surprises people. **No behaviour has been specified yet**, and
we are about to build the thing that judges the behaviour. That inversion is the
point of the method.

## Phase 4 — The plan (the HOW)

`plan.md` lands. Abbreviated:

> **Stack.** TypeScript, Fastify, Postgres, S3-compatible object store, Vitest.
> Postgres because feed reads are ordered and relational and we already run one;
> object store because image bytes have no business in a row. *Every choice carries a
> rationale tied to a constraint or a principle. A choice with no rationale is a
> smell.*
>
> **Architecture.** `api` (HTTP, auth, validation) → `media` (the only module that
> touches the blob store) → `feed` (read model, does not import `media`). This honours
> the architecture principle directly.
>
> **Named interfaces.** `media.store(bytes, mime) -> MediaId`,
> `feed.append(userId, MediaId)`, `feed.forViewer(viewerId, cursor)`.
>
> **Sequencing.** Skeleton and harness → validation boundary → store → feed append →
> feed read.
>
> **Risks.** Upload latency dominated by the blob store round trip. Open question:
> do we resize on upload or on read?

**Constitution check.** The coach walks each principle domain. Serving uploads from a
separate origin needs a second hostname and a signed-URL path, which is real work; it
is a non-negotiable, so the plan changes to include it rather than the principle
bending to the plan.

## Stand up the oracle

Now the skeleton goes up with the named interfaces and empty seams, and, in the same
move, the checks:

1. `tests/traceability.test.ts` is written and wired into the normal test run. It
   parses `SPEC.md` for every `REQ-XXX` and `AC-XXX-NN`, scans `tests/` for
   `// SPEC:` markers, and **fails** if any criterion has no test carrying its
   marker, if any marker names a criterion that does not exist, or if the
   regenerated matrix differs from the committed `TRACEABILITY.md`. It regenerates
   `TRACEABILITY.md` as a side effect.
2. A fitness function is added asserting that `feed` never imports `media`, because
   that architecture principle is otherwise a comment nobody reads.
3. The harness is proven. Seed a fake criterion `AC-999-99` with no test: the suite
   goes **red**. Remove it: **green** on the empty skeleton. Add an import of `media`
   into `feed`: **red**. Remove it: **green**.

**GATE — green on the skeleton, red on a seeded violation.** Both directions were
demonstrated, so the harness is an oracle rather than decoration.

**Why this step exists.** Two reasons, and the second is the one that matters now
that a model is writing most of the code.

The first is ordinary: a check written after the behaviour tends to be shaped by the
behaviour. You test what the code does, not what the spec said, and the test passes
by construction. Standing the oracle up first means the checks are shaped by intent,
because intent is all that exists yet.

The second is that **"it looks correct" is worth nothing when a model wrote the
code**. Generated code is fluent, plausible and confidently wrong in ways that read
fine. Your judgement of a diff is no longer a reliable signal, so the only thing
standing between you and shipping a convincing mistake is a check that can fail. And
the seeding step is not ceremony: a check that has never gone red is a check you have
no evidence about. Most rotten test suites are rotten because nobody ever proved they
could fail.

The traceability check specifically is the load-bearing one. Hand-maintained
traceability matrices rot within weeks, every time, in every team. Treat traceability
as code that fails the build, or do not claim to have it.

---

# STEP 3 — SPECIFY

**What you type**

```
/s-loop specify
```

The skeleton stands and the harness runs. Every criterion written from here lands
against something that can immediately contradict it.

## Phase 2 — The specification (the WHAT)

`SPEC.md` is created, Style A, IDs banded by concern: `001–019` upload, `020–039`
feed, `070–089` security.

```markdown
### REQ-001: Photo upload

An authenticated user can upload a single image file. The system validates the
bytes, stores them, and returns an identifier the feed can reference.

**Acceptance Criteria:**
- [ ] **AC-001-01** A valid JPEG under 10MB is accepted and returns a media ID
  - GIVEN an authenticated user
  - WHEN they POST a valid JPEG of 2MB to /upload
  - THEN a 201 is returned carrying a media ID
- [ ] **AC-001-02** A file whose bytes are not a JPEG or PNG is rejected with 415,
  regardless of its Content-Type header
- [ ] **AC-001-03** A file over 10MB is rejected with 413 before the bytes are read
  into memory
- [ ] **AC-001-04** An unauthenticated upload returns 401

**Constraints:**
- Format is determined by magic-byte inspection, never the declared Content-Type
  (security principle, non-negotiable)

### REQ-020: Photo appears in follower feeds

**Acceptance Criteria:**
- [ ] **AC-020-01** A photo uploaded by A appears in B's feed when B follows A
- [ ] **AC-020-02** It does not appear in C's feed when C does not follow A
- [ ] **AC-020-03** Feed entries are ordered newest first
```

Notice what is absent: no Fastify, no S3, no table names. The WHAT lives here, the
HOW lives in `plan.md`. A good spec could be implemented on a different stack without
changing a word.

## Phase 3 — Clarify

The coach interrogates its own draft for under-specification and asks five questions.
Real ones from this run:

1. AC-001-03 says "before the bytes are read into memory" — is that a hard
   requirement or an implementation preference? *(Answer: hard. It is a denial-of-
   service surface. It stays, and moves into REQ-070.)*
2. What happens when the blob store accepts the bytes but the feed append fails? Does
   the user see success? *(Answer: no. Upload is not acknowledged until the feed row
   exists. This becomes ADDED requirement REQ-002.)*
3. "Newest first" by upload time or capture time? *(Answer: upload time. Capture time
   comes from EXIF and is user-controlled.)*
4. Is there a per-user upload rate limit? *(Answer: yes, 20 per hour. ADDED as
   REQ-071.)*
5. What does a follower see if the media is still uploading? *(Answer: nothing. The
   feed row is written after the store succeeds, per question 2.)*

Every answer is written back into the spec, dated, in a `## Clarifications` section
or folded into the requirement it fixes. The two new requirements enter as ADDED
deltas.

**Why this phase exists.** Under-specification is where teams fail, not bad code. The
most common failure mode by a long way is a spec vague enough that two readers build
two different things, and you discover it at integration or, worse, in production.
Clarify is fifteen minutes of questions and it is the highest-leverage step in the
whole loop, especially for less experienced teams. Look at question 2: it surfaced a
consistency bug that would otherwise have shipped as a photo that exists but nobody
can see, and it cost one sentence to fix here instead of a week of debugging later.

## Phase 5 — Bind tests to the standing checks

Tests are a mechanical translation of criteria, not creative work. Each carries the
required marker, which is what binds it to the oracle already running:

```typescript
// SPEC: AC-001-02 - Non-image bytes are rejected regardless of declared type
test('rejects a text file declared as image/jpeg', async () => {
  // GIVEN an authenticated user
  // WHEN they POST text bytes with Content-Type: image/jpeg
  // THEN 415
});
```

As tests land, the traceability check's red entries go green one by one. The suite is
now telling you exactly how much of the intent is unbuilt, without anyone maintaining
a spreadsheet.

**GATE — every criterion maps to a check.** A criterion with no oracle is a wish and
does not ship.

**Why this step exists here and not earlier.** Because the harness was already
standing, the spec was written against something that could contradict it, and the
tests bind to checks rather than inventing new ones. Writing the spec after the
skeleton also kills the most expensive kind of spec: the beautiful one that turns out
to be unbuildable, discovered three weeks in.

---

# STEP 4 — SHIP

**What you type**

```
/s-loop derive     # if you have not already emitted the tests
/s-loop validate
/s-loop ship
```

## Phase 6 — Implementation

Red-green-refactor against the standing skeleton. The discipline is that you are
satisfying the **specification**, not the test. After each pass the coach asks: does
this satisfy the spec, does it follow the plan, are we adding behaviour nobody
specified?

Midway through, the agent adds automatic image resizing on upload. It is sensible,
and it is not in the spec. **Stop.** Either it goes back through Scope and Specify as
an ADDED delta, or it comes out. In this run it comes out; it is a real idea, but it
is next turn's bet, not this one's scope creep.

## Phase 7 — Validation

- **7a. Enforced.** Full suite including the traceability check. Every criterion has
  a passing test carrying its marker, no orphan markers, `TRACEABILITY.md`
  regenerates without drift. If the matrix disagrees with reality, fix the spec, the
  test or the marker and regenerate. Never hand-edit the matrix; the moment you do,
  it stops being evidence.
- **7b. Advisory.** `/s-loop analyze` reports coverage gaps, surviving ambiguity,
  duplication and constitution alignment. It blocks nothing. Here it flags that
  REQ-070's DoS criterion has one test where the edge cases suggest three.
- **7c. Checklist.** Guided generates one: unit tests *for the requirements*, asking
  whether the spec is complete and consistent, never asserting anything about the
  code.

## Release, verdict, close

1. **Release**, instrumented so the Scope bet can actually be settled: upload
   attempts, upload successes, p95 upload-to-visible, share of active users who
   uploaded. These are not general dashboards, they are the specific instruments the
   bet named in Step 1.
2. **File the instrumented skill as a complete bundle.** What leaves the loop is
   Frame's SDD flow (the spec, the plan, the traceability matrix) bound to its evals,
   its cost profile (the £0.02 per active user per month the bet inherited), its
   guardrails, its observability, and a manifest carrying its contract clause. Miss
   any and you shipped code, not capability, and the loop has not closed.
3. **Read the verdict.** Two weeks later: 34% of active users uploaded, p95 is 6.1
   seconds. The bet is **partially settled**. Uptake passes; latency misses the
   success condition without hitting the kill condition. The instruments say the
   6.1 seconds is the blob-store round trip on mobile connections, which is the open
   question the plan flagged.
4. **Record the verdict as the next change.** The delta is drafted and merged back
   into the living spec:

```markdown
## MODIFIED Requirements
### REQ-020: Photo appears in follower feeds
Feed rows are written on upload acknowledgement, with the media served from a
pre-signed URL available before the blob store round trip completes.
(Previously required a completed store — changed 2026-08-01, reason: p95 6.1s
against a 4s success condition; see verdict.)

## ADDED Requirements
### REQ-003: Optimistic upload acknowledgement
[+ criteria]
```

**GATE — verdict recorded.** The bet was settled against real signal and the verdict
is written down as the Event that opens the next Scope. A release with no readable
verdict is not a Ship, it is an escape.

**Why this step exists.** Most teams stop at "the tests pass and it deployed", which
answers a question nobody asked. Passing tests tell you the code does what the spec
said; only the world tells you whether the spec was worth saying. Shipping without an
instrument is shipping without learning, and it is how organisations accumulate
features nobody wanted while being certain they are data-driven.

The close matters as much as the release. The verdict is not a retrospective note, it
is the input to the next turn, expressed as a delta against the spec that now
describes the system as it actually behaves. That is what makes the loop a loop
rather than four steps in a row.

---

## What you have on disk after one turn

```
specs/principles-architecture.md    # constitution, versioned
specs/principles-development.md
specs/principles-security.md
SPEC.md                             # the WHAT, living truth, source of truth
plan.md                             # the HOW, with rationale and constitution check
TRACEABILITY.md                     # machine-generated, never hand-edited
tests/traceability.test.ts          # the oracle, fails the build
tests/upload.test.ts                # carries // SPEC: markers
src/...                             # a projection of the spec, not the asset
tasks/lessons.md                    # what this turn taught, if it taught anything
```

## The turn in one page

| Step | You produce | The gate that must pass | Why it is there |
|---|---|---|---|
| **Scope** | A bet with a kill condition, inside a constitution | A failure is definable | A wish-list can never be wrong, so it can never be settled |
| **Scaffold** | Plan, skeleton, and a harness proven to fail | Green on skeleton, red on a seeded violation | A check that cannot fail is not a check, and "looks correct" is worthless when a model wrote it |
| **Specify** | Executable intent, every criterion bound to a check | Every criterion maps to a check | Under-specification, not bad code, is where teams fail |
| **Ship** | The change, released and instrumented, and a delta | The verdict is recorded | Passing tests prove the code matched the spec, not that the spec was worth writing |

## Your second turn

The next turn starts from the verdict, not from a blank page. `/s-loop iterate` picks
up REQ-003 as an ADDED delta and runs it round again, and this time you will probably
want **Standard**: the constitution exists, the harness stands, the plan is a
paragraph. The spine does not change. The ceremony does.

Three things will not relax, whatever tier you pick:

1. The build-failing traceability check is never optional.
2. A change always starts by touching the spec, never the code.
3. No step advances past a failing gate, and every step ends in an artefact.

## Where to look next

- `SKILL.md` — the coach, the maturity dial, the full command reference.
- `Maintenance/S-LOOP-CANONICAL.md` — the authoritative definition of the loop.
- `templates/` — spec, plan, principles, traceability and checklist templates.
- `examples/sample-spec.md` — a fuller specification in Style A.
