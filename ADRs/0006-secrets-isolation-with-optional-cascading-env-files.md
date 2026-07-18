# ADR-0006: Secrets Isolation with Optional Cascading Env Files

## Status
Accepted

## Context
Deploying self-hosted stacks requires managing highly sensitive secrets (like API keys, database passwords, and WireGuard private keys).
Previously, these secrets were mixed directly with non-sensitive layout parameters inside our committed environment templates (`home.env` / `work.env`). While convenient, this posed a significant security risk of accidentally leaking live production keys and credentials when committing context updates.

We need a design pattern that isolates sensitive secrets from Git-tracked templates, while maintaining ease of deployment and supporting dynamic variable interpolation inside `compose.yaml`.

## Decision
We will employ a **Secrets Isolation** pattern using Docker Compose's service-level optional `env_file` block:

1. **Dual-File Cascading Loading**:
   For any service possessing sensitive variables, we configure its service block to load two separate environment files in order of precedence:
   ```yaml
   env_file:
     - path: .env
       required: true
     - path: secrets.env
       required: false
   ```
2. **Template Cleansing**:
   All sensitive variables inside `home.env` and `work.env` templates are scrubbed and replaced with generic placeholder values (e.g., `your_private_key_here`).
3. **Local Overriding**:
   Users create a local `secrets.env` file (which is globally ignored via `.gitignore`) in the target service directory containing their live, private keys. Since `secrets.env` is listed second, its variables override the default `.env` placeholders at runtime.
4. **Resilience**:
   By setting `required: false` on `secrets.env`, the service will gracefully skip the file if it doesn't exist, allowing standard development deployments to spin up without crashing.

## Consequences
- **Pros**:
  - **Perfect Security**: Live credentials, API tokens, and passwords are isolated on-disk, fully protected by Git ignore rules, and can never be accidentally leaked.
  - **Robustness**: The optional loading flag ensures the stack compiles cleanly even if the user hasn't created local `secrets.env` overrides.
  - **Clarity**: Establishes a distinct boundary between public design configurations and private credentials.
- **Cons**:
  - Requires manually creating the `secrets.env` file once on host setup.
