import 'package:flutter/material.dart';

class BitacoraItem extends StatelessWidget {
  final Map<String, dynamic> bitacora;

  const BitacoraItem({super.key, required this.bitacora});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Código: ${bitacora['codigo']}"),
      subtitle: Text("Fecha: ${bitacora['fecha']} - Estado: ${bitacora['estado']}"),
      onTap: () {
        // Aquí podrías navegar a una pantalla de detalles de la bitácora, si es necesario
        /*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesBitacoraScreen(
              idBitacora: bitacora['id'],
            ),
          ),
        );
        */
      },
    );
  }
}
