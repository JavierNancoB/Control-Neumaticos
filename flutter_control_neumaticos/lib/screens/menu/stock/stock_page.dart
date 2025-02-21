import 'package:flutter/material.dart';
import '../../../services/stock_service.dart';
import '../../../widgets/diccionario.dart';
import '../bitacora/informacion_neumatico.dart';

// Clase principal de la página de stock
class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  _StockPageState createState() => _StockPageState();
}

// Estado de la página de stock
class _StockPageState extends State<StockPage> {
  // Variable que almacenará el futuro de la lista de neumáticos
  late Future<List<dynamic>> futureNeumaticos;

  @override
  void initState() {
    super.initState();
    // Inicializa la variable futureNeumaticos con la función fetchNeumaticos
    futureNeumaticos = fetchNeumaticos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título de la AppBar
        title: Text('Stock en Bodega'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              // Título de la sección
              'Neumáticos HABILITADOS en BOGEGA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            // Widget que construye la lista de neumáticos de manera asíncrona
            child: FutureBuilder<List<dynamic>>(
              future: futureNeumaticos,
              builder: (context, snapshot) {
                // Muestra un indicador de carga mientras se espera la respuesta
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                // Muestra un mensaje de error si ocurre un error
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                // Muestra un mensaje si no hay datos disponibles
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay neumáticos disponibles'));
                // Construye la lista de neumáticos si hay datos disponibles
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var neumatico = snapshot.data![index];
                      // Obtiene el ID del tipo de neumático
                      int tipoNeumaticoId = neumatico['tipO_NEUMATICO'] ?? 0;
                      // Obtiene la descripción del tipo de neumático
                      String tipoNeumaticoDesc = Diccionario.obtenerDescripcion(
                        Diccionario.tipoNeumatico,
                        tipoNeumaticoId,
                      );

                      return InkWell(
                        // Navega a la página de información del neumático al hacer clic
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
