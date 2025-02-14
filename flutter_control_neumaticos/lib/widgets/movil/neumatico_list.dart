import 'package:flutter/material.dart';
import '../../screens/menu/bitacora/informacion_neumatico.dart';
import '../button.dart';
import '../diccionario.dart';
import '../../screens/menu/patentes/comprobar_neumaticos.dart';

class NeumaticoList extends StatelessWidget {
  final List<dynamic>? neumaticosData;
  
  final dynamic patente;

  const NeumaticoList({super.key, required this.neumaticosData, required this.patente});

  @override
  Widget build(BuildContext context) {
    return neumaticosData != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: neumaticosData!.length + 1, // Incrementar el itemCount en 1
            itemBuilder: (context, index) {
              if (index == neumaticosData!.length) {
                // Este es el último elemento, que será el botón
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: StandarButton(
                    text: 'Comprobar neumáticos',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComprobarNeumaticosScreen(
                            neumaticosData: neumaticosData,
                            //lo mandamos con id neumatico
                            patente: patente,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              final neumatico = neumaticosData![index];

              // Crear una variable 'codigo' que sea siempre un String
              String codigo = neumatico['codigo']?.toString() ?? '';

              // Agregar el código de ubicación usando Diccionario
              // Suponiendo que 'ubicacion' es un número que corresponde a la clave en el diccionario
              int ubicacionCodigo = neumatico['ubicacion'] ?? 1;  // Usar '1' como valor por defecto
              String ubicacionDescripcion = Diccionario.obtenerDescripcion(Diccionario.ubicacionNeumaticos, ubicacionCodigo);

              // Agregamos un print para ver qué datos estamos obteniendo

              return InkWell(
                onTap: () {
                  // Imprimir antes de navegar para ver el código que estamos pasando

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformacionNeumatico(
                        nfcData: codigo, // Pasamos la variable 'codigo'
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: Icon(Icons.info_outline), // Ícono visual
                    title: Text('Codigo: $codigo'),
                    subtitle: Text('Ubicación: $ubicacionDescripcion'),
                  ),
                ),
              );
            },
          )
        : const Text('No se encontraron neumáticos.');
  }
}
