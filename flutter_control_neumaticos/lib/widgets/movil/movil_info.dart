import 'package:flutter/material.dart';
import 'neumatico_list.dart';

class MovilInfo extends StatelessWidget {
  final Map<String, dynamic> movilData;
  final List<dynamic>? neumaticosData;

  const MovilInfo({super.key, required this.movilData, required this.neumaticosData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ID Movil: ${movilData['iD_MOVIL']}'),
        Text('Patente: ${movilData['patente']}'),
        Text('Marca: ${movilData['marca']}'),
        Text('Modelo: ${movilData['modelo']}'),
        Text('Ejes: ${movilData['ejes']}'),
        Text('Cantidad de Neumaticos: ${movilData['cantidaD_NEUMATICOS']}'),
        const SizedBox(height: 16),
        const Text('Neumaticos:'),
        NeumaticoList(neumaticosData: neumaticosData),
      ],
    );
  }
}
