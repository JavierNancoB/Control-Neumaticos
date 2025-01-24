import 'package:flutter/material.dart';

class EditableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isModified;
  final Function onChanged;

  EditableTextField({
    required this.controller,
    required this.label,
    required this.isModified,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: isModified,
        fillColor: isModified ? Colors.yellow : Colors.transparent,
      ),
      onChanged: (value) => onChanged(),
    );
  }
}
