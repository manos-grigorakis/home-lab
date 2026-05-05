# Coolify

## Setup

1. Copy and configure environment variables

   ```bash
   cp .env.example .env
   ```

2. Create data directories

   ```bash
   mkdir -p /mnt/volume/home-lab/lxc/coolify/data/coolify/{db,redis,ssh,databases,backups}
   ```

3. Apply permissions

   ```bash
   chown -R 9999:9999 /mnt/volume/home-lab/lxc/coolify/data/coolify/ssh
   ```

4. Generate SSH key

   ```bash
   ssh-keygen -t ed25519 -a 100 \
   -f /mnt/volume/home-lab/lxc/coolify/data/coolify/ssh/keys/id.root@host.docker.internal \
   -q -N "" -C root@coolify
   ```

5. Add public SSH key to authorized keys of the machine

   ```bash
   cat /mnt/volume/home-lab/lxc/coolify/data/coolify/ssh/keys/id.root@host.docker.internal.pub >> ~/.ssh/authorized_keys
   ```

6. Create Docker Network

   ```bash
   docker network create --attachable coolify
   ```

7. Start Services through Docker
   ```bash
   docker compose up -d --remove-orphans --force-recreate
   ```
