import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

class CustomDatePickerDialog extends StatefulWidget {
  final Function(DateTime, DateTime) onDateSelected;

  const CustomDatePickerDialog({super.key, required this.onDateSelected});

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy'); // Formato de fecha

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart ? _startDate ?? DateTime.now() : _endDate ?? _startDate ?? DateTime.now();
    DateTime firstDate = isStart ? DateTime(2000) : _startDate ?? DateTime(2000);
    
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null; // Reinicia la fecha de fin si es menor a la de inicio
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _confirmSelection() {
    if (_startDate != null && _endDate != null) {
      Navigator.pop(context); // Cierra el diálogo
      widget.onDateSelected(_startDate!, _endDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Rango de Fechas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _pickDate(context, true),
            child: Text(_startDate == null 
                ? 'Seleccionar Inicio' 
                : 'Inicio: ${dateFormat.format(_startDate!)}'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _startDate != null ? () => _pickDate(context, false) : null,
            child: Text(_endDate == null 
                ? 'Seleccionar Fin' 
                : 'Fin: ${dateFormat.format(_endDate!)}'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: (_startDate != null && _endDate != null) ? _confirmSelection : null,
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
