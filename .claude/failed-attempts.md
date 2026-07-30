# Failed Attempts

Every approach that was tried and did not work — failed apply, failed
test, failed validation, or explicitly rejected by the user as the wrong
approach. Claude must check this file before proposing a new approach and
must never re-propose something logged here.

Each entry: date, what was tried, why it failed / was rejected.

---

## 2026-07-30 — Stale .terraform cache caused false "undeclared" errors
`terraform test -verbose` in modules/aws_ingest failed with "Reference to
undeclared local value" (local.track_id) and "undeclared resource"
(terraform_data.raw_audio, terraform_data.transcode_trigger), even though
main.tf and outputs.tf on disk were correct and matched. Root cause was a
stale `.terraform`/`.terraform.lock.hcl` cache from an earlier init that
predated main.tf's final content. Not a code or design problem — no change
to main.tf/outputs.tf/variables.tf is needed.
Fix that worked: `rm -rf .terraform .terraform.lock.hcl && terraform init`
before re-running tests. Do not re-diagnose this as a config bug if it
recurs — check for a stale cache first.

Separately, an empty stray nested directory
(modules/aws_ingest/modules/aws_ingest/tests) was found and removed during
this investigation. It contained no files and was not the cause of the
error — just leftover clutter, likely from a `mkdir`/`mv` run from the
wrong working directory.
