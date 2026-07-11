# ADR-0004: Compose-First Management with Arcane

## Status
Accepted

## Context
Since services are split modularly into separate subdirectories (as decided in ADR-0003), launching, updating, and monitoring multiple different container stacks requires navigating into several individual folders and running terminal commands. This can be repetitive, especially when managing deployments remotely or when wanting a quick high-level visual overview of active containers.

Traditional central container management tools (like Portainer) often require taking control of the entire Docker socket, importing/re-declaring stacks in custom database states, or introducing complicated external cluster overhead. 

We need a lightweight, visual management control panel that preserves the git-first, file-based nature of our Docker Compose files without taking ownership of them or locking them behind database states.

## Decision
We will employ a **compose-first management architecture** utilizing the Arcane container dashboard:
1. **Repository Mount**: Deploy the Arcane dashboard as a service container under `services/arcane/`.
2. **Directory Mirroring**: Configure Arcane's stack scanner by mounting the parent `services/` directory directly into the Arcane workspace volume (via `../:/app/data/projects`).
3. **No Database Lock-in**: All stack definitions, start/stop actions, and configuration changes are read and written directly to the filesystem's `compose.yaml` files. This allows Git to remain the single, canonical source of truth for all environment configurations.
4. **Real-time Discovery**: When any new folder and `compose.yaml` is added under `services/`, Arcane must automatically discover and display it as an active stack in the UI.

## Consequences
- **Pros**:
  - Declarative integrity: The visual UI directly modifies and executes the local files. There is no discrepancy between what is stored in Git and what is configured in the container engine.
  - Visual convenience: Users can view logs, check container health, and start/stop individual service stacks through a sleek, single-page web dashboard.
  - Automatic indexing: Adding a new directory under `services/` immediately registers it inside the dashboard with zero manual configuration.
- **Cons**:
  - Direct socket access: Arcane requires mounting the host's `/var/run/docker.sock` to control containers, which demands careful network isolation behind Traefik.
  - Relative-path dependency: The volume mapping relies on a precise folder structure (`../:/app/data/projects`); changing the root folder name or relocating Arcane's folder would require correcting the mount.
