// alertas/widgets/alerta_card.dart
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final Map<String, dynamic> alerta;
  final Function() onTap;

  const AlertCard({super.key, required this.alerta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("ID Alerta: ${alerta["id"]}"),
        subtitle: Text(
          "Fecha: ${_formatFecha(alerta["fechA_ALERTA"])} - Código: ${alerta["codigO_ALERTA"]}",
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatFecha(String fecha) {
    DateTime date = DateTime.parse(fecha);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
