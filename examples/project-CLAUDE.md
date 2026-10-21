# CLAUDE.md — ReschedulingEngine (Team Aurora)

## How to work with me
- Challenge my approach if you see a better one — say so before implementing, with the trade-off.
- Work autonomously on code, tests, and local commands. **Ask first** only for: anything touching prod,
  DB migrations, deleting data/files, deploys, adding dependencies.
- Unsure about a business rule? Ask; don't guess.

## Project
- Python service (FastAPI) handling customer rescheduling. Zero Touch critical path.
- Flow: `POST /reschedule` → EligibilityDSL → SchedulerV2 `Reschedule` gRPC → `job.rescheduled` (Kafka) → NotificationService.
- Storage: PostgreSQL `reschedule_events` (audit log). Flags: Statsig.
- Layout: `services/rescheduling/` (api, handler, clients), `tests/`.

## Commands
- Test: `make test` · Lint/type: `make lint` · Run locally: `make dev`
- A change is done when lint + tests pass and changed lines are covered.

## Domain invariants (non-negotiable — flag violations in review)
- Every reschedule passes the eligibility check. No path bypasses it.
- Every mutation is idempotent: client-supplied idempotency key, dedupe before side effects.
- DB write + event publish go through the transactional outbox — never publish directly after an RPC.
- Every external call has a timeout/deadline and explicit error handling; gRPC errors are exceptions.
- No blocking I/O inside `async` handlers.
- Kafka events keyed by `job_id`.
- New behavior ships behind its own Statsig flag with rollback criteria.

## Testing
- Bug fix → failing test first.
- Every external call → failure-path test (timeout, error, duplicate).
- Mock clients via dependency injection; no network in unit tests.

## Safety
- Never read, print, or commit secrets. Secrets come from env / secrets manager only.
- Never run `./deploy.sh` or connect to prod.
