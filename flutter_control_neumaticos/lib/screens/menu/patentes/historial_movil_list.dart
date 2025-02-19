import 'package:flutter/material.dart';
import '../../../services/movil/historial_movil_service.dart';

class HistorialMovilListScreen extends StatefulWidget {
  final String patente;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isWithDateRange;

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
  late Future<List<Map<String, dynamic>>> _historialFuture;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(title: const Text('Historial Móvil')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historialFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay historial disponible"));
          }

          final historial = snapshot.data!;

          return ListView.builder(
            itemCount: historial.length,
            itemBuilder: (context, index) {
              final item = historial[index];
              final codigo = item["codigo"] as int;
              final color = _getColorByCodigo(codigo);
              final idUsuario = item["idUsuario"] as int;

              return GestureDetector(
                onTap: () {
                  // Aquí puedes agregar la lógica para navegar a la página de detalles
                  // Por ejemplo:
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => DetallesPage()));
                },
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
                          item["observacion"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Fecha: ${item["fecha"]}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        FutureBuilder<String>(
                          future: HistorialMovilService.getUsuarioNombre(idUsuario),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (userSnapshot.hasError) {
                              return Text("Error al obtener el nombre");
                            } else if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                              return const Text("Usuario no encontrado");
                            }

                            return Text(
                              "Usuario: ${userSnapshot.data}",
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
