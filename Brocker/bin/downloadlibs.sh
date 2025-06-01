#!/usr/bin/env bash

# Funktion zum Herunterladen und Verschieben von JAR-Dateien aus dem Maven-Repository
# Parameter:
#   library_name: Name der Bibliothek (z. B. jakarta.jakartaee-api)
#   version: Version der Bibliothek (z. B. 10.0.0)
#   maven_path: Pfad im Maven-Repository (z. B. jakarta/platform)
#   library_type: Typ der Bibliothek (compile, runtime, compile+runtime)
#   custom_filename: Optionaler Dateiname für die JAR-Datei (überschreibt Standardnamen)
download_library() {
  local library_name="$1"
  local version="$2"
  local maven_path="$3"
  local library_type="$4"
  local custom_filename="$5"

  # Standardname der JAR-Datei: <Bibliotheksname>-<Version>.jar
  local default_filename="${library_name}-${version}.jar"
  # Verwende benutzerdefinierten Dateinamen, falls angegeben, sonst Standardname
  local final_filename="${custom_filename:-$default_filename}"
  # URL zum Herunterladen der JAR-Datei aus dem Maven-Repository
  local url="https://repo1.maven.org/maven2/${maven_path}/${library_name}/${version}/${library_name}-${version}.jar"

  # Lade die JAR-Datei in das temporäre Verzeichnis herunter
  curl -f -s -o "tmp/${final_filename}" "${url}"
  local download_status="$?"

  # Gib den Download-Status, Dateinamen und Bibliothekstyp aus
  echo "${download_status} ${final_filename} ${library_type}"

  # Wenn der Download erfolgreich war (Status 0)
  if [ "${download_status}" -eq 0 ]; then
    # Verschiebe die Datei basierend auf dem Bibliothekstyp
    if [ "${library_type}" = "compile" ]; then
      mv "tmp/${final_filename}" "lib/"
    elif [ "${library_type}" = "runtime" ]; then
      mv "tmp/${final_filename}" "app/WEB-INF/lib/"
    elif [ "${library_type}" = "compile+runtime" ]; then
      mv "tmp/${final_filename}" "lib/"
      cp "lib/${final_filename}" "app/WEB-INF/lib/"
    fi
  fi
}

# Lösche vorhandene Dateien in den Zielverzeichnissen
rm -f lib/*
rm -f app/WEB-INF/lib/*

# Erstelle die Verzeichnisse lib und tmp, falls sie nicht不便
mkdir -p lib tmp

# Lade die benötigten Bibliotheken herunter
download_library jakarta.jakartaee-api 10.0.0 jakarta/platform compile
download_library json 20240205 org/json compile+runtime
download_library jedis 5.2.0 redis/clients compile+runtime
download_library commons-pool2 2.12.0 org/apache/commons compile+runtime
download_library slf4j-api 2.0.16 org/slf4j runtime
download_library HikariCP 6.2.1 com/zaxxer runtime

# Entferne das temporäre Verzeichnis
rm -rf tmp