import 'package:flutter/material.dart';
import '../../../../services/admin/neumaticos/deshabilitar_neumatico_service.dart';

class InhabilitarNeumaticoPage extends StatefulWidget {
  final String nfcData;

  const InhabilitarNeumaticoPage({super.key, required this.nfcData});

  @override
  _InhabilitarNeumaticoPageState createState() =>
      _InhabilitarNeumaticoPageState();
}

class _InhabilitarNeumaticoPageState extends State<InhabilitarNeumaticoPage> {
  bool isLoading = false;

  // Método para mostrar el cuadro de diálogo de confirmación con 3 opciones
  Future<void> _mostrarDialogoConfirmacion(int estado) async {
    if (estado == 1) {
      // Si el estado es "habilitar", no hay opción de desasignar el móvil
      await _modificarEstado(estado, 0); // Solo habilitar sin opciones de móvil
    } else {
      // Si el estado es "inhabilitar", mostrar opciones
      String? seleccion = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Inhabilitación'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¿Está seguro de que desea inhabilitar el neumático?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  'Seleccione la opción deseada:',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'sinMovil'),
                child: Text('Deshabilitar sin móvil'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'mantenerMovil'),
                child: Text('Deshabilitar manteniendo móvil'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'cancelar'),
                child: Text('Cancelar'),
              ),
            ],
          );
        },
      );

      if (seleccion != null && seleccion != 'cancelar') {
        int desasignarMovil = (seleccion == 'sinMovil') ? 1 : 0;
        await _modificarEstado(estado, desasignarMovil);
      }
    }
  }

  // Método para modificar el estado con confirmacionMovil
  Future<void> _modificarEstado(int estado, int desasignarMovil) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Llamada al servicio para modificar el estado del neumático con confirmacionMovil
      await DeshabilitarNeumaticoService.modificarEstadoNeumatico(
          widget.nfcData, estado, desasignarMovil);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado modificado con éxito')),
      );
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Estado del Neumático'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // El retroceso se maneja con la flecha del dispositivo, no se bloquea
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Desea habilitar o inhabilitar el neumático?',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Botones para habilitar o inhabilitar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _mostrarDialogoConfirmacion(1), // Estado "habilitado"
                        child: const Text('Habilitar'),
                      ),
                      ElevatedButton(
                        onPressed: () => _mostrarDialogoConfirmacion(2), // Estado "inhabilitado"
                        child: const Text('Inhabilitar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
