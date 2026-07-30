# Business & Architecture Rules

This file defines *what* the project is and the architectural rules it must
follow. Process rules (how Claude and the user work together) live in
[CLAUDE.md](CLAUDE.md).

## Project concept

"Battle of the Bands: Streaming Edition" — a fictional, Spotify-like music
streaming service, used purely as a learning vehicle for multi-cloud
Terraform. All providers, resources, and data are placeholders/fake:

- **AWS** — audio ingest & storage (raw audio files, track metadata,
  transcoding triggers).
- **Azure** — user accounts & playlists (playlists, users, "playlist
  shared" notifications).
- **GCP** — listening analytics & charts (top-charts calculation, real-time
  play events).

The information is not required to be true to how a real streaming service
works. The goal is to learn Terraform workflows: providers, resources, data
sources, modules, variables/outputs, state, and multi-cloud composition —
not to build a real product.

## No real cloud interaction

- Everything is simulated using `terraform_data` / `null_resource` and
  locals standing in for real resource types.
- No real AWS/Azure/GCP account, credentials, or billing is used at any
  point.
- `required_providers` blocks for `aws`, `azurerm`, and `google` are declared
  with realistic version constraints so the syntax is learned properly, even
  though the providers are not exercised against real infrastructure.
- Terraform state is local to start. A real S3 (or equivalent) backend
  block may be written and documented for learning purposes, but kept
  commented out / inactive — it is not pointed at a real bucket unless the
  user explicitly decides to change this rule later.

## Cloud coupling ("loose wiring")

- AWS's ingest stack produces a fake output (e.g. a simulated "new track"
  identifier) that GCP's analytics stack consumes, simulating "new track
  available for chart tracking."
- Azure's accounts/playlists stack produces a fake output (e.g. a simulated
  "play event") that GCP's analytics stack also consumes, simulating "user
  played a track" feeding the charts pipeline.
- Since state is local (not a shared real backend), this coupling is
  simulated via local values / variables passed between modules in the same
  apply, documented clearly as a stand-in for what a real cross-account
  remote-state data source would do.

## Environments and branches

- Two environments: `dev` and `prod`, implemented as separate directories
  (`envs/dev`, `envs/prod`), each with its own state and each calling the
  shared modules under `modules/`.
- Two long-lived git branches: `dev` and `prod`, mirroring the environments.
- Each branch's environment folder only ever references its own
  environment's module instances and variables.
- No merging in a direction that would mix environment data — e.g. the
  `prod` branch must never be merged into the `dev` branch. Work flows
  forward (dev → prod when promoting a change), never backward.
- This is enforced by GitHub branch protection rules in addition to being a
  documented convention.

## Naming conventions

- No duplicate resource or module instance names anywhere in the project.
- Any shared module instantiated per environment must have its name suffixed
  with the environment it belongs to: `<name>_dev` / `<name>_prod`. A bare,
  environment-ambiguous name is not allowed for anything environment-scoped.
- Names should clearly describe the fake resource's role in the streaming
  theme (e.g. `aws_s3_bucket.raw_audio_dev`,
  `google_bigquery_dataset.weekly_top_charts_prod`) rather than generic
  placeholders like `bucket1`.

## Versioning

- Terraform CLI: `required_version = "~> 1.9"`.
- Provider version constraints declared per provider (`aws`, `azurerm`,
  `google`) using `~>` pessimistic constraints, pinned to current stable
  major versions at the time they're introduced, documented with a source
  link per rule 4 in CLAUDE.md.

## Testing and CI

- Every module and environment must be validated via:
  1. `terraform fmt -check`
  2. `terraform validate`
  3. `terraform plan` (against local/fake state, no real credentials)
  4. `terraform test` (native test framework) with real test cases
     asserting expected outputs/attributes.
- GitHub Actions runs this on every pull request. Merge is blocked unless
  all checks pass.
- Branch protection additionally blocks any merge from `prod` into `dev`.
