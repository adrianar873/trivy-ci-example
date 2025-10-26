#  Trivy CI/CD Demo

Demo práctica de cómo usar **Trivy**, un escáner de vulnerabilidades open source, para analizar imágenes Docker e integrarlo en un pipeline **CI/CD con GitHub Actions**.

---

## ¿Qué es Trivy?

**Trivy** (de [Aqua Security](https://github.com/aquasecurity/trivy)) detecta **vulnerabilidades (CVEs)** y **configuraciones inseguras** en:

- Imágenes Docker   
- Sistemas de archivos 
- Repositorios de código  

Es rápido, fácil de usar y compatible con Alpine, Debian, Ubuntu, RHEL, etc.

---

## Instalación (Ubuntu/Linux)

Instala **Trivy** paso a paso en un sistema basado en **Ubuntu/Linux**.

```bash
# 1️ Actualiza los paquetes del sistema
sudo apt update && sudo apt upgrade -y
# - `apt update` actualiza la lista de paquetes disponibles
# - `apt upgrade` instala las últimas versiones de los paquetes instalados

# 2️ Instala las herramientas necesarias (wget y curl)
sudo apt install wget curl -y
# wget y curl se usan para descargar archivos desde la web

# 3️ Descarga el paquete .deb de Trivy 
wget https://github.com/aquasecurity/trivy/releases/download/v0.67.2/trivy_0.67.2_Linux-64bit.deb
# wget descarga el instalador directamente desde GitHub

# 4️ Instala Trivy desde el archivo descargado
sudo dpkg -i trivy_0.67.2_Linux-64bit.deb
# dpkg instala el paquete Debian (.deb) en tu sistema

# 5️ Verifica que Trivy esté instalado correctamente
trivy --version
# Muestra la versión instalada de Trivy

# 6️ Actualizar la base de datos de vulnerabilidades
trivy image --download-db-only
# Descarga o actualiza la base de datos local usada para detectar CVEs


## 🔍 Escanear una Imagen Docker

A continuación se muestran ejemplos prácticos de cómo analizar imágenes Docker con **Trivy** para detectar vulnerabilidades.

---

### Escanear una imagen vulnerable (`python:3.7-slim`)

```bash
trivy image python:3.7-slim
# - Analiza la imagen "python:3.7-slim"
# - Muestra las vulnerabilidades detectadas
# - Indica el nivel de severidad, los paquetes afectados y el estado del parche



##  Integración de Trivy en CI/CD

**Trivy** puede integrarse fácilmente en un pipeline de **Integración Continua y Despliegue Continuo (CI/CD)** para automatizar el escaneo de vulnerabilidades en cada cambio de código o despliegue.

Durante el flujo de CI/CD, Trivy se ejecuta automáticamente cuando se realiza un **push**, **pull request** o **build** de una imagen Docker.  
Esto permite detectar vulnerabilidades **antes de que la aplicación llegue a producción**.

---

###  Ejemplo: Integración con GitHub Actions

Trivy se ejecuta como un paso dentro del workflow de GitHub Actions:

```yaml
name: Trivy Scan
on:
  push:
    branches: [ main ]

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Trivy Scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: python:3.11-slim
          format: table
          output: results.txt
          exit-code: 0
          severity: CRITICAL,HIGH,MEDIUM,LOW

