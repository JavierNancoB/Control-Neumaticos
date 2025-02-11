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

#### Alertas.
Alertas en caso de existir algun tipo de alerta pendiente o leida se mostrara en el menú principal de color amarillo indicando que existen alertas pendientes. La opcion de alertas nos dará 2 opciones:
- **Alertas Pendientes:** Recaen aquí tanto las alertas pendientes como leidas. 
- **Alertas Atendidas:** Para mayor facilidad se mostraran solamente las últimas 50 alertas atendidas.

Para mayor información sobre la opción Alertas [aquí].

#### Información Patentes.
Podemos buscar la información por patente 

#### Bitacora.
Nos redigirá a la pagina lector NFC, nos permitirá leer los chips y reedirigirnos al [especificaciones del neumatico].

#### Stock.

#### Administración.
Administración nos da la posibilidad de poder elegir entre estas 3 opciones que a su vez tienen un desgloce de más opciones:
- **Movil:** Se puede añadir, deshabilitar como modificar un movil.
- **Neumatico:** Se puede gestionar y deshabilitar un neumatico
- **Usuario:** Esta opcion se podra visibilizar en la apliacion solo para aquellos que posean una cuenta de administrador. Tiene las capacidades de gestionar, modificar, añadir a un usuario y reestablecer su contraseña.

Todas las pantallas de administracion se crean en base a [admin_menu_screen.dart](./lib/screens/menu/admin/admin_menu_screen.dart), para más detalle sobre esta ventana puedes verlo [aqui]

#### Generar Reportes.



#### Reestablecer Contraseña.




### **3. NFC**
Pantalla dedicada a la lectura de chips NFC, permitiendo registrar y consultar información de los neumáticos en tiempo real.

---

## Contacto
Para consultas o soporte, contactar javiernancob@gmail.com o javier.nanco@pentacrom.cl.

