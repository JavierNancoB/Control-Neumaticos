import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'bitacora/informacion_neumatico.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List<dynamic>> futureNeumaticos;

  @override
  void initState() {
    super.initState();
    futureNeumaticos = fetchNeumaticos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock de Neumáticos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Solo se muestran los neumáticos HABILITADOS',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureNeumaticos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay neumáticos disponibles'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var neumatico = snapshot.data![index];
                      return ListTile(
                        title: Text('Código: ${neumatico['codigo']}'),
                        subtitle: Text('Estado: ${neumatico['estado'] ?? 'Desconocido'}'),
                        onTap: () {
                          // Redirigir a la página de Información del Neumático
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InformacionNeumatico(
                                nfcData: neumatico['codigo'].toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<dynamic>> fetchNeumaticos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('Token not found');
  }

  final response = await http.get(
    Uri.parse('http://localhost:5062/api/Neumaticos/GetNeumaticoByMovilNULL'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> neumaticos = json.decode(response.body);
    return neumaticos.where((neumatico) => neumatico['estado'] == 1).toList();
  } else {
    throw Exception('Failed to load neumaticos');
  }
}