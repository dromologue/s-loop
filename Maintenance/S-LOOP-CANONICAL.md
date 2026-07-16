<!--
  GENERATED — do not hand-edit.
  Redrafted from the canonical S-Loop definition in Workflowy (node a463d48d325f)
  by Maintenance/sync-canonical.sh. If the canonical source changes, the pre-commit
  hook re-extracts and redrafts this file. To change the content, edit the
  canonical Workflowy node, not this file. Raw source snapshot: Maintenance/canonical/source.md
-->

# The S-Loop (SSSS) — the Canonical Definition

> This is the authoritative description of the S-Loop, drawn from the canonical
> source. The `s-loop` skill in this repository is a coach that runs a
> specification-driven workflow **inside** this paradigm; read this document to
> understand the loop the skill is structuring work against. It is written for an
> engineer who has already sat through a spec-first pitch and wants to know what
> is actually different.

## 1. What the S-Loop is

The S-Loop (SSSS) is a build loop — **Scope, Scaffold, Specify, Ship** — run once
per change and *closed*, so that shipping starts the next turn rather than ending
the line. It sits in the **spec-driven development (SDD)** family, where a
versioned specification is the source of truth and the running code is a
projection you regenerate, not the asset you hand-edit. It maps onto the wider
Dromologue framework — it is that framework's build process at **Level 4
(Construction)** — but you need none of that to use it. What follows is
deliberately concrete, and it assumes you have already sat through a spec-first
pitch and want to know what is actually different.

The same loop runs at **two nested levels**. The **programme loop** turns over a
use case or application; each turn ships a change and updates the **nine
disciplines** of the operating model, which is how the model is discovered rather
than designed. Inside it, **each skill runs its own loop**: any requirement a turn
exposes sends that skill back through Scope, Scaffold, Specify, Ship. A skill is a
living artefact on its own loop, not a one-pass build, and it runs the identical
method, reused from the `s-loop` skill rather than restated.

## 2. The baseline: what spec-driven development already gives you

If your team runs GitHub Spec Kit or AWS Kiro well, you already have most of the
value here. SSSS is **not a rival tool**; it is an opinionated way of sequencing
the same primitives, with two departures — and it shares everything else with the
field.

Take the field as it stands in 2026, because SSSS assumes it rather than
reinventing it. **Spec Kit** runs constitution, specify, plan, tasks and implement
as commands over a repo. **Kiro** splits the same work across `requirements.md`,
`design.md` and `tasks.md`, with acceptance criteria in **EARS** form (*when* a
trigger occurs, *under* a stated condition, the system *shall* produce a
response). **Tessl** pushes furthest, treating the spec as the maintained artefact
and regenerating code from it. The literature names three rigour levels —
*spec-first*, *spec-anchored*, *spec-as-source* — and settles on one honest
conclusion: **when a model writes most of the code, the specification is the
highest-leverage thing a human still writes.**

## 3. What SSSS changes, and why

**Departure one — the oracle comes first.** Linear SDD derives tests from the
specification, *after* the specification exists. SSSS stands the executable checks
up in **Scaffold, before the behavioural spec is written**: architectural fitness
functions, the evaluation harness for any model-driven behaviour, and the golden
and regression cases the change must not break. The reason is blunt — when a model
generates the code, "it looks correct" is worth nothing, and a check that cannot
fail is not a check. Building the oracle before the behaviour makes every later
step machine-decidable the moment it lands, including the non-deterministic parts a
conventional test suite has no answer for.

**Departure two — the primitives run in every step, not as a pipeline.** This is
the one worth arguing about. Spec Kit runs constitution, specify, plan, tasks and
implement as ordered phases with gates between them. SSSS runs *all* of those
primitives inside *each* of the four steps, with the centre of gravity shifting as
you go round the loop. You are always doing some framing, some specifying, some
designing, some decomposing, some building and some checking; what changes step to
step is the **proportion**. That is closer to how competent engineers actually
work than a five-stage relay, and it is what makes SSSS a loop of four mixed steps
rather than an assembly line.

**The close.** Ship does not end the line; it emits a **governed, instrumented
skill** — its SDD flow (spec, plan, traceability) bound to its evals, cost profile,
guardrails, observability, and a manifest carrying its contract clause — and feeds
the result back as the next change. The SDD movement's own admitted failure is that
specifications drift and go ungoverned. A closed loop whose output is a governed
skill bundle with a live eval harness is the governance the tools have not yet
supplied.

## 4. How the SDD primitives distribute across the four steps

The primitives are the familiar ones: **set principles** (Spec Kit's
constitution), **specify** (EARS acceptance criteria), **design** (architecture,
interfaces, technology choices), **decompose** (atomic tasks bound to criteria),
**implement** (generate against the spec), **evaluate** (run the checks), and
**release**. Each of the four steps is a different mix of them. The weightings are
the point of SSSS, not the four names.

Weighting at a glance — **H** heavy, **M** medium, **L** light, **–** negligible:

| Step | principles | specify | design | decompose | implement | evaluate | release |
|------|:----------:|:-------:|:------:|:---------:|:---------:|:--------:|:-------:|
| **Scope** | H | L | – | – | – | – | – |
| **Scaffold** | – | M | H | L | – | H | – |
| **Specify** | – | H | M | H | L | M | – |
| **Ship** | – | ref | L | – | H | H | H |

- **Scope** is dominated by principles and framing. You set the constraints the
  change must honour, state the outcome it bets on, and write the kill condition.
  There is a thin slice of specify (the *outcome*, not the behaviour) and
  essentially no design, decomposition or implementation. In Spec Kit terms this is
  constitution plus the first paragraph of specify, and nothing downstream.
- **Scaffold** is dominated by design and by evaluate. You commit interfaces,
  module boundaries and technology, and in the same move stand up the fitness
  functions and the eval harness. Specify appears only as the interface contracts
  the skeleton exposes; decomposition is light; there is no behavioural
  implementation yet. This is where SSSS departs hardest from linear SDD, which
  leaves the test scaffolding implicit and late; here it is explicit and first.
- **Specify** is dominated by specify and decompose. Now you write the full
  acceptance criteria, in EARS or an equivalent, and break them into atomic tasks,
  each bound to a check that can pass or fail. Design is refinement only;
  implementation is still light. This is Kiro's requirements-and-tasks, written
  against a skeleton that can already contradict you rather than on a blank page.
- **Ship** is dominated by implement, evaluate and release. The model generates
  against the spec, the harness runs and gates, the change goes out, and you read
  the telemetry. Specify is now *reference, not authorship*; the verdict updates the
  spec and the loop closes. This is Spec Kit's implement plus the release, the
  observation and the feedback the linear pipeline stops just short of.

## 5. The four steps in depth, in engineering terms

### Scope
Produce a one-paragraph problem statement, an explicit in-and-out boundary, success
and kill conditions, and the constraints the build inherits: latency and cost per
call, data residency, and the platform policies the change is bound by.
**Gate:** the change has a defined failure. If no observable outcome would count as
failure, it is not a bet and Scaffold does not start.

### Scaffold
Produce a running skeleton with named interfaces, the fitness functions and eval
harness wired into CI, and seeded failing cases.
**Gate:** the harness is green on the empty skeleton and red on a deliberately
violated contract. A harness that cannot go red is not an oracle.

### Specify
Produce the acceptance criteria in EARS, each bound to a check; the atomic task
list; and the guardrails and policy shape the change must honour.
**Gate:** every criterion maps to a check that can pass or fail. A criterion with
no oracle does not ship.

### Ship
Produce the deployed change, the telemetry that settles the Scope bet, and the
instrumented skill filed back to the platform.
**Gate:** the bet is settled against real signal and the verdict is recorded as
the next change. A release with no readable verdict is not a Ship, it is an escape.

## 6. Objections a good engineer will raise, answered

- **"This is TDD."** Related, and narrower. TDD is red-green at unit level *inside*
  implementation. Oracle-first here means architectural fitness functions and an
  evaluation harness stood up *before* the behavioural spec, spanning the whole
  change and the non-deterministic model output a unit test cannot judge.
- **"This is just Spec Kit or Kiro."** No. Those run the primitives as gated
  phases. SSSS interleaves them inside each step in shifting proportions, puts the
  oracle before the behaviour, and closes with a governed skill the tools do not
  produce.
- **"This is waterfall with new labels."** No. Waterfall is linear, treats code as
  the source of truth, and writes tests last. SSSS is a loop run per change, treats
  the spec as the source of truth, and writes the oracle first.
- **"Spec-as-source is a fantasy; specs drift."** That is the movement's real
  failure, and it is what the close answers. The code is regenerated from the spec,
  and the skill carries a live eval harness that turns drift into a failing check.
  If your spec cannot fail a check, it is documentation, not source.
- **"The four S names are marketing."** The names are a mnemonic. The content is
  the oracle-first ordering and the per-step weighting. Judge it on those; if they
  do not hold up, the alliteration will not save it.

## 7. Agent operating contract

> Run **one change per turn**. The spec is the source of truth; never hand-edit the
> running system into divergence from it. Do not pass a failing gate. Every step
> ends in an artefact, not a conversation.

**Invariant.** The skill leaving Ship is a **complete bundle**: its SDD flow (spec,
plan, traceability), its evals, cost profile, guardrails and observability, and a
manifest carrying its contract clause. Miss any and you shipped code, not
capability, and the loop has not closed.

| Step | INPUT | PRODUCE | GATE | STOP if |
|------|-------|---------|------|---------|
| **Scope** | the trigger | problem statement, boundary, success and kill conditions, constraints | a failure is definable | nothing would count as failure |
| **Scaffold** | the scoped bet | skeleton, interfaces, fitness functions and eval harness in CI | green on the skeleton, red on a seeded violation | a check cannot fail |
| **Specify** | the skeleton and its checks | EARS criteria bound to checks, atomic tasks, guardrails and policy shape | every criterion maps to a check | a criterion has no oracle |
| **Ship** | the spec and passing tasks | the release, the telemetry, the instrumented skill | bet settled on real signal, verdict recorded | the release yields no readable verdict |

---

## How this skill's SDD workflow maps onto the S-Loop

The `s-loop` skill coaches a specification-driven workflow whose phases are the
**inner mechanics** of the four S's. Read alongside §4 above — the skill's phases
are the primitives, and the four S's set their weighting:

| S-Loop step | Skill phases (inner mechanics) |
|-------------|-------------------------------|
| **Scope** | Requirements Discovery framed as a *bet* — problem, in/out boundary, success **and kill** conditions. The constitution (Principles, Phase 0) supplies the standing constraints and policy shape Scope must honour. |
| **Scaffold** | The Plan (interfaces, module boundaries, technology) **and the enforced traceability check / fitness functions stood up first** — the oracle before the behaviour, green on the skeleton and red on a seeded violation. |
| **Specify** | The executable specification (EARS acceptance criteria) + Clarify, decomposed into atomic tasks, each **bound to a check** the Scaffold harness already runs. |
| **Ship** | Implementation against the skeleton, Validation (running the harness), release, the verdict, and Iteration — the delta that re-opens Scope as the next change. |

The one feature the skill keeps that the broader SDD movement still lacks — a
**build-failing traceability check** — is Scaffold's fitness function made
concrete: the oracle stood up before the behaviour, failing CI whenever a
specification has no test. It is the skill's answer to *"spec-as-source is a
fantasy; specs drift."*

---

*Canonical source: Workflowy node `a463d48d325f` ("8. The S Loop (SSSS)").
Redrafted by `Maintenance/sync-canonical.sh`; the pre-commit hook keeps it in sync.*
