# Práctica 8: Uso de Ansible para automatizar tareas en servidores

Este proyecto automatiza la configuración de **5 servidores virtuales Ubuntu** utilizando **Docker**, **Docker Compose** y **Ansible**.

## Estructura del Proyecto

```text
practica-ansible-docker/
├── Dockerfile             # Imagen Ubuntu con servidor SSH, usuario 'ansible' y sudo sin password
├── Dockerfile.ansible     # Imagen del nodo de control Ansible con ansible, sshpass y openssh-client
├── docker-compose.yml     # Orquesta los 5 servidores Ubuntu (server1 a server5) y el nodo Ansible
├── inventario.ini         # Inventario con los 5 servidores, IPs fijas, usuario y clave
├── ansible.cfg            # Configuración de Ansible (ignora advertencias de verificación de clave SSH)
├── playbook.yml           # Playbook que ejecuta las 5 tareas de automatización solicitadas
├── .dockerignore
├── .gitignore
└── README.md
```

## Requisitos Previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y en ejecución en Windows.

## Instrucciones de Ejecución

### 1. Iniciar los 5 servidores Ubuntu
Abre una terminal en este directorio y ejecuta:
```bash
docker compose up -d
```
Esto creará la red `ansible_net` (172.20.0.0/16) y levantará los 5 servidores:
- **server1**: IP `172.20.0.11` (Puerto SSH host: `2201`)
- **server2**: IP `172.20.0.12` (Puerto SSH host: `2202`)
- **server3**: IP `172.20.0.13` (Puerto SSH host: `2203`)
- **server4**: IP `172.20.0.14` (Puerto SSH host: `2204`)
- **server5**: IP `172.20.0.15` (Puerto SSH host: `2205`)

### 2. Probar conectividad con Ansible (Ping a todos los servidores)
Ejecuta el módulo ping desde el contenedor de Ansible:
```bash
docker compose run --rm ansible ansible all -m ping
```

### 3. Ejecutar el Playbook de automatización
Aplica todas las tareas en los 5 servidores en paralelo:
```bash
docker compose run --rm ansible ansible-playbook playbook.yml
```

Las tareas ejecutadas por el playbook son:
1. Actualizar el caché de APT del sistema operativo (`apt update`).
2. Crear el usuario `itla` en cada servidor.
3. Crear el directorio `/app` con permisos para el usuario `itla`.
4. Crear el archivo `/app/hola.txt` en cada servidor con información dinámica.
5. Instalar las aplicaciones `cowsay` e `htop` en cada servidor.

### 4. Verificar los resultados
Puedes comprobar que las tareas se completaron conectándote a cualquiera de los servidores, por ejemplo en `server1`:
```bash
# Ver contenido del archivo creado
docker exec -it server1 cat /app/hola.txt

# Probar la aplicación cowsay
docker exec -it server1 /usr/games/cowsay "¡Práctica 8 completada con éxito!"

# Verificar el usuario creado
docker exec -it server1 id itla
```

### 5. Detener el laboratorio
Cuando finalices la práctica, puedes apagar los servidores con:
```bash
docker compose down
```
