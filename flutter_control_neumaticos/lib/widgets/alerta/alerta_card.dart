// alertas/widgets/alerta_card.dart
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final Map<String, dynamic> alerta;
  final Function() onTap;

  const AlertCard({super.key, required this.alerta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Se define el color dependiendo del estado
    Color cardColor = _getCardColor(alerta["estadO_ALERTA"]);

    return Card(
      color: cardColor,  // Asignamos el color del card
      child: ListTile(
        title: Text("ID Alerta: ${alerta["id"]}"),
        subtitle: Text(
          "Fecha Ingreso: ${_formatFecha(alerta["fechA_INGRESO"])} - Código: ${alerta["codigO_ALERTA"]} - Estado: ${_formatEstado(alerta["estadO_ALERTA"])}",
        ),
        onTap: onTap,
      ),
    );
  }

  // Formatear fecha en formato día/mes/año
  String _formatFecha(String fecha) {
    DateTime date = DateTime.parse(fecha);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // Formatear el estado de la alerta
  String _formatEstado(int estado) {
    switch (estado) {
      case 1:
        return "Pendiente";
      case 2:
        return "Leído";
      case 3:
        return "Atendido";
      default:
        return "Desconocido";
    }
  }

  // Función para obtener el color del Card dependiendo del estado
  Color _getCardColor(int estado) {
    switch (estado) {
      case 1: // Pendiente (color brillante)
        return const Color.fromARGB(255, 255, 213, 213); // O rojo, según prefieras
      case 2: // Leído
        return const Color.fromARGB(255, 241, 224, 185); // O azul, según prefieras
      case 3: // Atendido
        return const Color.fromARGB(255, 224, 224, 224); // O gris, dependiendo de la preferencia
      default:
        return Colors.grey; // Color por defecto si no se reconoce el estado
    }
  }
}
