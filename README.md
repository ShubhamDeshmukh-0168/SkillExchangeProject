# SkillExchangeProject — Deploy on a New Server (Root URL Only)

This deploys the app on a **fresh** EC2 instance so it's reachable at just
`http://<ip-or-load-balancer-dns>/` — no `:8080`, no `/SkillExchangeProject/`,
no `/#home`. The WAR is deployed as Tomcat's `ROOT` app from the start, and
Tomcat is put behind Nginx on port 80 so the port number disappears too.

You'll need, before starting:
- A new EC2 instance's public IP and `.pem` key file
- Your RDS endpoint, username, and password
- Your git repository URL for this project (the `main` branch you pushed)

---

## 1. Connect to the Instance

```bash
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>          # Amazon Linux
# ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>          # Ubuntu
```

---

## 2. Install Required Software

```bash
# Amazon Linux 2023
sudo dnf update -y
sudo dnf install -y java-17-amazon-corretto maven git mariadb105

# Ubuntu (alternative)
# sudo apt update && sudo apt install -y openjdk-17-jdk maven git mysql-client
```

> Amazon Linux 2023 has no package literally called `mysql` — `mariadb105`
> provides the same `mysql` command-line client and works identically
> against RDS for MySQL. If `mariadb105` isn't found, try `mariadb`.

Verify:
```bash
java -version
mvn -version
git --version
mysql --version
```

---

## 3. Install Tomcat 10.1

> Requires **Tomcat 10.1+** (`jakarta.servlet.*` namespace) — Tomcat 9.x will
> not run this app.

Check https://tomcat.apache.org/download-10.cgi for the current latest
10.1.x version — old point releases get removed from the mirror over time.

```bash
cd /opt
TOMCAT_VERSION=10.1.59

sudo curl -fO https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
ls -lh apache-tomcat-${TOMCAT_VERSION}.tar.gz   # should be tens of MB

sudo mkdir -p tomcat10
sudo tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C tomcat10 --strip-components=1
sudo rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

ls /opt/tomcat10   # should show bin, conf, lib, logs, webapps, work directly
```

```bash
sudo useradd -r -M -U -d /opt/tomcat10 -s /bin/false tomcat
sudo chown -R tomcat:tomcat /opt/tomcat10
sudo chmod +x /opt/tomcat10/bin/*.sh
ls -la /opt/tomcat10/bin/*.sh   # confirm -rwxr-xr-x
```

---

## 4. Create the systemd Service (RDS details go here)

```bash
sudo tee /etc/systemd/system/tomcat10.service > /dev/null <<'EOF'
[Unit]
Description=Apache Tomcat 10
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
Environment=CATALINA_HOME=/opt/tomcat10
Environment=CATALINA_BASE=/opt/tomcat10
Environment=CATALINA_PID=/opt/tomcat10/temp/tomcat.pid
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

# ============================================================
#  >>> YOUR RDS CONNECTION DETAILS GO HERE <<<
# ============================================================
Environment=DB_URL=jdbc:mysql://REPLACE_ME_ENDPOINT:3306/skillexchange?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
Environment=DB_USER=REPLACE_ME_USERNAME
Environment=DB_PASSWORD=REPLACE_ME_PASSWORD

ExecStart=/opt/tomcat10/bin/startup.sh
ExecStop=/opt/tomcat10/bin/shutdown.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

Edit the three placeholders:
```bash
sudo nano /etc/systemd/system/tomcat10.service
```
> Double-check the very first line still reads exactly `[Unit]` (with the
> bracket) after editing — a missing bracket silently breaks the whole file.
> The `allowPublicKeyRetrieval=true` parameter is required for RDS MySQL's
> default authentication — without it you'll hit `Public Key Retrieval is
> not allowed` errors.

Save, then:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now tomcat10
sudo systemctl status tomcat10
curl -I http://localhost:8080
```

Remove the default management apps:
```bash
sudo rm -rf /opt/tomcat10/webapps/manager /opt/tomcat10/webapps/host-manager \
            /opt/tomcat10/webapps/examples /opt/tomcat10/webapps/docs
```

---

## 5. Set Up the RDS Schema

If this is a **new** RDS database, create it and load the schema. If you're
pointing at an RDS database you've already set up before, skip to Step 6.

```bash
mysql -h <YOUR_RDS_ENDPOINT> -P 3306 -u <YOUR_USERNAME> -p -e "CREATE DATABASE IF NOT EXISTS skillexchange;"
```
(You'll load `database/schema.sql` in a moment, right after cloning — see
Step 6.)

---

## 6. Clone the Repository and Build

```bash
cd ~
git clone <your-repo-url> SkillExchangeProject
cd SkillExchangeProject
```

Load the schema now that you have `database/schema.sql` locally (skip if
already done on this RDS database):
```bash
mysql -h <YOUR_RDS_ENDPOINT> -P 3306 -u <YOUR_USERNAME> -p skillexchange < database/schema.sql
```

Build:
```bash
mvn clean package
```
This produces `target/SkillExchangeProject.war`.

---

## 7. Deploy as ROOT (no port, no path)

```bash
sudo systemctl stop tomcat10

# Remove Tomcat's default welcome page occupying ROOT
sudo rm -rf /opt/tomcat10/webapps/ROOT

sudo cp target/SkillExchangeProject.war /opt/tomcat10/webapps/ROOT.war
sudo chown tomcat:tomcat /opt/tomcat10/webapps/ROOT.war

sudo systemctl start tomcat10
sudo tail -f /opt/tomcat10/logs/catalina.out
```
Watch for `ROOT.war` finishing deployment, then `Ctrl+C`.

Confirm it works directly on port 8080 first (before adding Nginx):
```
http://<EC2_PUBLIC_IP>:8080/
```

---

## 8. Put Nginx in Front (removes the `:8080` too)

This is what actually gets you to a clean `http://<ip>/` or
`http://<load-balancer-dns>/` with no port number.

```bash
sudo dnf install -y nginx     # Amazon Linux
# sudo apt install -y nginx   # Ubuntu
```

```bash
sudo tee /etc/nginx/conf.d/skillexchange.conf > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo systemctl enable --now nginx
sudo nginx -t && sudo systemctl reload nginx
```

Make sure your EC2 **security group** allows inbound port **80** (not just
8080) from wherever you need access.

---

## 9. Verify

**Direct IP:**
```
http://<EC2_PUBLIC_IP>/
```

**Through a load balancer** (if you're putting an ALB in front of this
instance): use the ALB's DNS name, copied exactly from **EC2 console → Load
Balancers → your ALB → DNS name** — don't retype it, copy-paste to avoid
typos:
```
http://<load-balancer-dns-name>/
```
Make sure the ALB's target group points at this instance on port **80**
(since Nginx is now what's listening there), and the instance's security
group allows inbound port 80 from the load balancer's security group.

No `:8080`, no `/SkillExchangeProject/`, no `/#home` needed anywhere.

Register a test user and log in to confirm it reads/writes to RDS correctly.

---

## 10. Redeploying Updates Later

```bash
cd ~/SkillExchangeProject
git pull
mvn clean package

sudo systemctl stop tomcat10
sudo rm -rf /opt/tomcat10/webapps/ROOT /opt/tomcat10/webapps/ROOT.war
sudo cp target/SkillExchangeProject.war /opt/tomcat10/webapps/ROOT.war
sudo chown tomcat:tomcat /opt/tomcat10/webapps/ROOT.war
sudo systemctl start tomcat10
sudo tail -f /opt/tomcat10/logs/catalina.out
```

**Tip:** back up the current WAR before overwriting, so you can roll back
fast if something breaks:
```bash
sudo cp /opt/tomcat10/webapps/ROOT.war /opt/tomcat10/webapps/ROOT.war.bak-$(date +%Y%m%d-%H%M)
```

---

## Quick Reference — Where Things Go

| What | Where |
|---|---|
| RDS endpoint | `DB_URL` in `/etc/systemd/system/tomcat10.service` |
| RDS username / password | `DB_USER` / `DB_PASSWORD` in the same file, and the `mysql -u ...` commands in Steps 5–6 |
| Git repo URL | `git clone <your-repo-url>` in Step 6 |
| Deployed app | `/opt/tomcat10/webapps/ROOT.war` (serves at `/`) |
| Removes the `:8080` | Nginx config in Step 8, proxying port 80 → 8080 |

After changing any `DB_*` value:
```bash
sudo systemctl daemon-reload
sudo systemctl restart tomcat10
```

---

## Troubleshooting

**Still seeing a port number or `/#home` in the URL** — that's just where
your browser navigated to, not a server requirement; typing the plain
`http://<ip>/` or `http://<load-balancer-dns>/` should load the same
homepage.

**404 at `/`** — confirm the WAR is named exactly `ROOT.war` in
`/opt/tomcat10/webapps/`, and that the old default `ROOT` folder was removed
before deploying.

**Nginx shows its own default page instead of the app, or a 502/504** —
confirm Tomcat is actually running on 8080 (`curl -I http://localhost:8080`
on the instance itself) and that `/etc/nginx/conf.d/skillexchange.conf`
proxies to `http://127.0.0.1:8080/`.

**`Public Key Retrieval is not allowed` / `PoolInitializationException`** —
`DB_URL` is missing `allowPublicKeyRetrieval=true`. Add it, then
`sudo systemctl daemon-reload && sudo systemctl restart tomcat10`.

**`Access denied for user '...'@'...'`** — `DB_USER`/`DB_PASSWORD` don't
match your actual RDS credentials, or there's a typo/trailing space.

**`Unknown database 'skillexchange'`** — run
`CREATE DATABASE IF NOT EXISTS skillexchange;` against RDS and retry.

**App can't reach RDS at all (timeout)** — RDS security group must allow
inbound port 3306 from **this new instance's** security group specifically
— a previous instance's rule doesn't carry over.

**Browser can't reach the instance at all** — security group missing an
inbound rule for port 80 (and/or 8080 if testing directly) from your IP or
`0.0.0.0/0`.

**`ClassNotFoundException: com.mysql.cj.jdbc.Driver`** — WAR wasn't built
with `mvn clean package`; rebuild and redeploy.

**`gzip: stdin: not in gzip format` downloading Tomcat** — the download URL
404'd (stale version number). Recheck
https://tomcat.apache.org/download-10.cgi and use `curl -f` so a bad
download fails loudly instead of silently.
