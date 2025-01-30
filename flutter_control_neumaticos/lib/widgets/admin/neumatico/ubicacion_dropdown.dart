import 'package:flutter/material.dart';

class UbicacionDropdown extends StatefulWidget {
  final int ubicacion;
  final ValueChanged<int> onChanged;
  final String? patente; // Hacemos patente nullable

  const UbicacionDropdown({super.key, 
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
    // Si la patente está presente, setea la ubicación en 2 si no se ha seleccionado ninguna
    ubicacionSeleccionada = widget.patente == null || widget.patente!.isEmpty
        ? 1
        : (widget.ubicacion == 1 ? 2 : widget.ubicacion); // Si es 1, setea a 2
  }

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

    // Si la patente es nula o vacía, solo mostramos 'BODEGA'
    if (widget.patente == null || widget.patente!.isEmpty) {
      return DropdownButtonFormField<int>(
        value: ubicacionSeleccionada, // Solo 'BODEGA'
        onChanged: (newUbicacion) {
          setState(() {
            ubicacionSeleccionada = newUbicacion!;
            widget.onChanged(newUbicacion); // Actualizamos el valor
          });
        },
        decoration: const InputDecoration(labelText: 'Ubicación'),
        items: const [
          DropdownMenuItem<int>(
            value: 1,
            child: Text('BODEGA'),
          ),
        ],
      );
    } else {
      // Si la patente existe, mostramos todas las opciones excepto 'BODEGA'
      return DropdownButtonFormField<int>(
        value: ubicacionSeleccionada, // Utilizamos el valor controlado
        onChanged: (newUbicacion) {
          setState(() {
            ubicacionSeleccionada = newUbicacion!;
            widget.onChanged(newUbicacion); // Actualizamos el valor
          });
        },
        decoration: const InputDecoration(labelText: 'Ubicación'),
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
