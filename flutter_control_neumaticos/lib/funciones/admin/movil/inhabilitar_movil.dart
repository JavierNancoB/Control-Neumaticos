import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CambiarEstadoMovilPage extends StatefulWidget {
  @override
  _CambiarEstadoMovilPageState createState() => _CambiarEstadoMovilPageState();
}

class _CambiarEstadoMovilPageState extends State<CambiarEstadoMovilPage> {
  bool isLoading = false;
  final TextEditingController patenteController = TextEditingController();

  // Función para cambiar el estado del camión
  Future<void> cambiarEstadoCamion(int estado) async {
    setState(() {
      isLoading = true;
    });

    // Obtener el token de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Si no se encuentra el token, mostrar mensaje de error
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token no encontrado')));
      return;
    }

    // Realizar la solicitud PUT para cambiar el estado del camión
    final response = await http.put(
      Uri.parse('http://localhost:5062/api/Movil/CambiaEstadoMovilPorPatente?patente=${patenteController.text}&estado=$estado'),
      headers: {
        'Authorization': 'Bearer $token', // Incluir el token en la cabecera
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 204) {
      // Si la respuesta es exitosa, mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Estado modificado con éxito')));
    } else if (response.statusCode == 404) {
      // Si no se encuentra el camión, mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camión no encontrado')));
    }
    else {
      // Si ocurre un error, mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al modificar el estado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Estado del Camión'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Mostrar cargando mientras esperamos la respuesta
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de texto para ingresar la patente del camión
                  TextField(
                    controller: patenteController,
                    decoration: InputDecoration(labelText: 'Patente del Camión'),
                  ),
                  SizedBox(height: 20),
                  Text('¿Desea habilitar o inhabilitar el camión con patente ${patenteController.text}?'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botón para habilitar el camión
                      ElevatedButton(
                        onPressed: () => cambiarEstadoCamion(1),  // Habilitar
                        child: Text('Habilitar'),
                      ),
                      // Botón para inhabilitar el camión
                      ElevatedButton(
                        onPressed: () => cambiarEstadoCamion(2),  // Inhabilitar
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
