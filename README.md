# AttackDefenseAll-In-One
Attack and defense lab built with Docker. All within the same VM.

# Laboratorio Docker per Cybersecurity

## Introduzione
Questo laboratorio è progettato per fornire un ambiente realistico in cui sperimentare tecniche di cybersecurity e penetration testing. Utilizzando Docker e Docker Compose, il laboratorio simula una rete aziendale con vulnerabilità comuni, fornendo un'opportunità pratica per imparare e testare exploit in un ambiente sicuro e controllato.

### Obiettivi del Laboratorio
- Creare un ambiente sicuro per il testing di vulnerabilità.
- Permettere l'uso di strumenti come Metasploit in un contesto realistico.
- Offrire un'infrastruttura pronta per l'uso con servizi vulnerabili e reti segmentate.
- Fornire esempi pratici per l'analisi delle minacce e la mitigazione degli attacchi.

## Prerequisiti
- **Docker**: Versione più recente installata.
- **Docker Compose**: Versione compatibile con la versione di Docker.
- Sistema operativo compatibile (Linux consigliato).

## Struttura del Progetto
### Directory Principali
- **/scripts**: Contiene script di automazione e utility.
- **/configs**: File di configurazione per i vari servizi.
- **/logs**: Archivia i log generati dai container.
- **/data**: Contiene dati persistenti, come database e file di configurazione.

### File Principali
- **Makefile**: Script principale per gestire l'ambiente.
- **init.sh**: Script di avvio del laboratorio.
- **docker-compose.yml**: Definisce la struttura dei container e delle reti.

## Comandi Makefile
### Deploy
```
make deploy
```
Avvia il laboratorio eseguendo il file `init.sh`, che controlla i prerequisiti e avvia i container. Utilizza Docker Compose per costruire e avviare l'ambiente completo.

### Test
```
make test
```
Mostra i container attivi utilizzando il comando `docker ps`, assicurandosi che tutti i servizi siano correttamente avviati.

### Spegnimento
```
make spegni
```
Arresta tutti i container in esecuzione utilizzando i loro ID. Utilizza il comando `docker stop` per garantire un arresto sicuro.

### Pulizia Completa
```
make clean
```
Rimuove tutti i container, immagini, volumi e reti create. Include una fase di pulizia approfondita per garantire che nessuna risorsa rimanga attiva dopo la rimozione.

### Ricostruzione
```
make rebuild
```
Esegue una ricostruzione completa del laboratorio, rimuovendo i container esistenti e creando nuovi container aggiornati. Utilizza Docker Compose per l'intero processo.

## Configurazione delle Reti
Il laboratorio è suddiviso in due reti principali:

- **public_net**: Rete pubblica, accessibile da servizi esposti.
- **private_net**: Rete interna, utilizzata per servizi non esposti.

### Tabella dei Servizi
| Nome del Servizio        | Immagine                                      | Container Name       | Indirizzo IP           | Rete        | Porta Esposta |
|-------------------------|----------------------------------------------|----------------------|-------------------------|-------------|--------------|
| Metasploit Attacker      | metasploitframework/metasploit-framework:latest | metasploit            | 172.16.10.20            | public_net  | -            |
| FTP Server              | clintmint/vsftpd-2.3.4:1.0                     | ftp                  | 172.16.10.30 / 10.1.0.11 | public_net / private_net | -            |
| SSH Honeypot            | cowrie/cowrie                                 | ssh-honeypot          | 172.16.10.40            | public_net  | 2222         |
| SSH Access              | rastasheep/ubuntu-sshd:latest                 | ssh-allow-root        | 10.1.0.13               | private_net | 22           |
| Metasploit Attacker Priv | metasploitframework/metasploit-framework:latest | metasploit-private    | 10.1.0.15               | private_net | -            |
| MySQL Server            | vulhub/mysql:5.5.23                           | mysql                 | 172.16.10.60            | public_net  | 3306         |
| Web Server              | vulhub/uwsgi-php:2.0.16                       | web                   | 10.1.0.17               | private_net | 8080         |

## Utilizzo del Laboratorio
1. **Clonare il repository:**
```
git clone https://github.com/tuo-utente/laboratorio-cybersecurity.git
cd laboratorio-cybersecurity
```
2. **Avviare il laboratorio:**
```
make deploy
```
3. **Verificare lo stato dei container:**
```
make test
```
4. **Accedere ai servizi:**
- SSH Honeypot: `ssh admin@localhost -p 2222`
- MySQL: `mysql -h 172.16.10.60 -u root -p`

## Backup e Ripristino
- I dati persistenti si trovano nella directory `/data`.
- Per eseguire un backup completo:
```
tar czvf backup.tar.gz ./data
```
- Per ripristinare:
```
tar xzvf backup.tar.gz -C ./data
```

## Monitoraggio e Log
I log dei container sono disponibili nella directory `/logs`. Per visualizzare i log:
```
docker logs nome-container
```

## Risoluzione dei Problemi
- **Errore di avvio:** Verificare i log del container per dettagli.
- **Impossibilità di avviare Docker Compose:** Assicurarsi che Docker Compose sia aggiornato.
- **Rete non raggiungibile:** Verificare la configurazione delle reti Docker.

## Contatti e Supporto
Per problemi o suggerimenti, aprire una issue su GitHub o contattare direttamente l'autore.

