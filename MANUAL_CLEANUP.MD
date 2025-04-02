Ecco il testo in formato Markdown per GitHub:

# Docker Cleanup Commands

Questi comandi Docker consentono di fermare, rimuovere container, immagini, volumi, reti e liberare spazio sul sistema.

---

## 1. Fermare tutti i container in esecuzione
```bash
docker stop $(docker ps -aq)
```

## 2. Rimuovere tutti i container
```bash
docker rm -f $(docker ps -aq)
```

## 3. Rimuovere tutte le immagini
```bash
docker rmi -f $(docker images -aq)
```

## 4. Rimuovere tutti i volumi
```bash
docker volume rm $(docker volume ls -q)
```

## 5. Rimuovere tutte le reti non predefinite
```bash
docker network rm $(docker network ls --format '{{.ID}} {{.Name}}' | grep -vE 'bridge|host|none' | awk '{print $1}')
```

## 6. Pulizia completa del sistema Docker (container, immagini, volumi e reti non utilizzate)
```bash
docker system prune -a --volumes -f
```

---
