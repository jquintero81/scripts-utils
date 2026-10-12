### Guía de instalación: entorno Java profesional en Windows 11 + WSL 2

Vamos a montarlo de forma que puedas trabajar con proyectos Java antiguos y modernos, usar Maven, desarrollar desde ambos IDE y levantar bases de datos con Docker.

Con tus 32 GB de RAM o más, no necesitas limitar demasiado los recursos al principio. Lo importante es mantener una arquitectura sencilla, evitar instalaciones duplicadas y poder recuperar el entorno si algo falla.

### Fase 1. Comprobar e instalar WSL 2

### Paso 1.1 — Comprueba el estado actual

Abre PowerShell como administrador desde el menú Inicio y ejecuta:

```powershell
wsl --status
wsl --version
wsl --list --verbose
```

Estos comandos permiten comprobar la versión de WSL, su configuración y las distribuciones Linux instaladas. Si alguno falla, no pasa nada: puede que WSL todavía no esté instalado.

### Paso 1.2 — Instala WSL y Ubuntu

Si no tienes WSL instalado, ejecuta:

```powershell
wsl --install
```

Reinicia Windows si te lo solicita.

Si el comando muestra la ayuda en vez de iniciar la instalación, prueba lo siguiente:

```powershell
wsl --list --online
wsl --install -d Ubuntu
```

Si la descarga se queda bloqueada en el 0 %, puedes probar:

```powershell
wsl --install --web-download -d Ubuntu
```

No hace falta ejecutar todos los comandos consecutivamente: empieza por el primero y utiliza las alternativas solo si las necesitas.

### Paso 1.3 — Crea tu usuario Linux

Abre Ubuntu desde el menú Inicio. En el primer arranque puede tardar unos minutos mientras se prepara el sistema.

Te pedirá:

* Un nombre de usuario Linux, por ejemplo `dev`.

* Una contraseña para ese usuario.

Esta cuenta es independiente de tu cuenta de Windows. Cuando uses `sudo`, se te pedirá la contraseña Linux para realizar operaciones administrativas.

### Paso 1.4 — Verifica que Ubuntu funciona con WSL 2

Vuelve a PowerShell y ejecuta:

```powershell
wsl --list --verbose
```

El resultado esperado será similar a este:

```text
  NAME      STATE      VERSION
* Ubuntu    Running    2
```

El estado puede ser `Stopped` si Ubuntu está cerrado; eso es normal. Lo importante es que la columna `VERSION` muestre `2`.

Si aparece `1`, conviértelo con:

```powershell
wsl --set-version Ubuntu 2
```

Y establece WSL 2 como versión predeterminada para futuras distribuciones:

```powershell
wsl --set-default-version 2
```

Si todo funciona, ya tienes la base del entorno instalada.

### Fase 5. Configurar Git y SSH

### Paso 5.1 — Configurar Git

En Ubuntu:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@example.com"

git config --global init.defaultBranch main
git config --global core.autocrlf input
```

Sustituye el nombre y el correo por los que utilizas en tus repositorios.

Comprueba la configuración:

```bash
git config --global --list
```

### Paso 5.2 — Preparar SSH para GitHub o GitLab

Si utilizas repositorios privados, puedes generar una clave SSH:

```bash
ssh-keygen -t ed25519 -C "tu-correo@example.com"
```

Guarda la clave en la ubicación predeterminada. Después muestra la clave pública:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copia únicamente la clave pública a tu proveedor Git. No compartas el archivo `~/.ssh/id_ed25519`, que es tu clave privada.

Si utilizas varios proveedores o tienes una clave SSH ya configurada en Windows, podemos decidir después si conviene reutilizarla o mantener identidades separadas.

### Fase 6. Configurar VS Code

![Visual studio code logo png vector svg free download – Artofit](https://images.openai.com/static-rsc-4/3Dm-CyYOLXRFVcIdfmwsEGQK6rbcQV1pbzDQajpb8pKM0I4gfckw2DJrw4TpDlGf_NmIjtuyClfSlc75pETpHfahIPThwUfOj_YG8019QKeED-EJZc3peTMl29eFsHoTyoTomkBHQCidYoKCkgXd5AiLJPRTLeyA8g_qyHCxuBmoSvQj3-4db0_Ma1eDTonw?purpose=fullsize)

VS Code se instala en Windows, no hace falta instalar otra copia completa dentro de Ubuntu.

Descárgalo desde [la web oficial de VS Code](https://code.visualstudio.com/) y añade la extensión WSL, de Microsoft.

### Paso 6.1 — Abrir tu entorno Linux

Desde Ubuntu:

```bash
cd ~/projects
code .
```

La primera vez, VS Code instalará su componente remoto en Ubuntu.

En la esquina inferior izquierda deberías ver que la ventana está conectada a WSL. La terminal integrada debe ejecutar Bash dentro de Ubuntu, no PowerShell.

### Paso 6.2 — Instalar extensiones Java

En esa ventana conectada a WSL, instala las extensiones de Java que necesites, como las incluidas en el paquete Extension Pack for Java.

Comprueba desde la terminal integrada:

```bash
java -version
mvn -version
git --version
```

Los resultados deben corresponder a Ubuntu.

Documentación: [Guía oficial de VS Code con WSL](https://learn.microsoft.com/es-es/windows/wsl/tutorials/wsl-vscode).

### Fase 7. Configurar IntelliJ IDEA

![File:JetBrains IntelliJ IDEA Product Icon.svg - Wikimedia Commons](https://images.openai.com/static-rsc-4/Yf0j7jmH57ktOch2reReI3x_wvpS7OYr9O8Y0u9aHyJD4hIS0Ywv99r4xaWyfiCr074erSVF_ShTWyMo1Q-qREdjKw9bbvoU-5IyOWXCNuT0tVdO1Vt0zJmycVpfNBLrKXEYidEj_xg87Ayn9xp8SLwyM8VyrlwopXyeW5yI87aqr9EobCJwbrPbs0xmEWWv?purpose=fullsize)

Mantén IntelliJ IDEA instalado en Windows. No necesitas instalar un escritorio Linux completo para utilizarlo con WSL.

Consulta [la documentación oficial de IntelliJ y WSL](https://www.jetbrains.com/help/idea/how-to-use-wsl-development-environment-in-product.html).

### Paso 7.1 — Abrir un proyecto ubicado en Ubuntu

En IntelliJ, selecciona Open y abre una carpeta de proyecto ubicada en tu distribución Ubuntu.

La ruta tendrá un formato parecido a:

```text
\\wsl.localhost\Ubuntu\home\dev\projects\mi-proyecto
```

Sustituye `dev` por tu usuario real y `mi-proyecto` por el nombre de la carpeta.

### Paso 7.2 — Configurar el JDK

En los ajustes de IntelliJ, entra en Project Structure y configura el SDK del proyecto con el JDK instalado en WSL.

Si el IDE no lo detecta automáticamente, utiliza la opción para añadir un SDK desde WSL y selecciona el JDK correspondiente.

### Paso 7.3 — Configurar Maven

En los ajustes de Maven, selecciona el Maven Wrapper del proyecto cuando esté disponible. Comprueba que la ejecución de Maven utiliza el JDK de WSL, y no una instalación de Java independiente de Windows.

Haz una prueba con una compilación y una ejecución de depuración.

Consejo: VS Code e IntelliJ pueden trabajar con el mismo repositorio, pero no ejecutes simultáneamente operaciones Git que modifiquen el índice desde ambos IDE.

### Fase 8. Instalar Docker para bases de datos y servicios

Para tu configuración, empezaría por Docker Desktop en Windows con integración WSL 2. Es una opción sencilla para ejecutar PostgreSQL, MySQL, Redis y otros servicios sin mantener instalaciones independientes de cada base de datos.

![Use docker on reComputer | Seeed Studio Wiki](https://images.openai.com/static-rsc-4/Dzb_ub1XSunIllrbkhmbxfvCaF7wJdKMzvIWC_ULSU3A9VAjsMojnleGBiGjDyk_OmwhXimaw9pb7sE06e_NwcGMrONKWYv1Y8xd5mdBAUYNqepQe8zpGxYQAigEywIcMOmNbRiSw_bLlzZqMFNxBLFflsBLfZwyadFjEwXDxWLmc4EicYMqDCGbojKS_GaJ?purpose=fullsize)

Descarga Docker Desktop desde [la web oficial de Docker](https://www.docker.com/products/docker-desktop/).

### Paso 8.1 — Activar la integración con WSL

En Docker Desktop:

* Entra en Settings → General.

* Activa Use the WSL 2 based engine.

* Entra en Settings → Resources → WSL Integration.

* Activa la integración con Ubuntu.

* Pulsa Apply & Restart.

### Paso 8.2 — Verificar Docker desde Ubuntu

Abre una terminal nueva en Ubuntu:

```bash
docker version
docker compose version
docker run --rm hello-world
```

Si funciona, tendrás Docker disponible desde tu entorno Linux. No instales además otro daemon Docker dentro de Ubuntu mientras uses Docker Desktop, porque puede provocar conflictos de contexto y configuración.

### Paso 8.3 — Levantar una base de datos de prueba

Por ejemplo, puedes crear `~/projects/docker-lab/compose.yaml` para probar PostgreSQL:

```yaml
services:
  postgres:
    image: postgres:17
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:?Define POSTGRES_PASSWORD}
    ports:
      - "127.0.0.1:5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Crea el directorio y el archivo `compose.yaml`, y define una contraseña de prueba en tu terminal antes de iniciar el servicio:

```bash
mkdir -p ~/projects/docker-lab
cd ~/projects/docker-lab

export POSTGRES_PASSWORD='cambia-esta-clave-local'
docker compose up -d
docker compose ps
```

Guarda el contenido YAML anterior en `compose.yaml` antes de ejecutar los comandos. La contraseña es ilustrativa: no uses esa cadena en un entorno real ni guardes secretos en Git.

Para detener el servicio:

```bash
docker compose down
```

Los datos persistentes se conservan en el volumen. Para eliminar también los datos, tendrías que borrar explícitamente el volumen, así que no uses esa operación sin comprobar antes qué necesitas conservar.

Documentación: [Configuración del entorno de desarrollo WSL](https://learn.microsoft.com/en-us/windows/wsl/setup/environment) y [Docker y WSL 2](https://learn.microsoft.com/en-us/windows/dev-environment/docker/dev-containers).

### Fase 9. Ajustar recursos y mantenimiento

Con 32 GB de RAM o más, empezaría con los valores predeterminados y mediría el consumo antes de limitar WSL. Puedes añadir una configuración de memoria y CPU en el archivo `.wslconfig` de tu perfil de Windows si observas un consumo excesivo.

No es necesario configurarlo ahora. Docker Desktop y WSL comparten recursos del equipo, y conviene medir primero cómo se comportan IntelliJ, Maven y los contenedores en conjunto.

Mantén también un plan de recuperación:

* Guarda el código en repositorios Git remotos.

* Conserva un respaldo de los archivos de configuración, las claves públicas y los scripts.

* Exporta periódicamente la distribución WSL con `wsl --export` desde PowerShell.

* Haz copias de seguridad de los datos importantes de Docker por separado: exportar Ubuntu no sustituye necesariamente a una estrategia de backup de los volúmenes de Docker Desktop.

### Lista de comprobación final

### Progreso de la instalación

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

 Copiar lista de comprobación

Mi recomendación para empezar hoy: completa únicamente la Fase 1 y verifica `wsl --list --verbose`. Cuando confirmes que Ubuntu está instalado y funciona con WSL 2, podremos avanzar sobre una base conocida y solucionar cualquier problema concreto antes de instalar el resto.
