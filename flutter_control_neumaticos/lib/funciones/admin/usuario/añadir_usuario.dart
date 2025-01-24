import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar JSON
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _guardarUsuario() async {
    final String nombres = _nombresController.text;
    final String apellidos = _apellidosController.text;
    final String correo = _correoController.text;
    final String clave = _claveController.text;
    final int codigoPerfil = _perfiles.indexOf(_perfilSeleccionado) + 1; // 1 = ADMINISTRADOR
    final int codigoEstado = _estadoSeleccionado == 'HABILITADO' ? 1 : 2;

    if (nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      _redirigirAlLogin();
      return;
    }

    final String apiUrl = 'http://localhost:5062/api/usuarios';
    final body = json.encode({
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'clave': clave,
      'codigO_PERFIL': codigoPerfil,
      'coD_ESTADO': codigoEstado,
      'iD_BODEGA': 1, // Cambiar según sea necesario
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado con éxito')),
        );
        Navigator.pop(context); // Regresa a la página anterior
      } else if (response.statusCode == 401) {
        _redirigirAlLogin();
      } else if (response.statusCode == 409){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: El correo ya está en uso')),
        );
      } else if (response.statusCode == 400) {
        try {
          final Map<String, dynamic> body = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${body['message']}')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al procesar la respuesta')),
          );
      }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con el servidor')),
      );
    }
  }

  void _redirigirAlLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión expirada. Por favor, inicia sesión de nuevo.')),
    );
    Navigator.pushReplacementNamed(context, '/login'); // Reemplaza por tu ruta de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Usuario')),
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
