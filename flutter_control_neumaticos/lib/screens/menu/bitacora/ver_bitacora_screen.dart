import 'package:flutter/material.dart';
import '../../../services/bitacora/ver_bitacora_services.dart';
import '../../../widgets/bitacora/bitcora_item.dart';
import 'bitacora_details_screen.dart';  // Asegúrate de importar la pantalla de detalles

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
    print('Inicializando pantalla con idNeumatico: ${widget.idNeumatico}');
    bitacoras = VerBitacoraServices.getBitacoraByNeumatico(widget.idNeumatico);
  }

  @override
  Widget build(BuildContext context) {
    print('Construyendo la UI de VerBitacoraScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bitácora del Neumático"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: bitacoras,
        builder: (context, snapshot) {
          print('Estado de la conexión: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error en el FutureBuilder: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No hay bitácoras disponibles');
            return const Center(child: Text('No hay bitácoras disponibles'));
          }

          List<Map<String, dynamic>> bitacorasData = snapshot.data!;
          print('Datos de bitácoras obtenidos: $bitacorasData');

          return ListView.builder(
            itemCount: bitacorasData.length,
            itemBuilder: (context, index) {
              var bitacora = bitacorasData[index];
              print('Generando item para bitacora: $bitacora');
              return Listener(
                onPointerDown: (_) {
                  debugPrint('Item tocado: ${bitacora['id']}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BitacoraDetailsScreen(
                        idBitacora: bitacora['id'],
                        bitacora: bitacora,
                      ),
                    ),
                  );
                },
                child: BitacoraItem(bitacora: bitacora),
              );

            },
          );
        },
      ),
    );
  }
}
