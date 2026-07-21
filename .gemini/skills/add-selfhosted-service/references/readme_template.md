### SERVICE_NAME_CAPITALIZED Documentation <a name="top"></a>

#### Table of Contents
* [Overview](#overview)
* [Configuration](#configuration)
* [How to Run](#how-to-run)
* [Backing Up](#backing-up)
* [Restoring](#restoring)

#### Overview <a name="overview"></a>
SERVICE_DESCRIPTION

[top](#top)

#### Configuration <a name="configuration"></a>
SERVICE_NAME_CAPITALIZED is configured in `services/SERVICE_NAME/compose.yaml`.

##### Port Mappings
* **Host Port**: `FALLBACK_PORT` (Standard static fallback port mapping internally to port `CONTAINER_PORT`)

##### Traefik Labels
Exposes the service at `http://SERVICE_NAME.localhost` on the external `traefik-net` network.

[top](#top)

#### How to Run <a name="how-to-run"></a>
Before starting SERVICE_NAME_CAPITALIZED, select your operating context from the repository root (this automatically configures the appropriate `.env` symlink for SERVICE_NAME_CAPITALIZED and all other services):

* **At Work**:
  ```bash
  ./switch-context.sh work
  ```
* **At Home**:
  ```bash
  ./switch-context.sh home
  ```

Once the context is configured, navigate to the folder and start SERVICE_NAME_CAPITALIZED:
```bash
cd services/SERVICE_NAME
docker compose up -d
```

Verify the app is active by visiting [http://SERVICE_NAME.localhost](http://SERVICE_NAME.localhost) or [http://localhost:FALLBACK_PORT](http://localhost:FALLBACK_PORT).

[top](#top)

#### Backing Up <a name="backing-up"></a>
BACKUP_INSTRUCTIONS_AND_CRON_SETUP

[top](#top)

#### Restoring <a name="restoring"></a>
RESTORE_INSTRUCTIONS_AND_COMMANDS

[top](#top)
