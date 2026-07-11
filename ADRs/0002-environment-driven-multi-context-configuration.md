# ADR-0002: Environment-Driven Multi-Context Configuration

## Status
Accepted

## Context
Deploying self-hosted applications like Traefik or Open WebUI requires different configuration values depending on the physical context (e.g., at home vs. at work). 
- At **Home** (e.g., on server `gravity-1` or desktop `desktop-erich`), we may want to leverage custom domains, LAN routing rules, bypass authentication, and integrate local high-performance hardware (like Ollama running on a local GPU).
- At **Work** (e.g., on a corporate laptop), we must run in standalone environments, interface with authenticated cloud endpoints (such as OpenRouter or Gemini APIs), use restricted port sets, and secure data locally.

Hardcoding these parameters in `compose.yaml` or maintaining separate repository branches for work and home creates high maintenance overhead, risk of code drift, and increases the potential of accidentally leaking sensitive credentials.

## Decision
We will enforce an **environment-driven multi-context configuration** pattern:
1. **Declaration Isolation**: All service variables, API keys, and context differences must be defined inside environment variables inside the `compose.yaml` files.
2. **Context-Specific Templates**: Inside each context-dependent service (e.g., Traefik, Open WebUI), we will maintain a dedicated `env/` directory containing:
   - `env/home.env`: Contains presets Optimized for home usage (local hostnames, GPU endpoints, bypassed auth).
   - `env/work.env`: Contains presets optimized for standalone, local work usage (standard cloud APIs, local loops, restricted endpoints).
3. **Onboarding Action**: Users must copy their chosen context template (e.g., `cp env/home.env .env`) before running `docker compose up -d`. The `.env` file is git-ignored to prevent configuration leak.

## Consequences
- **Pros**:
  - Unified codebase: A single repository, branch, and Docker Compose structure supports both home server and work environments.
  - Security: Sensitive values (API keys, custom domains) are kept out of tracking by utilizing the local `.env` file pattern.
  - Flexibility: Switching contexts is as easy as swapping environment files and recreating the containers.
- **Cons**:
  - Manual onboarding step: Users must manually select and copy an environment file to `.env` before executing `docker compose`.
  - Upkeep: Any changes to environment variable names/requirements must be updated simultaneously across both `home.env` and `work.env` template files.
