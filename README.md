# Aplicación de Gestión de Neumáticos

## Descripción General
Este repositorio ha sido desarrollado por Javier Alonso Nanco Becerra para la empresa Pentacrom, con el objetivo principal de ofrecer una solución integral para la gestión de neumáticos en camiones. La problemática que se busca resolver es el mal manejo de los neumáticos, donde algunos choferes venden los neumáticos actuales y adquieren otros de menor calidad para obtener ganancias personales. Esto puede derivar en riesgos operativos y financieros para la empresa.

### Solución Propuesta
La aplicación permite gestionar neumáticos utilizando chips NFC implantados en cada uno de ellos. Cada chip cuenta con un identificador único (ID), lo que facilita el registro y la visualización del historial de cada neumático. Entre las funcionalidades principales de la aplicación se incluyen:

- Registro y monitoreo del kilometraje de cada neumático.
- Comprobaciones en movil de la existencia de los neumáticos.
- Alerta temprana para jefes de planta o administradores sobre cualquier peligro relacionado al estado de los neumáticos.

El sistema está diseñado para mejorar la seguridad, reducir costos y evitar irregularidades en la gestión de los neumáticos.

## Estructura del Repositorio
El repositorio está organizado de la siguiente manera:

- **`/flutter_control_neumaticos`**: Contiene el código fuente de la aplicación móvil desarrollada en Flutter.
- **`/api_control_neumaticos`**: Contiene el código fuente de la API desarrollada en ASP.NET Core.
- **`/api_correos`**: Contiene el código fuente de la API que tiene como objetivo enviar correos.
- **`/resources`**: Incluye los recursos de documentación:

## Tecnologías Utilizadas

1. **Frontend:** Flutter
2. **Backend:** ASP.NET Core
3. **Base de datos:** SQL SERVER
4. **Herramientas de monitoreo:** Chips con identificador único implantados en los neumáticos con tecnología NFC.

## Uso del Repositorio

### 1. Clonar el repositorio

```bash
git clone https://github.com/JavierNancoB/Control-Neumaticos.git
```

### 2. Configurar la API
En caso de no tener instalado ASP.NET Core, [haz clic aquí](./api_control_neumaticos/README.md) para seguir las instrucciones de instalación. Caso contrario, sigue los pasos a continuación:
1. Dirígete a la carpeta [/api_control_neumaticos](/api_control_neumaticos) y [/api_correos](/api_correos).
2. Configura la cadena de conexión a la base de datos en el archivo `appsettings.json` en la API principal y en la secundaria configura la conexión al servidor de mensajeria email, en ambas se tiene un ejemplo de como debe estar el app settings.
3. Ejecuta ambas APIs utilizando Visual Studio o la CLI de .NET:

   ```bash
   dotnet run
   ```

### 3. Configurar la aplicación Flutter
En caso de no tener instalado Flutter, [haz clic aquí](./flutter_control_neumaticos/README.md) para seguir las instrucciones de instalación. Caso contrario, sigue los pasos a continuación:
1. Dirígete a la carpeta [/flutter_control_neumaticos](/flutter_control_neumaticos).
2. Asegúrate de tener Flutter configurado, debes ajustar la url de tu api en [config.dart](./flutter_control_neumaticos/lib/models/config_ejemplo.dart). y particularmente cambiar el nombre de config_ejemplo.dart a solo config.dart.
3. Ejecuta la aplicación:

   ```bash
   flutter run
   ```

## Recursos de Documentación
En la carpeta [resources](./resources/README.md) encontrarás:

1. **Colección de Postman:** Se encuentran los endpoints de la API para pruebas de forma sencilla.
2. **Diagrama de flujo:** Describe el flujo de la base de datos de la API principal.

## Contacto
Si tienes dudas se encuentra mas documentación en las carpetas de las aplicacions o si necesitas más información, no dudes en contactarme a través de mi correo personal javiernancob@gmail.com.
