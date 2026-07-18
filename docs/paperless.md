### Paperless Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)

#### Overview <a name="overview"></a>
Paperless-ngx is a document management system that transforms your physical documents into a searchable online archive.

[top](#top)

#### Configuration <a name="configuration"></a>
Paperless is configured in `services/paperless/compose.yaml`.

##### Port Mappings
* **Host Port**: `8010` (Standard static fallback port mapping internally to port `8000`)

##### Traefik Labels
Exposes Paperless on standard port 80 at `http://paperless.localhost` (or `http://paperless.prplalpca.com`) on the external `traefik-net` network.

##### Secrets Management (`secrets.env`)
To protect your document archive and Postgres database, you can create a `secrets.env` file (which is git-ignored) in the `services/paperless/` directory containing:

* **`DB_PASSWORD`**: A strong, unique password for Paperless's PostgreSQL database and admin access.

To securely generate a strong, high-entropy database password, use this command:
```bash
openssl rand -base64 24
```

[top](#top)

#### How to Run <a name="how-to-run"></a>
To launch Paperless, navigate to its directory, select your environment, and start:

```bash
cd services/paperless
cp env/home.env .env  # Or env/work.env
docker compose up -d
```

Open Paperless at [http://paperless.localhost](http://paperless.localhost) or fallback on [http://localhost:8010](http://localhost:8010).

[top](#top)
