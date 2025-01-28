import 'package:flutter/material.dart';

class FechaPicker extends StatelessWidget {
  final DateTime fecha;
  final ValueChanged<DateTime?> onChanged;

  const FechaPicker({
    Key? key,
    required this.fecha,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: fecha,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (newDate != null) {
          onChanged(newDate);
        }
      },
      child: Text('${fecha.toLocal()}'.split(' ')[0]),
    );
  }
}
