# Guía de instalación: entorno Java profesional en Windows 11 + WSL 2

Vamos a preparar un entorno para trabajar con proyectos Java antiguos y modernos, usar Maven, desarrollar desde ambos IDE y levantar bases de datos con Docker.

En equipos con 32 GB de RAM o más, no hace falta limitar demasiado los recursos al principio. Lo importante es mantener una arquitectura sencilla, evitar instalaciones duplicadas y poder recuperar el entorno si algo falla.

## Fase 1. Comprobamos e instalamos WSL 2

### Paso 1.1 — Comprobamos el estado actual

Abrimos PowerShell como administrador desde el menú Inicio y ejecutamos:

```
wsl --status
wsl --version
wsl --list --verbose
```

Estos comandos permiten comprobar la versión de WSL, su configuración y las distribuciones Linux instaladas. Si alguno falla, no pasa nada: puede que WSL todavía no esté instalado.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://learn.microsoft.com\&sz=32)

Microsoft Learn

+1



### Paso 1.2 — Instalamos WSL y Ubuntu

Si WSL aún no está instalado, ejecutamos:

```
wsl --install
```

Reiniciamos Windows si el sistema lo solicita.

Si el comando muestra la ayuda en vez de iniciar la instalación, probamos lo siguiente:

```
wsl --list --online
wsl --install -d Ubuntu
```

Si la descarga se queda bloqueada en el 0 %, probamos:

```
wsl --install --web-download -d Ubuntu
```

No hace falta ejecutar todos los comandos consecutivamente: empezamos por el primero y utilizamos las alternativas solo si las necesitamos.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://learn.microsoft.com\&sz=32)

Microsoft Learn

+1



### Paso 1.3 — Creamos el usuario de Linux

Abrimos Ubuntu desde el menú Inicio. En el primer arranque, el sistema puede tardar unos minutos en prepararse.

El sistema nos pedirá:

- Un nombre de usuario de Linux, por ejemplo `dev`.
- Una contraseña para esa cuenta.

Esta cuenta es independiente de nuestras cuentas de Windows. Cuando usemos `sudo`, el sistema nos pedirá la contraseña de Linux para realizar operaciones administrativas.

### Paso 1.4 — Verificamos que Ubuntu funciona con WSL 2

Volvemos a PowerShell y ejecutamos:

```
wsl --list --verbose
```

El resultado esperado será similar a este:

```
  NAME      STATE      VERSION
* Ubuntu    Running    2
```

El estado puede ser `Stopped` si Ubuntu está cerrado; eso es normal. Lo importante es que la columna `VERSION` muestre `2`.

Si aparece `1`, conviértelo con:

```
wsl --set-version Ubuntu 2
```

Y establece WSL 2 como versión predeterminada para futuras distribuciones:

```
wsl --set-default-version 2
```

Si todo funciona, ya tendremos instalada la base del entorno.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://learn.microsoft.com\&sz=32)

Microsoft Learn


## Fase 2. Actualizamos Ubuntu y preparamos las herramientas

Abrimos Ubuntu y ejecutamos los siguientes comandos.

### Paso 2.1 — Actualizamos el sistema

```
sudo apt update
sudo apt upgrade -y
```

Instalamos las herramientas esenciales:

```
sudo apt install -y \
  git curl wget unzip zip \
  ca-certificates gnupg \
  build-essential openssh-client
```

Comprobamos las versiones:

```
git --version
curl --version
```

### Paso 2.2 — Creamos una estructura de directorios

```
mkdir -p ~/projects
mkdir -p ~/tools
mkdir -p ~/scripts
```

Usaremos esta organización:

`~/projects/`

Aquí guardaremos nuestros repositorios Git, aplicaciones y microservicios.

`~/tools/`

Aquí guardaremos herramientas auxiliares que no se instalen con apt o SDKMAN.

`~/scripts/`

Aquí guardaremos scripts para automatizar tareas de desarrollo.

No necesitamos crear manualmente carpetas para cada JDK ni para Maven: dejaremos que SDKMAN gestione las versiones.

Importante: el código vivirá en el sistema de archivos Linux, bajo `/home/...`. Microsoft recomienda este enfoque cuando ejecutamos herramientas Linux como Git, Maven y Docker, porque reduce el coste de acceso entre sistemas de archivos.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://learn.microsoft.com\&sz=32)

Microsoft Learn

+1



## Fase 3. Instalamos Java y gestionamos varias versiones

Como gestor de versiones de Java, usaremos SDKMAN!. Permite instalar y cambiar de JDK, y también gestionar Maven y otras herramientas del ecosistema Java.

### Paso 3.1 — Instalamos SDKMAN!

Desde Ubuntu:

```
curl -s "https://get.sdkman.io" | bash
```

Activamos SDKMAN! en la terminal actual:

```
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

Comprobamos que funciona:

```
sdk version
```

La instalación y activación están documentadas en la guía oficial de SDKMAN!.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://sdkman.io\&sz=32)

SDKMAN! the Software Development Kit Manager



### Paso 3.2 — Instalamos varias versiones del JDK

Primero, consultamos las versiones disponibles:

```
sdk list java
```

Como punto de partida, podemos considerar Java 17, 21 y 25, siempre que sean compatibles con nuestros proyectos y dependencias. Son generaciones LTS útiles para cubrir proyectos de distintas edades.

Instalamos las versiones que necesitemos seleccionando el identificador exacto que muestra SDKMAN!. Por ejemplo, si el identificador de una distribución aparece como `21.0.x-tem`, utilizamos ese identificador:

```
sdk install java 21.0.x-tem
```

El texto `21.0.x-tem` es un ejemplo de formato, no un identificador garantizado: lo reemplazamos por uno de los resultados reales de `sdk list java`.

Repetimos el procedimiento para las versiones adicionales.

### Paso 3.3 — Seleccionamos el JDK activo

Para consultar lo que hemos instalado:

```
sdk list java
java -version
javac -version
echo "$JAVA_HOME"
```

Para cambiar de versión en la terminal actual, ejecutamos:

```
sdk use java <identificador>
```

Para elegir una versión predeterminada, ejecutamos:

```
sdk default java <identificador>
```

Para fijar una versión solo en un proyecto, entramos en su directorio y ejecutamos:

```
sdk env init
```

Esto crea un archivo `.sdkmanrc` que podemos configurar con las versiones necesarias para ese proyecto. Después podremos activar su configuración con:

```
sdk env
```

Conviene no cambiar continuamente el Java predeterminado para cada aplicación: configuramos la versión en cada proyecto y nos aseguramos de que IntelliJ use el mismo JDK.

## Fase 4. Instalamos Maven

Instalamos Maven a través de SDKMAN! para gestionar su versión de forma coherente con los JDK:

```
sdk list maven
sdk install maven
```

Comprobamos la instalación:

```
mvn -version
```

La salida debe indicar tanto la versión de Maven como la de Java que estamos utilizando.

Cuando un proyecto tiene un Maven Wrapper (`mvnw`), normalmente conviene utilizarlo:

```
./mvnw -version
```

El Wrapper permite que el proyecto utilice la versión de Maven que sus desarrolladores han definido. No necesitamos instalar una versión global distinta para cada proyecto.

### Verificación práctica

Creamos un proyecto de prueba con Maven o utilizamos uno existente. Comprobamos que compila:

```
mvn clean verify
```

En proyectos con Wrapper:

```
./mvnw clean verify
```

No continuamos con la configuración de los IDE hasta que `java -version`, `mvn -version` y una compilación de prueba funcionen correctamente.

## Fase 5. Configuramos Git y SSH

### Paso 5.1 — Configuramos Git

Desde Ubuntu:

```
git config --global user.name "Nombre Apellido"
git config --global user.email "nombre.apellido@example.com"

git config --global init.defaultBranch main
git config --global core.autocrlf input
```

Sustituimos el nombre y el correo de ejemplo por los que utilizamos en nuestros repositorios.

Comprobamos la configuración:

```
git config --global --list
```

### Paso 5.2 — Preparamos SSH para GitHub o GitLab

Si utilizamos repositorios privados, podemos generar una clave SSH:

```
ssh-keygen -t ed25519 -C "nombre.apellido@example.com"
```

Guardamos la clave en la ubicación predeterminada. Después mostramos la clave pública:

```
cat ~/.ssh/id_ed25519.pub
```

Copiamos únicamente la clave pública a nuestro proveedor Git. No compartimos el archivo `~/.ssh/id_ed25519`, que es la clave privada.

Si utilizamos varios proveedores o ya tenemos una clave SSH configurada en Windows, valoraremos si conviene reutilizarla o mantener identidades separadas.

## Fase 6. Configuramos VS Code

[Visual studio code logo png vector svg free download – Artofit](https://images.openai.com/static-rsc-4/NlVyxEUh8Sbkqq6iXcGKDr5kfSRTDppoQJyX7JBnxo7QK2-gxXDN_S3sPUmUmEDCqRMIKBJC2hYIR0D53c_poHEyN9GWRNAJFtHvaL0vZUGlNvXb1JKEX_25edqS2rNrj0cEgrvVQBxUiVYzVsVLQQD2YyfA2TrkSo75vfTUiMQ?purpose=inline)

Instalamos VS Code en Windows; no hace falta instalar otra copia completa dentro de Ubuntu.

Lo descargamos desde [la web oficial de VS Code](https://code.visualstudio.com/) y añadimos la extensión WSL, de Microsoft.

### Paso 6.1 — Abrimos nuestro entorno Linux

Desde Ubuntu, ejecutamos:

```
cd ~/projects
code .
```

La primera vez, VS Code instalará su componente remoto en Ubuntu.

En la esquina inferior izquierda, comprobamos que la ventana esté conectada a WSL. La terminal integrada debe ejecutar Bash dentro de Ubuntu, no PowerShell.

### Paso 6.2 — Instalamos extensiones Java

En esa ventana conectada a WSL, instalamos las extensiones de Java que necesitemos, como las incluidas en el paquete Extension Pack for Java.

Comprobamos desde la terminal integrada:

```
java -version
mvn -version
git --version
```

Los resultados deben corresponder a Ubuntu.

Documentación: [Guía oficial de VS Code con WSL](https://learn.microsoft.com/es-es/windows/wsl/tutorials/wsl-vscode).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://learn.microsoft.com\&sz=32)

Microsoft Learn



## Fase 7. Configuramos IntelliJ IDEA

[File:JetBrains IntelliJ IDEA Product Icon.svg - Wikimedia Commons](https://images.openai.com/static-rsc-4/nvtrzeFNt65vrERznrQCfWZkGysv7qrVMDzsqKj6K6mwKql9H22cHYwDhqBfuIFzql5BYdRbbfVUYRiIr3Q2RRzRXrBVYW_DcAI5-tRQfxu5Qr35Zcf3MH5_M6fWFwEV-GZgdqrW_FDpzjMgDEm3W3We-bRVR5xUAPfiauWwzB0?purpose=inline)

Mantenemos IntelliJ IDEA instalado en Windows. No necesitamos instalar un escritorio Linux completo para utilizarlo con WSL.

Consultamos [la documentación oficial de IntelliJ y WSL](https://www.jetbrains.com/help/idea/how-to-use-wsl-development-environment-in-product.html).

### Paso 7.1 — Abrimos un proyecto ubicado en Ubuntu

En IntelliJ, seleccionamos Open y abrimos una carpeta de proyecto ubicada en nuestra distribución Ubuntu.

La ruta tendrá un formato parecido a:

```
\\wsl.localhost\Ubuntu\home\dev\projects\proyecto-demo
```

Sustituimos `dev` por nuestro usuario real y `proyecto-demo` por el nombre de la carpeta.

### Paso 7.2 — Configuramos el JDK

En los ajustes de IntelliJ, entramos en Project Structure y configuramos el SDK del proyecto con el JDK instalado en WSL.

Si el IDE no lo detecta automáticamente, utilizamos la opción para añadir un SDK desde WSL y seleccionamos el JDK correspondiente.

### Paso 7.3 — Configuramos Maven

En los ajustes de Maven, seleccionamos el Maven Wrapper del proyecto cuando esté disponible. Comprobamos que la ejecución de Maven utiliza el JDK de WSL y no una instalación de Java independiente de Windows.

Hacemos una prueba con una compilación y una ejecución de depuración.

Consejo: VS Code e IntelliJ pueden trabajar con el mismo repositorio, pero no ejecutamos simultáneamente operaciones Git que modifiquen el índice desde ambos IDE.

## Fase 8. Instalamos Docker para bases de datos y servicios

Empezaremos con Docker Desktop en Windows con integración WSL 2. Es una opción sencilla para ejecutar PostgreSQL, MySQL, Redis y otros servicios sin mantener instalaciones independientes de cada base de datos.

[Use docker on reComputer | Seeed Studio Wiki](https://images.openai.com/static-rsc-4/amm6Vb_4VYZT5-KWySxrvu6Crufk4KG7G29DQQIu7g959wCq5COHo0FcgKjkniI61de5tp_tebFzOY55jE4Zg34QKNv3MnYP14qH7tkoTRoPvs8ptd6QWnwwvgGmjJ2eAfyQwyrzEH-GAfrjyBBhv-H-9ZrP3yHxwwMMCzKKuos?purpose=inline)

Descargamos Docker Desktop desde [la web oficial de Docker](https://www.docker.com/products/docker-desktop/).

### Paso 8.1 — Activamos la integración con WSL

En Docker Desktop:

1. Entramos en Settings → General.
2. Activamos Use the WSL 2 based engine.
3. Entramos en Settings → Resources → WSL Integration.
4. Activamos la integración con Ubuntu.
5. Pulsamos Apply & Restart.

### Paso 8.2 — Verificamos Docker desde Ubuntu

Abrimos una terminal nueva en Ubuntu y ejecutamos:

```
docker version
docker compose version
docker run --rm hello-world
```

Si funciona, tendremos Docker disponible desde nuestro entorno Linux. No instalamos además otro daemon Docker dentro de Ubuntu mientras usemos Docker Desktop, porque puede provocar conflictos de contexto y configuración.

### Paso 8.3 — Levantamos una base de datos de prueba

Por ejemplo, creamos `~/projects/docker-lab/compose.yaml` para probar PostgreSQL:

```
services:
  postgres:
    image: postgres:17
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:?Definamos POSTGRES_PASSWORD}
    ports:
      - "127.0.0.1:5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Creamos el directorio y el archivo `compose.yaml`, y definimos una contraseña de prueba en la terminal antes de iniciar el servicio:

```
mkdir -p ~/projects/docker-lab
cd ~/projects/docker-lab

export POSTGRES_PASSWORD='cambia-esta-clave-local'
docker compose up -d
docker compose ps
```

Guardamos el contenido YAML anterior en `compose.yaml` antes de ejecutar los comandos. La contraseña es ilustrativa: no usamos esa cadena en un entorno real ni guardamos secretos en Git.

Para detener el servicio, ejecutamos:

```
docker compose down
```

Los datos persistentes se conservan en el volumen. Para eliminar también los datos, tendríamos que borrar explícitamente el volumen, así que no usamos esa operación sin comprobar antes qué necesitamos conservar.

Documentación: [Configuración del entorno de desarrollo WSL](https://learn.microsoft.com/en-us/windows/wsl/setup/environment) y [Docker y WSL 2](https://learn.microsoft.com/en-us/windows/dev-environment/docker/dev-containers).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://learn.microsoft.com\&sz=32)

Microsoft Learn

+1



## Fase 9. Ajustamos recursos y mantenimiento

Con 32 GB de RAM o más, empezaremos con los valores predeterminados y mediremos el consumo antes de limitar WSL. Podemos añadir una configuración de memoria y CPU en el archivo `.wslconfig` de nuestro perfil de Windows si observamos un consumo excesivo.

No es necesario configurarlo de inmediato. Docker Desktop y WSL comparten recursos del equipo, y conviene medir primero cómo se comportan IntelliJ, Maven y los contenedores en conjunto.

Mantenemos también un plan de recuperación:

- Guardamos el código en repositorios Git remotos.
- Conservamos un respaldo de los archivos de configuración, las claves públicas y los scripts.
- Exportamos periódicamente la distribución WSL con `wsl --export` desde PowerShell.
- Hacemos copias de seguridad de los datos importantes de Docker por separado: exportar Ubuntu no sustituye necesariamente a una estrategia de backup de los volúmenes de Docker Desktop.

## Lista de comprobación final

## Progreso de la instalación

### 0/10

WSL instalado y Ubuntu ejecutándose en versión 2

Ubuntu actualizado y herramientas básicas instaladas

SDKMAN funcionando y JDK necesarios instalados

Maven y Maven Wrapper verificados

Git configurado y SSH preparado si es necesario

VS Code conectado a WSL

IntelliJ configurado con el JDK y Maven de WSL

Docker Desktop integrado con Ubuntu

Contenedor de prueba ejecutado y detenido correctamente

Código y datos importantes con una estrategia de respaldo

&#x20;Copiar lista de comprobación

Para empezar, completamos la Fase 1 y verificamos `wsl --list --verbose`. Cuando confirmemos que Ubuntu está instalado y funciona con WSL 2, podremos avanzar sobre una base conocida y solucionar cualquier problema concreto antes de instalar el resto.