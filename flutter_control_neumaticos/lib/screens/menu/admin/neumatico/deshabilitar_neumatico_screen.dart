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

  Future<void> _modificarEstado(int estado) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Llamada al servicio para modificar el estado del neumático
      await DeshabilitarNeumaticoService.modificarEstadoNeumatico(
          widget.nfcData, estado);

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
                        onPressed: () => _modificarEstado(1), // Estado "habilitado"
                        child: const Text('Habilitar'),
                      ),
                      ElevatedButton(
                        onPressed: () => _modificarEstado(2), // Estado "inhabilitado"
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
