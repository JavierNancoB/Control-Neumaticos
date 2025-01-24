import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InhabilitarUsuarioPage extends StatefulWidget {
  @override
  _InhabilitarUsuarioPageState createState() => _InhabilitarUsuarioPageState();
}

class _InhabilitarUsuarioPageState extends State<InhabilitarUsuarioPage> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();

  Future<void> modificarEstadoUsuario(int estado) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle token not found
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.put(
      Uri.parse('http://localhost:5062/api/Usuarios/ModificarCodEstadoPorCorreo?mail=${emailController.text}&codEstado=$estado'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 204) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Estado modificado con éxito')));
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al modificar el estado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Estado del Usuario'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Correo Electrónico'),
                  ),
                  SizedBox(height: 20),
                  Text('¿Desea habilitar o inhabilitar el usuario?'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => modificarEstadoUsuario(1),
                        child: Text('Habilitar'),
                      ),
                      ElevatedButton(
                        onPressed: () => modificarEstadoUsuario(2),
                        child: Text('Inhabilitar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}