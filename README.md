### Homelab Deployment Guide (Private Services Stack)

This repository contains private local service stacks managed via Docker Compose. The setup utilizes a **hybrid approach** to align with the core architectural standards:
1. **Primary Access**: Routed through a **Traefik Reverse Proxy** under the `.localhost` and `.prplalpca.com` domain spaces (e.g., `http://jellyfin.localhost`).
2. **Fallback Access**: Exposed directly via **static host ports** (e.g., `http://localhost:8010`). This ensures resilient, zero-configuration fallback access if Traefik is not running or if you are in a restrictive network.

---

### Service Directory

| Service | Traefik Domain URL (Home / Local) | Fallback URL (Static Port) | Documentation |
| :--- | :--- | :--- | :--- |
| **Dumbassets** | `http://dumbassets.prplalpca.com` or `.localhost` | [http://localhost:3030](http://localhost:3030) | [Read Docs](docs/dumbassets.md) |
| **Grimmory** | `http://grimmory.prplalpca.com` or `.localhost` | [http://localhost:6060](http://localhost:6060) | [Read Docs](docs/grimmory.md) |
| **Jellyfin** | `https://jellyfin.prplalpca.com` or `.localhost` | [http://localhost:8096](http://localhost:8096) | [Read Docs](docs/jellyfin.md) |
| **Mealie Recipes** | `http://mealie.prplalpca.com` or `.localhost` | [http://localhost:9091](http://localhost:9091) | [Read Docs](docs/mealie.md) |
| **Paperless Documents** | `http://paperless.prplalpca.com` or `.localhost` | [http://localhost:8010](http://localhost:8010) | [Read Docs](docs/paperless.md) |
| **Pi-hole Admin** | `http://pihole.prplalpca.com` or `.localhost` | [http://localhost:8087](http://localhost:8087) | [Read Docs](docs/pihole.md) |
| **Plex Media Server** | `http://plex.prplalpca.com` or `.localhost` | [http://localhost:32400](http://localhost:32400) | [Read Docs](docs/plex.md) |
| **TorGuard VPN Stack** | Multiple domains (see docs) | Multiple ports (see docs) | [Read Docs](docs/torguard-vpn.md) |
| **Wake-on-LAN (UpSnap)** | `http://wol.prplalpca.com` or `.localhost` | [http://localhost:8090](http://localhost:8090) | [Read Docs](docs/wol.md) |

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
