import 'package:flutter/material.dart';
import '../../../services/movil/historial_movil_service.dart';

// Pantalla que muestra el historial de un móvil
class HistorialMovilListScreen extends StatefulWidget {
  final String patente; // Patente del móvil
  final DateTime? startDate; // Fecha de inicio del rango
  final DateTime? endDate; // Fecha de fin del rango
  final bool isWithDateRange; // Indica si se usa un rango de fechas

  const HistorialMovilListScreen({
    super.key,
    required this.patente,
    this.startDate,
    this.endDate,
    required this.isWithDateRange,
  });

  @override
  _HistorialMovilListScreenState createState() =>
      _HistorialMovilListScreenState();
}

class _HistorialMovilListScreenState extends State<HistorialMovilListScreen> {
  late Future<List<Map<String, dynamic>>> _historialFuture; // Futuro que contiene el historial

  @override
  void initState() {
    super.initState();
    // Inicializa el futuro según si se usa un rango de fechas o no
    _historialFuture = widget.isWithDateRange
        ? HistorialMovilService.fetchHistorialPorFechas(
            widget.patente, widget.startDate!, widget.endDate!)
        : HistorialMovilService.fetchHistorialPorUsuario(widget.patente);
  }

  // Método para obtener el color según el código
  Color _getColorByCodigo(int codigo) {
    switch (codigo) {
      case 1:
        return Colors.green; // Código 1: verde
      case 2:
        return Colors.yellow; // Código 2: amarillo
      case 3:
        return Colors.red; // Código 3: rojizo
      default:
        return Colors.grey; // Si no hay código, gris
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial Móvil')), // Título de la pantalla
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historialFuture, // Futuro que contiene el historial
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se espera el resultado
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si ocurre un error
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Muestra un mensaje si no hay datos disponibles
            return const Center(child: Text("No hay historial disponible"));
          }

          final historial = snapshot.data!; // Datos del historial

          return ListView.builder(
            itemCount: historial.length, // Número de elementos en la lista
            itemBuilder: (context, index) {
              final item = historial[index]; // Elemento actual
              final codigo = item["codigo"] as int; // Código del elemento
              final color = _getColorByCodigo(codigo); // Color según el código
              final idUsuario = item["idUsuario"] as int; // ID del usuario

              return GestureDetector(
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  color: color, // Color sólido según el código
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["observacion"], // Observación del historial
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Fecha: ${item["fecha"]}", // Fecha del historial
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        FutureBuilder<String>(
                          future: HistorialMovilService.getUsuarioNombre(idUsuario), // Futuro que obtiene el nombre del usuario
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se espera el resultado
                              return const CircularProgressIndicator();
                            } else if (userSnapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error
                              return Text("Error al obtener el nombre");
                            } else if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                              // Muestra un mensaje si no se encuentra el usuario
                              return const Text("Usuario no encontrado");
                            }

                            return Text(
                              "Usuario: ${userSnapshot.data}", // Nombre del usuario
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
