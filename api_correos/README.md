# API de Correos

## Introducción
La **API de Correos** es un servicio desarrollado en **ASP.NET Core** para facilitar el envío de correos electrónicos, incluyendo la posibilidad de adjuntar archivos. Esta solución permite superar las restricciones impuestas por algunos proveedores de alojamiento en la nube que bloquean el envío de correos a través del puerto 25.

### Versión de .NET
Esta API está desarrollada con **.NET 9.0.103**.

## Requisitos para ejecutar la API
Para ejecutar la API, se requiere lo siguiente:
- **.NET SDK 9.0.103** instalado. Puedes descargarlo desde [aquí](https://dotnet.microsoft.com/download/dotnet/9.0)
- **Configuración del `appsettings.json`** correctamente definida.
- **Dependencias instaladas** (ver siguiente sección).

### Instalación de dependencias
Antes de ejecutar la API, asegúrate de instalar las dependencias necesarias ejecutando:

```bash
dotnet restore
```

## Configuración del AppSettings.json
Para que la API funcione correctamente, es necesario configurar el archivo `appsettings.json`. A continuación se muestra un ejemplo de configuración, recuerda que puedes utilizar el [appsettings de ejemplo](./appsettings.Ejemplo.json), no olvides renombrarlo para que pueda funcionar:

```json
{
  "EmailSettings": {
    "SmtpServer": "smtp.tu dominio.com",
    "SmtpPort": "puerto del servidor",
    "SenderEmail": "tu correo@tu dominio.com",
    "SenderPassword": "tu contraseña"
  },
  "AllowedHosts": "*"
}
```

- **SmtpServer**: Dirección del servidor SMTP utilizado para enviar correos.
- **SmtpPort**: Puerto del servidor SMTP (25, 587 o 465 dependiendo del proveedor).
- **SenderEmail**: Correo electrónico desde el cual se enviarán los mensajes.
- **SenderPassword**: Contraseña del correo electrónico del remitente.
- **AllowedHosts**: Permite definir desde qué hosts se puede acceder a la API.

## Controlador `EmailSenderController`
Este controlador expone un endpoint para el envío de correos:

- **Endpoint:** `POST /api/EmailSender/send`
- **Parámetros:** Recibe un formulario con los siguientes campos:
  - `ToEmail` (string, requerido): Dirección del destinatario.
  - `Subject` (string, requerido): Asunto del correo.
  - `Body` (string, requerido): Contenido del correo.
  - `Attachment` (archivo, opcional): Archivo adjunto.

### Ejemplo de solicitud

```bash
curl -X POST "http://localhost:5000/api/EmailSender/send" \
     -F "ToEmail=destinatario@correo.com" \
     -F "Subject=Prueba" \
     -F "Body=Este es un correo de prueba" \
     -F "Attachment=@archivo.pdf"
```

## Servicio `EmailSender`
El servicio `EmailSender` se encarga de la lógica de envío de correos utilizando los parámetros definidos en `appsettings.json`. Este servicio se inyecta en `EmailSenderController` para facilitar su uso.

## Propiedades en `0.0.0.0`
La API está configurada para escuchar en `0.0.0.0`, lo que significa que acepta peticiones desde cualquier dirección IP. Esto es especialmente útil en entornos de contenedores o cuando se despliega en servidores accesibles desde diferentes redes.

## Seguridad
Para garantizar la seguridad de la API:
- Se recomienda utilizar **variables de entorno** para manejar credenciales sensibles.
- Implementar **autenticación y autorización** si la API será expuesta públicamente.
- Utilizar **HTTPS** para cifrar las comunicaciones.

## Tutorial de uso
### Clonar el repositorio
```bash
git clone https://github.com/tu-repositorio/api_correos.git
cd api_correos
```

### Instalar dependencias
```bash
dotnet restore
```

### Configurar `appsettings.json`
Modificar el archivo `appsettings.json` con los valores correctos para el servidor SMTP.

### Ejecutar la API
```bash
dotnet run
```

La API estará disponible en `http://localhost:5000` por defecto.

## Publicar la API
Para generar los archivos de despliegue de la API, utiliza el siguiente comando:

```bash
dotnet publish -c Release -o ./publicado
```

Esto creará una carpeta `publicado` con todos los archivos necesarios para ejecutar la API.

## Ejecutar la API permanentemente en Windows
Para que la API quede corriendo de manera permanente en un servidor Windows, sigue estos pasos:

1. **Abrir PowerShell como administrador**
2. **Navegar a la carpeta donde se publicó la API:**
   ```bash
   cd C:\ruta\a\publicado
   ```
3. **Ejecutar la API como un servicio en segundo plano:**
   ```bash
   Start-Process -NoNewWindow -FilePath "dotnet" -ArgumentList "api_correos.dll"
   ```

### Crear un servicio en Windows
Para ejecutar la API como un servicio de Windows y que se inicie automáticamente al encender el sistema:

1. **Abrir PowerShell como administrador** y ejecutar:
   ```bash
   New-Service -Name "ApiCorreos" -BinaryPathName "C:\ruta\a\publicado\api_correos.exe"
   ```
2. **Iniciar el servicio:**
   ```bash
   Start-Service -Name "ApiCorreos"
   ```
3. **Verificar el estado del servicio:**
   ```bash
   Get-Service -Name "ApiCorreos"
   ```

El servicio se ejecutará automáticamente cada vez que el sistema se inicie.

## Contacto
Para soporte o consultas, contacta a: **javiernancob@gmail.com**.

