### Dumbassets Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
Dumbassets is a simple and lightweight self-hosted asset manager and file hosting utility.

[top](#top)

#### Configuration <a name="configuration"></a>
Dumbassets is configured in `services/dumbassets/compose.yaml`.

##### Port Mappings
* **Host Port**: `3030` (Standard static fallback port mapping internally to port `3000`)

##### Traefik Labels
Exposes the dashboard on standard port 80 at `http://dumbassets.localhost` (or `http://dumbassets.prplalpca.com`) on the external `traefik-net` network.

##### Secrets Management (`secrets.env`)
To protect your assets dashboard from unauthorized access, you can create a `secrets.env` file (which is git-ignored) in the `services/dumbassets/` directory.

You can move any sensitive environment variables out of your standard env profiles and define them here:
* **`DUMBASSETS_PIN`**: The secure admin login/upload security PIN (defaults to `0604` if not defined).
* **`DUMBASSETS_APPRISE_URL`**: Apprise notification endpoint URL for instant asset events (optional).

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch Dumbassets, navigate to its directory, select your environment, and start:

```bash
cd services/dumbassets
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open your assets manager at [http://dumbassets.localhost](http://dumbassets.localhost) or fallback on [http://localhost:3030](http://localhost:3030).

[top](#top)
