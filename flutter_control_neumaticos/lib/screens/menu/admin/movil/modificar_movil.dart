import 'package:flutter/material.dart';
import '../../../../models/movil_modificar.dart';
import '../../../../services/admin/movil/modificar_movil.dart';
import '../../../../widgets/button.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los datos del móvil'), backgroundColor: Colors.red),
      );
    }
  }

  void _updateFieldsForTipoMovil() {
    final tipoMovil = _tiposMovil.firstWhere((tipo) => tipo['value'] == _tipoMovilSeleccionado);
    _ejesController.text = tipoMovil['ejes'].toString();
    _cantidadNeumaticosController.text = tipoMovil['neumaticos'].toString();
  }

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Móvil modificado con éxito'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Regresa a la pantalla anterior después de éxito
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al modificar el móvil'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al modificar los datos del móvil'), backgroundColor: Colors.red),
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
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _marcaController,
                      decoration: const InputDecoration(labelText: 'Marca'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _modeloController,
                      decoration: const InputDecoration(labelText: 'Modelo'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ejesController,
                      enabled: false,
                      decoration: const InputDecoration(labelText: 'Ejes'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cantidadNeumaticosController,
                      enabled: false,
                      decoration: const InputDecoration(labelText: 'Cantidad de Neumáticos'),
                    ),
                    const SizedBox(height: 10),
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
                    StandarButton(
                      onPressed: _modificarMovil,
                      text: 'Guardar Cambios',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
