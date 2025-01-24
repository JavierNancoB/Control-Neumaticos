import 'package:flutter/material.dart';
import '../../../../models/movil_estado.dart';
import '../../../../services/admin/movil/deshabilitar_movil_service.dart';
import '../../../../widgets/estado_button.dart';


class CambiarEstadoMovilPage extends StatefulWidget {
  @override
  _CambiarEstadoMovilPageState createState() => _CambiarEstadoMovilPageState();
}

class _CambiarEstadoMovilPageState extends State<CambiarEstadoMovilPage> {
  bool isLoading = false;
  final TextEditingController patenteController = TextEditingController();
  final MovilService movilService = MovilService();

  // Lista de estados posibles
  final List<EstadoMovil> estados = [
    EstadoMovil(id: 1, descripcion: 'Habilitado'),
    EstadoMovil(id: 2, descripcion: 'Inhabilitado'),
  ];

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
        title: Text('Modificar Estado del Camión'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: patenteController,
                    decoration: InputDecoration(labelText: 'Patente del Camión'),
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
