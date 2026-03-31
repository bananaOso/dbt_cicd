# Tasty Bytes dbt CI/CD Demo

Demonstrates CI/CD lifecycle strategies for dbt + Snowflake, based on the
"Git Your Data Together" Snowflake User Group presentation.

## Architecture

### Database Layout (DBT_TASTY_BYTES)

| Schema | Purpose |
|--------|---------|
| `RAW_DBT` | Source data (Tasty Bytes food truck data) |
| `DEV_DBT` | Developer workspace |
| `QA_DBT` | QA/UAT environment (indirect promotion only) |
| `PROD_DBT` | Production |
| `CI_PR_<n>` | Ephemeral CI schemas per pull request |

### dbt Model Layers

```
RAW_DBT (sources)
  -> models/staging/   (1:1 mirrors of source tables)
  -> models/marts/     (business-level aggregations)
       - orders
       - customer_loyalty_metrics
       - sales_metrics_by_location
       - top_selling_items  <-- demo feature
```

---

## Branching Strategies

### Strategy 1: Direct Promotion (Continuous Deployment)

One long-lived branch (`main`). Fast promotion cycle.

```
feature branch  -->  PR to main  -->  CI check  -->  Merge  -->  CD to Prod
```

**Workflows:**
- `.github/workflows/direct_promotion_ci.yml` - Runs `dbt build` in `CI_PR_<n>` schema on every PR
- `.github/workflows/direct_promotion_cd.yml` - Deploys to `PROD_DBT` on merge to main

### Strategy 2: Indirect Promotion (Continuous Delivery)

Two long-lived branches (`main` + `qa`). Adds QA gate before production.

```
feature branch  -->  PR to qa  -->  CI check  -->  Merge to qa  -->  CD to QA
                                                     |
                                          QA validation period
                                                     |
                                          PR from qa to main  -->  CD to Prod
```

**Workflows:**
- `.github/workflows/indirect_promotion_ci.yml` - CI check on PRs to qa
- `.github/workflows/indirect_promotion_cd_qa.yml` - Deploy to `QA_DBT` on merge to qa
- `.github/workflows/indirect_promotion_cd_prod.yml` - Deploy to `PROD_DBT` on merge to main

---

## CI Job Behavior

1. **Listens** for pull requests against the target branch
2. **Builds** all models in an isolated `CI_PR_<n>` schema
3. **Tests** all dbt tests against the CI schema
4. **Reports** pass/fail status back to the PR
5. **Drops** the CI schema when the PR is merged

## CD Job Behavior

1. **Triggers** on merge to the target branch
2. **Runs** `dbt run` against the target schema (prod or qa)
3. **Tests** with `dbt test`
4. **Generates** documentation artifacts

---

## Getting Started

### Prerequisites
- Python 3.11+
- `pip install dbt-snowflake`
- Snowflake account with access to `DBT_TASTY_BYTES`

### Local Development
```bash
# Copy and configure profiles
cp profiles.yml.example profiles.yml
# Edit profiles.yml with your credentials (or set env vars)

# Install packages
dbt deps

# Run all models
dbt run

# Run tests
dbt test

# Full build (run + test)
dbt build
```

### GitHub Secrets Required
| Secret | Description |
|--------|-------------|
| `SNOWFLAKE_ACCOUNT` | Account identifier |
| `SNOWFLAKE_USER` | Service account username |
| `SNOWFLAKE_PASSWORD` | Service account password |
| `SNOWFLAKE_WAREHOUSE` | Warehouse name (e.g. `COMPUTE_WH`) |

---

## Demo Walkthrough

### Simulating the Full Lifecycle

1. **Start on main** - The production-ready code
2. **Create a feature branch** (e.g. `feature/top-selling-items`)
3. **Add a new model** (`models/marts/top_selling_items.sql`)
4. **Open a PR** against main (direct) or qa (indirect)
5. **CI runs** automatically - builds + tests in an isolated schema
6. **Peer review** - use the PR template checklist
7. **Merge** - CD deploys to production (direct) or QA (indirect)
8. **Release** (indirect only) - PR from qa to main triggers prod deployment
