# Aplicación Flutter - Gestión de Neumáticos

## Introducción
Esta aplicación Flutter está diseñada para dispositivos Android y permite la gestión eficiente de neumáticos mediante el uso de chips NFC. Los administradores pueden llevar un registro detallado del historial de cada neumático, registrar kilometraje, tipos de neumáticos y recibir alertas de seguridad.

## Instalación
Sigue estos pasos para configurar y ejecutar la aplicación:

### 1. Requisitos Previos
- Tener **Flutter** instalado en tu sistema. Consulta la [documentación oficial](https://flutter.dev/docs/get-started/install) para la configuración.
- Disponer de un **emulador o un dispositivo Android** conectado para pruebas.

### 2. Clonar el Repositorio
Ejecuta el siguiente comando en la terminal:
```bash
  git clone https://github.com/JavierNancoB/Control-Neumaticos
  cd flutter-app
```

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
- **`models/`**: Definición de clases y estructuras de datos.
- **`utils/`**: Funciones de utilidad, como el formateo de fechas.

---

## Dependencias Utilizadas

### **Principales Librerías**
- **`flutter`**: SDK principal.
- **`cupertino_icons`**: Iconos con estilo iOS.
- **`nfc_manager`**: Manejo de NFC.
- **`pin_code_fields`**: Campos de entrada para códigos PIN.
- **`http`**: Realizar peticiones a la API.
- **`shared_preferences`**: Almacenamiento local de datos.
- **`intl`**: Manejo de fechas y formatos.
- **`email_validator`**: Validación de correos electrónicos.
- **`path_provider`**: Acceso a directorios del dispositivo.
- **`permission_handler`**: Manejo de permisos.
- **`open_file`**: Abrir archivos desde la aplicación.

---

## Descripción de Pantallas

### **1. Login**
La pantalla de inicio de sesión permite a los usuarios autenticarse.

![Pantalla de Login](assets/readme/Screenshot_login.png)

#### **Elementos Principales:**
- **UsernameField:** Campo de entrada para el usuario.
- **PasswordField:** Campo de entrada de contraseña con opción de ocultar/mostrar.
- **RememberMeCheckbox:** Opción para recordar las credenciales.
- **ForgotPasswordLink:** Enlace a la pantalla de recuperación de contraseña.
- **LoginButton:** Envío de datos al servicio de autenticación.

#### **Lógica Implementada:**
- **Autocompletar:** Si el usuario seleccionó "Recordarme", se cargan los datos desde el almacenamiento local.
- **Validación:** Se verifica que los campos no estén vacíos.
- **Autenticación:** Conexión con el servicio `AuthService`.
- **Redirección:** Si la autenticación es exitosa, se guarda el token y se redirige al menú principal.

### **2. Menú Principal**
El menú proporciona acceso a las principales funcionalidades:

![Pantalla de Menú](assets/readme/Screenshot_menu.png)

#### Alertas.
Alertas en caso de existir algun tipo de alerta pendiente o leida se mostrara en el menú principal de color amarillo indicando que existen alertas pendientes. La opcion de alertas nos dará 2 opciones:
- **Alertas Pendientes:** Recaen aquí tanto las alertas pendientes como leidas. 
- **Alertas Atendidas:** Para mayor facilidad se mostraran solamente las últimas 50 alertas atendidas.

Para mayor información sobre la opción Alertas: [alertas_menu.dart](./lib/screens/menu/alertas/alertas_menu.dart).

#### Información Patentes.
Podemos buscar la información de un movil a tarves de su patente, [patente_screen.dart] 

#### Bitacora.
Nos redigirá a la pagina [lector NFC](./lib/screens/nfc/nfc_reader.dart), nos permitirá leer los chips y reedirigirnos a [informacion_neumatica.dart](./lib/screens/menu/bitacora/informacion_neumatico.dart).

#### Stock.
Stock se encarga de mostrarnos todos los neumaticos que no esten asignados a ningun vehiculo o que su ubicacion sea BODEGA, [stock_page.dart](./lib/screens/menu/stock/stock_page.dart).

#### Administración.
Administración nos da la posibilidad de poder elegir entre estas 3 opciones que a su vez tienen un desgloce de más opciones:
- **Movil:** Se puede añadir, deshabilitar como modificar un movil.
- **Neumatico:** Se puede gestionar y deshabilitar un neumatico
- **Usuario:** Esta opcion se podra visibilizar en la apliacion solo para aquellos que posean una cuenta de administrador. Tiene las capacidades de gestionar, modificar, añadir a un usuario y reestablecer su contraseña.

Todas las pantallas de administracion se crean en base a [admin_menu_screen.dart](./lib/screens/menu/admin/admin_menu_screen.dart), para más detalle sobre esta ventana puedes verlo [admin_actions_screen.dart](./lib/screens/menu/admin/admin_actions_screen.dart).

#### Generar Reportes.
Podemos generar un archivo excel con la informacion de usuarios, moviles y neumaticos. Este archivo debe ser filtrado entre 2 fechas. Más información en [generar_reporte_screen.dart](./lib/screens/menu/Reportes/generar_reporte_screen.dart).

#### Reestablecer Contraseña.
La última opcion nos permite reestablecer nuestra contraseña, al momento de hacerlo nos devolveremos al inicio de sesión y tendremos que entrar con nuestras credenciales nuevamente. esta opción es la unica que no se bloquea cuando el administrador reestablece nuestra contraseña, esto con el fin de que lo primero que vea el usaurio al momento de entrar cuando su contraseña sea reestablecida por el administrador sea reestablecer por parte del usuario la contraseña. [reestablecer_passw_page.dart](./lib/screens/menu/admin/usuario/reestablecer_passw_page.dart).

---

## Contacto
Para consultas o soporte, contactar javiernancob@gmail.com o javier.nanco@pentacrom.cl.

