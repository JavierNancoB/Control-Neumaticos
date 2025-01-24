import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InhabilitarNeumaticoPage extends StatefulWidget {
  final String nfcData;

  InhabilitarNeumaticoPage({required this.nfcData});

  @override
  _InhabilitarNeumaticoPageState createState() => _InhabilitarNeumaticoPageState();
}

class _InhabilitarNeumaticoPageState extends State<InhabilitarNeumaticoPage> {
  bool isLoading = false;

  Future<void> modificarEstadoNeumatico(int estado) async {
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
      Uri.parse('http://localhost:5062/api/Neumaticos/ModificarEstadoPorCodigo?codigo=${widget.nfcData}&estado=$estado'),
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
        title: Text('Modificar Estado del Neumático'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Desea habilitar o inhabilitar el neumático?'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => modificarEstadoNeumatico(1),
                        child: Text('Habilitar'),
                      ),
                      ElevatedButton(
                        onPressed: () => modificarEstadoNeumatico(2),
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