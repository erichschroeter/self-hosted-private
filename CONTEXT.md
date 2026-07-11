# Context: Self-Hosted Services Infrastructure

This context covers the local self-hosted infrastructure repo, featuring containerized stacks running via Docker Compose, routed through a local reverse proxy with direct host port fallback options, and configured dynamically via multi-context environments.

## Glossary

- **Services Directory**: The top-level `services/` folder containing isolated subdirectories for each application (such as `traefik/`, `homepage/`, `open-webui/`, `forgejo/`, `it-tools/`, `omni-tools/`, `dumbpad/`, `arcane/`).
  - *Constraint*: Every service stack must live in its own subdirectory under the `services/` folder.
- **Traefik Reverse Proxy**: The primary reverse proxy container that routes domain-based requests (e.g., `*.localhost` or custom domains like `*.prplalpca.com`) to individual container services.
  - *Constraint*: Must be the first service started, as it initializes the shared external `traefik-net` network.
- **Fallback Port**: A static port mapped directly from the host system to a container (e.g., mapping port `8081` on the host to port `80` on the `it-tools` container). This provides secondary access if Traefik is offline or when custom domains/subdomains are blocked on certain networks.
  - *Constraint*: Every service intended for direct user access must specify a distinct fallback port mapped on `127.0.0.1` or `0.0.0.0` inside its `compose.yaml`.
- **Environment-Driven Configuration**: Parameterizing deployment files using environment files (`.env`). Specific context environments (such as home and work) are stored in `env/home.env` and `env/work.env` respectively.
  - *Constraint*: Local secrets or environment-specific values must never be hardcoded into the `compose.yaml` file; they must be referenced via environment variables and loaded from a `.env` file copied from `env/*.env`.
- **Multi-Context Integration**: Designing a deployment to support multiple distinct operational environments (such as a personal home server context vs. a work laptop context) without fracturing codebase architecture.
- **Compose-First Management**: A deployment orchestration approach where an administrative GUI (such as Arcane) manages container stacks by scanning and mounting the parent repository directory, providing real-time UI controls over existing `compose.yaml` files.
  - *Constraint*: The management GUI must mount the parent directory (`../:/app/data/projects`) to maintain automatic discovery.
