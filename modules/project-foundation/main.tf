terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

resource "google_project" "this" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.extra_labels
  )

  deletion_policy = "PREVENT"
}

resource "google_project_service" "apis" {
  for_each = toset(var.enable_apis)

  project = google_project.this.project_id
  service = each.value

  disable_on_destroy = false
}

resource "google_billing_budget" "this" {
  count = var.monthly_budget_usd > 0 ? 1 : 0

  billing_account = var.billing_account
  display_name    = "${var.project_id}-monthly-budget"

  budget_filter {
    projects = ["projects/${google_project.this.number}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = tostring(var.monthly_budget_usd)
    }
  }

  dynamic "threshold_rules" {
    for_each = [0.5, 0.9, 1.0]
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = "CURRENT_SPEND"
    }
  }
}
