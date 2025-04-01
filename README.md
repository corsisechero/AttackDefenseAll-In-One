# AttackDefenseAll-In-One
Attack and defense lab built with Docker. All within the same VM.

# Laboratorio Docker per Cybersecurity

## Introduzione
Questo laboratorio Docker è progettato per fornire un ambiente realistico di test per la sicurezza informatica. Utilizzando Docker e Docker Compose, il laboratorio simula una rete aziendale con vulnerabilità comuni. Il setup include container con servizi vulnerabili e reti segmentate, creando un ambiente ideale per il penetration testing.

### Obiettivi del Laboratorio
- Creare un ambiente sicuro per testare vulnerabilità note.
- Simulare un'infrastruttura aziendale con servizi esposti e segmentazione della rete.
- Consentire l'uso di strumenti come Metasploit in un ambiente realistico.

## Prerequisiti
- Docker
- Docker Compose
- Sistema operativo basato su Linux (consigliato)

Assicurarsi che Docker e Docker Compose siano installati correttamente prima di eseguire il laboratorio. Il file `init.sh` verifica la presenza di queste dipendenze.

## Comandi Makefile
Il file Makefile fornisce una serie di comandi per gestire il laboratorio.

### Deploy
```
make deploy
```
Questo comando avvia il laboratorio eseguendo lo script `init.sh`, che verifica la presenza di Docker e Docker Compose, e successivamente avvia i container con Docker Compose.

### Test
```
make test
```
Mostra i container attivi per verificare che l'ambiente sia operativo.

### Spegnimento
```
make spegni
```
Arresta tutti i container in esecuzione tramite il comando `docker stop`.

### Pulizia Completa
```
make clean
```
Elimina tutti i container, le immagini, i volumi e le reti create dal laboratorio. Questo comando garantisce una pulizia completa e rimuove tutte le risorse Docker inutilizzate.

### Ricostruzione
```
make rebuild
```
Ricostruisce e riavvia l'intero ambiente da zero, garantendo l'uso delle versioni aggiornate dei container.

## Struttura della Rete
Il laboratorio è suddiviso in due reti Docker:
- **public_net**: Rete pubblica, accessibile dai servizi esposti.
  - Subnet: `172.16.10.0/24`
  - Gateway: `172.16.10.1`
- **private_net**: Rete privata, isolata per i servizi interni.
  - Subnet: `10.1.0.0/24`
  - Gateway: `10.1.0.1`

### Tabella dei Servizi
| Nome del Servizio        | Container Name           | Indirizzo IP           | Rete        | Porta Esposta |
|-------------------------|--------------------------|-------------------------|-------------|--------------|
| Attacker                | attacker                 | 172.16.10.20            | public_net  | -            |
| FTP Server              | ftp.euxcorp.com           | 172.16.10.30 / 10.1.0.11 | public_net / private_net | -            |
| SSH Honeypot            | public.euxcorp.com        | 172.16.10.40            | public_net  | 2222         |
| SSH Access              | access.euxcorp.com        | 10.1.0.13               | private_net | 22           |
| Attacker Private        | attacker-private          | 10.1.0.15               | private_net | -            |
| MySQL Server            | mysql.euxcorp.com         | 172.16.10.60            | public_net  | 3306         |
| Web Server              | web.euxcorp.com           | 10.1.0.17               | private_net | 8080         |

## Avvio del Laboratorio
1. Clonare il repository:
```
git clone https://github.com/tuo-utente/laboratorio-cybersecurity.git
cd laboratorio-cybersecurity
```
2. Avviare il laboratorio:
```
make deploy
```
3. Verificare i container attivi:
```
make test
```

## Monitoraggio dei Log
I log di ogni container sono accessibili con il comando:
```
docker logs nome-container
```

## Risoluzione dei Problemi
- **Errore di connessione alla rete**: Verificare lo stato della rete con:
```
docker network ls
```
- **Container non avviati**: Controllare i log con:
```
docker logs nome-container
```
- **Errore durante il deploy**: Assicurarsi che Docker e Docker Compose siano installati.

## Contatti
Per segnalare problemi o suggerimenti, aprire una issue su GitHub o contattare l'autore.


