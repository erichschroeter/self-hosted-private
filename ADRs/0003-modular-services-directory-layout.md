# ADR-0003: Modular Services Directory Layout

## Status
Accepted

## Context
A self-hosted deployment workspace often hosts several unrelated helper applications (e.g., Git hosting, dashboard interfaces, proxy servers, developer utilities). 
Putting all services into a single monolithic `compose.yaml` file makes maintenance difficult, makes isolated service restarts cumbersome, mixes unrelated application states, and leads to extremely complex, unreadable files.

We need an organizational layout that allows adding, removing, and updating services with zero impact on other running services.

## Decision
We will employ a **modular directory layout** structured around isolated helper stacks under a single `services/` directory:
1. **Isolated Service Directories**: Every helper application gets its own dedicated folder under the root `services/` folder (e.g., `services/traefik/`, `services/homepage/`, `services/it-tools/`).
2. **Autonomous Stacks**: Each service directory must contain its own self-sufficient `compose.yaml` file, local configuration folders, and state or volume mount targets.
3. **External Common Networks**: Cross-container routing is accomplished strictly using defined external Docker network hooks (e.g., `traefik-net`), rather than bundling services into the same network group or file.
4. **Isolated Documentation**: For clear discoverability, standard service documentation is organized directly inside each respective service folder as a local `README.md` file.

```text
.
└── services/               # Standalone service stacks
    ├── traefik/
    │   ├── compose.yaml
    │   └── README.md       # Local service documentation
    └── homepage/
        ├── compose.yaml
        └── README.md       # Local service documentation
```

## Consequences
- **Pros**:
  - Modular stability: Restarting, updating, or deleting one service has zero effect on the execution or performance of other services.
  - Organization: Clear division of files makes discovering and editing configurations intuitive.
  - Upgradability: Adding new applications is as simple as creating a new folder and writing a standalone `compose.yaml`.
- **Cons**:
  - Independent startup: Containers must be started independently folder-by-folder, rather than using a single repository-wide execution command (with the exception of using a centralized management GUI).
  - External network dependency: Common shared networks (like `traefik-net`) must be explicitly declared as `external` and created beforehand.
