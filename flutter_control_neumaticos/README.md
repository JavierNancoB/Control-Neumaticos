# Aplicación Flutter - Gestión de Neumáticos

## Introducción
Esta aplicación Flutter está diseñada para dispositivos Android y posteriormente para IOS, permite la gestión eficiente de neumáticos mediante el uso de chips NFC. Los administradores pueden llevar un registro detallado del historial de cada neumático, registrar kilometraje, tipos de neumáticos y recibir alertas de seguridad.

## Tecnologías Utilizadas
- **Flutter 3.29.0** • channel stable • [Repositorio oficial](https://github.com/flutter/flutter.git)
- **Dart 3.7.0**
- **DevTools 2.42.2**
- **Motor de Flutter:** revision f73bfc4522

## Instalación
Sigue estos pasos para configurar y ejecutar la aplicación:

### 1. Requisitos Previos
- Tener **Flutter** instalado en tu sistema. Consulta la [documentación oficial](https://flutter.dev/docs/get-started/install) para la configuración.
- Disponer de un **emulador o un dispositivo Android** conectado para pruebas.
- Tener instalado **Android Debug Bridge (ADB)** para trabajar con APIs locales.

### 2. Clonar el Repositorio
Ejecuta el siguiente comando en la terminal:
```bash
  git clone https://github.com/JavierNancoB/Control-Neumaticos
  cd flutter_control_neumaticos
```

### 2.1 config.dart
en la carpeta de models copia el archivo [config_ejemplo.dart](./lib/models/config_ejemplo.dart) y renómbralo a `config.dart`. Luego, modifica la URL base según tu API, sin esto la aplicación no funcionará.

### 3. Instalar Dependencias
Dentro de la carpeta del proyecto, ejecuta:
```bash
  flutter pub get
```

### 4. Ejecutar la Aplicación
Para ejecutar la aplicación en un dispositivo físico o emulador, usa:
```bash
  flutter run
```
Si estás usando APIs locales, asegúrate de que ADB esté ejecutándose correctamente, reemplaza 8000 por el puerto que estas utilizando para tu API.:
```bash
  adb reverse tcp:8000 tcp:8000
```

---

## Generar APK
Para generar un archivo APK listo para pruebas, ejecuta:
```bash
  flutter build apk --release
```
Si deseas generar una APK en modo debug:
```bash
  flutter build apk --debug
```
Para obtener una APK en modo perfil:
```bash
  flutter build apk --profile
```

---

## Características Principales
- **Escaneo NFC:** Leer y registrar información de neumáticos mediante chips NFC.
- **Registro y consulta de datos:** Kilometraje, tipo de neumático, historial y alertas de seguridad.
- **Autenticación segura:** Inicio de sesión con validación de usuario y almacenamiento seguro.

---

## Estructura del Proyecto

### **Carpetas Principales en `lib/`**
- **`main.dart`**: Punto de entrada de la aplicación.
- **`screens/`**: Contiene las pantallas principales de la aplicación, como login, menú y gestión de neumáticos.
- **`widgets/`**: Componentes reutilizables, como botones y cuadros de diálogo.
- **`services/`**: Manejo de la lógica de negocio, NFC y llamadas a la API.
- **`models/`**: Definición de clases y estructuras de datos, ademas de los temas que utiliza la aplicación.
- **`utils/`**: Funciones de utilidad, como el formateo de fechas.

---

## 📦 Dependencias del Proyecto

| Dependencia              | Versión   | Descripción |
|--------------------------|----------|-------------|
| `flutter`               | SDK      | Framework principal para la app. |
| `cupertino_icons`       | ^1.0.8   | Íconos estilo iOS para Flutter. |
| `nfc_manager`           | ^3.5.0   | Permite leer y escribir etiquetas NFC. |
| `pin_code_fields`       | ^8.0.1   | Campos de entrada para códigos PIN/OTP. |
| `http`                  | ^1.3.0   | Cliente HTTP para realizar peticiones a APIs. |
| `shared_preferences`    | ^2.3.5   | Almacenamiento local de datos clave-valor. |
| `intl`                  | ^0.20.2  | Soporte para formatos de fecha, hora y número. |
| `email_validator`       | ^3.0.0   | Valida direcciones de correo electrónico. |
| `path_provider`         | ^2.1.5   | Obtiene rutas de almacenamiento en el dispositivo. |
| `permission_handler`    | ^11.3.1  | Maneja permisos de usuario en iOS/Android. |
| `open_file`             | ^3.5.10  | Abre archivos con apps predeterminadas del sistema. |
| `flutter_dotenv`        | ^5.2.1   | Carga variables de entorno desde un archivo `.env`. |
| `flutter_svg`           | ^2.0.17  | Renderiza imágenes SVG en Flutter. |
| `flutter_native_splash` | ^2.4.5   | Configura una pantalla de carga personalizada. |
| `flutter_launcher_icons`| ^0.14.3  | Personaliza los íconos de la app en iOS/Android. |
| `google_fonts`          | ^6.2.1   | Permite usar fuentes de Google fácilmente. |


---

## Descripción de Pantallas [(./screens)](./lib/screens/)
Aquí es donde se generan todas las pantallas que uno vé en la aplicación, posee muy poca lógica de eso se encarga servicios, para los temas se encarga models, ambos se encuentran más abajo. Cabe resaltar que muchas de las caracteristicas que se ven aqui si bien se arman en screens, estan construidas en la carpeta widgets.

### **1. Login**
La pantalla de inicio de sesión permite a los usuarios autenticarse, esta pantalla se crea junto con [splash_screen.dart](./lib/screens/splash/splash_screen.dart), en esta pantalla encontraras todo lo relacionado a la animación de inicio como al formulario de inicio de sesión.

<div style="display: flex; gap: 20px;">
  <img src="assets/readme/Screenshot_prelogin.png" width="150">
  <img src="assets/readme/Screenshot_login.png" width="150">
</div>

#### **Elementos Principales:**
- **[LoginForms](./lib/widgets/login/login_form.dart):** Tiene como objetivo unir todos los widgets relacionados al login, ademas es escencial puesto que es llamado desde el splash para que junto con la animación al momento de la apertura de la aplicación aparezca este widgets en la pantalla posterior a la animación.
- **[UsernameField](./lib/widgets/login/username_field.dart):** Campo de entrada para el usuario.
- **[PasswordField](./lib/widgets/login/password_field.dart):** Campo de entrada de contraseña con opción de ocultar/mostrar.
- **[RememberMeCheckbox](./lib/widgets/login/remember_me_checkbox.dart):** Opción para recordar las credenciales.
- **[ForgotPasswordLink](./lib/widgets/login/forgot_password_link.dart):** Enlace a la pantalla de recuperación de contraseña.
- **[LoginButton](./lib/widgets/login/login_button.dart):** Envío de datos al servicio de autenticación.

#### **Lógica Implementada:**
- **Autocompletar:** Si el usuario seleccionó "Recordarme", se cargan los datos desde el almacenamiento local.
- **Validación:** Se verifica que los campos no estén vacíos.
- **Autenticación:** Conexión con el servicio `AuthService`.
- **Redirección:** Si la autenticación es exitosa, se guarda el token y se redirige al menú principal.

### **2. Menú Principal**
El menú proporciona acceso a las principales funcionalidades:

<img src="assets/readme/Screenshot_menu.png" width="200">

#### Información Patentes.
Podemos buscar la información de un movil a tarves de su patente, [buscar_movil_screen.dart](./lib/screens/menu/patentes/buscar_movil_screen.dart)

<img src="assets/readme/patente/Screenshot_patente.png" width="200">

#### Bitacora.
Nos redigirá a la pagina [lector NFC](./lib/screens/nfc/nfc_reader.dart), nos permitirá leer los chips y reedirigirnos a [informacion_neumatica.dart](./lib/screens/menu/bitacora/informacion_neumatico.dart).

<div style="display: flex; gap: 20px;">
  <img src="assets/readme/bitacora/flutter_01.png" width="150">
  <img src="assets/readme/bitacora/flutter_02.png" width="150">
  <img src="assets/readme/bitacora/flutter_03.png" width="150">
</div>

#### Alertas.
Alertas en caso de existir algun tipo de alerta pendiente o leida se mostrara en el menú principal de color amarillo indicando que existen alertas pendientes. La opcion de alertas nos dará 2 opciones:
- **Alertas Pendientes:** Recaen aquí tanto las alertas pendientes como leidas. 
- **Alertas Atendidas:** Por configuración de la API y para mayor facilidad se mostraran solamente las últimas 50 alertas atendidas.

Para mayor información sobre la opción Alertas: [alertas_menu.dart](./lib/screens/menu/alertas/alertas_menu.dart).

<div style="display: flex; gap: 20px;">
  <img src="assets/readme/alertas/flutter_01.png" width="150">
  <img src="assets/readme/alertas/flutter_02.png" width="150">
  <img src="assets/readme/alertas/flutter_03.png" width="150">
  <img src="assets/readme/alertas/flutter_04.png" width="150">
</div>

#### Stock.
Stock se encarga de mostrarnos todos los neumaticos que esten habilitados y que ademas que su ubicacion sea BODEGA, esto quiere decir que no esten asignados a ningun vehiculo. Para informacion más especifica sobre Stock se encuentra en su archivo: [stock_page.dart](./lib/screens/menu/stock/stock_page.dart).

<img src="assets/readme/stock/flutter_01.png" width="150">

#### Administración.
Administración nos da la posibilidad de poder elegir entre estas 3 opciones que a su vez tienen un desgloce de más opciones:
- **Movil:** Se puede añadir, deshabilitar como modificar un movil.
- **Neumatico:** Se puede gestionar y deshabilitar un neumatico
- **Usuario:** Esta opcion se podra visibilizar en la apliacion solo para aquellos que posean una cuenta de administrador. Tiene las capacidades de gestionar, modificar, añadir a un usuario y reestablecer su contraseña.

Todas las pantallas de administracion se crean en base a [admin_menu_screen.dart](./lib/screens/menu/admin/admin_menu_screen.dart), para más detalle sobre esta ventana puedes verlo [admin_actions_screen.dart](./lib/screens/menu/admin/admin_actions_screen.dart).

#### Generar Reportes.
Podemos generar un archivo excel con la informacion de usuarios, moviles y neumaticos. Este archivo debe ser filtrado entre 2 fechas. Más información en [generar_reporte_screen.dart](./lib/screens/menu/Reportes/generar_reporte_screen.dart).

<img src="assets/readme/reporte/flutter_01.png" width="150">

#### Reestablecer Contraseña.
La última opcion nos permite reestablecer nuestra contraseña, al momento de hacerlo nos devolveremos al inicio de sesión y tendremos que entrar con nuestras credenciales nuevamente. esta opción es la unica que no se bloquea cuando el administrador reestablece nuestra contraseña, esto con el fin de que lo primero que vea el usaurio al momento de entrar cuando su contraseña sea reestablecida por el administrador sea reestablecer por parte del usuario la contraseña. [reestablecer_passw_page.dart](./lib/screens/menu/admin/usuario/reestablecer_passw_page.dart).

<img src="assets/readme/reestablecerContraseña/flutter_01.png" width="150">

---

## Models [(./models)](./lib/models/) y Services [(./services)](./lib/services/) 
El objetivo de services es recibir y mandar toda la logica a traves de solicitudes a la API. La mayoria de models y services trabajan en conjunto, principalmente es cuando se hace la solicitud a la api y la respuesta de aquella es un .JSON, con el fin de ordenar en variables los datos que nos llega de la solicitud se crean ciertos models. A continuacion se mostraran algunos services y models más importantes:

#### Servicio de autenticacion o [auth_service.dart](./lib/services/auth_service.dart)
El AuthService es el servicio encargado de manejar la autenticación de usuarios en la aplicación. Su función principal es comunicarse con el backend para validar credenciales, gestionar errores de conexión y almacenar información relevante del usuario en SharedPreferences para su uso en otras partes de la aplicación.

#### Modelo de Configuracion de Endpoint o [config.dart](./lib/models/config_ejemplo.dart)
La clase Config es un modelo simple que almacena la URL base del servidor de la API. Su propósito principal es centralizar la configuración del endpoint, facilitando los cambios sin necesidad de modificar múltiples archivos dentro del código, un dato sumamente relevante es que en el repositorio hay un config de ejemplo el cual debe ser cambiado por un endpoint donde la API este corriendo y sea accesible desde el dispositivo.

RECUERDA: Copia el archivo `config_ejemplo.dart` y renómbralo a `config.dart`. Luego, modifica la URL base según tu API.


#### Modelo de Temas o [app_colors.dart](./lib/models/temas/app_colors.dart) y [app_themes.dart](./lib/models/temas/app_themes.dart)
La clase AppColors define una paleta de colores centralizada para la aplicación, asegurando coherencia visual en toda la interfaz. La clase AppTheme define el tema global de la aplicación utilizando la paleta de colores y la tipografía Figtree.

## Widgets [(./widgets)](./lib/widgets/)
Aquí en su mayoria se encuentra el mayor contenido reutilizable de la aplicación, cosas como el StandarButton que es casi el unico boton perteneciente y diccionario que se utiliza para traducir lo que nos entrega la api para un formato más amigable para el usuario, los revisaremos a continuación:

#### StandarButton [button.dart](./lib/widgets/button.dart)
El StandarButton es un widget personalizado que representa un botón estándar con varias configuraciones opcionales. Permite personalizar el texto, el color de fondo, el gradiente, la acción al presionar (callback) y el radio de bordes. Si no se pasa una acción al presionar (onPressed), el botón se deshabilita y se vuelve gris. Este widget es útil para mantener un diseño consistente y reutilizable a lo largo de la aplicación. El StandarButton ofrece:

- Un botón de tamaño fijo (250x50) con un texto personalizado.
- Configuración de color de fondo y gradiente.
- Radio de bordes personalizable.
- Acción opcional al presionar (onPressed).
- Comportamiento deshabilitado cuando no se proporciona una acción.

Este botón se usa para crear interfaces limpias y consistentes, ayudando a mantener la coherencia del diseño en toda la aplicación.

#### Diccionario [diccionario.dart](./lib/widgets/diccionario.dart)
El widget Diccionario es una clase estática que contiene varios diccionarios (mapas) con valores clave-valor. Cada diccionario mapea un número entero a una descripción legible que se utiliza en la aplicación. Los diccionarios cubren diversas categorías, como tipos de perfiles de usuario, estados de objetos (neumáticos, móviles, alertas), ubicaciones de neumáticos y eventos en una bitácora.

La clase también proporciona un método estático obtenerDescripcion() que permite obtener una descripción legible a partir de una clave en cualquier diccionario. Si la clave no existe en el diccionario, devuelve un valor por defecto de "Desconocido".


## Utils [(./utils/)](./lib/utils/)
Por el momento solo encontraremos el de snackbar.

#### Snackbar [./snackbar_util.dart](./lib/utils/snackbar_util.dart)
La función personalizada showCustomSnackBar permite mostrar un SnackBar con un mensaje en la aplicación. La función recibe un BuildContext, un mensaje de tipo String y un parámetro opcional isError, que por defecto está configurado como false. Dependiendo del valor de isError, el color de fondo del SnackBar será rojo (para errores) o verde (para mensajes exitosos).

La función utiliza el ScaffoldMessenger.of(context) para mostrar el SnackBar en la pantalla. El SnackBar tiene el mensaje proporcionado y siempre muestra el texto en color blanco, sin importar el color de fondo.


## Contacto
Para consultas o soporte, contactar javiernancob@gmail.com.

