import 'package:flutter/material.dart';
import '../../../../models/neumatico_modifcar.dart';
import '../../../../services/admin/neumaticos/modificar_neumatico.dart';
import '../../../../widgets/admin/neumatico/neumatico_form.dart';

class ModificarNeumaticoScreen extends StatefulWidget {
  final String nfcData;

  const ModificarNeumaticoScreen({Key? key, required this.nfcData}) : super(key: key);

  @override
  State<ModificarNeumaticoScreen> createState() => _ModificarNeumaticoScreenState();
}

class _ModificarNeumaticoScreenState extends State<ModificarNeumaticoScreen> {
  final NeumaticoService _service = NeumaticoService();
  final _codigoController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _patenteController = TextEditingController();
  final _fechaIngresoController = TextEditingController();
  final _fechaSalidaController = TextEditingController();
  final _estadoController = TextEditingController();
  final _kmTotalController = TextEditingController();
  final _tipoNeumaticoController = TextEditingController();

  String? _ubicacionOriginal;
  String? _patenteOriginal;
  String? _fechaIngresoOriginal;
  String? _fechaSalidaOriginal;
  String? _estadoOriginal;
  String? _kmTotalOriginal;
  String? _tipoNeumaticoOriginal;

  bool _isUbicacionModified = false;
  bool _isPatenteModified = false;
  bool _isFechaIngresoModified = false;
  bool _isFechaSalidaModified = false;
  bool _isEstadoModified = false;
  bool _isKmTotalModified = false;
  bool _isTipoNeumaticoModified = false;

  @override
  void initState() {
    super.initState();
    _loadNeumatico();
  }

  Future<void> _loadNeumatico() async {
    try {
      final neumatico = await _service.fetchNeumatico(widget.nfcData);
      if (neumatico != null) {
        setState(() {
          _codigoController.text = neumatico.codigo.toString();
          _ubicacionController.text = neumatico.ubicacion.toString();
          _patenteController.text = neumatico.patente ?? '';
          _fechaIngresoController.text = neumatico.fechaIngreso;
          _fechaSalidaController.text = neumatico.fechaSalida ?? '';
          _estadoController.text = neumatico.estado.toString();
          _kmTotalController.text = neumatico.kmTotal.toString();
          _tipoNeumaticoController.text = neumatico.tipoNeumatico.toString();

          // Guardamos los valores originales
          _ubicacionOriginal = _ubicacionController.text;
          _patenteOriginal = _patenteController.text;
          _fechaIngresoOriginal = _fechaIngresoController.text;
          _fechaSalidaOriginal = _fechaSalidaController.text;
          _estadoOriginal = _estadoController.text;
          _kmTotalOriginal = _kmTotalController.text;
          _tipoNeumaticoOriginal = _tipoNeumaticoController.text;
        });
      }
    } catch (e) {
      print('Error al cargar el neumático: $e');
    }
  }

  // Función para comparar y actualizar el estado de los campos
  void _onFieldChanged(String fieldName, String value) {
    setState(() {
      switch (fieldName) {
        case 'ubicacion':
          _isUbicacionModified = value != _ubicacionOriginal;
          break;
        case 'patente':
          _isPatenteModified = value != _patenteOriginal;
          break;
        case 'fechaIngreso':
          _isFechaIngresoModified = value != _fechaIngresoOriginal;
          break;
        case 'fechaSalida':
          _isFechaSalidaModified = value != _fechaSalidaOriginal;
          break;
        case 'estado':
          _isEstadoModified = value != _estadoOriginal;
          break;
        case 'kmTotal':
          _isKmTotalModified = value != _kmTotalOriginal;
          break;
        case 'tipoNeumatico':
          _isTipoNeumaticoModified = value != _tipoNeumaticoOriginal;
          break;
      }
    });
  }

  Future<void> _modifyNeumatico() async {
    final neumatico = Neumatico(
      id: 0,
      codigo: int.parse(_codigoController.text),
      ubicacion: int.parse(_ubicacionController.text),
      idMovil: null,
      patente: _patenteController.text,
      fechaIngreso: _fechaIngresoController.text,
      fechaSalida: _fechaSalidaController.text.isNotEmpty ? _fechaSalidaController.text : null,
      estado: int.parse(_estadoController.text),
      kmTotal: int.parse(_kmTotalController.text),
      tipoNeumatico: int.parse(_tipoNeumaticoController.text),
    );

    final success = await _service.modificarNeumatico(neumatico);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Neumático modificado correctamente'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al modificar el neumático'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modificar Neumático')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NeumaticoForm(
          codigoController: _codigoController,
          ubicacionController: _ubicacionController,
          patenteController: _patenteController,
          fechaIngresoController: _fechaIngresoController,
          fechaSalidaController: _fechaSalidaController,
          estadoController: _estadoController,
          kmTotalController: _kmTotalController,
          tipoNeumaticoController: _tipoNeumaticoController,
          onSubmit: _modifyNeumatico,
          isUbicacionModified: _isUbicacionModified,
          isPatenteModified: _isPatenteModified,
          isFechaIngresoModified: _isFechaIngresoModified,
          isFechaSalidaModified: _isFechaSalidaModified,
          isEstadoModified: _isEstadoModified,
          isKmTotalModified: _isKmTotalModified,
          isTipoNeumaticoModified: _isTipoNeumaticoModified,
          onFieldChanged: _onFieldChanged,
        ),
      ),
    );
  }
}
