import 'package:flutter/material.dart';
import '../../../../services/admin/usuarios/reestablecer_passw_service.dart'; // Importar el servicio
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

class ReestablecerPasswPage extends StatefulWidget {
  final String email;
  final bool autoGenerada;
  final bool admin;

  const ReestablecerPasswPage({super.key, required this.email, required this.autoGenerada, required this.admin});

  @override
  _ReestablecerPasswPageState createState() => _ReestablecerPasswPageState();
}

class _ReestablecerPasswPageState extends State<ReestablecerPasswPage> {
  final RestablecerPasswService _service = RestablecerPasswService(); // Instancia del servicio para restablecer contraseñas
  String nuevaClave = ''; // Variable para almacenar la nueva contraseña
  String confirmacionClave = ''; // Variable para almacenar la confirmación de la nueva contraseña
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  
  // Dos variables para la visibilidad de las contraseñas
  bool _isPasswordVisible = false; // Controla la visibilidad de la nueva contraseña
  bool _isConfirmPasswordVisible = false; // Controla la visibilidad de la confirmación de la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Contraseña'), // Título de la página
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenido
        child: Form(
          key: _formKey, // Asignar la clave del formulario
          child: Column(
            children: [
              SizedBox(height: 5), // Espaciado entre elementos
              if (widget.autoGenerada) ...[ // Si la contraseña es auto-generada
                Text(
                  'Restablecer contraseña automáticamente para el correo: ${widget.email}, se le enviará un correo con la nueva contraseña',
                  style: TextStyle(fontSize: 18), // Estilo del texto
                ),
                SizedBox(height: 20), // Espaciado entre elementos
                StandarButton(
                  onPressed: () async {
                    bool exito = await _service.restablecerContrasenaAutomatica(widget.email); // Llamar al servicio para restablecer la contraseña automáticamente

                    if (exito) {
                      showCustomSnackBar(context, 'Contraseña restablecida automáticamente para ${widget.email}'); // Mostrar mensaje de éxito
                    } else {
                      showCustomSnackBar(context, 'Error al restablecer la contraseña automáticamente', isError: true); // Mostrar mensaje de error
                    }
                  },
                  text: 'Restablecer Contraseña', // Texto del botón
                ),
              ] else ...[ // Si la contraseña no es auto-generada
                Text(
                  'Restablecer contraseña para el correo: ${widget.email}',
                  style: TextStyle(fontSize: 18), // Estilo del texto
                ),
                TextFormField(
                  obscureText: !_isPasswordVisible, // Controlar visibilidad de la nueva contraseña
                  decoration: InputDecoration(
                    labelText: 'Nueva Contraseña', // Etiqueta del campo
                    hintText: 'Ingrese la nueva contraseña', // Texto de sugerencia
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off, // Icono de visibilidad
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // Cambiar visibilidad de la contraseña
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nuevaClave = value; // Actualizar la nueva contraseña
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña no puede estar vacía'; // Validar que la contraseña no esté vacía
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres'; // Validar longitud mínima
                    }
                    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                      return 'La contraseña debe tener al menos una letra mayúscula'; // Validar que tenga al menos una letra mayúscula
                    }
                    if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                      return 'La contraseña debe tener al menos un número'; // Validar que tenga al menos un número
                    }
                    if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
                      return 'La contraseña debe tener al menos un carácter especial'; // Validar que tenga al menos un carácter especial
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10), // Espaciado entre elementos
                TextFormField(
                  obscureText: !_isConfirmPasswordVisible, // Controlar visibilidad para la confirmación
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña', // Etiqueta del campo
                    hintText: 'Ingrese nuevamente la contraseña', // Texto de sugerencia
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, // Icono de visibilidad
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible; // Cambiar visibilidad de la confirmación de la contraseña
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      confirmacionClave = value; // Actualizar la confirmación de la contraseña
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La confirmación de contraseña no puede estar vacía'; // Validar que la confirmación no esté vacía
                    }
                    if (value != nuevaClave) {
                      return 'Las contraseñas no coinciden'; // Validar que las contraseñas coincidan
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20), // Espaciado entre elementos
                StandarButton(
                  text: 'Ingresar Nueva Contraseña', // Texto del botón
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) { // Validar el formulario
                      bool exito = await _service.restablecerContrasenaManual(widget.email, nuevaClave, widget.admin); // Llamar al servicio para restablecer la contraseña manualmente

                      if (exito) {
                        showCustomSnackBar(context, 'Contraseña manualmente cambiada para ${widget.email}'); // Mostrar mensaje de éxito

                        // Verificar si admin es false y realizar dos pops
                        if (!widget.admin) {
                          Navigator.pop(context); // Primer pop
                          Navigator.pop(context); // Segundo pop
                        }
                      } else {
                        showCustomSnackBar(context, 'Error al restablecer la contraseña', isError: true); // Mostrar mensaje de error
                      }
                    }
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
