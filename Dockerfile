# Imagen base oficial de Python
FROM python:3.11-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo principal
COPY app.py .

# Comando que ejecutará el contenedor
CMD ["python", "app.py"]
