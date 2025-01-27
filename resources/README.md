# Carpeta `resources`

La carpeta `resources` contiene archivos esenciales para la documentación y pruebas del proyecto. Estos recursos están diseñados para facilitar la comprensión de las APIs y la estructura de la base de datos. A continuación, se describen los elementos principales que encontrarás dentro de esta carpeta.

## Contenido

### 1. Colección JSON de Postman

**Archivo:** `api-collection.postman.json`

Este archivo contiene una colección de solicitudes preconfiguradas de Postman que permiten probar las diferentes APIs del proyecto de manera sencilla.

#### Detalles:
- Las solicitudes están organizadas por carpetas, cada una representando un módulo o funcionalidad específica del sistema.
- Cada solicitud incluye:
  - La URL de la API.
  - Los métodos HTTP correspondientes (GET, POST, PUT, DELETE, etc.).
  - Cualquier encabezado o cuerpo necesario para realizar la petición.
- Ejemplo de pruebas incluidas:
  - Autenticación (login).
  - Operaciones CRUD para las entidades principales.
  - Endpoints relacionado para acceder a la base de datos a traves de atributos.

#### Cómo usar:
1. Importa el archivo `api-collection.postman.json` en Postman.
2. Configura la variable de entorno Token si es necesario.
3. Ejecuta las solicitudes o utiliza el runner de Postman para pruebas automatizadas, recuerda que la aplicación ASP.NET Core debe estar corriendo.

### 2. Diagrama de Base de Datos

**Archivo:** `database-diagram.png`

Este archivo es una representación gráfica de la estructura de la base de datos del proyecto, mostrando las tablas, columnas y relaciones entre ellas.

#### Detalles:
- El diagrama incluye:
  - Todas las tablas principales del sistema.
  - Relaciones (uno a uno, uno a muchos, muchos a muchos) entre las tablas.
  - Claves primarias y foráneas claramente identificadas.
- Diseñado para proporcionar una visión clara y comprensible de la arquitectura de la base de datos.

#### Cómo usar:
1. Abra el archivo database-diagram.drawio con un editor compatible como Draw.io o aplicaciones equivalentes.
2. Utilice el diagrama como referencia al implementar consultas o modificaciones en la base de datos.
3. Recuerde que ante cualquier modificación de la base de datos modificar tambien el diagrama entidad-relacion para generar una consistencia en la documentación.

## Propósito
La carpeta `resources` tiene como objetivo:
- **Facilitar las pruebas y validación:** La colección de Postman permite probar rápidamente los endpoints del sistema, asegurando que cumplen con los requisitos establecidos.
- **Proveer documentación visual:** El diagrama de la base de datos ayuda a entender la estructura del modelo de datos y a realizar cambios informados en el sistema.

## Cómo contribuir
Si realizas cambios en las APIs o en la base de datos, asegúrate de actualizar los recursos:
1. Actualiza la colección de Postman y exporta la nueva versión del archivo JSON.
2. Modifica el diagrama de la base de datos y genera un nuevo archivo actualizado.

## Créditos
Este recurso ha sido diseñado como apoyo para desarrolladores y miembros del equipo técnico del proyecto. Agradecemos cualquier retroalimentación o contribución que mejore su utilidad.

