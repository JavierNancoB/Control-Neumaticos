import 'package:flutter/material.dart';
import '../../../services/stock_service.dart';
import '../../../widgets/diccionario.dart';
import '../bitacora/informacion_neumatico.dart';

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
                      int tipoNeumaticoId = neumatico['tipO_NEUMATICO'] ?? 0;
                      String tipoNeumaticoDesc = Diccionario.obtenerDescripcion(
                        Diccionario.tipoNeumatico,
                        tipoNeumaticoId,
                      );

                      return ListTile(
                        title: Text('Código: ${neumatico['codigo']}'),
                        subtitle: Text('Tipo: $tipoNeumaticoDesc'),
                        onTap: () {
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
