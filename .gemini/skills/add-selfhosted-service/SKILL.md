---
name: add-selfhosted-service
description: Guides and automates the creation of a new containerized helper stack inside the self-hosted services repository, enforcing multi-context configs, fallback port assignments starting at 8100, standard README documentation, and optional backup/restore utilities. Use this skill when requested to add, register, bootstrap, or create a new self-hosted service stack.
---

# Add Self-Hosted Service Skill Guide

This skill ensures that all new services added to the self-hosted repo follow the established architectural conventions, multi-context dynamics, secrets isolation, and robust disaster recovery designs.

## High-Level Workflow

Follow these steps sequentially when executing a directive to add a new service:

### Step 1: Scan for Fallback Ports
Run the custom port scanner script in this skill to identify the next available sequential fallback port starting from `8100`:
```bash
node <skill_path>/scripts/scan_ports.cjs
```
Verify the output and assign that port (e.g. `8107`) as the fallback port in the new service's compose file.

### Step 2: Scaffold Directory Structure
Create a dedicated folder for the service under the root `services/` directory and create an `env/` subdirectory:
```bash
mkdir -p services/<service-name>/env
```
*Note: Ensure the service folder name is lowercase (e.g., `services/forgejo/`).*

### Step 3: Implement Multi-Context Compose (`compose.yaml`)
Copy and adapt `references/compose_template.yaml` to `services/<service-name>/compose.yaml`.
- Replace `service-name` / `SERVICE_NAME` with the lowercase name of the new service.
- Replace `image-name` with the official docker container image.
- Set `FALLBACK_PORT` to the port identified in Step 1.
- Set `CONTAINER_PORT` to the standard port exposed by the container (e.g., `80` or `3000`).
- Ensure `env_file` references `.env`.

### Step 4: Implement Context Environments (`env/home.env` & `env/work.env`)
Copy and adapt the environment templates:
- Copy `references/env_home_template.env` to `services/<service-name>/env/home.env`.
- Copy `references/env_work_template.env` to `services/<service-name>/env/work.env`.
- Customize the domain names and default variables inside these environment files to match the new service.
- **Secrets Isolation**: If the service manages database credentials, passwords, or API keys, do not commit them. Scaffold an uncommitted local template file or write-up standard variable names, and instruct the user to set them up inside `services/<service-name>/secrets.env` (merged via compose's `env_file` block).

### Step 5: Implement Backup & Restore (If Stateful)
If the service holds persistent database records or files, scaffold backup and restore scripts inside `services/<service-name>/`:
- Copy `references/backup_template.sh` to `services/<service-name>/backup.sh`.
- Copy `references/restore_template.sh` to `services/<service-name>/restore.sh`.
- Modify both scripts with service-specific dump/extraction commands (e.g., `pg_dump`, `sqlite3` backups, or raw folder copies).
- If the service is stateless, document it as stateless in its local README.md and skip creating backup/restore scripts.

### Step 6: Create Service README Documentation
Create a standard markdown document at `services/<service-name>/README.md` using `references/readme_template.md`.
- Fill out all placeholders (`SERVICE_NAME_CAPITALIZED`, `SERVICE_DESCRIPTION`, `FALLBACK_PORT`, etc.).
- Under the **Backing Up** and **Restoring** sections, document the exact backup and restore scripts or guidelines you set up in Step 5. If stateless, simply note: "*This service is stateless and does not require local data backups or restoration procedures.*"

### Step 7: Update Main Repository Metadata
To maintain discoverability:
1. **Homepage Bookmarks**: Add fallback links for the new service to both `services/homepage/config/bookmarks.home.yaml` and `services/homepage/config/bookmarks.work.yaml`.
2. **README.md**: Add a new row to the main README.md services index table, linking the Read Docs option to `services/<service-name>/README.md`.

### Step 8: Validate Context Switching
Validate that context switching works cleanly by running:
```bash
./switch-context.sh home
# or
./switch-context.sh work
```
Confirm that the symlink `services/<service-name>/.env` is successfully created and points to the relative target `env/home.env` (or `env/work.env`).
