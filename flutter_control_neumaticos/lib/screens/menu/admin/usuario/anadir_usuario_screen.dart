import 'package:flutter/material.dart';
import '../../../../models/admin/usuario.dart';
import '../../../../services/admin/usuarios/anadir_usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

class AnadirUsuarioPage extends StatefulWidget {
  const AnadirUsuarioPage({super.key});

  @override
  _AnadirUsuarioPageState createState() => _AnadirUsuarioPageState();
}

class _AnadirUsuarioPageState extends State<AnadirUsuarioPage> {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _repetirClaveController = TextEditingController();

  String _perfilSeleccionado = 'ADMINISTRADOR';
  String _estadoSeleccionado = 'HABILITADO';

  final List<String> _perfiles = ['ADMINISTRADOR', 'JEFE DE PLANTA'];
  final List<String> _estados = ['HABILITADO', 'DESHABILITADO'];

  bool _isPasswordVisible = false;
  bool _isRepetirClaveVisible = false;

  Future<void> _guardarUsuario() async {
    final String nombres = _nombresController.text;
    final String apellidos = _apellidosController.text;
    final String correo = _correoController.text;
    final String clave = _claveController.text;
    final String repetirClave = _repetirClaveController.text;
    final int codigoPerfil = _perfiles.indexOf(_perfilSeleccionado) + 1;
    final int codigoEstado = _estadoSeleccionado == 'HABILITADO' ? 1 : 2;

    if (nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || clave.isEmpty || repetirClave.isEmpty) {
      showCustomSnackBar(context, 'Por favor, completa todos los campos');
      return;
    }

    if (!EmailValidator.validate(correo)) {
      showCustomSnackBar(context, 'Por favor, ingresa un correo válido');
      return;
    }

    if (clave.length < 8) {
      showCustomSnackBar(context, 'La contraseña debe tener al menos 8 caracteres');
      return;
    }

    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(clave)) {
      showCustomSnackBar(context, 'La contraseña debe tener al menos una letra mayúscula');
      return;
    }

    if (!RegExp(r'^(?=.*\d)').hasMatch(clave)) {
      showCustomSnackBar(context, 'La contraseña debe tener al menos un número');
      return;
    }

    if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(clave)) {
      showCustomSnackBar(context, 'La contraseña debe tener al menos un carácter especial');
      return;
    }

    if (clave != repetirClave) {
      showCustomSnackBar(context, 'Las contraseñas no coinciden');
      return;
    }

    final usuario = Usuario(
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      clave: clave,
      perfil: codigoPerfil,
      estado: codigoEstado,
      bodega: 1,
    );

    try {
      await UsuarioService.crearUsuario(usuario);
      showCustomSnackBar(context, 'Usuario creado con éxito');
      Navigator.pop(context);
    } catch (e) {
      showCustomSnackBar(context, 'Error: ${e.toString()}', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nombresController,
                decoration: const InputDecoration(labelText: 'Nombres'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _perfilSeleccionado,
                decoration: const InputDecoration(labelText: 'Perfil'),
                items: _perfiles.map((perfil) {
                  return DropdownMenuItem(
                    value: perfil,
                    child: Text(perfil),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _perfilSeleccionado = value as String;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _estadoSeleccionado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: _estados.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _estadoSeleccionado = value as String;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _claveController,
                decoration: InputDecoration(
                  labelText: 'Clave',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _repetirClaveController,
                decoration: InputDecoration(
                  labelText: 'Repetir Clave',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isRepetirClaveVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isRepetirClaveVisible = !_isRepetirClaveVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isRepetirClaveVisible,
              ),
              const SizedBox(height: 20),
              StandarButton(
                onPressed: _guardarUsuario,
                text: 'Guardar Usuario',
              )
            ],
          ),
        ),
      ),
    );
  }
}
