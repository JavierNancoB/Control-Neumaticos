import 'package:flutter/material.dart';
import '../../../../models/admin/movil_estado.dart';
import '../../../../services/admin/movil/deshabilitar_movil_service.dart';
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

// Clase principal que representa la página para cambiar el estado de un móvil
class CambiarEstadoMovilPage extends StatefulWidget {
  const CambiarEstadoMovilPage({super.key});

  @override
  _CambiarEstadoMovilPageState createState() => _CambiarEstadoMovilPageState();
}

// Estado de la clase principal
class _CambiarEstadoMovilPageState extends State<CambiarEstadoMovilPage> {
  bool isLoading = false; // Variable para controlar el estado de carga
  final TextEditingController patenteController = TextEditingController(); // Controlador para el campo de texto de la patente
  final MovilService movilService = MovilService(); // Servicio para manejar las operaciones relacionadas con el móvil
  List<String> patentesSugeridas = []; // Lista de patentes sugeridas

  // Función para cargar las sugerencias de patentes
  Future<void> cargarSugerencias(String query) async {
    if (query.isEmpty) {
      setState(() {
        patentesSugeridas = [];
      });
      return;
    }

    try {
      final sugerencias = await movilService.fetchPatentesSugeridas(query);
      setState(() {
        patentesSugeridas = sugerencias;
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString(), isError: true);
    }
  }

  // Función para mostrar el diálogo de confirmación con tres opciones
  Future<void> _mostrarDialogoConfirmacion() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Acción'),
          content: Text('¿Qué acción desea realizar con el camión con patente ${patenteController.text}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await cambiarEstadoCamion(EstadoMovil(id: 1, descripcion: 'Habilitar'));
              },
              child: const Text('Habilitar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await cambiarEstadoCamion(EstadoMovil(id: 2, descripcion: 'Deshabilitar'));
              },
              child: const Text('Deshabilitar'),
            ),
          ],
        );
      },
    );
  }

  // Función para cambiar el estado del camión
  Future<void> cambiarEstadoCamion(EstadoMovil estado) async {
    setState(() {
      isLoading = true;
    });

    final patente = patenteController.text;

    if (patente.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showCustomSnackBar(context, 'Por favor, ingrese una patente', isError: true);
      return;
    }

    try {
      bool success = await movilService.cambiarEstadoMovil(patente, estado);

      if (success) {
        showCustomSnackBar(context, 'Estado modificado con éxito');
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString(), isError: true);
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
        title: const Text('Modificar Estado del Móvil'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de texto con autocompletado para la patente del camión
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      await cargarSugerencias(textEditingValue.text);
                      return patentesSugeridas.where((patente) => patente.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (String selection) {
                      setState(() {
                        patenteController.text = selection;
                      });
                    },
                    fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                      patenteController.text = textEditingController.text;
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(labelText: 'Patente del Camión'),
                        onChanged: (value) => cargarSugerencias(value),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('¿Qué acción desea realizar con el camión con patente ${patenteController.text}?'),
                  const SizedBox(height: 20),
                  
                  // Botón para cambiar el estado del camión
                  StandarButton(
                    onPressed: _mostrarDialogoConfirmacion,
                    text: 'Cambiar Estado',
                  ),
                ],
              ),
            ),
    );
  }
}
