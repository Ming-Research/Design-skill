---
name: design-tree
description: "The owner's working rules for agents: reports to an owner who reads only the last message, when to stop, the ledger of items awaiting the owner and decision cards, one task per pull request with one completion review, and a design tree of the decisions a project is built on, checked against the code (design and correspondence checks G1-G3, DC1-DC4). Use when a task asks the owner to decide anything, reports to the owner, edits a design tree or its log, or reviews design and implementation for correspondence."
---

<!-- Backup copy of the owner-wide agent instructions, kept in step with
them; projects load those instructions directly, not this skill. -->

# Owner-wide agent instructions

A project's own AGENTS.md holds only what is specific to that project: its
goal and priorities, references, paths, checks, review checklist, merge rules,
project-only rules and the extra parts its reports carry. It leaves out what
these instructions say and what holds for a night or a week.

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

Keep a report short enough to read in two minutes; length buries what
matters. The owner knows the projects, their components and their
established terms, so explain only what is new since the owner last read:
names you introduced, internal plan labels, new mechanisms. State each fact
once, and leave step-by-step detail to the pull request description.

A report covers the time since the owner's last message, in this order:

1. **Progress.** The whole goal in one line, then a list of what is done,
   with the items finished since the owner's last message in bold, and a list
   of what remains.
2. **This round.** What you did since the owner's last message and what each
   change does. Mention a mistake you caught and fixed, or a routine merge
   conflict, only when it affects the results.
3. **Results.** What now works, the evidence for it, and what is still
   unverified.
4. **Why stopped.** When you stopped before finishing, the reason.
5. **Open items.** Every ledger ID with its status, then a decision card for
   each item that needs the owner's ruling, or one line saying none does.
6. **At completion,** also: the validation run and its revision, the review's
   scope and the findings it fixed, what the work found along the way with
   each item's disposition, and the parts the project's AGENTS.md adds.

Make the report stand alone: give each thing its full name, and restate in
the report any earlier context the reader needs.

### When to stop and wait

Before starting, discuss every choice that sets the direction of the work, and
keep discussing while a matter that could change it substantially is unclear.

Once started, work through to completion. When a question arises, add it to
the ledger with your recommendation, proceed on that recommendation, and bring
it to the owner in the report. When an item blocks one line of work, finish
every other line first; stop when only work that depends on the owner
remains.

Stop and wait for the owner only for an action that:

- cannot be undone;
- reaches outside the repository's work branch, such as publishing, posting or
  messaging;
- belongs to the owner, such as an approval or a merge into the main line;
- uses one of the owner's machines directly, such as the 14900K over the home
  network; or
- rests on an uncertainty that could change the direction of the work.

### Ledger

Every item awaiting the owner gets an ID, `Q1`, `Q2` and on, kept for that
item for the whole conversation; an item enters the ledger with the next
unused number. Refer to an item by its ID, with any internal label such as a
plan step after it. The ledger holds design decisions and operational
authorizations alike, including a direction the owner gave in passing. An
item stays open until the owner answers its ID; superseding or withdrawing
one takes the owner's agreement, asked in one line with the reason under open
items. Reports list every ID with its status, for example "Q1, Q2 approved;
Q3 approved with a change; Q4 open".

### Decision cards

A card is for an item with a real choice between options. Put a horizontal
rule (`---`) before and after each card. A card opens with
its ID and the question in bold, then:

- **Background.** The problem, limited to what the decision turns on, for a
  reader who has not seen the work: what the component or rule does, what
  goes wrong or stays open, and the concrete evidence. Include a minimal code or command example whenever it makes the
  problem concrete.
- **Options.** A, B and on. Each states what it does, its cost and risks, and
  why it is or is not recommended; mark the recommended one.
- **Confidence N/5.** 5 when evidence settles it, 1 when it rests on
  judgment, with the reason and what could overturn it.

A card for an operational authorization uses the same parts at the length the
action needs. Order cards oldest first, each after the cards it depends on.

### Language

Write repository artifacts in English unless the project requires another
language. Talk with
the owner in the owner's language, and write reports and cards in it,
headings included.

## 2. Pull requests and completion

Do one task on one pull request, from a Draft to its finish, and keep every
change that serves the task on it; open another only for a change that stands
on its own. On resuming, check the actual worktree and pull request state
first. Push coherent progress as you go and keep the description and its
validation results current. When a conclusion or its grounds change, update
the guidance and work that depend on it in the same change. Finish a task before starting the next:

1. Validate the work with the project's checks.
2. Run one review: a separate, read-only agent that did not implement the
   change applies the review checks of part 3 together with the project's
   review checklist, and reports its scope, revision, findings with evidence,
   and uncertainty. The project names the model and checklist. A review
   approves nothing.
3. Fix every finding; a fix that changes a decision becomes a ledger item.
   Send a fix back for review, limited to what it touched, when it changed a
   decision or rewrote logic or behavior beyond a local repair; check smaller
   fixes yourself and list them in the report.
4. Push, confirm the remote head is the reviewed revision, bring the pull
   request description current, and write the report.
5. After the owner rules on every open card, write the approval records the
   project keeps, mark the pull request ready once its checks pass, and leave
   the merge to the project's merge rules.

Examine the responsibilities, interfaces, representations and affected
consumers of the work for design gaps and clear opportunities for a better
design, even when the current design is valid. Likewise, when you notice a
defect outside the task, such as a bug, an awkward interface, duplicated
logic, an oversized file or function, or a stale document or test, fix it in
the same change when it is small and inside the files you are changing;
otherwise record it in the project's TODO with its impact, uncertainty, the
change you would make, how to validate it and when to reopen it. List each in
the report and the pull request with its disposition (fixed, deferred or
declined) and reason.

## 3. Design tree

Apply this part when the repository root contains `design/`; skip it
otherwise.

A design tree records the decisions a project is built on: what was chosen,
because of what, instead of what, organized by concept rather than code
structure. The main line holds only decisions the owner approved; a draft
branch changes the tree freely, and the owner's approval, recorded in the
log, lets it become ready. Git holds history.

The project's AGENTS.md maps these roles to its paths:

- Live tree: one file per node, with children in a directory of the same name.
- Change log: one entry per approved change, newest first.
- Research record: where derivations, measurements and comparisons live.
- Maintained TODO: where deferred work is recorded.
- Form check and readiness check: the lint invocations below.

### Node format

A node is a file named for the decision it owns, holding one or more
`Decision:` lines and an optional `Rejected:` list. It holds decisions only;
cite dates, standalone facts, measurements and progress as evidence in a
reason, and name events by what happened. Each field occupies one line, with a
blank line between fields; list items directly follow their header.

A `Decision:` line states the choice, its reason after `because`, and the
alternative after `instead of`; at least one of the two is present. Write for
a reader who has not seen the source record, expanding compressed
terminology.

`Rejected:` lists refused alternatives as `- <alternative>: rejected because
<reason>`, one per line, each with a discriminating reason. Re-propose a
rejected alternative only with an account of what changed.

### What is a decision

A choice between viable alternatives is a decision, even when the selection
seems obvious; an implementation step with only one viable way needs no
record. Start coarse; the owner tunes the threshold when the tree grows too
fine or too thin.

A reason states its kind of ground. A deduction names its premises and only
the conclusion they entail; an empirical reason names what was observed and
under which conditions; a provisional choice names its reason, uncertainty
and reopening condition. A constitutional principle or one measurement shows
that a choice fits, not that it is the only possible one. Keep an open
question open: name an assumption used to proceed and how it will be checked,
and keep a proposal or an agent's default as a ledger item until the owner
settles it.

### Keeping the tree lean

Apply three filters to every tree change:

1. Decision, not description: every `Decision:` line has `because` or
   `instead of`.
2. Not derivable from code: a node states a choice, not an interface or
   implementation the code already shows.
3. Normalize upward: state a shared rule once at its common ancestor.

Keep each decision concise: the choice, its decisive reason or refused
alternative (or both), and the qualifications needed to preserve its meaning.
Put detailed derivations, measurements, comparisons and implementation
mechanics in the research record and link directly to that section; the tree
explains the choice on its own.

### Changes and approval

On a draft branch, change the live tree in the same work as the
implementation it governs, and keep the two consistent as the work goes. The
owner approves the decisions shown in the completion report; writing one does
not approve it. The owner's ruling becomes the node's `Decision:`, and each
refused option worth remembering a `Rejected:` item with the reasons its card
gave. When the owner refuses a change, revise or revert it. A change made
after approval, other than one the owner directed, is shown and approved
again.

A report lists tree edits that change no decision, such as a rewording, under
its open items: the node, what changed and why, one bullet each.

### Log format

After the owner has ruled on every decision of the branch, write one log
entry: a `## <date> <title>` heading, a `Nodes:` line listing every node
added, changed or retired, an `Owner-approved:` line identifying the owner's
approval in the owner's words, and a concise `Summary:` paragraph with the
change and its reasons. The approval covers every node the entry names. The
newest entry is new on the branch and names every changed node. Cite data and
evidence at their source in the research record. When parallel branches add
entries, keep both, newest first.

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
examination of part 2 and that the result is visible to the owner. Report
concrete gaps or clear improvement opportunities left without a
disposition, including deferred ones missing from the TODO. Judge the
design as built; leave speculative generality and reconstructed rationale
out.

Correspondence checks, on the agreed scope, its design commitments, the work
diff, resulting artifacts and validation. Code means whichever artifact
implements a decision, including a specification or configuration; extend
into affected consumers as needed.

DC1. Decisions in code. For each changed region embodying a design choice,
name its node. Report a choice with no node as a missing tree change;
ordinary implementation steps need no record.

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

`lint.py`, from the Design-skill submodule the project names, checks form, not
design quality. Its layout has one root node file and optional child directory
per concept, with `log.md` beside the roots.

    python3 -B <skill-directory>/lint.py --root <design-directory> --trees <concept> ... [--base <base>] [--require-approval]

Without `--base` it checks form only. With `--base` it also prints node count,
depth and decision counts against the base, which the review reports. With
`--require-approval` it is the readiness check: when the tree differs from the
base, the newest log entry must be new, name every changed node and carry a
nonempty `Owner-approved:`, which lint cannot authenticate; the owner reads
the log before merging. A `--base` resolves to a commit that exposes the
changes under review: for a push to the main line, the revision before the
push. In CI, `sh <skill-directory>/review-base.sh EVENT REF PUSH_BEFORE`
prints that base.

## 4. Engineering standards

### Evidence

A passing result is evidence only if a wrong result would have failed it.
Prefer an observation that separates two hypotheses over one merely
consistent with yours, make each new check fail once for each way it can
fail, never check a transform against its own output, and read an exit code
directly, not through a pipe. Resolve every commit id, path, count and
measurement with a tool when you write it. Another agent's or a reviewer's
report is a lead to verify, not evidence.

A green result reached by weakening a requirement answers nothing. Keep every
test and check wired; retire one only on purpose, with its technical reason
in the same change. A compiler limitation, a timeout or an unimplemented
feature never rewrites an expected result.

Size a run before starting it: run the smallest useful sample, time it, look
at its spread, then choose the scale; repeat or lengthen only where the spread
is too large to decide. Record a discriminating experiment's criterion before
using its result to choose.

### Design judgment

Judge a design by its merits. Until a project has real compatibility needs,
the effort of changing existing code, tests, programs or documents, and how
many of them a choice touches, is no reason for or against it; work a design
needs only because of a poor abstraction is a flaw of that design. How often
something appears in a project's own tests and programs is no evidence of how
often real programs need it. Nor is the effort of building a mechanism soundly
a reason to choose or refuse it; the rule governs which design is chosen, not
which work comes first. Record a choice's reasons when it settles, not by
reconstruction at completion.

### Repository hygiene

- Add a repository-root entry only with the owner's approval; put new material
  in the directory that owns its kind, and ask when none fits.
- Create a file, directory, script or document only when you can name what it
  serves, its home and when it will be removed. A script ships wired to a
  caller or is deleted after its one use; a document is kept current or
  deleted.
- Prefer native tooling; a new script states why the native path cannot do
  the job.
- Supersede in place: when new material replaces old, update, merge or delete
  the old in the same change.
- Preserve unrelated changes in a dirty worktree; change only what the task
  covers.
- Each document holds what serves its reader: one owner states a definition
  and others point to it, and a cited passage supports the claim citing it.
  A pull request description describes its change and is never a source of
  project rules.
- Describe work in precise, neutral technical wording: the concrete rule,
  failure and expected behavior, with material risks reported accurately and
  without security or attack framing for ordinary correctness work.

### Machines

Build and test on GitHub-hosted CI, keeping the owner's computer free: push
the work branch and read its runs, adding a temporary workflow on the branch
when no existing one runs what you need, and removing it before the branch is
ready. Run locally only checks that compile nothing, or what CI cannot do,
and say so in the report.

The owner's i9-14900K is a self-hosted CI runner (labels `self-hosted`,
`14900k`): use it through CI for heavy test runs and for every precise timing
or performance measurement. Several projects share it, so check that it is
idle and tell the other sessions before a long run.
