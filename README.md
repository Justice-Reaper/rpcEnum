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

# Uso
```
git clone https://github.com/Justice-Reaper/rpcEnum.git
cd rpcEnum
chmod +x rpcEnum.sh
./rpcEnum.sh
```

# Panel de Ayuda
Si usamos el script de forma incorrecta nos saltará un aviso y nos mostrará el panel de ayuda

![](/images/image_1.png)

# Enumeración de Usuarios
Utilización de los parámetros -u (username) y -p (password) para proporcionar unas credenciales 

![](/images/image_2.png)

Enumerar sin usar credenciales, es decir con el usuario anonymous 

![](/images/image_3.png)

Otra alternativa sería dejar los campos -u (username) y -p (password) vacíos

![](/images/image_4.png)

Enumerar información sobre los usuario en el despliegue

![](/images/image_5.png)

Enumerar toda la información posible de los usuarios

![](/images/image_6.png)

# Enumeración de Grupos
Enumerar los grupos y sus descripciones

![](/images/image_7.png)

Enumerar los grupos y los usuarios pertenecientes a cada uno de ellos

![](/images/image_8.png)

# Enumeración de impresoras
Enumerar las impresoras

![](/images/image_9.png)

# Enumeración Smb
Enumerar los recursos compartidos por smb

![](/images/image_10.png)

# Enumeración de la Política de Contraseñas
Enumerar la política de contraseñas

![](/images/image_11.png)

# Enumeración del Servidor
Enumerar información sobre el servidor

![](/images/image_12.png)

## Créditos
Autor: Justice-Reaper  

Inspiración: Herramienta basada en la creada por Zunder > [https://github.com/rubenza02/rpcenumeration.git](https://github.com/rubenza02/rpcenumeration.git)  

Youtube: Enlace al vídeo de Zunder donde explica la utilidad de su herramienta > [https://youtu.be/gC6l4YA3Ue4?si=MFjejjpeVxMlbhjg](https://youtu.be/gC6l4YA3Ue4?si=MFjejjpeVxMlbhjg)
