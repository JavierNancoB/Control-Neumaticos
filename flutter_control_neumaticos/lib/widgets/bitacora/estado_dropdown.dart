import 'package:flutter/material.dart';

class EstadoDropdown extends StatelessWidget {
  final int? selectedEstado;
  final Function(int?) onChanged;

  const EstadoDropdown({super.key, required this.selectedEstado, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedEstado,
      decoration: const InputDecoration(labelText: 'Estado'),
      items: const [
        DropdownMenuItem(value: 1, child: Text('1')),
        DropdownMenuItem(value: 2, child: Text('2')),
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor seleccione un estado';
        }
        return null;
      },
    );
  }
}
