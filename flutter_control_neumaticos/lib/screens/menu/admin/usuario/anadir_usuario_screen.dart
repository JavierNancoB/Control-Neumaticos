import 'package:flutter/material.dart';
import '../../../../models/usuario.dart';
import '../../../../services/admin/usuarios/anadir_usuario_service.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../widgets/button.dart';

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

  bool _isPasswordVisible = false; // Controlar visibilidad de la contraseña
  bool _isRepetirClaveVisible = false; // Controlar visibilidad de "repetir contraseña"

  // Método para guardar el usuario
  Future<void> _guardarUsuario() async {
    final String nombres = _nombresController.text;
    final String apellidos = _apellidosController.text;
    final String correo = _correoController.text;
    final String clave = _claveController.text;
    final String repetirClave = _repetirClaveController.text;
    final int codigoPerfil = _perfiles.indexOf(_perfilSeleccionado) + 1;
    final int codigoEstado = _estadoSeleccionado == 'HABILITADO' ? 1 : 2;

    // Validaciones
    if (nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || clave.isEmpty || repetirClave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    if (!EmailValidator.validate(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un correo válido')),
      );
      return;
    }

    if (clave.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 8 caracteres')),
      );
      return;
    }

    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(clave)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos una letra mayúscula')),
      );
      return;
    }

    if (!RegExp(r'^(?=.*\d)').hasMatch(clave)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos un número')),
      );
      return;
    }

    if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(clave)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos un carácter especial')),
      );
      return;
    }

    if (clave != repetirClave) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    // Crear un nuevo usuario
    final usuario = Usuario(
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      clave: clave,
      perfil: codigoPerfil,
      estado: codigoEstado,
      bodega: 1, // Cambiar según sea necesario
    );

    try {
      // Llamar al servicio para crear el usuario
      await UsuarioService.crearUsuario(usuario);

      // Si la creación fue exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado con éxito')),
      );
      Navigator.pop(context); // Regresa a la página anterior
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña no puede estar vacía';
                  }
                  if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, repite la contraseña';
                  }
                  if (value != _claveController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // reemplazamos el ElevatedButton por StandarButton
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
