# CLAUDE.md — Rules of Engagement for this Project

These are binding process rules for how Claude must operate in this repository.
They override Claude's normal defaults. If any instruction elsewhere conflicts
with this file, this file wins unless the user explicitly overrides it in the
moment.

Project business/architecture rules live separately in
[business-rules.md](business-rules.md) — this file is about *how we work*,
not *what we're building*.

## 1. Claude never applies changes directly

- Claude must never use file-write/edit tools or run shell commands that
  change this repository's files, git state, or any external state.
- Every change is delivered as text: full file contents or a diff/patch,
  plus any exact shell/git commands needed — for the user to copy, review,
  and run themselves.
- Exception: none, going forward. (A one-time bootstrap exception was used
  to create the initial `CLAUDE.md` and `business-rules.md` files only,
  approved explicitly by the user on 2026-07-29.)

## 2. No change without explicit consent

- Claude must never bundle multiple changes into one approval.
- Each proposed change is presented on its own, with an explanation of what
  it does and why, and Claude waits for explicit approval before considering
  it "agreed" — even if a related change was approved earlier in the
  conversation.
- Silence or approval of a plan is not approval of implementation details
  invented afterward. If Claude must make a judgment call (a default value,
  a version number, a naming choice), it asks — it does not decide alone and
  say "I'll proceed with that."

## 3. Small changes, one commit each

- Work proceeds as a series of small, single-purpose changes, not large
  batches.
- After the user applies a change, Claude provides a commit title (and short
  body if useful) describing that specific change, for the user to commit.
- Commit titles should be clear and specific enough that `git log` alone
  tells the story of the project.

## 4. Documentation-backed decisions only

- Claude must not invent solutions from general training assumptions when a
  documented, official answer exists.
- Acceptable sources, in order of preference:
  1. Official docs: developer.hashicorp.com/terraform, registry.terraform.io
     (provider docs), official AWS/Azure/GCP documentation.
  2. Reputable community sources when official reference docs don't cover a
     workflow question: official HashiCorp Learn tutorials, official
     HashiCorp/provider GitHub example repositories.
- When proposing a non-trivial decision (module structure, resource
  arguments, workflow pattern), Claude states which source backs it.
- If no solid source can be found, Claude says so explicitly rather than
  guessing.

## 5. Failure and success logging

Two separate log files, both in [.claude/](.claude/):

- [changelog.md](changelog.md) — every change that was tried and
  applied successfully. This is the "last known good" trail.
- [failed-attempts.md](failed-attempts.md) — every change that was
  tried and did not work (failed apply, failed test, failed validation, or
  the user rejected it as wrong). Includes what was tried and why it failed.

Rules:
- If something fails, it is logged in `failed-attempts.md` and Claude must
  **never propose that same approach again** in this project. Before
  proposing a new approach, Claude should check `failed-attempts.md` so it
  doesn't repeat a dead end.
- If something works, it is logged in `changelog.md` immediately.
- If a later change breaks things, the recovery point is not necessarily
  "the last commit" — it's the last entry in `changelog.md` marked as
  working, which may be more precise than the last commit if a commit
  bundled a working change with an in-progress one.

## 6. Testing and CI are mandatory gates

- Nothing merges without passing tests. This is enforced by GitHub Actions.
- CI runs on every pull request and must pass before merge is allowed:
  1. `terraform fmt -check` (formatting)
  2. `terraform validate` (syntax/internal consistency)
  3. `terraform plan` (using local/fake state — no real cloud credentials
     are ever used or required)
  4. `terraform test` (native Terraform test framework) covering the
     project's modules — asserting expected outputs/attributes.
- Branch protection on GitHub should require these checks before merge.

## 7. Naming and structure discipline

- No duplicate names across modules/resources.
- Shared modules instantiated per environment must be named to show which
  environment they belong to, e.g. `name_dev` / `name_prod` — never a bare
  ambiguous name reused across environments.
- See [business-rules.md](business-rules.md) for the full naming and
  environment/branch isolation rules.

## 8. Communication style for this project

- Claude explains *why* before *what* for any non-trivial proposal.
- Claude asks rather than assumes on anything ambiguous — defaults,
  versions, structure, naming — even if there's a "sensible" answer.
- Claude does not narrate intent to act ("I'll proceed with...") — it either
  asks a clarifying question or presents the concrete change for approval.
