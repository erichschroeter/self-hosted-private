# ADR-0005: Automated Zero-Hardcode Context Switching

## Status
Accepted

## Context
Our environment-driven homelab architecture requires deploying containers across multiple contexts (Home server and Work laptop).
Previously, switching contexts required manual configuration, copying files, or running hardcoded service-specific symlink switches. As our service portfolio expanded to 15+ containers across public and private sibling repositories, managing files manually or maintaining hardcoded switch statements inside scripts created massive maintenance overhead.

We need a unified, automated, and completely generic way to switch contexts without hardcoding individual service names or layout files.

## Decision
We will implement a fully generic context-switching shell framework (`switch-context.sh`) in the repository root.
The framework operates based on two highly abstract patterns:

1. **Environment Linking**: For any service directory that contains an `env/` folder, the script automatically links the context-appropriate template (`env/home.env` or `env/work.env`) to `.env` at the service root.
2. **Dynamic Configuration Discovery (`*.<context>.<ext>`)**:
   Instead of hardcoding filenames, the switcher uses a pruned `find` command to dynamically locate any file matching `*.<context>.<ext>` inside any service subdirectory (such as `services/homepage/config/services.home.yaml` or `services/arcane/compose.override.home.yaml`). It calculates the destination name by stripping the `.<context>` substring (e.g., creating `services.yaml` or `compose.override.yaml`) and creates a relative symbolic link inside that folder.

## Consequences
- **Pros**:
  - **Zero Maintenance**: Adding new custom layouts, configurations, or overrides for any current or future service requires absolutely zero script changes.
  - **Simplicity**: Users switch their entire workspace (both public and private repos) using a single, unified command: `./switch-context.sh [home|work]`.
  - **Clean Git Status**: By combining this with local `.gitignore` files, all generated symlink outputs are hidden from Git, preventing context switches from polluting `git status`.
- **Cons**:
  - Requires developers to strictly follow the `*.<context>.<ext>` naming convention for any context-dependent config files.
