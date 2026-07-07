# Terraform AWS DB Assessment

This repository implements a plan-only AWS infrastructure design with Terraform and a runnable local PostgreSQL workflow for backup, restore, and query optimization.

## What is included

- Terraform modules for `network`, `security`, `alb`, `ecs`, and `rds`
- Separate `dev` and `prod` Terraform environments with different sizing and protection settings
- Docker Compose for a local PostgreSQL database
- SQL migration, indexing, and seed data scripts
- Backup and restore shell scripts
- GitHub Actions workflow for `fmt`, `init`, `validate`, and `plan`

## Architecture

The Terraform design models this flow:

`Internet -> ALB -> ECS/Fargate -> RDS PostgreSQL`

Key design choices:

- Public subnets host the ALB and NAT gateway.
- Private application subnets host ECS/Fargate tasks.
- Private database subnets host RDS and do not have a default internet route.
- RDS is not publicly accessible.
- The RDS security group allows inbound traffic only from the ECS/Fargate security group on port `5432`.
- The Terraform provider is configured for plan-only validation with placeholder credentials so reviewers can run `init`, `validate`, and `plan` locally without a live AWS account.

## Repository layout

```text
infra/
  envs/
    dev/
    prod/
  modules/
    alb/
    ecs/
    network/
    rds/
    security/
database/
  indexes/
  migrations/
  queries/
  seeds/
docker/
  postgres/
scripts/
```

## Terraform environments

Environment differences:

- `dev`
  - ECS: `1` task, `256` CPU, `512` MiB memory
  - RDS: `db.t3.micro`, `20` GiB storage
  - Backup retention: `3` days
  - Deletion protection: `false`
  - Final snapshot skipped: `true`
- `prod`
  - ECS: `2` tasks, `512` CPU, `1024` MiB memory
  - RDS: `db.t3.small`, `50` GiB storage
  - Backup retention: `14` days
  - Deletion protection: `true`
  - Final snapshot skipped: `false`

### Terraform commands

Run these from the repository root.

Dev:

```bash
terraform -chdir=infra/envs/dev init
terraform -chdir=infra/envs/dev fmt -recursive
terraform -chdir=infra/envs/dev validate
terraform -chdir=infra/envs/dev plan -refresh=false -var-file=terraform.tfvars
```

Prod:

```bash
terraform -chdir=infra/envs/prod init
terraform -chdir=infra/envs/prod fmt -recursive
terraform -chdir=infra/envs/prod validate
terraform -chdir=infra/envs/prod plan -refresh=false -var-file=terraform.tfvars
```

PowerShell note: if `terraform plan` complains about extra arguments on Windows, run:

```powershell
terraform --% plan -refresh=false -var-file=terraform.tfvars -input=false
```

from inside `infra/envs/dev` or `infra/envs/prod`.

Note: the local backend is used for reviewability. For a real deployment, replace it with an S3 backend and real AWS credentials.

## Local PostgreSQL setup

### Start the database

```bash
docker compose up -d
```

The container bootstraps the database automatically by running:

- `database/migrations/001_create_tables.sql`
- `database/indexes/001_query_optimization.sql`
- `database/seeds/001_seed_data.sql`

### Verify seeded data

```bash
docker compose exec db psql -U postgres -d hotel_assessment -c "SELECT COUNT(*) FROM hotel_bookings;"
docker compose exec db psql -U postgres -d hotel_assessment -c "SELECT COUNT(*) FROM booking_events;"
```

Expected result:

- `hotel_bookings` should contain `150` rows.
- `booking_events` should contain multiple rows for a subset of bookings.

### Part 5 verification

The seed script intentionally creates:

- `150` hotel bookings
- `5` organizations
- `5` cities: `delhi`, `mumbai`, `bangalore`, `chennai`, `jaipur`
- `4` statuses: `confirmed`, `cancelled`, `pending`, `completed`
- booking events for a subset of bookings

You can verify that with:

```bash
docker compose exec db psql -U postgres -d hotel_assessment -c "SELECT COUNT(*) AS bookings, COUNT(DISTINCT org_id) AS orgs, COUNT(DISTINCT city) AS cities, COUNT(DISTINCT status) AS statuses FROM hotel_bookings;"
docker compose exec db psql -U postgres -d hotel_assessment -c "SELECT city, COUNT(*) FROM hotel_bookings GROUP BY city ORDER BY city;"
docker compose exec db psql -U postgres -d hotel_assessment -c "SELECT status, COUNT(*) FROM hotel_bookings GROUP BY status ORDER BY status;"
docker compose exec db psql -U postgres -d hotel_assessment -c "SELECT COUNT(DISTINCT booking_id) AS bookings_with_events, COUNT(*) AS total_events FROM booking_events;"
```

If you want to rerun initialization from scratch:

```bash
docker compose down -v
docker compose up -d
```

## Query optimization

Target query:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

Added index:

```sql
CREATE INDEX idx_hotel_bookings_city_created_at_org_status
  ON hotel_bookings (city, created_at, org_id, status)
  INCLUDE (amount);
```

Why this index helps:

- `city` comes first because the query filters it with equality.
- `created_at` comes second because the query applies a range predicate over the last `30 days`.
- `org_id` and `status` are part of the grouping, so keeping them in the index reduces extra heap work.
- `amount` is included so PostgreSQL can satisfy the aggregation with fewer table lookups.

Run the optimized query:

```bash
docker compose exec db psql -U postgres -d hotel_assessment -f /workspace/database/queries/optimized_aggregation.sql
```

## Backup and restore

If you are on Windows, run the scripts from Git Bash or WSL so `./scripts/*.sh` works as expected.

Create a timestamped dump:

```bash
./scripts/backup.sh
```

Restore the latest dump into a fresh database named `hotel_assessment_restored`:

```bash
./scripts/restore.sh
```

Restore a specific dump file:

```bash
./scripts/restore.sh backups/postgres-YYYYMMDD-HHMMSS.dump
```

### Verify restore

```bash
docker compose exec db psql -U postgres -d hotel_assessment_restored -c "SELECT COUNT(*) FROM hotel_bookings;"
docker compose exec db psql -U postgres -d hotel_assessment_restored -c "SELECT COUNT(*) FROM booking_events;"
```

The restored counts should match the source database.

## GitHub Actions

The workflow at `.github/workflows/terraform-plan.yml` runs on pull requests and performs:

- `terraform fmt`
- `terraform init`
- `terraform validate`
- `terraform plan`

The plan is published both as a workflow artifact and in the workflow summary.
