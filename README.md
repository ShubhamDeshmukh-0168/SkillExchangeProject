# SkillExchangeProject — Deploy on a New Server

This deploys the application on a fresh EC2 instance so it is reachable at:

`http://<EC2_PUBLIC_IP>/`

Your RDS is private and the application connects to it from the EC2 instance over the VPC.

---

## 1. Connect to the EC2 Instance

```bash
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
```

For Ubuntu:

```bash
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>
```

---

## 2. Install Required Software

### Amazon Linux 2023

```bash
sudo dnf update -y
sudo dnf install -y java-17-amazon-corretto maven git mariadb105
```

### Ubuntu

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk maven git mysql-client
```

Verify:

```bash
java -version
mvn -version
git --version
mysql --version
```

---

## 3. Install Tomcat 10.1

This application requires Tomcat 10.1+ because it uses the `jakarta.servlet.*` namespace.

```bash
cd /opt

TOMCAT_VERSION=10.1.59

sudo curl -fO https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

ls -lh apache-tomcat-${TOMCAT_VERSION}.tar.gz

sudo mkdir -p tomcat10

sudo tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
  -C tomcat10 --strip-components=1

sudo rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

ls /opt/tomcat10
```

You should see:

```text
bin
conf
lib
logs
temp
webapps
work
```

Create the Tomcat user and set permissions:

```bash
sudo useradd -r -M -U -d /opt/tomcat10 -s /bin/false tomcat

sudo chown -R tomcat:tomcat /opt/tomcat10

sudo chmod +x /opt/tomcat10/bin/*.sh

ls -la /opt/tomcat10/bin/*.sh
```

The scripts should have executable permissions such as:

```text
-rwxr-xr-x
```

---

## 4. Test Private RDS Connectivity

RDS endpoint:

```text
database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com
```

Username:

```text
admin
```

Database:

```text
skillexchange
```

Test the connection from EC2:

```bash
mysql -h database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com \
  -P 3306 \
  -u admin \
  -p
```

When prompted, enter the RDS password.

If successful:

```text
Welcome to the MariaDB monitor...
```

Exit:

```sql
exit;
```

### If the connection times out

Your RDS security group must allow:

```text
Type:     MySQL/Aurora
Port:     3306
Source:   EC2 instance security group
```

Do not open RDS to:

```text
0.0.0.0/0
```

The EC2 instance and RDS must have network connectivity inside the appropriate VPC/subnets.

---

## 5. Create the Tomcat systemd Service

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

Environment=DB_URL=jdbc:mysql://database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com:3306/skillexchange?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
Environment=DB_USER=admin
Environment=DB_PASSWORD=cloud123

ExecStart=/opt/tomcat10/bin/startup.sh
ExecStop=/opt/tomcat10/bin/shutdown.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

Check the file:

```bash
sudo cat /etc/systemd/system/tomcat10.service
```

Make sure the first line is exactly:

```text
[Unit]
```

---

## 6. Start Tomcat

```bash
sudo systemctl daemon-reload

sudo systemctl enable --now tomcat10

sudo systemctl status tomcat10 --no-pager
```

Test Tomcat:

```bash
curl -I http://localhost:8080
```

You should receive an HTTP response.

Remove the default Tomcat applications:

```bash
sudo rm -rf /opt/tomcat10/webapps/manager \
            /opt/tomcat10/webapps/host-manager \
            /opt/tomcat10/webapps/examples \
            /opt/tomcat10/webapps/docs
```

---

## 7. Create the RDS Database

If the `skillexchange` database does not already exist:

```bash
mysql -h database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com \
  -P 3306 \
  -u admin \
  -p \
  -e "CREATE DATABASE IF NOT EXISTS skillexchange;"
```

---

## 8. Clone the Repository

Replace `<your-repo-url>` with your Git repository URL.

```bash
cd ~

git clone <your-repo-url> SkillExchangeProject

cd SkillExchangeProject
```

---

## 9. Load the Database Schema

The project contains:

```text
database/schema.sql
```

Load it into the private RDS:

```bash
mysql -h database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com \
  -P 3306 \
  -u admin \
  -p \
  skillexchange < database/schema.sql
```

---

## 10. Build the Application

From the project directory:

```bash
mvn clean package
```

The build should produce:

```text
target/SkillExchangeProject.war
```

Verify:

```bash
ls -lh target/SkillExchangeProject.war
```

---

## 11. Deploy the Application as ROOT

Stop Tomcat:

```bash
sudo systemctl stop tomcat10
```

Remove the default ROOT application:

```bash
sudo rm -rf /opt/tomcat10/webapps/ROOT
```

Copy the application:

```bash
sudo cp target/SkillExchangeProject.war \
  /opt/tomcat10/webapps/ROOT.war
```

Set ownership:

```bash
sudo chown tomcat:tomcat \
  /opt/tomcat10/webapps/ROOT.war
```

Start Tomcat:

```bash
sudo systemctl start tomcat10
```

Watch the log:

```bash
sudo tail -f /opt/tomcat10/logs/catalina.out
```

Wait for Tomcat to finish deploying `ROOT.war`, then press:

```text
Ctrl+C
```

---

## 12. Test the Application Directly

Open:

```text
http://<EC2_PUBLIC_IP>:8080/
```

If the application works, continue to Nginx.

---

## 13. Install Nginx

### Amazon Linux

```bash
sudo dnf install -y nginx
```

### Ubuntu

```bash
sudo apt install -y nginx
```

---

## 14. Configure Nginx

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
```

Test Nginx:

```bash
sudo nginx -t
```

Start and enable:

```bash
sudo systemctl enable --now nginx
```

Reload:

```bash
sudo systemctl reload nginx
```

---

## 15. EC2 Security Group

Your EC2 security group should allow:

| Protocol | Port | Source |
|---|---:|---|
| SSH | 22 | Your IP |
| HTTP | 80 | Your required users / `0.0.0.0/0` |
| Custom TCP | 8080 | Only if you want to test Tomcat directly |

Once Nginx is working, you normally only need port 80 publicly.

Do not expose RDS publicly just because the application is on EC2.

---

## 16. Final Verification

Open:

```text
http://<EC2_PUBLIC_IP>/
```

Expected architecture:

```text
EC2
 |
 | Port 80
 v
Nginx
 |
 | 127.0.0.1:8080
 v
Tomcat 10
 |
 | Private VPC connection
 | Port 3306
 v
Private RDS
```

The application should be accessible without:

```text
:8080
```

and without:

```text
/SkillExchangeProject/
```

---

## 17. Verify RDS From the Application Server

```bash
mysql -h database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com \
  -P 3306 \
  -u admin \
  -p \
  -e "SHOW DATABASES;"
```

Then:

```bash
mysql -h database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com \
  -P 3306 \
  -u admin \
  -p \
  skillexchange \
  -e "SHOW TABLES;"
```

You should see the tables created by `database/schema.sql`.

---

## 18. Redeploying Updates

```bash
cd ~/SkillExchangeProject

git pull

mvn clean package
```

Then:

```bash
sudo systemctl stop tomcat10

sudo rm -rf /opt/tomcat10/webapps/ROOT \
              /opt/tomcat10/webapps/ROOT.war

sudo cp target/SkillExchangeProject.war \
  /opt/tomcat10/webapps/ROOT.war

sudo chown tomcat:tomcat \
  /opt/tomcat10/webapps/ROOT.war

sudo systemctl start tomcat10
```

Check:

```bash
sudo systemctl status tomcat10 --no-pager
```

And:

```bash
sudo tail -f /opt/tomcat10/logs/catalina.out
```

---

## Quick Reference

| Item | Value |
|---|---|
| RDS endpoint | `database-2.c05ceqiyeh79.us-east-1.rds.amazonaws.com` |
| RDS username | `admin` |
| RDS database | `skillexchange` |
| RDS port | `3306` |
| Tomcat | `/opt/tomcat10` |
| Tomcat port | `8080` |
| Application WAR | `/opt/tomcat10/webapps/ROOT.war` |
| Nginx port | `80` |
| Public application URL | `http://<EC2_PUBLIC_IP>/` |

> **Security:** The RDS password was provided in this chat and is included in the service configuration above. If this is a real production credential, rotate it after deployment. For production, use AWS Secrets Manager or SSM Parameter Store instead of storing the database password directly in the systemd service.
