import 'package:flutter/material.dart';

class CodigoDropdown extends StatelessWidget {
  final int? selectedCodigo;
  final Function(int?) onChanged;

  const CodigoDropdown({super.key, required this.selectedCodigo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedCodigo,
      decoration: const InputDecoration(labelText: 'Código'),
      items: List.generate(10, (index) {
        return DropdownMenuItem(
          value: index + 1,
          child: Text('${index + 1}'),
        );
      }),
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
