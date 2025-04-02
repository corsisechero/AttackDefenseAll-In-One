## Diagramma dei Servizi

```
+-----------------------+                   +------------------------+
|       Rete Pubblica                          |        Rete Privata                |
+-----------------------+                   +------------------------+

+-----------------------+                   +------------------------+
|       Attacker        |                   |    Attacker Private     |
|  Container: attacker  |                   |  Container: attacker-pri |
|  IP: 172.16.10.20     |                   |  IP: 10.1.0.15          |
|  Network: public_net  |                   |  Network: private_net   |
|  Port: -              |                   |  Port: -                |
+-----------------------+                   +------------------------+
         |                                      |
         |                                      |
         v                                      v
+-----------------------+       <----------->   +------------------------+
|     FTP Server        |                       |       FTP Server        |
|  Container: ftp.euxcorp|                       |  Container: ftp.euxcorp  |
|  IP: 172.16.10.30     |                       |  IP: 10.1.0.11          |
|  Network: public_net  |                       |  Network: private_net   |
|  Port: -              |                       |  Port: -                |
+-----------------------+                       +------------------------+

+-----------------------+                   +------------------------+
|     SSH Honeypot      |                   |       SSH Access        |
|  Container: public.eux|                   |  Container: access.euxcor|
|  IP: 172.16.10.40     |                   |  IP: 10.1.0.13          |
|  Network: public_net  |                   |  Network: private_net   |
|  Port: 2222           |                   |  Port: 22               |
+-----------------------+                   +------------------------+

+-----------------------+                   +------------------------+
|       MySQL Server     |                   |       Web Server        |
|  Container: mysql.euxcor|                   |  Container: web.euxcorp  |
|  IP: 172.16.10.60      |                   |  IP: 10.1.0.17          |
|  Network: public_net   |                   |  Network: private_net   |
|  Port: 3306            |                   |  Port: 8080             |
+-----------------------+                   +------------------------+
```
```
