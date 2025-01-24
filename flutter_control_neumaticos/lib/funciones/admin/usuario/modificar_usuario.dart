import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ModificarUsuarioPage extends StatefulWidget {
  final String email;

  ModificarUsuarioPage({required this.email});

  @override
  _ModificarUsuarioPageState createState() => _ModificarUsuarioPageState();
}

class _ModificarUsuarioPageState extends State<ModificarUsuarioPage> {
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  int idUsuario = 0;
  int codPerfil = 2; // Valor inicial para el código de perfil
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    obtenerUsuario();
  }

  Future<void> obtenerUsuario() async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Limpiar el error
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:5062/api/Usuarios/GetUsuarioByMail?mail=${widget.email}'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null && data.isNotEmpty) {
          var usuario = data[0]; // Suponiendo que el dato es un array
          setState(() {
            idUsuario = usuario['iD_USUARIO'];
            nombresController.text = usuario['nombres'];
            apellidosController.text = usuario['apellidos'];
            correoController.text = usuario['correo'];
            codPerfil = usuario['codigO_PERFIL'] ?? 2; // Asignar el perfil
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Usuario no encontrado';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error al obtener datos del usuario';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> modificarUsuario() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token no encontrado')));
      return;
    }

    final usuarioData = {
      "mail": widget.email,  // Correo del usuario
      "nombres": nombresController.text,
      "apellidos": apellidosController.text,
      "correo": correoController.text,
      "codigO_PERFIL": codPerfil,
    };

    final response = await http.put(
      Uri.parse('http://localhost:5062/api/Usuarios/ModificarDatosUsuario'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(usuarioData),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario modificado con éxito')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al modificar el usuario')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Usuario'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  TextField(
                    controller: nombresController,
                    decoration: InputDecoration(labelText: 'Nombres'),
                  ),
                  TextField(
                    controller: apellidosController,
                    decoration: InputDecoration(labelText: 'Apellidos'),
                  ),
                  TextField(
                    controller: correoController,
                    decoration: InputDecoration(labelText: 'Correo Electrónico'),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    value: codPerfil,
                    onChanged: (newValue) {
                      setState(() {
                        codPerfil = newValue!;
                      });
                    },
                    items: List.generate(
                      3,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('Perfil ${index + 1}'),
                      ),
                    ),
                    decoration: InputDecoration(labelText: 'Código Perfil'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: modificarUsuario,
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
    );
  }
}
