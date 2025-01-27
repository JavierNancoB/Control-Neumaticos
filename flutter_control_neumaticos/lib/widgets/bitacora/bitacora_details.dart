import 'package:flutter/material.dart';
import '../../models/bitacora_models.dart';
import '../../models/usuario_alertas.dart';

class BitacoraDetailsWidget extends StatelessWidget {
  final Bitacora bitacora;
  final Usuario usuario;
  final Function(int, int) onStateChange;

  const BitacoraDetailsWidget({
    Key? key,
    required this.bitacora,
    required this.usuario,
    required this.onStateChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Código: ${bitacora.codigo}', style: const TextStyle(fontSize: 18)),
          Text('Fecha: ${bitacora.fecha}', style: const TextStyle(fontSize: 18)),
          Text('Observación: ${bitacora.observacion}', style: const TextStyle(fontSize: 18)),
          Text('Estado: ${bitacora.estado == 1 ? 'Habilitado' : 'Deshabilitado'}', style: const TextStyle(fontSize: 18)),
          Text('Usuario que agregó: ${usuario.nombres} ${usuario.apellidos}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => onStateChange(bitacora.id, 1), // Habilitar
                child: const Text('Habilitar'),
              ),
              ElevatedButton(
                onPressed: () => onStateChange(bitacora.id, 2), // Deshabilitar
                child: const Text('Deshabilitar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
