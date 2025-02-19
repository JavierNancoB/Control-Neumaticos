import 'package:flutter/material.dart';
import '../../screens/menu/bitacora/informacion_neumatico.dart';
import '../button.dart';
import '../diccionario.dart';
import '../../screens/menu/patentes/comprobar_neumaticos.dart';
import '../../screens/menu/patentes/historial_movil_list.dart';
import '../../widgets/rango_fechas.dart';

class NeumaticoList extends StatelessWidget {
  final List<dynamic>? neumaticosData;
  final dynamic patente;

  const NeumaticoList({super.key, required this.neumaticosData, required this.patente});

  void _showDateRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        onDateSelected: (startDate, endDate) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistorialMovilListScreen(
                startDate: startDate,
                endDate: endDate,
                isWithDateRange: true,
                patente: patente,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPreviousChecksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Comprobaciones Anteriores'),
          content: const Text('¿Cómo desea realizar la revisión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra este diálogo
                _showDateRangeDialog(context); // Abre el selector de fechas
              },
              child: const Text('Entre un rango de Fechas'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistorialMovilListScreen(
                      isWithDateRange: false,
                      patente: patente,
                    ),
                  ),
                );
              },
              child: const Text('Comprobaciones anteriores Propias'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return neumaticosData != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: neumaticosData!.length + 2,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == neumaticosData!.length) {
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
                                  patente: patente,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (index == neumaticosData!.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: StandarButton(
                          text: 'Comprobaciones Anteriores',
                          onPressed: () => _showPreviousChecksDialog(context),
                        ),
                      );
                    }

                    final neumatico = neumaticosData![index];
                    String codigo = neumatico['codigo']?.toString() ?? '';
                    int ubicacionCodigo = neumatico['ubicacion'] ?? 1;
                    String ubicacionDescripcion = Diccionario.obtenerDescripcion(Diccionario.ubicacionNeumaticos, ubicacionCodigo);

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InformacionNeumatico(nfcData: codigo),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: Text('Codigo: $codigo'),
                          subtitle: Text('Ubicación: $ubicacionDescripcion'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : const Text('No se encontraron neumáticos.');
  }
}
