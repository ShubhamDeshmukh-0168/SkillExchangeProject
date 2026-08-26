# SkillExchangeProject — Deployment Guide

This assumes your EC2 instance and RDS for MySQL database already exist. It
covers only the **deployment process**: connecting to the instance,
installing what's needed, cloning the repo, and running the app — including
exactly where your RDS endpoint, username, and password go.

You will need, from your own setup, before starting:
- Your EC2 instance's public IP and `.pem` key file
- Your RDS endpoint (e.g. `skillexchange-db.abcd1234wxyz.us-east-1.rds.amazonaws.com`)
- Your RDS master username and password
- Your git repository URL for this project

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

sudo dnf install -y \
  java-17-amazon-corretto \
  maven \
  git \
  mariadb105

# Ubuntu (alternative)
# sudo apt update && sudo apt install -y openjdk-17-jdk maven git sudo dnf install -y mariadb105
```

Verify:
```bash
java -version      # should show 17.x
mvn -version         # should show Maven, using Java 17
git --version
```

`mysql`/`mysql-client` gives you the command-line client, used in Step 4 to
create the schema on RDS.

### Install Tomcat 10.1
> This project uses the `jakarta.servlet.*` namespace, which requires
> **Tomcat 10.1+**. Older Tomcat 9.x will not run this app.

Check https://tomcat.apache.org/download-10.cgi for the current latest
10.1.x version — older point releases get removed from the download mirror,
so a version number from an older guide can 404. At the time of writing the
latest is `10.1.59`; adjust `TOMCAT_VERSION` below if a newer one exists.

```bash
cd /opt
TOMCAT_VERSION=10.1.59

# -f makes curl fail loudly on a 404 instead of silently saving an error page
sudo curl -fO https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Sanity check before extracting: this should be tens of MB, not a few hundred bytes
ls -lh apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Extract straight into /opt/tomcat10 (no separate "extract then mv/rename" step —
# that two-step approach is what causes a nested apache-tomcat-x.y.z folder if a
# previous attempt already created /opt/tomcat10, e.g. from a failed run).
sudo mkdir -p tomcat10
sudo tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C tomcat10 --strip-components=1
sudo rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Verify the layout landed correctly — you should see bin, conf, lib, logs,
# webapps, work directly under /opt/tomcat10 (NOT nested inside another folder)
ls /opt/tomcat10
```

Create the dedicated service user. `-M` deliberately skips auto-creating a
home directory, since `/opt/tomcat10` already exists from the extraction
above — this avoids the user/extraction steps stepping on each other
regardless of what order you run them in or whether you retry after a
failure. (If you already created this user earlier and it says "user
'tomcat' already exists" — that's fine, it's harmless, move on.)
```bash
sudo useradd -r -M -U -d /opt/tomcat10 -s /bin/false tomcat
sudo chown -R tomcat:tomcat /opt/tomcat10
sudo chmod +x /opt/tomcat10/bin/*.sh

# Confirm the scripts are actually executable (look for the 'x' bits, e.g. -rwxr-xr-x)
ls -la /opt/tomcat10/bin/*.sh
```

Create the systemd service — **this is where your RDS details go**:

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
#  DB_URL   -> replace REPLACE_ME_ENDPOINT with your RDS endpoint
#  DB_USER  -> your RDS username (the app's DB user, see Step 4)
#  DB_PASSWORD -> that user's password
# ============================================================
Environment=DB_URL=jdbc:mysql://sd.c7ssi4qo40tp.us-east-1.rds.amazonaws.com:3306/skillexchange?useSSL=false&serverTimezone=UTC
Environment=admin
Environment=cloud123

ExecStart=/opt/tomcat10/bin/startup.sh
ExecStop=/opt/tomcat10/bin/shutdown.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
```

**Example** — if your RDS endpoint is
`skillexchange-db.abcd1234wxyz.us-east-1.rds.amazonaws.com`, your username is
`skillexchange`, and your password is `MyStr0ngPass!`, the three lines would
read:
```
Environment=DB_URL=jdbc:mysql://skillexchange-db.abcd1234wxyz.us-east-1.rds.amazonaws.com:3306/skillexchange?useSSL=false&serverTimezone=UTC
Environment=DB_USER=skillexchange
Environment=DB_PASSWORD=MyStr0ngPass!
```

You can edit these three values any time with:
```bash
sudo nano /etc/systemd/system/tomcat10.service
sudo systemctl daemon-reload
sudo systemctl restart tomcat10
```

On Ubuntu, change `JAVA_HOME` in the file above to
`/usr/lib/jvm/java-17-openjdk-amd64` (confirm with
`update-alternatives --list java`).

Start Tomcat and confirm it's running:
```bash
sudo systemctl enable --now tomcat10
sudo systemctl status tomcat10
curl -I http://localhost:8080
```

Remove the default management apps (not needed, reduces attack surface):
```bash
sudo rm -rf /opt/tomcat10/webapps/manager /opt/tomcat10/webapps/host-manager \
            /opt/tomcat10/webapps/examples /opt/tomcat10/webapps/docs
```

---

## 3. Clone the Repository

```bash
cd ~
git clone <your-repo-url> SkillExchangeProject
cd SkillExchangeProject
```

If it's a private repo over HTTPS, you'll be prompted for a username and a
personal access token (not your account password). For SSH clones, make
sure this instance's SSH key is added as a deploy key on the repo first.

---

## 4. Create the Database Schema on RDS

Still inside `~/SkillExchangeProject` (so the relative path to
`database/schema.sql` resolves):

**Connect as the RDS master user** — put your **RDS endpoint** and **master
username** here:
```bash
mysql -h sd.c7ssi4qo40tp.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
```
You'll be prompted for the **RDS master password**.

**Create the app's own database + user** (don't use the master user for the
app itself) — set a real password where shown:
```sql
CREATE DATABASE IF NOT EXISTS skillexchange;

CREATE USER 'skillexchange'@'%' IDENTIFIED BY 'CHANGE_ME_STRONG_PASSWORD';
GRANT ALL PRIVILEGES ON skillexchange.* TO 'skillexchange'@'%';
FLUSH PRIVILEGES;
EXIT;
```

**Load the schema as that new user:**
```bash
mysql -h sd.c7ssi4qo40tp.us-east-1.rds.amazonaws.com -P 3306 -u admin -p skillexchange < database/schema.sql
```
Enter the password you just set (`CHANGE_ME_STRONG_PASSWORD`) when prompted.

> This `skillexchange` username/password combo is exactly what goes into
> `DB_USER` / `DB_PASSWORD` in the systemd file from Step 2.

---

## 5. Build the WAR

```bash
cd ~/SkillExchangeProject
mvn clean package
```
This produces `target/SkillExchangeProject.war` with the MySQL JDBC driver
and connection pool already bundled in — nothing else to install.

---

## 6. Deploy to Tomcat

cd ~/SkillExchangeProject

# If the footer edit has already been pushed:
#git pull

mvn clean package

sudo systemctl stop tomcat10
sudo rm -rf /opt/tomcat10/webapps/ROOT
sudo cp target/SkillExchangeProject.war /opt/tomcat10/webapps/ROOT.war
sudo chown tomcat:tomcat /opt/tomcat10/webapps/ROOT.war
sudo systemctl start tomcat10

## 7. Verify

```
http://<EC2_PUBLIC_IP>:8080/SkillExchangeProject/
```
Register a test user and log in to confirm the app can read/write to RDS
end-to-end.

---

## 8. Redeploying Updates Later

cd ~/SkillExchangeProject

git pull
mvn clean package

sudo systemctl stop tomcat10

sudo rm -rf /opt/tomcat10/webapps/ROOT
sudo rm -rf /opt/tomcat10/webapps/SkillExchangeProject \
            /opt/tomcat10/webapps/SkillExchangeProject.war

sudo cp target/SkillExchangeProject.war /opt/tomcat10/webapps/ROOT.war
sudo chown tomcat:tomcat /opt/tomcat10/webapps/ROOT.war

sudo systemctl start tomcat10
sudo tail -f /opt/tomcat10/logs/catalina.out
---

## Quick Reference — Where Things Go

| What | Where |
|---|---|
| RDS endpoint | `DB_URL` line in `/etc/systemd/system/tomcat10.service` (replaces `REPLACE_ME_ENDPOINT`) |
| RDS app DB username | `DB_USER` line in the same file, and the `mysql -u ...` command in Step 4 |
| RDS app DB password | `DB_PASSWORD` line in the same file, and the password prompt in Step 4 |
| RDS master username/password | only used once, to connect in Step 4 and create the app's own DB user |
| Git repo URL | `git clone <your-repo-url>` in Step 3 |

After changing any `DB_*` value:
```bash
sudo systemctl daemon-reload
sudo systemctl restart tomcat10
```

---

## Troubleshooting

**`Access denied for user '...'@'...'`** — `DB_USER`/`DB_PASSWORD` in the
systemd file don't match the user you created in Step 4.

**`Unknown database 'skillexchange'`** — the `CREATE DATABASE` in Step 4 was
skipped; run it as the master user and retry.

**App can't reach RDS at all (timeout)** — this is a security-group issue
(RDS must allow inbound port 3306 from the EC2 instance's security group),
not something fixed in this file.

**`ClassNotFoundException: com.mysql.cj.jdbc.Driver`** — the WAR wasn't
built with `mvn clean package`; rebuild and redeploy.

**Env vars not picked up** — check what systemd is actually passing:
```bash
sudo systemctl show tomcat10 -p Environment
```
and remember `sudo systemctl daemon-reload` after any edit to the service file.
