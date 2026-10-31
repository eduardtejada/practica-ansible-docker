# Imagen base oficial de Ubuntu
FROM ubuntu:22.04

# Evitar pausas interactivas durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar servidor OpenSSH, sudo y python3 (requerido por Ansible para ejecutar módulos)
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    python3-apt \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio necesario para el servicio SSH
RUN mkdir -p /var/run/sshd

# 1) Crear el usuario ansible con password ansible y shell bash
RUN useradd -m -s /bin/bash -G sudo ansible && \
    echo 'ansible:ansible' | chpasswd

# 1) Otorgar privilegios sudo sin contraseña al usuario ansible
RUN echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Asegurar que SSH permita autenticación por contraseña
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

# Exponer el puerto SSH
EXPOSE 22

# Iniciar el demonio SSH en primer plano
CMD ["/usr/sbin/sshd", "-D"]
