# edgar-github-config

Terraform config for GitHub repository governance across the Edgar Pipeline repos. It manages rulesets only, no cloud infrastructure.

## What it manages

A "Protect main" branch ruleset on each repo:

| Repo             | Ruleset ID | Rules                                                                                                                              |
| ---------------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `edgar-fetcher`  | 24042796   | no deletion, no force-push, PR required (squash only), required checks: `check-schema-drift`, `build-test`, `Validate PR title`   |
| `edgar-schemas`  | 24042851   | no deletion, no force-push, PR required (squash only), required checks: `validate-schema`, `Validate PR title`                     |
| `edgar-pipeline` | 24042888   | no deletion, no force-push, PR required (squash only), required checks: `validate-manifests`, `Validate PR title`                 |

Not managed here: general repo settings (merge-method checkboxes, squash commit title default). Those are still manual.

## Files

- `providers.tf`: Terraform and provider version requirements, GitHub provider config
- `main.tf`: the three rulesets and the shared `locals`
- `.terraform.lock.hcl`: provider version lock, committed on purpose

## Prerequisites

- Terraform (see `required_version` in `providers.tf`)
- A GitHub token with admin access to the repos, provided through the environment. Never commit it.

```bash
export GITHUB_TOKEN="$(gh auth token)"
```

## Usage

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

Review the plan before applying. `terraform plan` should report no changes unless you edited the config. An unexpected diff means the live ruleset was changed outside Terraform, so find out why before applying.

## State

State is local (`terraform.tfstate`) and gitignored. Back it up manually. If it's lost, re-import each ruleset using the IDs above:

```bash
terraform import github_repository_ruleset.edgar_fetcher_main edgar-fetcher:24042796
terraform import github_repository_ruleset.edgar_schemas_main edgar-schemas:24042851
terraform import github_repository_ruleset.edgar_pipeline_main edgar-pipeline:24042888
```

Then run `terraform plan` and confirm it's empty before applying anything.

## Adding or changing required checks

- A check's `context` is the check run name: the job's `name:` if it has one, otherwise the job id. Confirm it with `gh pr checks <pr>` before requiring it.
- GitHub can only offer a check it has seen report at least once.
- Set `integration_id = 15368` (the GitHub Actions app) on every `required_check`. Without it, Terraform sets the ID to 0 and any app can satisfy the check.
- A ruleset allows only one `required_status_checks` block. Edit it, don't add a second.

## Known limitations

- `require_extra_approval_for_unattributed_changes` can't be managed by the provider (integrations/terraform-provider-github#3664). GitHub defaults it to `true` when a payload omits it. If you turn it off in the UI, the next Terraform update to that ruleset turns it back on.
- Don't edit these rulesets in the GitHub UI. Terraform will revert them on the next apply.
