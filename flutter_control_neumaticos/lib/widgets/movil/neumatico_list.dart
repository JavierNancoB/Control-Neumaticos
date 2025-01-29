import 'package:flutter/material.dart';
import '../../screens/menu/bitacora/informacion_neumatico.dart';
import '../diccionario.dart';


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

              // Agregar el código de ubicación usando Diccionario
              // Suponiendo que 'ubicacion' es un número que corresponde a la clave en el diccionario
              int ubicacionCodigo = neumatico['ubicacion'] ?? 1;  // Usar '1' como valor por defecto
              String ubicacionDescripcion = Diccionario.obtenerDescripcion(Diccionario.ubicacionNeumaticos, ubicacionCodigo);

              // Agregamos un print para ver qué datos estamos obteniendo
              print("Neumático $index: ID = ${neumatico['iD_NEUMATICO']}, Código = $codigo, Ubicación = $ubicacionDescripcion");

              return ListTile(
                title: Text('Codigo: $codigo'),
                subtitle: Text('Ubicación: $ubicacionDescripcion'),
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
        : const Text('No se encontraron neumáticos.');
  }
}

