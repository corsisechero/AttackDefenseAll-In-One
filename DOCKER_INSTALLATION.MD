## Installazione di Docker
```bash
sudo apt update
sudo apt install -y docker.io
```

## Abilitazione e avvio del servizio Docker
```bash
sudo systemctl enable docker --now
```

## Aggiunta dell'utente corrente al gruppo Docker
```bash
sudo usermod -aG docker $USER
```

---

## Installazione di Docker Compose

### Impostazione della directory dei plugin
```bash
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
```

### Download di Docker Compose
```bash
curl -SL https://github.com/docker/compose/releases/download/v2.34.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
```

### Rendere eseguibile Docker Compose
```bash
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
```

### Verifica della versione di Docker Compose
```bash
docker compose version
```
