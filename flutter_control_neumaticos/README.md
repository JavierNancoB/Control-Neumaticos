# Aplicación Flutter - Gestión de Neumáticos

## Introducción
Este README describe los detalles de la aplicación Flutter desarrollada principalmente para dispositivos Android. La aplicación está diseñada para facilitar la gestión de neumáticos mediante el uso de chips NFC y permite a los administradores llevar un registro detallado del historial de cada neumático.

## Tutorial de Instalación
Sigue estos pasos para configurar y ejecutar la aplicación Flutter:

1. **Requisitos Previos:**
   - Tener Flutter instalado en tu sistema. Sigue la [documentación oficial](https://flutter.dev/docs/get-started/install) para configurarlo.
   - Un emulador o dispositivo Android conectado para probar la aplicación.

2. **Clonar el Repositorio:**
   ```bash
   git clone [URL-del-repositorio]
   cd flutter-app
   ```

3. **Instalar las Dependencias:**
   Ejecuta el siguiente comando en la carpeta del proyecto:
   ```bash
   flutter pub get
   ```

4. **Ejecutar la Aplicación:**
   Para ejecutar la aplicación en un dispositivo o emulador:
   ```bash
   flutter run
   ```

## Contexto y Funcionalidades
La aplicación se centra en ofrecer una solución para la gestión de neumáticos en camiones, utilizando la tecnología NFC para identificar cada neumático mediante un ID único. Entre sus principales funcionalidades se incluyen:

- Escaneo de chips NFC para registrar y consultar información del neumático.
- Registro de kilometraje y tipo de neumático.
- Visualización del historial y alertas de seguridad para los administradores.

### Estructura General de las Carpetas en `lib`

- **`main.dart`**: Archivo principal que inicializa la aplicación.
- **`screens/`**: Contiene las pantallas de la aplicación, como la pantalla de inicio, detalles de neumáticos y configuraciones.
- **`widgets/`**: Componentes reutilizables, como botones personalizados y cuadros de diálogo.
- **`services/`**: Maneja la lógica relacionada con el NFC y las llamadas a la API.
- **`models/`**: Define las clases y modelos utilizados en la aplicación, como el modelo de neumático.
- **`utils/`**: Funciones auxiliares y constantes usadas en toda la aplicación.

## Librerías Utilizadas
La aplicación utiliza varias dependencias para implementar funcionalidades específicas:

### Dependencias Principales:
- **`flutter`**: SDK principal de Flutter.
- **`cupertino_icons`**: Iconos prediseñados para aplicaciones con estilo iOS.
- **`nfc_manager`**: Manejo de NFC para interactuar con los chips.
- **`pin_code_fields`**: Campos de entrada para códigos PIN.
- **`http`**: Realizar solicitudes HTTP a la API.
- **`shared_preferences`**: Almacenamiento local de datos.

## Screens
Aqui se encuentran las pantallas de la aplicación, a continuacion explicaré en detalle cada una.

### login
La funcionalidad de login de la aplicación permite a los usuarios autenticarse y acceder a las funcionalidades protegidas del sistema. A continuación, se describen las principales características de esta pantalla y su implementación.

El login se encuentra implementado en el widget HomePage, que utiliza un diseño basado en un formulario sencillo con los siguientes elementos:

1. Campos de Entrada:
- UsernameField: Campo de texto para que el usuario ingrese su nombre de usuario.
- PasswordField: Campo para la contraseña, con funcionalidad para mostrar u ocultar el texto.
2. Opciones Adicionales:
- RememberMeCheckbox: Checkbox que permite al usuario decidir si los datos deben recordarse para futuros inicios de sesión.
- ForgotPasswordLink: Enlace que redirige a la pantalla de recuperación de contraseña (RecuperarContrasenaPage).
3. Acciones:
- LoginButton: Botón para enviar los datos ingresados al servicio de autenticación.

El estado y lógica del formulario están manejados dentro del widget HomePage:

Autocompletar: Si el usuario seleccionó "Recordarme" en un inicio previo, los datos se cargan automáticamente desde el almacenamiento local.
Validación: Se valida que el usuario complete todos los campos antes de proceder.
Autenticación: Se conecta con el servicio AuthService para realizar la autenticación.
Redirección: Si las credenciales son correctas, se guarda el token y el ID del usuario, y el usuario es redirigido al menú principal.

### Menu

### NFC

## Models

## Services

### Services generales

### Services Admin

## Utils

## Widgets

## Contacto
Para cualquier duda o consulta, puedes contactarme en [tu correo electrónico].

