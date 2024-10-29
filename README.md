# RpcEnum
Este script en Bash permite escanear de forma cómoda el servicio MSRPC

# Características
- Enumerar usuarios del dominio
- Enumerar información sobre usuarios del despliegue
- Enumerar descripción, nombre completo, alias de los usuarios
- Enumerar grupos
- Enumerar grupos y sus respectivos usuarios
- Enumerar impresoras
- Enumerar recursos compartidos por smb
- Enumerar política de contraseñas
- Enumerar información del servidor
- Imprimir un informe completo con todas las funciones anteriores

# Dependencias
- Es necesarios instalar las siguientes dependenciales
```
sudo apt install -y git curl sed xclip gawk coreutils              
```

# Uso
```
git clone https://github.com/Justice-Reaper/rpcEnum.git
cd rpcEnum
chmod +x rpcEnum.sh
./rpcEnum.sh
```

# Ejemplo
```
./HttpProxyPortScanner.sh

██╗  ██╗████████╗████████╗██████╗     ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗    ██████╗  ██████╗ ██████╗ ████████╗    ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ 
██║  ██║╚══██╔══╝╚══██╔══╝██╔══██╗    ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝    ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗
███████║   ██║      ██║   ██████╔╝    ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝     ██████╔╝██║   ██║██████╔╝   ██║       ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
██╔══██║   ██║      ██║   ██╔═══╝     ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝      ██╔═══╝ ██║   ██║██╔══██╗   ██║       ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
██║  ██║   ██║      ██║   ██║         ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║       ██║     ╚██████╔╝██║  ██║   ██║       ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║
╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝         ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝

Introduce el proxy (ejemplo: http://usuario:contraseña@ip:puerto - http://usuario:contraseña@dominio:puerto - http://ip:puerto - http://dominio:puerto)
Proxy: http://lance.friedman:o>WJ5-jD<5^m3@10.129.181.242:3128

Introduce el objetivo (ejemplo: http://ip - http://dominio - ip - dominio):
Objetivo: 127.0.0.1

Introduce hasta que puerto deseas escanear (ejemplo: 65535):
Puertos: 80
        [*] Port 22 - OPEN
        [*] Port 80 - OPEN

[+] Escaneo completado, los puertos abiertos han sido guardados en openPortsHttpProxy.txt
[+] Los puertos han sido copiados en la clipboard
```
