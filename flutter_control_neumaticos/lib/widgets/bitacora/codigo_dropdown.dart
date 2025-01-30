import 'package:flutter/material.dart';
import '../diccionario.dart';

class CodigoDropdown extends StatelessWidget {
  final int? selectedCodigo;
  final Function(int?) onChanged;

  const CodigoDropdown({super.key, required this.selectedCodigo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedCodigo,
      decoration: const InputDecoration(labelText: 'Evento'),
      items: Diccionario.bitacora.entries
          .where((entry) => entry.key >= 10 && entry.key <= 11)
          .map((entry) {
        return DropdownMenuItem(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor seleccione un código';
        }
        return null;
      },
    );
  }
}
