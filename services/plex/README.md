### Plex Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
Plex Media Server organizes your video, music, and photo collections and lets you stream them to all of your screens.

[top](#top)

#### Configuration <a name="configuration"></a>
Plex is configured in `services/plex/compose.yaml`.

##### Port Mappings
* **Host Port**: `32400` (Standard static fallback port mapping internally to port `32400`)

##### Traefik Labels
Exposes Plex on standard port 80 at `http://plex.localhost` (or `http://plex.prplalpca.com`) on the external `traefik-net` network.

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch Plex, navigate to its directory, select your environment, and start:

```bash
cd services/plex
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open Plex at [http://plex.localhost](http://plex.localhost) or fallback on [http://localhost:32400](http://localhost:32400).

[top](#top)
