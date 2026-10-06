---
name: design-tree
description: "The owner's working rules for agents: reports to an owner who reads only the last message, when to stop, the ledger of items awaiting the owner and decision cards, one task per pull request with one completion review, and a design tree of the decisions a project is built on, checked against the code (design and correspondence checks G1-G3, DC1-DC4). Use when a task asks the owner to decide anything, reports to the owner, edits a design tree or its log, or reviews design and implementation for correspondence."
---

<!-- Backup copy of the owner-wide agent instructions, kept in step with
them; projects load those instructions directly, not this skill. -->

# Owner-wide agent instructions

These rules hold in every repository. A project's own AGENTS.md adds only
what is specific to that project and lasts: its goal and first priorities,
references, paths, checks and gate commands, review checklist, extra merge
preconditions, project-only rules and the extra parts its reports carry.

## 1. Working with the owner

### How the owner reads

The owner reads the last report on returning, often many turns later, and
skips the work in between, so the report carries everything the owner needs.

### While working

Between tool calls, write at most one short status line. Record anything
important you learn, such as a finding, a surprise, a changed plan or a
question for the owner, where you will find it again (your memory, a notes
file, the project's TODO), and carry it into the next report.

### Reports

Write a report whenever you stop, finished or blocked, and whenever the owner
sends "report" while you work; after a "report" request, continue working. In
a discussion, talk normally.

A report covers the time since the owner's last message and is short enough
to read in two minutes. The owner knows the projects, their components and
their established terms, so explain only what is new in that time: names you
introduced, internal plan labels, new mechanisms. Each fact appears in one
section; step-by-step detail belongs in the pull request description. The
sections, in order:

1. **Progress.** The whole goal in one line, then the done items by name, with
   those finished since the owner's last message in bold, and the remaining
   items by name.
2. **This round.** What each change since the owner's last message does.
   Mention a mistake you caught and fixed, or a routine merge conflict, only
   when it affects the results.
3. **Results.** What now works and its evidence, and what is still
   unverified. At completion this includes the validation run and its
   revision, the review's scope and the findings it fixed, and what the work
   found along the way with each item's disposition.
4. **Why stopped.** When you stopped before finishing, the reason.
5. **Open items.** Every ledger ID with its status; then a decision card for
   each item with a real choice, and one line with your recommendation for
   each item that needs only a yes or no; or one line saying nothing awaits
   the owner.
6. **Project parts.** What the project's AGENTS.md adds to its reports.

Make the report stand alone: give each thing its full name, link every pull
request it names, and restate any earlier context the reader needs.

### When to stop and wait

Before starting, discuss every choice that sets the direction of the work, and
keep discussing while a matter that could change it substantially is unclear.

Once started, work through to completion. A question that leaves the direction
unchanged goes into the ledger with your recommendation, you proceed on that
recommendation, and it reaches the owner in the report. When an item blocks
one line of work, finish every other line first; stop when only work that
depends on the owner remains.

Stop and wait for the owner only for an action that:

- cannot be undone;
- publishes, posts or sends something to people, or merges into a main line;
- belongs to the owner, such as an approval;
- uses another of the owner's machines other than through CI, such as the
  14900K over the home network; or
- rests on an uncertainty that could change the direction of the work.

Standing authorizations: pushing to a work branch, opening and updating its
Draft pull request, running CI on it (hosted or the 14900K runner), the local
checks part 4 allows on the machine your session runs on, and messaging the
owner's other agent sessions.

### Ledger

Every item awaiting the owner gets an ID, `Q1`, `Q2` and on, kept for that
item for the whole conversation; an item enters the ledger with the next
unused number. Refer to an item by its ID, with any internal label such as a
plan step after it. The ledger holds design decisions and operational
authorizations alike, including a direction the owner gave in passing. An
item closes when the owner answers it, by ID or unambiguously; superseding or
withdrawing one takes the owner's agreement, asked in one line with the
reason under open items.

### Decision cards

Put a horizontal rule (`---`) before and after each card. A card opens with
its ID and the question in bold, then:

- **Background.** The problem, limited to what the decision turns on, for a
  reader who has not seen the work: what the component or rule does, what
  goes wrong or stays open, and the concrete evidence. Include a minimal code
  or command example whenever it makes the problem concrete.
- **Options.** A, B and on. Each states what it does, its cost and risks, and
  why it is or is not recommended; mark the recommended one.
- **Confidence N/5.** 5 when evidence settles it, 1 when it rests on
  judgment, with the reason and what could overturn it.

A card for an operational authorization uses the same parts at the length the
action needs. Order cards so each follows the cards it depends on, and
otherwise oldest first.

### Language

Write repository artifacts in English unless the project requires another
language. Talk with the owner in the owner's language, and write reports and
cards in it, headings included.

## 2. Work, review and merge

### Doing a task

Do one task on one pull request, from a Draft to its finish, and keep every
change that serves the task on it; open another only for a change that stands
on its own, and stack dependent pull requests, each on the branch of the one
before it. On resuming, check the actual worktree and pull request state
first. Push coherent progress as you go and keep the description and its
validation results current. When a conclusion or its grounds change, update
the guidance and work that depend on it in the same change, and say which
choices still stand, stand on different grounds or need replacement.

Before changing anything, read its current owners: the design-tree nodes it
touches and their ancestors, the project's references, and the documents
that define what you change. Implement the general
behavior: no test, example, client or benchmark selects a special path, and
no fallback conceals an unsupported feature. Judge correctness against an
oracle independent of the code (the project's reference, a specification, a
test suite, a format's conformance files), never the code's own earlier
output. Ported code keeps its license notice beside it.

Examine the responsibilities, interfaces, representations and affected
consumers of the work for design gaps and clear opportunities for a better
design, even when the current design is valid. When you notice a defect
outside the task, such as a bug, an awkward interface, duplicated logic, an
oversized file or function, or a stale document or test, fix it in the same
change when it is small and inside the files you are changing; otherwise
record it in the project's TODO with its impact, uncertainty, the change you
would make, how to validate it and when to reopen it. List each in the report
and the pull request with its disposition: fixed, deferred or declined, with
the reason.

### Delegating

The owner and the primary agent own the architecture: the design tree, the
module graph, module interfaces with their contracts, and the formats
components exchange. A subagent that finds an interface insufficient reports
the gap to the primary agent with a minimal example and leaves the interface
as it is. Choose each subagent's model by the task's difficulty.

### Completing a task

1. Validate the work with the project's checks.
2. Run one review: a separate, read-only agent that did not implement the
   change applies the review checks of part 3, the standards of part 4 and
   the project's review checklist. It reads the task's requested outcome and
   constraints, the complete diff from the base plus untracked files, less
   any mechanically checked copies the project names, the changed sections in
   context, what they directly affect, the checklist and the actual
   validation results; it stays within the change, reruns no green suite and
   adds no style convention. It marks each checklist item pass, finding,
   unverified or not applicable, missing evidence being no pass; compares a
   changed review rule or expected result with its previous form; and marks a
   question local inspection cannot settle, such as a design argument's
   soundness, unverified for the implementing agent. It reports Scope (its
   model, base..head, checklist groups checked and skipped), Checks (what it
   ran) and Findings (item ID, file:line, quoted text or missing evidence,
   reason; both sides of a contradiction quoted), or "none within scope".
   Approval stays with the owner.
3. Fix every finding; a fix that changes a decision becomes a ledger item.
   Send a fix back for review, limited to what it touched, when it changed a
   decision or rewrote logic or behavior beyond a local repair; check smaller
   fixes yourself and list them in the report. Merging the main line without
   conflicts in reviewed content needs no new review; a resolved conflict is
   reviewed as changed content, those hunks only.
4. Push; confirm the remote head is the reviewed revision plus only the fixes
   the report lists; record the review's scope and fixed findings in the pull
   request's review section; bring its description current; write the
   report.
5. After the owner rules on every open card, write the approval records the
   project keeps, mark the pull request ready once its checks pass, and leave
   the merge to the owner.

### Merging into the main line

- Work-branch changes need no approval beyond part 1's stop list; adding a
  repository-root entry needs the owner's approval.
- A merge into the main line needs the owner's approval of the exact
  revision, the complete tree that will enter it with its pins and
  submodules, and a passing project gate on that revision. A revision that
  changes after either needs both again.
- A change that moves a pinned dependency names the revisions it adopts and
  why; the main line pins revisions on their repositories' main lines.
- These, with the project's extra preconditions, are all the merge
  preconditions.

## 3. Design tree

Apply this part when the repository root contains `design/`.

A design tree records the decisions a project is built on: what was chosen,
because of what, instead of what, organized by concept rather than code
structure. The main line holds only decisions the owner approved.

### Layout

- `design/` at the repository root holds the live trees, the change log and
  the checker.
- Live trees: every root node file `design/<concept>.md` other than `log.md`
  is one tree; a node's children live in the directory of the same name,
  `design/<concept>/`, to any depth.
- Change log: `design/log.md`, newest entry first.
- Checker: the [Design-skill](https://github.com/Ming-Research/Design-skill)
  submodule at `design/skill`, changed only in Design-skill and adopted by
  moving the pin.
- Checks: `make design-lint` checks form on every push, as part of the
  project's static checks; `make design-ready` is the readiness check, run
  before marking a pull request ready and in CI on ready pull requests and
  on the main line. Both run `lint.py` over every live tree.
- The project's AGENTS.md names its research record (where derivations,
  measurements and comparisons live), its maintained TODO and anything its
  readiness check adds.

### What is a decision

A material choice between viable alternatives is a decision, even when the
selection seems obvious: a choice that changes accepted behavior or
persisted state, a safety or trust condition, a shared interface or
representation, a significant performance commitment or a standing project
rule. Task size and file count do not decide it, and a step with only one
viable way needs no record. The owner tunes the threshold when the tree grows
too fine or too thin.

A reason states its kind of ground. A deduction names its premises and only
the conclusion they entail; an empirical reason names what was observed and
under which conditions; a provisional choice names its reason, uncertainty
and reopening condition. A constitutional principle or one measurement shows
that a choice fits, not that it is the only possible one. An open question
names the assumption used to proceed and how it will be checked, and a
proposal or an agent's default stays a ledger item until the owner settles
it. Record a choice's reasons when it settles.

### Node format

A node is a file named for the decision it owns, holding one or more
`Decision:` lines and an optional `Rejected:` list; dates, standalone facts,
measurements and progress appear only as evidence cited in a reason, and
events are named by what happened. Each field occupies one line, with a
blank line between fields; list items directly follow their header.

A `Decision:` line states the choice, its reason after `because`, and the
alternative after `instead of`; at least one of the two is present. Write for
a reader who has not seen the source record, expanding compressed
terminology.

`Rejected:` lists refused alternatives as `- <alternative>: rejected because
<reason>`, one per line, each with a discriminating reason. Re-propose a
rejected alternative only with an account of what changed.

### Keeping the tree lean

Apply three filters to every tree change:

1. Decision, not description: a node that only describes is removed.
2. Grounds, not code: a node records why a choice was made and what it beat;
   an interface or implementation with no alternative behind it gets no node.
3. Normalize upward: state a shared rule once at its common ancestor.

Keep each decision concise: the choice, its decisive reason or refused
alternative (or both), and the qualifications needed to preserve its meaning.
Put detailed derivations, measurements, comparisons and implementation
mechanics in the research record and link directly to that section.

### Changes and approval

On a draft branch, change the live tree in the same work as the
implementation it governs, and keep the two consistent; a decision the tree
does not cover is added to it. A `Decision:` written on a draft branch is
proposed until the owner approves it in the completion report. The owner's
ruling becomes the node's `Decision:`, and each refused option worth
remembering a `Rejected:` item with the reasons its card gave. When the owner
refuses a change, revise or revert it. A change made after approval, other
than one the owner directed, is shown and approved again.

The report lists tree edits that change no decision, such as a rewording,
under its open items: the node, what changed and why, one bullet each. The
owner's approval of the report covers them.

### Log format

After the owner has ruled on every decision of the branch, write one log
entry: a `## <date> <title>` heading, a `Nodes:` line listing every node the
branch added, changed or retired against its base, an `Owner-approved:` line
identifying the owner's approval in the owner's words, and a concise
`Summary:` paragraph with the change and its reasons. The entry is new on the
branch and the approval covers every node it names. Cite data and evidence at
their source in the research record. When parallel branches add entries,
keep both, newest first.

### Review checks

The completion review applies these to the tree diff, the complete work diff
and the relevant existing nodes and ancestors, including for a task without
tree changes.

Design checks:

G1. Decision test. Check each added or changed node against the node format
and leanness filters. Report descriptions without decisions, circular
refusal reasons, and choices or grounds that require the source record to
understand.

G2. Consistency scan. Check changed nodes against ancestors and siblings,
extending to related decisions as needed; a change governing a whole concept
requires reading its subtree. Report nodes read and conflicts, narrowings or
broken dependencies, naming both sides.

G3. Architectural fit. Check that structural choices received the design-gap
examination of part 2 when they were made, and that the result is visible to
the owner. Report concrete gaps or clear improvement opportunities left
without a disposition, including deferred ones missing from the TODO. Judge
the design as built, against its recorded grounds.

Correspondence checks, on the agreed scope, its design commitments, the work
diff, resulting artifacts and validation. Code means whichever artifact
implements a decision, including a specification or configuration; extend
into affected consumers as needed.

DC1. Decisions in code. For each changed region embodying a design choice,
name its node. Report a choice with no node as a missing tree change.

DC2. Contradiction. Report code that contradicts a decision or implements a
refused alternative without a tree change that replaces the decision.

DC3. Orphaned support. For deleted code, identify decisions that lose their
implementation. Report a retired approach missing its rejection rationale,
and rejected approaches still implemented.

DC4. Missing or partial implementation. For each design commitment in scope,
identify support for its required behavior and conditions. Report missing or
partial paths, placeholders and insufficient evidence; a related function
alone is not proof of completion. An explicitly deferred design is in scope
only when the deferral contradicts the scope or the completion claim.

### Lint

`design/skill/lint.py` checks form, not design quality.

    python3 -B design/skill/lint.py --root design --trees <every live tree> [--base <base>] [--require-approval]

With `--base` it also prints node count, depth and decision counts against
the base, which the review reports. `make design-ready` passes the review
base and `--require-approval`: when the tree differs from the base, the
newest log entry must be new, name every changed node and carry a nonempty
`Owner-approved:`, which lint cannot authenticate, so the owner reads the log
before merging. The base is a commit that exposes the changes under review:
for a push to the main line, the revision before the push; in CI,
`sh design/skill/review-base.sh EVENT REF PUSH_BEFORE` prints it. `make
design-lint` also runs the checker's tests,
`python3 -B -m unittest discover -s design/skill -p 'test_lint.py'`.

## 4. Engineering standards

### Priorities

After the project's own first priorities: keep the implementation
understandable and easy to change, add only the evidence needed to trust the
current result, and defer robustness, infrastructure and polish that no
current experiment needs.

### Evidence

A passing result is evidence only if a wrong result would have failed it.
Prefer an observation that separates two hypotheses over one merely
consistent with yours; make each new check fail once for each condition it
protects; read an exit code from the command itself, outside any pipe.
Resolve every commit id, path, count and measurement you report as fact with
a tool when you write it. Another agent's or a reviewer's report is a lead to
verify.

A green result reached by weakening a requirement answers nothing. Keep every
test and check wired; retire one only on purpose, with its technical reason
in the same change. A compiler limitation, a timeout or an unimplemented
feature never rewrites an expected result. A test case earns its place with
an observation no existing case makes and a failure that means something.

A bug fix gets a case that fails before the fix and passes after, or an
account of why the old run is unavailable and how the case detects the
fault; new behavior gets coverage of its normal use and its relevant failure
and boundary; existing coverage that exercises the change suffices, and a
prose-only edit needs no test. A negative case fails for the intended reason,
not an earlier unrelated error. Every removed, skipped, narrowed, regenerated
or weakened test or check has a technical reason in the same change. New or
changed check machinery shows that a representative wrong result or missing
input is detected; reusing established machinery needs no new
demonstration.

Before any build, test batch, measurement or experiment whose duration you
have not seen, run the smallest useful sample, time it and look at its
spread, then choose the scale; repeat or lengthen only where the spread is
too large to decide, and never open with a run of hours.

### Experiments and performance

Plans live in investigations, not up-front planning documents: a selected
direction gets an investigation in the project's research record, which
writes, before it measures, the question, the comparison that could answer it
either way and the result that would reject the proposal; its surviving
decision goes to the design tree. Address the relevant prior objections. A
claimed prediction has an inspectable prior criterion, otherwise the result
is exploratory; a result is reported no wider than what it tested, such as
one model or one workload. Research records and other historical artifacts
are evidence: current guidance supersedes their commands and process
wording, and a research proposal is not an implementation requirement.

A performance comparison names its workload, machine, versions and settings,
and measures every side under the same conditions. A performance change is
attributed with a same-source before-and-after comparison of interleaved
runs, a twin of the base as a noise control, and a falsifier. An agent
writer trial records the model, prompt, context, turns and time of each run,
and keeps expressibility, the agent's success with the supplied help,
composition and cost apart.

### Design judgment

Until a project has real compatibility needs, the effort of changing existing
code, tests, programs or documents, and how many of them a choice touches, is
no reason for or against a design; neither is the effort of building a
mechanism soundly. Work a design needs only because of a poor abstraction is
a flaw of that design. How often something appears in a project's own tests
and programs is no evidence of how often real programs need it. These rules
govern which design is chosen, not which work comes first.

### Repository hygiene

- Put new material in the directory that owns its kind, and ask when none
  fits.
- Create a file, directory, script or document only when you can name what it
  serves, its home and when it will be removed. A script ships wired to a
  caller or is deleted after its one use; a document is kept current or
  deleted.
- Prefer native tooling; a new script states why the native path cannot do
  the job.
- Supersede in place: when new material replaces old, update, merge or delete
  the old in the same change. Keep load-bearing paths where specifications,
  tests, scripts and gates pin them.
- Preserve unrelated changes in a dirty worktree; change only what the task
  covers and the small fixes part 2 allows. Keep scratch output, personal
  paths, credentials and machine-local setup out of the repository.
- Each document holds what serves its reader, without editorial history or
  process inserted into substantive text: one owner states a definition and
  others point to it, a reference resolves to its intended file, heading or
  symbol, and a cited passage supports the claim citing it. Maintained
  guidance owns the rules; a pull request description describes its change.
- A claim says whether it is a goal, a proposal, specified behavior, an
  implemented capability or a dated measurement; a historical position is not
  a conflicting current instruction. Instructions name real commands and
  prerequisites, runnable examples are checked through the ordinary path,
  fragments are not offered as complete programs, and a changing status or
  version is stated in one place.
- Describe work in precise, neutral technical wording: the concrete rule,
  failure and expected behavior, with material risks reported accurately,
  ordinary correctness issues described in correctness terms, and the work's
  purpose stated plainly within platform safeguards.

### Machines

Run builds and tests in CI: GitHub-hosted runners by default, adding a
temporary workflow on the branch when no existing one runs what you need and
removing it before the branch is ready. The owner's i9-14900K is the
organization's self-hosted runner `14900k` (labels `self-hosted`, `14900k`):
use it through CI for heavy test runs and for every precise timing or
performance measurement, check that it is idle, and tell the other sessions
before a long run. On the owner's computer, run only checks that compile
nothing, or what CI cannot do, and say so in the report.
