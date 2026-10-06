# Design-skill

A skill for coding agents that keeps a project's design decisions in a
**design tree**: each decision written down with the reason it was made and
the alternatives it beat, approved by the project's owner before it reaches
the main line, and checked against the code that implements it.

It works with Claude Code and Codex, and it is written for any project. Its
checks are a small Python script and a test suite that run locally and in
CI.

## Why

Agents write a lot of code quickly, and the reasons behind it are easy to
lose: they end up spread over pull request threads and conversations, or are
never written down at all. Later work then proposes again an alternative that
was already rejected, or quietly contradicts a choice nobody can find. A
design tree keeps the reasons in the repository, next to the code, in a form
short enough to read and strict enough to check:

- **One place for decisions.** The tree is organized by concept, not by code
  structure. Each node holds one or more decisions and the alternatives they
  refused.
- **The owner decides.** An agent may change the tree freely on a draft
  branch, but the branch cannot become ready until the owner has approved
  every change and the approval is recorded in the log. CI enforces this.
- **Code follows the decisions.** At completion, a separate reviewer checks
  the tree's changes and checks the code against the decisions it implements
  (the Design Correspondence Review).

## What a tree looks like

A project keeps its tree in a directory, usually `design/`: one Markdown file
per node, children in a directory named after their parent, and a change log
beside the root nodes.

```
design/
  log.md            one entry per approved change, newest first
  pipeline.md       a root node
  pipeline/
    style.md        a child of pipeline
    layout.md
```

A node holds `Decision:` lines, each stating the choice, its reason after
`because` and the alternative after `instead of`, and an optional `Rejected:`
list:

```
Decision: Layout lengths are 1/64-pixel fixed-point integers, because fixed
point adds and compares exactly and keeps layout independent of
floating-point rounding, instead of f32 or f64 lengths.

Rejected:
- f64 lengths: rejected because a layout would depend on evaluation order.
```

Each field is one line in the file; the example wraps it for reading. A log
entry names the nodes it changed and records the owner's approval:

```
## 2026-10-01 Use fixed-point layout lengths

Nodes: vocabulary

Owner-approved: The owner agreed to Q12 as recommended.

Summary: Layout lengths become 1/64-pixel integers; the measurements are in
research/investigations/vocabulary/DESIGN.md.
```

[`SKILL.md`](SKILL.md) is the full procedure: the
node format, what counts as a decision, how the owner's decisions are
gathered into decision cards in reports, the log format and the review
checks. It is kept as a copy of the owner's agent instructions, which the
owner's agents load at every session start instead of waiting for the skill
to be triggered.

## Contents

| File | Purpose |
|---|---|
| `SKILL.md` | The procedure, as a skill; a copy of the owner's agent instructions |
| `lint.py` | Form check of a tree and, with `--require-approval`, the readiness check |
| `review-base.sh` | Picks the base revision a CI job compares the tree with |
| `test_lint.py` | Tests for the two scripts above |

The scripts need Python 3, Git and a POSIX shell.

## Using it in a project

A project adds this repository as a Git submodule, which pins the commit it
uses. The skill is changed only here, and a project adopts a change by moving
its pin.

1. **Add the submodule**, for example at `design/skill`:

   ```sh
   git submodule add https://github.com/Ming-Research/Design-skill.git design/skill
   ```

   A fresh clone then needs `git clone --recurse-submodules`, or
   `git submodule update --init` afterwards, and CI checks out submodules
   (`submodules: true` in `actions/checkout`). Until the submodule is
   initialized, the agents do not see the skill.

2. **Expose it to the agents**, unless they already load the procedure as
   standing instructions. From the project's root, link it where Claude Code
   and Codex look for skills:

   ```sh
   mkdir -p .claude/skills .agents/skills
   ln -s ../../design/skill .claude/skills/design-tree
   ln -s ../../design/skill .agents/skills/design-tree
   ```

3. **Map its roles** in the project's agent instructions (`AGENTS.md` or
   `CLAUDE.md`): where the live tree and the log live, where research records
   and deferred work go, and which commands run the checks.

4. **Wire the checks**, for example in a Makefile:

   ```make
   DESIGN_REVIEW_BASE ?= origin/main
   design-lint:
   	python3 -B -m unittest discover -s design/skill -p 'test_lint.py'
   	python3 -B design/skill/lint.py --root design --trees pipeline --base "$(DESIGN_REVIEW_BASE)"
   design-ready:
   	python3 -B design/skill/lint.py --root design --trees pipeline --base "$(DESIGN_REVIEW_BASE)" --require-approval
   ```

   Run `design-lint` on every push, and `design-ready` on pull requests that
   are ready for review and on the main line. In CI, pick the base with
   `review-base.sh`, which needs the full history (`fetch-depth: 0`):

   ```sh
   base=$(sh design/skill/review-base.sh "$GITHUB_EVENT_NAME" "$GITHUB_REF" "$PUSH_BEFORE")
   make design-ready DESIGN_REVIEW_BASE="$base"
   ```

   where `PUSH_BEFORE` is `${{ github.event.before }}`. A draft branch may
   change the tree without an approval; `design-ready` is what keeps
   unapproved changes off the main line.

## Changing the skill

Change it here, by pull request, with the tests passing. A project then
moves its submodule to the merged commit in its own pull request, which names
the Design-skill revision it adopts and why:

```sh
git -C design/skill fetch origin && git -C design/skill checkout <commit>
git add design/skill
```

## Projects using it

- [Whitefoot](https://github.com/Ming-Research/Whitefoot), an
  optimizer-first systems language designed to be written by AI
- [Snowghost-wf](https://github.com/Ming-Research/Snowghost-wf), a renderer
  for user interfaces built with web technology, written in Whitefoot

## License

MIT; see [LICENSE](LICENSE).
