# DevOps CI/CD Pipeline — Portfolio Project

A fully automated CI/CD pipeline built around GitOps principles,
wrapping a real C# application deployed to a personal home lab server.

## Project Goal

Build a production-grade CI/CD pipeline from scratch over 8 weeks,
using GitHub Actions, Docker, and a self-hosted runner on a Proxmox
home lab — demonstrating end-to-end software delivery automation.

## Pipeline Architecture

**Trigger:** Push to main or pull request

| Stage | Description |
|-------|-------------|
| 1 | Run `dotnet test` — fail fast if tests don't pass |
| 2 | Build Docker image tagged with git commit SHA |
| 3 | Push image to Docker Hub |
| 4 | SSH to home lab server, execute deployment script |
| 5 | Health check — curl `/health`, auto-rollback on failure |

## Tech Stack

- **CI/CD:** GitHub Actions with self-hosted runner
- **Containerization:** Docker with multi-stage builds
- **Registry:** Docker Hub
- **Deployment target:** Ubuntu Server 24.04 LTS on Proxmox home lab
- **Application:** [Coursedog Importer](https://github.com/AustinMLove/coursedog-importer) — a real C# tool solving a real     institutional problem
- **Testing:** xUnit
- **Rollback strategy:** Git commit SHA image tagging + automated rollback on failed health check

## Environment Separation

- Pull requests → staging (separate Docker container, different port)
- Merges to main → production

## Project Schedule

8-week self-study and build. Currently in Week 2.

| Week | Focus | Status |
|------|-------|--------|
| 1 | Linux & Bash Fundamentals | ✅ Complete |
| 2 | Git Deep Dive | ✅ Complete |
| 3 | Docker Fundamentals | 🔄 In progress |
| 4 | GitHub Actions & CI Foundation | ⬜ Pending |
| 5 | Home Lab Setup & Deployment Target | ⬜ Pending |
| 6 | Automated Deployment Pipeline | ⬜ Pending |
| 7 | Rollback Mechanisms | ⬜ Pending |
| 8 | GitOps Principles & Documentation | ⬜ Pending |

## Week 1 Artifact — init-csharp.sh

[scripts/init-csharp.sh](scripts/init-csharp.sh) is the Week 1
knowledge checkpoint: a bash script that scaffolds a complete .NET
project structure from the command line, incorporating:

- Shebang and `set -e` for safe execution
- Argument validation and usage messaging
- Idempotency checks
- `dotnet` CLI scaffolding via case statement
- Heredoc-generated file templates
- Numeric chmod for explicit permission control
- Timestamped logging

## Week 2 Artifact — GitHub Feature Branch Workflow

Week 2 produced the Git and GitHub workflow used across both portfolio
repositories for the remainder of the project, applied against real
feature development on the [Coursedog Importer](https://github.com/AustinMLove/coursedog-importer).

The first feature branch `feature/api-authentication` delivered OAuth2
authentication against the Coursedog staging API, completed through the
full PR workflow:

* Trunk-based development with branch protection enforced on `main`
* Feature branch naming conventions (`feature/`, `fix/`, `docs/`, `chore/`)
* Staged commits with descriptive messages
* Pull request descriptions documenting decisions, findings, and next steps
* Full branch lifecycle: create → commit → push → PR → review → merge → delete
* `.gitignore` discipline — credentials never committed
* `git log --oneline --graph` used to verify clean branch history after each merge

## Home Lab

- **Hardware:** Lenovo ThinkCentre M720s
- **Hypervisor:** Proxmox
- **Server OS:** Ubuntu Server 24.04 LTS (VM)
- **Remote access:** SSH over local network, Tailscale for off-site access (planned)

## Design References

GitOps tooling (ArgoCD, Flux) is referenced architecturally in this
project. Full implementation is outside scope but the README documents
where these tools would fit in a production version of this pipeline.
