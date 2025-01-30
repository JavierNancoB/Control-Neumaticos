import 'package:flutter/material.dart';
import '../../../../models/movil_estado.dart';
import '../../../../services/admin/movil/deshabilitar_movil_service.dart';
import '../../../../widgets/estado_button.dart';

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

  final List<EstadoMovil> estados = [
    EstadoMovil(id: 1, descripcion: 'Habilitar'),
    EstadoMovil(id: 2, descripcion: 'Deshabilitar'),
  ];

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
      print("Error al obtener sugerencias: $e");
    }
  }

  Future<void> cambiarEstadoCamion(EstadoMovil estado) async {
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

    try {
      bool success = await movilService.cambiarEstadoMovil(patente, estado);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Estado modificado con éxito')));
      }
    } catch (e) {
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
                  Text('¿Desea habilitar o inhabilitar el camión con patente ${patenteController.text}?'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      EstadoButton(
                        texto: estados[0].descripcion,
                        estado: estados[0],
                        onPressed: cambiarEstadoCamion,
                      ),
                      EstadoButton(
                        texto: estados[1].descripcion,
                        estado: estados[1],
                        onPressed: cambiarEstadoCamion,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
