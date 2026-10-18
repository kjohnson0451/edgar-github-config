locals {
  common_branch_rules = {
    deletion         = true
    non_fast_forward = true
  }

  common_pull_request = {
    required_approving_review_count   = 0
    dismiss_stale_reviews_on_push     = false
    require_code_owner_review         = false
    require_last_push_approval        = false
    required_review_thread_resolution = true
    allowed_merge_methods             = ["squash"]
    # Live rulesets also set require_extra_approval_for_unattributed_changes = true.
    # The provider can't manage it yet (integrations/terraform-provider-github#3664).
  }
}

resource "github_repository" "edgar_pipeline" {
  name = "edgar-pipeline"

  allow_squash_merge          = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_ruleset" "edgar_pipeline_main" {
  name        = "Protect main"
  repository  = "edgar-pipeline"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    deletion         = local.common_branch_rules.deletion
    non_fast_forward = local.common_branch_rules.non_fast_forward

    pull_request {
      required_approving_review_count   = local.common_pull_request.required_approving_review_count
      dismiss_stale_reviews_on_push     = local.common_pull_request.dismiss_stale_reviews_on_push
      require_code_owner_review         = local.common_pull_request.require_code_owner_review
      require_last_push_approval        = local.common_pull_request.require_last_push_approval
      required_review_thread_resolution = local.common_pull_request.required_review_thread_resolution
      allowed_merge_methods             = local.common_pull_request.allowed_merge_methods
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      do_not_enforce_on_create             = false

      required_check {
        context        = "validate-manifests"
        integration_id = 15368
      }
      required_check {
        context        = "Validate PR title"
        integration_id = 15368
      }
    }
  }
}

resource "github_repository_ruleset" "edgar_schemas_main" {
  name        = "Protect main"
  repository  = "edgar-schemas"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    deletion         = local.common_branch_rules.deletion
    non_fast_forward = local.common_branch_rules.non_fast_forward

    pull_request {
      required_approving_review_count   = local.common_pull_request.required_approving_review_count
      dismiss_stale_reviews_on_push     = local.common_pull_request.dismiss_stale_reviews_on_push
      require_code_owner_review         = local.common_pull_request.require_code_owner_review
      require_last_push_approval        = local.common_pull_request.require_last_push_approval
      required_review_thread_resolution = local.common_pull_request.required_review_thread_resolution
      allowed_merge_methods             = local.common_pull_request.allowed_merge_methods
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      do_not_enforce_on_create             = false

      required_check {
        context        = "validate-schema"
        integration_id = 15368
      }
      required_check {
        context        = "Validate PR title"
        integration_id = 15368
      }
    }
  }
}

resource "github_repository_ruleset" "edgar_schemas_tags" {
  name        = "Protect version tags"
  repository  = "edgar-schemas"
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/tags/v*"]
      exclude = []
    }
  }

  rules {
    deletion = true
    update   = true
  }
}

resource "github_repository" "edgar_fetcher" {
  name = "edgar-fetcher"

  allow_squash_merge          = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_ruleset" "edgar_fetcher_main" {
  name        = "Protect main"
  repository  = "edgar-fetcher"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    deletion         = local.common_branch_rules.deletion
    non_fast_forward = local.common_branch_rules.non_fast_forward

    pull_request {
      required_approving_review_count   = local.common_pull_request.required_approving_review_count
      dismiss_stale_reviews_on_push     = local.common_pull_request.dismiss_stale_reviews_on_push
      require_code_owner_review         = local.common_pull_request.require_code_owner_review
      require_last_push_approval        = local.common_pull_request.require_last_push_approval
      required_review_thread_resolution = local.common_pull_request.required_review_thread_resolution
      allowed_merge_methods             = local.common_pull_request.allowed_merge_methods
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      do_not_enforce_on_create             = false

      required_check {
        context        = "check-schema-drift"
        integration_id = 15368
      }
      required_check {
        context        = "build-test"
        integration_id = 15368
      }
      required_check {
        context        = "Validate PR title"
        integration_id = 15368
      }
    }
  }
}

resource "github_repository" "edgar_schemas" {
  name = "edgar-schemas"

  allow_squash_merge          = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository" "edgar_github_config" {
  name = "edgar-github-config"

  allow_squash_merge          = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_ruleset" "edgar_github_config_main" {
  name        = "Protect main"
  repository  = "edgar-github-config"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    deletion         = local.common_branch_rules.deletion
    non_fast_forward = local.common_branch_rules.non_fast_forward

    pull_request {
      required_approving_review_count   = local.common_pull_request.required_approving_review_count
      dismiss_stale_reviews_on_push     = local.common_pull_request.dismiss_stale_reviews_on_push
      require_code_owner_review         = local.common_pull_request.require_code_owner_review
      require_last_push_approval        = local.common_pull_request.require_last_push_approval
      required_review_thread_resolution = local.common_pull_request.required_review_thread_resolution
      allowed_merge_methods             = local.common_pull_request.allowed_merge_methods
    }
  }
}
