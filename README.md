### Homelab Deployment Guide (Private Services Stack)

This repository contains private local service stacks managed via Docker Compose. The setup utilizes a **hybrid approach** to align with the core architectural standards:
1. **Primary Access**: Routed through a **Traefik Reverse Proxy** under the `.localhost` and `.prplalpca.com` domain spaces (e.g., `http://jellyfin.localhost`).
2. **Fallback Access**: Exposed directly via **static host ports** (e.g., `http://localhost:8502`). This ensures resilient, zero-configuration fallback access if Traefik is not running or if you are in a restrictive network.

---

### Service Directory

| Service | Traefik Domain URL (Home / Local) | Fallback URL (Static Port) | Documentation |
| :--- | :--- | :--- | :--- |
| **Dumbassets** | `http://dumbassets.prplalpca.com` or `.localhost` | [http://localhost:8500](http://localhost:8500) | [Read Docs](services/dumbassets/README.md) |
| **Grimmory** | `http://grimmory.prplalpca.com` or `.localhost` | [http://localhost:8501](http://localhost:8501) | [Read Docs](services/grimmory/README.md) |
| **Jellyfin** | `https://jellyfin.prplalpca.com` or `.localhost` | [http://localhost:8096](http://localhost:8096) | [Read Docs](services/jellyfin/README.md) |
| **Mealie Recipes** | `http://mealie.prplalpca.com` or `.localhost` | [http://localhost:8504](http://localhost:8504) | [Read Docs](services/mealie/README.md) |
| **Paperless Documents** | `http://paperless.prplalpca.com` or `.localhost` | [http://localhost:8502](http://localhost:8502) | [Read Docs](services/paperless/README.md) |
| **Pi-hole Admin** | `http://pihole.prplalpca.com` or `.localhost` | [http://localhost:8503](http://localhost:8503) | [Read Docs](services/pihole/README.md) |
| **Plex Media Server** | `http://plex.prplalpca.com` or `.localhost` | [http://localhost:32400](http://localhost:32400) | [Read Docs](services/plex/README.md) |
| **TorGuard VPN Stack** | Multiple domains (see docs) | Multiple ports (see docs) | [Read Docs](services/torguard-vpn/README.md) |
| **Wake-on-LAN (UpSnap)** | `http://wol.prplalpca.com` or `.localhost` | [http://localhost:8505](http://localhost:8505) | [Read Docs](services/wol/README.md) |

---

### Quick Onboarding Setup

Follow these simple instructions to spin up your private homelab environment:

#### Step 1: Select Your Operating Context
Each service has a dedicated `env/` directory. You must select your context template and copy it to `.env` before running the service:
- **At Home** (fully accessible on local LAN): `cp env/home.env .env`
- **At Work** (isolated to local loopback): `cp env/work.env .env`

#### Step 2: Spin Up Your Services
Once Traefik is running on your network (managing the shared external `traefik-net` network), you can launch any individual service container by navigating to its directory and executing:

```bash
cd services/<service_folder>
cp env/home.env .env  # Or cp env/work.env .env
docker compose up -d
```

For detailed configuration variables and database specifics of each service, consult the links in the **Service Directory** table above!
