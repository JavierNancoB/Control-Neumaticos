import 'package:flutter/material.dart';
import '../../../../models/admin/movil_modificar.dart';
import '../../../../services/admin/movil/modificar_movil.dart';
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

// Página para modificar los datos de un móvil
class ModificarMovilPage extends StatefulWidget {
  final String patente;

  const ModificarMovilPage({super.key, required this.patente});

  @override
  _ModificarMovilPageState createState() => _ModificarMovilPageState();
}

class _ModificarMovilPageState extends State<ModificarMovilPage> {
  final MovilService movilService = MovilService();
  late Movil _movil;
  bool _isLoading = true;

  // Controladores para los campos de texto
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _ejesController = TextEditingController();
  final TextEditingController _cantidadNeumaticosController = TextEditingController();

  int _tipoMovilSeleccionado = 1;
  final List<Map<String, dynamic>> _tiposMovil = [
    {'label': '4x2', 'value': 1, 'ejes': 2, 'neumaticos': 6},
    {'label': '6x2', 'value': 2, 'ejes': 2, 'neumaticos': 10},
    {'label': 'Rampla', 'value': 3, 'ejes': 2, 'neumaticos': 12},
  ];

  // Método para obtener los datos del móvil por su patente
  Future<void> _fetchMovilData() async {
    try {
      Movil? movil = await movilService.getMovilByPatente(widget.patente);
      if (movil != null) {
        setState(() {
          _movil = movil;
          _marcaController.text = movil.marca;
          _modeloController.text = movil.modelo;
          _tipoMovilSeleccionado = movil.tipoMovil;
          _updateFieldsForTipoMovil();
          _isLoading = false;
        });
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString(), isError: true);
    }
  }

  // Método para actualizar los campos de ejes y neumáticos según el tipo de móvil seleccionado
  void _updateFieldsForTipoMovil() {
    final tipoMovil = _tiposMovil.firstWhere((tipo) => tipo['value'] == _tipoMovilSeleccionado);
    _ejesController.text = tipoMovil['ejes'].toString();
    _cantidadNeumaticosController.text = tipoMovil['neumaticos'].toString();
  }

  // Método para modificar los datos del móvil
  Future<void> _modificarMovil() async {
    try {
      _movil.marca = _marcaController.text.trim();
      _movil.modelo = _modeloController.text.trim();
      _movil.tipoMovil = _tipoMovilSeleccionado;

      final tipoMovil = _tiposMovil.firstWhere((tipo) => tipo['value'] == _tipoMovilSeleccionado);
      _movil.ejes = tipoMovil['ejes'];
      _movil.cantidadNeumaticos = tipoMovil['neumaticos'];

      bool success = await movilService.modificarDatosMovil(widget.patente, _movil);

      if (success) {
        showCustomSnackBar(context, 'Móvil modificado con éxito');
        Navigator.pop(context); // Regresa a la pantalla anterior después de éxito
      } else {
        showCustomSnackBar(context, 'Error al modificar el móvil', isError: true);
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString(), isError: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovilData(); // Obtener datos del móvil al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Móvil - ${widget.patente}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Mostrar indicador de carga mientras se obtienen los datos
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Campo de texto para la marca del móvil
                    TextField(
                      controller: _marcaController,
                      decoration: const InputDecoration(labelText: 'Marca'),
                    ),
                    const SizedBox(height: 10),
                    // Campo de texto para el modelo del móvil
                    TextField(
                      controller: _modeloController,
                      decoration: const InputDecoration(labelText: 'Modelo'),
                    ),
                    const SizedBox(height: 10),
                    // Campo de texto para los ejes del móvil (deshabilitado)
                    TextField(
                      controller: _ejesController,
                      enabled: false, // Campo deshabilitado
                      decoration: const InputDecoration(labelText: 'Ejes'),
                    ),
                    const SizedBox(height: 10),
                    // Campo de texto para la cantidad de neumáticos del móvil (deshabilitado)
                    TextField(
                      controller: _cantidadNeumaticosController,
                      enabled: false, // Campo deshabilitado
                      decoration: const InputDecoration(labelText: 'Cantidad de Neumáticos'),
                    ),
                    const SizedBox(height: 10),
                    // Dropdown para seleccionar el tipo de móvil
                    DropdownButtonFormField<int>(
                      value: _tipoMovilSeleccionado,
                      decoration: const InputDecoration(labelText: 'Tipo de Móvil'),
                      items: _tiposMovil.map((tipo) {
                        return DropdownMenuItem<int>(
                          value: tipo['value'],
                          child: Text(tipo['label']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoMovilSeleccionado = value!;
                          _updateFieldsForTipoMovil();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón para guardar los cambios
                    StandarButton(
                      onPressed: _modificarMovil, // Llamar al método para modificar el móvil
                      text: 'Guardar Cambios',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
