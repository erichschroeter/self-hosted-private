### Grimmory Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
Grimmory is a comprehensive, self-hosted book collection and media library manager backed by MariaDB.

[top](#top)

#### Configuration <a name="configuration"></a>
Grimmory is configured in `services/grimmory/compose.yaml`.

##### Port Mappings
* **Host Port**: `6060` (Standard static fallback port mapping internally to port `6060`)

##### Traefik Labels
Exposes the application on standard port 80 at `http://grimmory.localhost` (or `http://grimmory.prplalpca.com`) on the external `traefik-net` network.

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch Grimmory, navigate to its directory, select your environment, and start:

```bash
cd services/grimmory
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open your books library at [http://grimmory.localhost](http://grimmory.localhost) or fallback on [http://localhost:6060](http://localhost:6060).

[top](#top)
