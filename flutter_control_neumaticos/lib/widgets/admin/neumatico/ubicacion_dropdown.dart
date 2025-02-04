import 'package:flutter/material.dart';

class UbicacionDropdown extends StatefulWidget {
  final int ubicacion;
  final ValueChanged<int> onChanged;
  final String? patente; // Hacemos patente nullable

  const UbicacionDropdown({
    super.key, 
    required this.ubicacion,
    required this.onChanged,
    required this.patente,
  });

  @override
  _UbicacionDropdownState createState() => _UbicacionDropdownState();
}

class _UbicacionDropdownState extends State<UbicacionDropdown> {
  late int ubicacionSeleccionada;

  @override
  void initState() {
    super.initState();
    // Inicializa con 0 si la patente es null o vacía, sino con la ubicación pasada
    if (widget.patente == null || widget.patente!.isEmpty) {
      ubicacionSeleccionada = 0; // No se ha seleccionado ninguna ubicación
    } else {
      ubicacionSeleccionada = widget.ubicacion; // O usa la ubicación pasada
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mapeo de las ubicaciones
    List<Map<String, dynamic>> ubicaciones = [
      {'value': 0, 'label': 'Seleccione una ubicación'}, // Valor 0 para selección inicial
    ];

    // Si la patente es null, solo se muestra la opción "BODEGA"
    if (widget.patente == null || widget.patente!.isEmpty) {
      ubicaciones.add({'value': 1, 'label': 'BODEGA'});
    } else {
      // Si la patente está presente, mostramos todas las ubicaciones
      ubicaciones.addAll([
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
      ]);
    }

    return DropdownButtonFormField<int>(
      value: ubicacionSeleccionada, // Inicializamos en 0 si no se ha seleccionado
      onChanged: (newUbicacion) {
        setState(() {
          ubicacionSeleccionada = newUbicacion!; // Actualizamos la selección
          widget.onChanged(newUbicacion); // Llamamos al callback
        });
      },
      decoration: const InputDecoration(labelText: 'Ubicación'),
      items: ubicaciones.map((ubicacionItem) {
        return DropdownMenuItem<int>(
          value: ubicacionItem['value'],
          child: Text(ubicacionItem['label']),
        );
      }).toList(),
    );
  }
}
