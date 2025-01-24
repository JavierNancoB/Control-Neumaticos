import 'package:flutter/material.dart';
import '../../../../models/usuario.dart';
import '../../../../services/admin/usuarios/añadir_usuario_service.dart';

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

  String _perfilSeleccionado = 'ADMINISTRADOR';
  String _estadoSeleccionado = 'HABILITADO';

  final List<String> _perfiles = ['ADMINISTRADOR', 'SUPERVISOR', 'CONDUCTOR'];
  final List<String> _estados = ['HABILITADO', 'DESHABILITADO'];

  // Método para guardar el usuario
  Future<void> _guardarUsuario() async {
    final String nombres = _nombresController.text;
    final String apellidos = _apellidosController.text;
    final String correo = _correoController.text;
    final String clave = _claveController.text;
    final int codigoPerfil = _perfiles.indexOf(_perfilSeleccionado) + 1;
    final int codigoEstado = _estadoSeleccionado == 'HABILITADO' ? 1 : 2;

    if (nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
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
              TextField(
                controller: _claveController,
                decoration: const InputDecoration(labelText: 'Clave'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarUsuario,
                child: const Text('Guardar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
