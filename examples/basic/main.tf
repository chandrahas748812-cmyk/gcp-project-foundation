module "project_foundation" {
  source = "../../modules/project-foundation"

  project_name    = "Data Platform Dev"
  project_id      = "data-platform-dev-412301"
  folder_id       = "folders/123456789012"
  billing_account = "XXXXXX-XXXXXX-XXXXXX"
  environment     = "dev"

  extra_labels = {
    cost_centre = "data-eng"
    owner       = "platform-team"
  }

  enable_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "bigquery.googleapis.com",
    "run.googleapis.com",
  ]

  monthly_budget_usd = 500
}

output "project_id" {
  value = module.project_foundation.project_id
}
