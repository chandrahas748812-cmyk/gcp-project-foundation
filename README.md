# GCP Project Foundation — Terraform Module

> **Portfolio / learning project.** Built to study GCP landing-zone patterns: project hierarchy, IAM, org policies, networking, and Terraform automation. Not production-hardened.

A small, interview-sized Terraform module that creates a GCP project with secure defaults.

## What it creates

- `google_project` — project under an org/folder, with labels for cost attribution
- `google_project_service` (for_each) — least-privilege API enablement
- `google_billing_budget` — spend guardrails: alerts at 50% / 90% / 100%

## Security decisions

1. `deletion_policy = "PREVENT"` — destroy can never nuke the project by accident
2. Least-privilege APIs — minimal default list, opt-in per environment
3. `disable_on_destroy = false` — removing an API from config doesn't break workloads
4. Labels as policy — environment + managed_by + custom labels for chargeback and audit
5. Input validation — project_id regex and environment allow-list fail fast at plan time
6. Budget before workloads — spend alerts exist from day one

## 20-minute interview talk track

1. Architecture (5 min): org → folder → project hierarchy; where IAM, org policy, Shared VPC attach
2. Code (5 min): for_each over APIs, dynamic threshold blocks, merge-based labels
3. Security (5 min): the six decisions above; next steps (IAM conditions, Workload Identity Federation)
4. Validation (5 min): terraform validate in CI; plan as review artifact
