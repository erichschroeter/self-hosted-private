### Pi-hole Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
Pi-hole is a self-hosted DNS sinkhole that blocks advertisements and tracking domains network-wide.

[top](#top)

#### Configuration <a name="configuration"></a>
Pi-hole is configured in `services/pihole/compose.yaml`.

##### Port Mappings
* **Host Port**: `8080` (Runs in host networking mode, exposing native HTTP port `8080` and DNS port `53` directly)

##### Traefik Labels
Exposes the Pi-hole Admin Web Interface on standard port 80 at `http://pihole.localhost` (or `http://pihole.prplalpca.com`) on the external `traefik-net` network using a custom loadbalancer destination.

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch Pi-hole, navigate to its directory, select your environment, and start:

```bash
cd services/pihole
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open Pi-hole at [http://pihole.localhost](http://pihole.localhost) or fallback on [http://localhost:8080](http://localhost:8080).

[top](#top)
