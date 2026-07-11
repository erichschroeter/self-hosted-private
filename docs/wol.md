### Wake-on-LAN (UpSnap) Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
UpSnap is a simple self-hosted Wake-on-LAN dashboard that lets you wake and ping devices on your local network.

[top](#top)

#### Configuration <a name="configuration"></a>
UpSnap is configured in `services/wol/compose.yaml`.

##### Port Mappings
* **Host Port**: `8090` (Runs in host networking mode, exposing native server port `8090` directly)

##### Traefik Labels
Exposes the Wake-on-LAN dashboard on standard port 80 at `http://wol.localhost` (or `http://wol.prplalpca.com`) on the external `traefik-net` network using a custom loadbalancer destination.

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch UpSnap, navigate to its directory, select your environment, and start:

```bash
cd services/wol
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open UpSnap at [http://wol.localhost](http://wol.localhost) or fallback on [http://localhost:8090](http://localhost:8090).

[top](#top)
