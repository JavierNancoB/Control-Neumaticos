import 'package:flutter/material.dart';
import 'neumatico_list.dart';

class MovilInfo extends StatelessWidget {
  final Map<String, dynamic> movilData;
  final List<dynamic>? neumaticosData;

  const MovilInfo({super.key, required this.movilData, required this.neumaticosData});

  @override
  Widget build(BuildContext context) {
    // Definir el estado como un texto y un color dependiendo del valor de movilData['estado']
    String estadoText = movilData['estado'] == 1 ? 'Habilitado' : 'Deshabilitado';
    Color estadoColor = movilData['estado'] == 1 ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ID Movil: ${movilData['iD_MOVIL']}'),
        Text('Patente: ${movilData['patente']}'),
        Text('Marca: ${movilData['marca']}'),
        Text('Modelo: ${movilData['modelo']}'),
        Text('Ejes: ${movilData['ejes']}'),
        Text('Cantidad de Neumaticos: ${movilData['cantidaD_NEUMATICOS']}'),
        // Mostrar el estado con el color correspondiente
        Text(
          'Estado: $estadoText',
          style: TextStyle(color: estadoColor),
        ),
        const SizedBox(height: 16),
        const Text('Neumaticos:'),
        NeumaticoList(neumaticosData: neumaticosData),
      ],
    );
  }
}
