import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/bitacora/ver_bitacora_services.dart';
import 'bitacora_details_screen.dart';  // Asegúrate de importar la pantalla de detalles
import '../../../widgets/diccionario.dart';

// Clase principal que representa la pantalla de ver bitácora
class VerBitacoraScreen extends StatefulWidget {
  final int idNeumatico;

  // Constructor que recibe el id del neumático
  const VerBitacoraScreen({super.key, required this.idNeumatico});

  @override
  _VerBitacoraScreenState createState() => _VerBitacoraScreenState();
}

// Estado asociado a la pantalla de ver bitácora
class _VerBitacoraScreenState extends State<VerBitacoraScreen> {
  // Variable que almacenará el futuro de la lista de bitácoras
  late Future<List<Map<String, dynamic>>> bitacoras;

  @override
  void initState() {
    super.initState();
    // Inicializa la variable bitacoras con los datos obtenidos del servicio
    bitacoras = VerBitacoraServices.getBitacoraByNeumatico(widget.idNeumatico);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bitácora del Neumático"),  // Título de la pantalla
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: bitacoras,  // Futuro que contiene la lista de bitácoras
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si ocurre algún problema
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Muestra un mensaje si no hay bitácoras disponibles
            return const Center(child: Text('No hay bitácoras disponibles'));
          }

          // Lista de bitácoras obtenidas del snapshot
          List<Map<String, dynamic>> bitacorasData = snapshot.data!;

          return ListView.builder(
            itemCount: bitacorasData.length,  // Número de elementos en la lista
            itemBuilder: (context, index) {
              var bitacora = bitacorasData[index];
              // Obtener la descripción de la bitácora usando el diccionario
              int codigoBitacora = bitacora['codigo'];
              String descripcionBitacora = Diccionario.obtenerDescripcion(Diccionario.bitacora, codigoBitacora);

              return Dismissible(
                key: Key(bitacora['id'].toString()),  // Clave única para cada item
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
                    // Navega a la pantalla de detalles de la bitácora al tocar el item
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

// Widget que representa un item de la bitácora en la lista
class BitacoraItem extends StatelessWidget {
  final Map<String, dynamic> bitacora;
  final String descripcion;

  // Constructor que recibe la bitácora y su descripción
  const BitacoraItem({super.key, required this.bitacora, required this.descripcion});

  @override
  Widget build(BuildContext context) {
    String fechaFormateada = "Desconocida";
    if (bitacora['fecha'] != null) {
      // Formatea la fecha si está disponible
      DateTime fecha = DateTime.parse(bitacora['fecha']);
      fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);
    }

    return ListTile(
      title: Text(descripcion),  // Muestra la descripción de la bitácora
      subtitle: Text('Fecha: $fechaFormateada'),  // Muestra la fecha formateada
    );
  }
}
