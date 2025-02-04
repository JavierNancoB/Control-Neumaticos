import 'package:flutter/material.dart';
import '../../../services/stock_service.dart';
import '../../../widgets/diccionario.dart';
import '../bitacora/informacion_neumatico.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

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
        title: Text('Stock en Bodega'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Neumáticos HABILITADOS en BOGEGA',
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

                      return InkWell(
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
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: ListTile(
                            leading: Icon(Icons.info_outline), // Ícono visual
                            title: Text('Código: ${neumatico['codigo']}'),
                            subtitle: Text('Tipo: $tipoNeumaticoDesc'),
                          ),
                        ),
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
