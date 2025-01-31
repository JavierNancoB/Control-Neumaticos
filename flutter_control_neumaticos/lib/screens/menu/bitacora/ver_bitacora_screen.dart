import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/bitacora/ver_bitacora_services.dart';
import 'bitacora_details_screen.dart';  // Asegúrate de importar la pantalla de detalles
import '../../../widgets/diccionario.dart';

class VerBitacoraScreen extends StatefulWidget {
  final int idNeumatico;

  const VerBitacoraScreen({super.key, required this.idNeumatico});

  @override
  _VerBitacoraScreenState createState() => _VerBitacoraScreenState();
}

class _VerBitacoraScreenState extends State<VerBitacoraScreen> {
  late Future<List<Map<String, dynamic>>> bitacoras;

  @override
  void initState() {
    super.initState();
    bitacoras = VerBitacoraServices.getBitacoraByNeumatico(widget.idNeumatico);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bitácora del Neumático"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: bitacoras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay bitácoras disponibles'));
          }

          List<Map<String, dynamic>> bitacorasData = snapshot.data!;

          return ListView.builder(
            itemCount: bitacorasData.length,
            itemBuilder: (context, index) {
              var bitacora = bitacorasData[index];
              // Obtener la descripción de la bitácora usando el diccionario
              int codigoBitacora = bitacora['codigo'];
              String descripcionBitacora = Diccionario.obtenerDescripcion(Diccionario.bitacora, codigoBitacora);

              return Dismissible(
                key: Key(bitacora['id'].toString()),  // Asegúrate de que cada item tenga una clave única
                onDismissed: (_) {
                  debugPrint('Item descartado: ${bitacora['id']}');
                  // Este es el lugar donde se maneja la acción de deslizamiento (si es necesario)
                },
                background: Container(
                  color: Colors.blue,
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () {
                    debugPrint('Item tocado: ${bitacora['id']}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BitacoraDetailsScreen(
                          idBitacora: bitacora['id'],
                        ),
                      ),
                    );
                  },
                  child: BitacoraItem(
                    bitacora: bitacora,
                    descripcion: descripcionBitacora,  // Pasamos la descripción a cada item
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BitacoraItem extends StatelessWidget {
  final Map<String, dynamic> bitacora;
  final String descripcion;

  const BitacoraItem({super.key, required this.bitacora, required this.descripcion});

  @override
  Widget build(BuildContext context) {
    String fechaFormateada = "Desconocida";
    if (bitacora['fecha'] != null) {
      DateTime fecha = DateTime.parse(bitacora['fecha']);
      fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);
    }

    return ListTile(
      title: Text(descripcion),  // Aquí usamos la descripción en lugar del código
      subtitle: Text('Fecha: $fechaFormateada'),  // Muestra la fecha formateada
    );
  }
}
