import 'package:flutter/material.dart';

class HistorialMovilListScreen extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isWithDateRange;

  const HistorialMovilListScreen({
    super.key,
    this.startDate,
    this.endDate,
    required this.isWithDateRange,
  });

  @override
  Widget build(BuildContext context) {
    // Lista de historial de ejemplo
    final List<Map<String, dynamic>> historial = [
      {"fecha": DateTime(2025, 2, 15), "detalle": "Revisión completada"},
      {"fecha": DateTime(2025, 2, 16), "detalle": "Advertencia detectada"},
      {"fecha": DateTime(2025, 2, 17), "detalle": "Sin novedades"},
    ];

    // Filtrar historial si isWithDateRange es true
    final List<Map<String, dynamic>> historialFiltrado = isWithDateRange
        ? historial.where((item) {
            final fecha = item["fecha"] as DateTime;
            return (startDate == null || fecha.isAfter(startDate!)) &&
                (endDate == null || fecha.isBefore(endDate!));
          }).toList()
        : historial;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial Móvil')),
      body: Column(
        children: [
          if (isWithDateRange)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Mostrando historial desde ${startDate?.toLocal()} hasta ${endDate?.toLocal()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: historialFiltrado.length,
              itemBuilder: (context, index) {
                final item = historialFiltrado[index];
                return ListTile(
                  title: Text(item["detalle"]),
                  subtitle: Text(item["fecha"].toLocal().toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
