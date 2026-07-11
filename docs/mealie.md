### Mealie Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
Mealie is a self-hosted recipe manager and meal planner with a beautiful, user-friendly interface.

[top](#top)

#### Configuration <a name="configuration"></a>
Mealie is configured in `services/mealie/compose.yaml`.

##### Port Mappings
* **Host Port**: `9091` (Standard static fallback port mapping internally to port `9000`)

##### Traefik Labels
Exposes Mealie on standard port 80 at `http://mealie.localhost` (or `http://mealie.prplalpca.com`) on the external `traefik-net` network.

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch Mealie, navigate to its directory, select your environment, and start:

```bash
cd services/mealie
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open Mealie at [http://mealie.localhost](http://mealie.localhost) or fallback on [http://localhost:9091](http://localhost:9091).

[top](#top)
