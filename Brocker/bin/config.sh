#!/usr/bin/env bash

# Skript zur Erstellung von Konfigurationsdateien für ein Java-Webprojekt in WSL
# Verwendet Umgebungsvariablen oder lokale Werte für Benutzer und Passwort

# Benutzername (entweder aus Umgebungsvariable YOURUSER oder aktueller Benutzer)
USER_NAME="${YOURUSER:-$(whoami)}"

# Passwort (entweder aus Umgebungsvariable DEPLOYPASSWORD oder Standardwert)
# Hinweis: In einer Produktionsumgebung sollte das Passwort sicherer gehandhabt werden
DEPLOY_PASSWORD="${DEPLOYPASSWORD:-default_password}"

# Überprüfe, ob ein Passwort gesetzt ist
if [ -z "$DEPLOY_PASSWORD" ]; then
  echo "Fehler: Kein Passwort angegeben (setze DEPLOYPASSWORD oder passe das Skript an)" >&2
  exit 1
fi

# Erstelle das Verzeichnis local, falls es nicht existiert
mkdir -p local

# Erstelle config.txt mit Konfigurationswerten
# Passe die Werte an deine lokale Umgebung an (z. B. MySQL/Redis-Server)
cat << EOF > local/config.txt
user=$USER_NAME
webapp=docker-$USER_NAME-java
manager=docker-$USER_NAME-manager
dbserver=localhost
dbuser=$USER_NAME
dbname=${USER_NAME}_db
dbpassword=$DEPLOY_PASSWORD
redisserver=localhost
redispassword=$DEPLOY_PASSWORD
baseurl=http://localhost:8080
EOF

# Erstelle netrc-Datei für Netzwerkzugangsdaten
# Passe die Maschinen und Zugangsdaten an deine Umgebung an
cat << EOF > local/netrc
machine localhost login manager password $DEPLOY_PASSWORD
EOF

# Bestätigung ausgeben
echo "config.txt angelegt ($USER_NAME)"