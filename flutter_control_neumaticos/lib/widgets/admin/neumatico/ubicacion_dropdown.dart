import 'package:flutter/material.dart';

class UbicacionDropdown extends StatelessWidget {
  final int ubicacion;
  final ValueChanged<int> onChanged;
  final String patente;

  UbicacionDropdown({
    required this.ubicacion,
    required this.onChanged,
    required this.patente,
  });

  @override
  Widget build(BuildContext context) {
    // Mapeo de las ubicaciones
    List<Map<String, dynamic>> ubicaciones = [
      {'value': 1, 'label': 'BODEGA'},
      {'value': 2, 'label': 'DIRECCIONAL IZQUIERDA'},
      {'value': 3, 'label': 'DIRECCIONAL DERECHO'},
      {'value': 4, 'label': 'PRIMER TRACCIONAL IZQUIERDO INTERNO'},
      {'value': 5, 'label': 'PRIMER TRACCIONAL IZQUIERDO EXTERNO'},
      {'value': 6, 'label': 'PRIMER TRACCIONAL DERECHO INTERNO'},
      {'value': 7, 'label': 'PRIMER TRACCIONAL DERECHO EXTERNO'},
      {'value': 8, 'label': 'SEGUNDO TRACCIONAL IZQUIERDO INTERNO'},
      {'value': 9, 'label': 'SEGUNDO TRACCIONAL IZQUIERDO EXTERNO'},
      {'value': 10, 'label': 'SEGUNDO TRACCIONAL DERECHO INTERNO'},
      {'value': 11, 'label': 'SEGUNDO TRACCIONAL DERECHO EXTERNO'},
      {'value': 12, 'label': 'TERCER TRACCIONAL IZQUIERDO INTERNO'},
      {'value': 13, 'label': 'TERCER TRACCIONAL IZQUIERDO EXTERNO'},
      {'value': 14, 'label': 'TERCER TRACCIONAL DERECHO INTERNO'},
      {'value': 15, 'label': 'TERCER TRACCIONAL DERECHO EXTERNO'},
      {'value': 16, 'label': 'REPUESTO'},
    ];

    // Si la patente es vacía, solo mostramos 'BODEGA'
    if (patente.isEmpty) {
      return DropdownButtonFormField<int>(
        value: 1, // Solo 'BODEGA'
        onChanged: (newUbicacion) {},
        decoration: InputDecoration(labelText: 'Ubicación'),
        items: [
          DropdownMenuItem<int>(
            value: 1,
            child: Text('BODEGA'),
          ),
        ],
      );
    } else {
      // Si la patente existe, mostramos todas las opciones excepto 'BODEGA'
      return DropdownButtonFormField<int>(
        value: ubicacion,
        onChanged: (newUbicacion) {
          onChanged(newUbicacion!);
        },
        decoration: InputDecoration(labelText: 'Ubicación'),
        items: ubicaciones
            .where((ubicacionItem) => ubicacionItem['value'] != 1) // Excluimos 'BODEGA'
            .map((ubicacionItem) {
              return DropdownMenuItem<int>(
                value: ubicacionItem['value'],
                child: Text(ubicacionItem['label']),
              );
            }).toList(),
      );
    }
  }
}
