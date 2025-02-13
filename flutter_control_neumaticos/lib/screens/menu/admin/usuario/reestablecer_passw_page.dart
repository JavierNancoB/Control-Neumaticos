import 'package:flutter/material.dart';
import '../../../../services/admin/usuarios/reestablecer_passw_service.dart'; // Importar el servicio
import '../../../../widgets/button.dart';

class ReestablecerPasswPage extends StatefulWidget {
  final String email;
  final bool autoGenerada;
  final bool admin;

  const ReestablecerPasswPage({super.key, required this.email, required this.autoGenerada, required this.admin});

  @override
  _ReestablecerPasswPageState createState() => _ReestablecerPasswPageState();
}

class _ReestablecerPasswPageState extends State<ReestablecerPasswPage> {
  final RestablecerPasswService _service = RestablecerPasswService();
  String nuevaClave = '';
  String confirmacionClave = '';
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // Para mostrar/ocultar la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Restablecer contraseña para el correo: ${widget.email}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              if (widget.autoGenerada)
                ElevatedButton(
                  onPressed: () async {
                    bool exito = await _service.restablecerContrasenaAutomatica(widget.email);

                    if (exito) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Contraseña restablecida automáticamente para ${widget.email}')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al restablecer la contraseña automáticamente')),
                      );
                    }
                  },
                  child: Text('Restablecer Contraseña Automáticamente'),
                )
              else
                Column(
                  children: [
                    TextFormField(
                      obscureText: !_isPasswordVisible, // Controlar visibilidad
                      decoration: InputDecoration(
                        labelText: 'Nueva Contraseña',
                        hintText: 'Ingrese la nueva contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Cambiar visibilidad
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          nuevaClave = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña no puede estar vacía';
                        }
                        if (value.length < 8) {
                          return 'La contraseña debe tener al menos 8 caracteres';
                        }
                        // Validar que tenga al menos una mayúscula, un número y un carácter especial
                        if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                          return 'La contraseña debe tener al menos una letra mayúscula';
                        }
                        if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                          return 'La contraseña debe tener al menos un número';
                        }
                        if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
                          return 'La contraseña debe tener al menos un carácter especial';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: !_isPasswordVisible, // Controlar visibilidad
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        hintText: 'Ingrese nuevamente la contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Cambiar visibilidad
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          confirmacionClave = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La confirmación de contraseña no puede estar vacía';
                        }
                        if (value != nuevaClave) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null; // Si no hay errores
                      },
                    ),
                    SizedBox(height: 20),
                    // Cambiamos elevated button por StandarButton
                    StandarButton(
                      text: 'Ingresar Nueva Contraseña',
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          bool exito = await _service.restablecerContrasenaManual(widget.email, nuevaClave, widget.admin);

                          if (exito) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Contraseña manualmente cambiada para ${widget.email}')),
                            );

                            // Verificar si admin es false y realizar dos pops
                            if (!widget.admin) {
                              Navigator.pop(context); // Primer pop
                              Navigator.pop(context); // Segundo pop
                            }
                          } else {
                            // Si el servidor ha enviado un mensaje, se lo mostramos
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${_service.errorMessage}')),
                            );
                          }
                        }
                      },
                    ),                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
