### TorGuard VPN (Media Stack) Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
This stack contains a centralized Gluetun WireGuard VPN client and a suite of self-hosted media managers:
- **qBittorrent**: Torrent download client (securely routed strictly through VPN network space).
- **Bazarr**: Subtitle downloader.
- **Flaresolverr**: Cloudflare bypass utility.
- **Prowlarr**: Torrent indexer manager.
- **Radarr**: Movies manager.
- **Sonarr**: TV shows manager.

[top](#top)

#### Configuration <a name="configuration"></a>
The stack is configured in `services/torguard-vpn/compose.yaml`.

##### Port Mappings (Fallback Ports)
* **qBittorrent (Gluetun)**: `8088` (Internal `8080`)
* **Bazarr**: `6767`
* **Prowlarr**: `9696`
* **Radarr**: `7878`
* **Sonarr**: `8989`

##### Traefik Labels
Each service is dynamically reverse-proxied over `traefik-net` on standard port 80:
* `http://qbittorrent.localhost` (or `.prplalpca.com`)
* `http://bazarr.localhost` (or `.prplalpca.com`)
* `http://prowlarr.localhost` (or `.prplalpca.com`)
* `http://radarr.localhost` (or `.prplalpca.com`)
* `http://sonarr.localhost` (or `.prplalpca.com`)

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch the VPN stack, navigate to its directory, select your environment, and start:

```bash
cd services/torguard-vpn
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Navigate to any of the service URLs listed above to access your managers.

[top](#top)
