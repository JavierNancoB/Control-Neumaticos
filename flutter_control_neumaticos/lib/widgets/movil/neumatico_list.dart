import 'package:flutter/material.dart';
import '../../screens/menu/bitacora/informacion_neumatico.dart';

class NeumaticoList extends StatelessWidget {
  final List<dynamic>? neumaticosData;

  const NeumaticoList({super.key, required this.neumaticosData});

  @override
  Widget build(BuildContext context) {
    return neumaticosData != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: neumaticosData!.length,
            itemBuilder: (context, index) {
              final neumatico = neumaticosData![index];
              
              // Crear una variable 'codigo' que sea siempre un String
              String codigo = neumatico['codigo']?.toString() ?? '';
              print("Tipo de la variable codigo: ${codigo.runtimeType}");

              // Agregamos un print para ver qué datos estamos obteniendo
              print("Neumático $index: ID = ${neumatico['iD_NEUMATICO']}, Código = $codigo");

              return ListTile(
                title: Text('ID Neumatico: ${neumatico['iD_NEUMATICO']}'),
                subtitle: Text('Codigo: $codigo'),
                onTap: () {
                  // Imprimir antes de navegar para ver el código que estamos pasando
                  print("Navegando a InformacionNeumatico con código: $codigo");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformacionNeumatico(
                        nfcData: codigo, // Pasamos la variable 'codigo'
                      ),
                    ),
                  );
                },
              );
            },
          )
        : const Text('No se encontraron neumaticos.');
  }
}
