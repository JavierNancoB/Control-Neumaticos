import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getBitacoraByNeumatico(int idNeumatico) async {
  final response = await http.get(
    Uri.parse('http://localhost:5062/api/BitacoraNeumatico/GetBitacoraByNeumaticoID?idNeumatico=$idNeumatico'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => {
      'codigo': item['codigo'],
      'fecha': item['fecha'],
      'estado': item['estado'],
      'id': item['id'],
    }).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class VerBitacoraScreen extends StatefulWidget {
  final int idNeumatico;

  VerBitacoraScreen({required this.idNeumatico});

  @override
  _VerBitacoraScreenState createState() => _VerBitacoraScreenState();
}

class _VerBitacoraScreenState extends State<VerBitacoraScreen> {
  late Future<List<Map<String, dynamic>>> bitacoras;

  @override
  void initState() {
    super.initState();
    bitacoras = getBitacoraByNeumatico(widget.idNeumatico);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bitácora del Neumático"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: bitacoras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay bitácoras disponibles'));
          }

          List<Map<String, dynamic>> bitacorasData = snapshot.data!;

          return ListView.builder(
            itemCount: bitacorasData.length,
            itemBuilder: (context, index) {
              var bitacora = bitacorasData[index];
              return ListTile(
                title: Text("Código: ${bitacora['codigo']}"),
                subtitle: Text("Fecha: ${bitacora['fecha']} - Estado: ${bitacora['estado']}"),
                onTap: () {
                  // Al hacer clic, navega a la pantalla de detalles
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesBitacoraScreen(
                        idBitacora: bitacora['id'],
                      ),
                    ),
                  );
                  */
                },
              );
            },
          );
        },
      ),
    );
  }
}
