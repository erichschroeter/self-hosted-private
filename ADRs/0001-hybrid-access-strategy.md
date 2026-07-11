# ADR-0001: Hybrid Access Strategy (Traefik + Fallback Ports)

## Status
Accepted

## Context
When running local containerized services on a personal workstation or home server, we want a clean, user-friendly way to access them using descriptive local domains (e.g., `http://it-tools.localhost`) rather than memorizing various arbitrary port numbers. 

However, we face two major constraints:
1. When operating on restricted networks (such as certain corporate, university, or client networks), administrative constraints may block custom DNS resolution, custom virtual hosts, or intermediate network setups.
2. If the reverse proxy container (Traefik) fails to start, is misconfigured, or is stopped for maintenance, all services become completely inaccessible.

We need an access strategy that combines modern, domain-based routing with robust, zero-configuration resilience.

## Decision
We will employ a **hybrid access strategy**:
1. **Primary Access**: Route all web-based container services through a **Traefik Reverse Proxy** container. Services will map to subdomains in the `.localhost` namespace (e.g., `http://homepage.localhost`, `http://it-tools.localhost`), routed dynamically via a shared external Docker network named `traefik-net`.
2. **Fallback Access**: Simultaneously expose every user-facing container service directly on the host using a **static fallback port** mapped in `compose.yaml` (e.g., `ports: - "8081:80"`). 

This ensures that:
- In friendly/standard environments, users access services via clean URLs.
- In restrictive or broken environments, users can immediately and reliably access services using direct socket addresses (e.g., `http://localhost:8081`).

## Consequences
- **Pros**:
  - High availability: If Traefik is down, individual services remain fully functional and accessible.
  - Flexibility: Works seamlessly across varying network environments without forcing network/DNS configuration updates.
  - Local discovery: Simplifies development and testing using clean local subdomains.
- **Cons**:
  - Port management: We must carefully manage and allocate unique static host ports to prevent collisions across the repository's services.
  - Attack surface: Exposing fallback ports on `0.0.0.0` could expose services directly to the local physical network; we must restrict sensitive ports to `127.0.0.1` where necessary.
