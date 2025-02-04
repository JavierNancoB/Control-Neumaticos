import 'package:flutter/material.dart';
import '../../../../models/movil_estado.dart';
import '../../../../services/admin/movil/deshabilitar_movil_service.dart';

class CambiarEstadoMovilPage extends StatefulWidget {
  const CambiarEstadoMovilPage({super.key});

  @override
  _CambiarEstadoMovilPageState createState() => _CambiarEstadoMovilPageState();
}

class _CambiarEstadoMovilPageState extends State<CambiarEstadoMovilPage> {
  bool isLoading = false;
  final TextEditingController patenteController = TextEditingController();
  final MovilService movilService = MovilService();
  List<String> patentesSugeridas = [];

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
      print("Sugerencias de patentes: $patentesSugeridas");  // Debug print
    } catch (e) {
      print("Error al obtener sugerencias: $e");
    }
  }

  // Función para mostrar el diálogo de confirmación con tres opciones
  Future<void> _mostrarDialogoConfirmacion() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Acción'),
          content: Text('¿Qué acción desea realizar con el camión con patente ${patenteController.text}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Cierra el diálogo sin hacer nada
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();  // Cierra el diálogo
                // Llama a la función para habilitar el camión
                print("Habilitar con neumáticos");
                await cambiarEstadoCamion(EstadoMovil(id: 1, descripcion: 'Habilitar'), true); // Habilitar con neumáticos
              },
              child: Text('Habilitar con neumáticos'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();  // Cierra el diálogo
                // Llama a la función para deshabilitar el camión
                print("Deshabilitar con neumáticos");
                await cambiarEstadoCamion(EstadoMovil(id: 2, descripcion: 'Deshabilitar'), true); // Deshabilitar con neumáticos
              },
              child: Text('Deshabilitar con neumáticos'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();  // Cierra el diálogo
                // Llama a la función para deshabilitar el camión sin neumáticos
                print("Deshabilitar sin neumáticos");
                await cambiarEstadoCamion(EstadoMovil(id: 3, descripcion: 'Deshabilitar sin neumáticos'), false); // Deshabilitar sin neumáticos
              },
              child: Text('Deshabilitar sin neumáticos'),
            ),
          ],
        );
      },
    );
  }

  Future<void> cambiarEstadoCamion(EstadoMovil estado, bool conNeumaticos) async {
    setState(() {
      isLoading = true;
    });

    final patente = patenteController.text;

    if (patente.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, ingrese una patente')));
      return;
    }

    print("Cambiando estado del camión...");
    print("Patente: $patente");
    print("Estado: ${estado.descripcion} (ID: ${estado.id})");
    print("Con neumáticos: $conNeumaticos");

    try {
      bool success = await movilService.cambiarEstadoMovil(patente, estado, conNeumaticos);

      if (success) {
        print("Estado modificado con éxito");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Estado modificado con éxito')));
      }
    } catch (e) {
      print("Error al modificar el estado: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
        title: Text('Modificar Estado del Movil'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        decoration: InputDecoration(labelText: 'Patente del Camión'),
                        onChanged: (value) => cargarSugerencias(value),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text('¿Qué acción desea realizar con el camión con patente ${patenteController.text}?'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _mostrarDialogoConfirmacion,  // Llama a la ventana emergente con las tres opciones
                    child: Text('Cambiar Estado'),
                  ),
                ],
              ),
            ),
    );
  }
}
