### Jellyfin Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
Jellyfin is a volunteer-built, private media system that puts you in control of managing and streaming your media.

[top](#top)

#### Configuration <a name="configuration"></a>
Jellyfin is configured in `services/jellyfin/compose.yaml`.

##### Port Mappings
* **Host Port**: `8096` (Runs in host networking mode, exposing native server port `8096` directly)

##### Traefik Labels
Exposes Jellyfin on standard port 80 at `http://jellyfin.localhost` (or `https://jellyfin.prplalpca.com`) on the external `traefik-net` network using a custom loadbalancer destination.

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch Jellyfin, navigate to its directory, select your environment, and start:

```bash
cd services/jellyfin
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open Jellyfin at [http://jellyfin.localhost](http://jellyfin.localhost) or fallback on [http://localhost:8096](http://localhost:8096).

[top](#top)
