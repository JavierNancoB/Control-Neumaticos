import 'package:flutter/material.dart';
import '../../../../models/movil_modificar.dart';
import '../../../../services/admin/movil/modificar_movil.dart';

class ModificarMovilPage extends StatefulWidget {
  final String patente;

  const ModificarMovilPage({Key? key, required this.patente}) : super(key: key);

  @override
  _ModificarMovilPageState createState() => _ModificarMovilPageState();
}


class _ModificarMovilPageState extends State<ModificarMovilPage> {
  final MovilService movilService = MovilService();
  late Movil _movil;
  bool _isLoading = true;

  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _ejesController = TextEditingController();
  final TextEditingController _cantidadNeumaticosController = TextEditingController();
  final TextEditingController _tipoMovilController = TextEditingController();

  // Obtener el móvil por patente
  Future<void> _fetchMovilData() async {
    try {
      Movil? movil = await movilService.getMovilByPatente(widget.patente);
      if (movil != null) {
        setState(() {
          _movil = movil;
          _marcaController.text = movil.marca;
          _modeloController.text = movil.modelo;
          _ejesController.text = movil.ejes.toString();
          _cantidadNeumaticosController.text = movil.cantidadNeumaticos.toString();
          _tipoMovilController.text = movil.tipoMovil.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos del móvil')),
      );
    }
  }

  // Modificar el móvil
  Future<void> _modificarMovil() async {
  try {
    _movil.marca = _marcaController.text.trim();
    _movil.modelo = _modeloController.text.trim();
    _movil.ejes = int.parse(_ejesController.text.trim());
    _movil.cantidadNeumaticos = int.parse(_cantidadNeumaticosController.text.trim());
    _movil.tipoMovil = int.parse(_tipoMovilController.text.trim());

    // Usamos la patente actual como la patente de origen
    bool success = await movilService.modificarDatosMovil(widget.patente, _movil);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Móvil modificado con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al modificar el móvil')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al modificar los datos del móvil')),
    );
  }
}



  @override
  void initState() {
    super.initState();
    _fetchMovilData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Móvil - ${widget.patente}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _marcaController,
                    decoration: InputDecoration(labelText: 'Marca'),
                  ),
                  TextField(
                    controller: _modeloController,
                    decoration: InputDecoration(labelText: 'Modelo'),
                  ),
                  TextField(
                    controller: _ejesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Ejes'),
                  ),
                  TextField(
                    controller: _cantidadNeumaticosController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Cantidad Neumáticos'),
                  ),
                  TextField(
                    controller: _tipoMovilController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Tipo de Móvil'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _modificarMovil,
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
    );
  }
}
