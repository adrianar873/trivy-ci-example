# Trivy CI/CD Demo

Demo práctica de cómo usar **Trivy**, un escáner de vulnerabilidades open source, para analizar imágenes Docker e integrarlo en un pipeline **CI/CD con GitHub Actions**.

---

## 📋 Índice

1. [¿Qué es Trivy?](#qué-es-trivy)
2. [Instalación en Ubuntu/Linux](#instalación-ubuntulinux)
3. [Escanear Imágenes Docker](#escanear-imágenes-docker)
4. [Integración en CI/CD](#integración-de-trivy-en-cicd)
5. [Ejemplo con GitHub Actions](#ejemplo-integración-con-github-actions)

---

## ¿Qué es Trivy?

**Trivy** (de [Aqua Security](https://github.com/aquasecurity/trivy)) detecta **vulnerabilidades (CVEs)** y **configuraciones inseguras** en:

- 🐳 Imágenes Docker
- 📁 Sistemas de archivos
- 📦 Repositorios de código

**Características principales:**
- Rápido y fácil de usar
- Compatible con Alpine, Debian, Ubuntu, RHEL, etc.
- Gratuito y open source
- Actualización constante de base de datos de vulnerabilidades

---

## Instalación (Ubuntu/Linux)

Instala **Trivy** paso a paso en un sistema basado en **Ubuntu/Linux**.

### Paso 1: Actualizar el sistema

```bash
# Actualiza los paquetes del sistema
sudo apt update && sudo apt upgrade -y
```

- `apt update` actualiza la lista de paquetes disponibles
- `apt upgrade` instala las últimas versiones de los paquetes instalados

### Paso 2: Instalar herramientas necesarias

```bash
# Instala wget y curl
sudo apt install wget curl -y
```

wget y curl se usan para descargar archivos desde la web

### Paso 3: Descargar Trivy

```bash
# Descarga el paquete .deb de Trivy
wget https://github.com/aquasecurity/trivy/releases/download/v0.67.2/trivy_0.67.2_Linux-64bit.deb
```

wget descarga el instalador directamente desde GitHub

### Paso 4: Instalar Trivy

```bash
# Instala Trivy desde el archivo descargado
sudo dpkg -i trivy_0.67.2_Linux-64bit.deb
```

dpkg instala el paquete Debian (.deb) en tu sistema

### Paso 5: Verificar instalación

```bash
# Verifica que Trivy esté instalado correctamente
trivy --version
```

Muestra la versión instalada de Trivy

### Paso 6: Actualizar base de datos

```bash
# Actualizar la base de datos de vulnerabilidades
trivy image --download-db-only
```

Descarga o actualiza la base de datos local usada para detectar CVEs

---

## Escanear Imágenes Docker

A continuación se muestran ejemplos prácticos de cómo analizar imágenes Docker con **Trivy** para detectar vulnerabilidades.

### Ejemplo básico: Escanear una imagen vulnerable

```bash
# Analiza la imagen "python:3.7-slim"
trivy image python:3.7-slim
```

**Este comando:**
- Analiza la imagen "python:3.7-slim"
- Muestra las vulnerabilidades detectadas
- Indica el nivel de severidad, los paquetes afectados y el estado del parche

### Opciones útiles de escaneo

```bash
# Mostrar solo vulnerabilidades CRÍTICAS y ALTAS
trivy image --severity CRITICAL,HIGH python:3.7-slim

# Guardar resultados en un archivo
trivy image --output results.txt python:3.7-slim

# Formato JSON para procesamiento automatizado
trivy image --format json --output results.json python:3.7-slim

# Salir con código de error si se encuentran vulnerabilidades
trivy image --exit-code 1 --severity CRITICAL,HIGH python:3.7-slim
```

---

## Integración de Trivy en CI/CD

**Trivy** puede integrarse fácilmente en un pipeline de **Integración Continua y Despliegue Continuo (CI/CD)** para automatizar el escaneo de vulnerabilidades en cada cambio de código o despliegue.

### ¿Por qué integrar Trivy en CI/CD?

- ✅ **Detección temprana**: Identifica vulnerabilidades antes de producción
- ✅ **Automatización**: Se ejecuta automáticamente en cada push o PR
- ✅ **Seguridad proactiva**: Previene el despliegue de código vulnerable
- ✅ **Cumplimiento**: Ayuda a cumplir con políticas de seguridad

### Flujo de trabajo típico

1. **Desarrollador** hace push al repositorio
2. **CI/CD** se activa automáticamente
3. **Trivy** escanea la imagen Docker construida
4. **Resultado**: 
   - ✅ Sin vulnerabilidades críticas → Continúa el despliegue
   - ❌ Vulnerabilidades encontradas → Detiene el proceso y notifica

---

## Ejemplo: Integración con GitHub Actions

Trivy se ejecuta como un paso dentro del workflow de GitHub Actions.

### Workflow completo

```yaml
name: Trivy Security Scan

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    
    steps:
      # 1. Checkout del código
      - name: Checkout code
        uses: actions/checkout@v4
      
      # 2. Ejecutar escaneo con Trivy
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'python:3.11-slim'
          format: 'table'
          output: 'trivy-results.txt'
          exit-code: '0'  # 0 = no falla el build, 1 = falla si hay vulnerabilidades
          severity: 'CRITICAL,HIGH,MEDIUM,LOW'
      
      # 3. Subir resultados como artefacto
      - name: Upload Trivy scan results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: trivy-scan-results
          path: trivy-results.txt
```


### Parámetros importantes

| Parámetro | Descripción | Valores |
|-----------|-------------|---------|
| `image-ref` | Imagen a escanear | `python:3.11-slim`, `myapp:latest` |
| `format` | Formato de salida | `table`, `json`, `sarif` |
| `output` | Archivo de resultados | `results.txt`, `report.json` |
| `exit-code` | Código de salida | `0` (no falla), `1` (falla si hay vulnerabilidades) |
| `severity` | Niveles de severidad | `CRITICAL`, `HIGH`, `MEDIUM`, `LOW` |


---

## 📚 Recursos Adicionales

- [Documentación oficial de Trivy](https://aquasecurity.github.io/trivy/)
- [Trivy GitHub Actions](https://github.com/aquasecurity/trivy-action)
- [Lista de CVEs](https://cve.mitre.org/)

---

## 📝 Notas

- Trivy requiere conexión a internet para actualizar su base de datos
- Los escaneos pueden tardar según el tamaño de la imagen
- Se recomienda usar imágenes base actualizadas (ej: `python:3.11-slim` en lugar de `python:3.7-slim`)
