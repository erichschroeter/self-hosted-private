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
* **Host Port**: `8087` (Exposing native HTTP port `8087` and DNS port `53` directly)

##### Traefik Labels
Exposes the Pi-hole Admin Web Interface on standard port 80 at `http://pihole.localhost` (or `http://pihole.prplalpca.com`) on the external `traefik-net` network using a custom loadbalancer destination.

##### Declarative Wildcard DNS (Zero Maintenance)
Pi-hole v6 in this homelab features fully automated, declarative wildcard DNS resolution. It leverages the native FTL configuration line variable `FTLCONF_misc_dnsmasq_lines` inside `compose.yaml` to automatically interpolate your active environment IP (`LOCAL_IP`):
* **At Home** (`LOCAL_IP=10.4.0.11`): Pi-hole automatically resolves `*.prplalpca.com` to your home server LAN IP, letting you access any new service instantly by simply adding Traefik labels in `compose.yaml` (no manual DNS setting required).
* **At Work** (`LOCAL_IP=127.0.0.1`): Pi-hole automatically routes `*.prplalpca.com` to your local loopback, enabling standalone domain testing.

##### Secrets Management (`secrets.env`)
To protect your Pi-hole web admin dashboard, you can create a `secrets.env` file (which is git-ignored) in the `services/pihole/` directory containing:

* **`FTLCONF_WEBSERVER_API_PASSWORD`**: The password used to access the Pi-hole web portal and query internal DNS status.

To securely generate a random, high-entropy password for Pi-hole, use this command:
```bash
openssl rand -base64 16
```

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
