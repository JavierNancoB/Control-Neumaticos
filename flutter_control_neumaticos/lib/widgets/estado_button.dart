import 'package:flutter/material.dart';
import '../models/admin/movil_estado.dart';

class EstadoButton extends StatelessWidget {
  final String texto;
  final EstadoMovil estado;
  final Function(EstadoMovil) onPressed;  // Cambiar el tipo de parametro aquí

  const EstadoButton({super.key, required this.texto, required this.estado, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(estado),  // Se pasa el objeto EstadoMovil completo
      child: Text(texto),
    );
  }
}
