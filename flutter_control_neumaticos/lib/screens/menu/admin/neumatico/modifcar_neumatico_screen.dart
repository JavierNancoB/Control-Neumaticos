import 'package:flutter/material.dart';
import '../../../../models/neumatico_modifcar.dart';
import '../../../../services/admin/neumaticos/modificar_neumatico.dart';
import '../../../../widgets/admin/neumatico/ubicacion_dropdown.dart';
import '../../../../widgets/diccionario.dart';

class ModificarNeumaticoPage extends StatefulWidget {
  final String patente;
  final String nfcData;

  const ModificarNeumaticoPage({required this.patente, required this.nfcData, super.key});

  @override
  _ModificarNeumaticoPageState createState() => _ModificarNeumaticoPageState();
}

class _ModificarNeumaticoPageState extends State<ModificarNeumaticoPage> {
  Neumatico? _neumatico;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _patenteController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _tipoNeumaticoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _patenteController.text = widget.patente.isEmpty ? 'Sin Patente' : widget.patente.toUpperCase();
    
    _neumatico = Neumatico(
      codigo: widget.nfcData,
      ubicacion: 0, // Ubicación no seleccionada por defecto
      idBodega: 1,
      idMovil: null,
      fechaIngreso: DateTime.now(),
      fechaSalida: null,
      kmTotal: 0,
      tipoNeumatico: 0, // Tipo no seleccionado por defecto
      estado: 1,
    );
    
    _tipoNeumaticoController.text = Diccionario.obtenerDescripcion(Diccionario.tipoNeumatico, _neumatico!.tipoNeumatico);
    _loadNeumaticoData();
  }

  void _loadNeumaticoData() async {
    try {
      Neumatico? neumatico = await NeumaticoService.fetchNeumaticoByCodigo(widget.nfcData);
      setState(() {
        _neumatico = neumatico;
        _kmController.text = _neumatico!.kmTotal.toString();
        _updateTipoNeumatico();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos del neumático: $e')),
      );
    }
  }

  void _updateTipoNeumatico() {
    if (_neumatico != null) {
      switch (_neumatico!.ubicacion) {
        case 1:
          _neumatico!.tipoNeumatico = 4;
          break;
        case 2:
        case 3:
          _neumatico!.tipoNeumatico = 2;
          break;
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
          _neumatico!.tipoNeumatico = 1;
          break;
        case 16:
          _neumatico!.tipoNeumatico = 3;
          break;
        default:
          _neumatico!.tipoNeumatico = 1;
          break;
      }
      setState(() {
        _tipoNeumaticoController.text = Diccionario.obtenerDescripcion(Diccionario.tipoNeumatico, _neumatico!.tipoNeumatico);
      });
    }
  }

  Future<void> _selectFechaIngreso(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _neumatico!.fechaIngreso,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _neumatico!.fechaIngreso = selectedDate; // Actualiza la fecha
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_neumatico!.ubicacion == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe seleccionar una ubicación válida.')),
        );
        return;
      }

      try {
        await NeumaticoService().modificarNeumatico(_neumatico!, widget.patente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Neumático modificado con éxito')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar los datos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Neumático'),
      ),
      body: _neumatico == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Código Neumático
                    TextFormField(
                      initialValue: _neumatico!.codigo.toString(),
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Código Neumático'),
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Patente
                    TextFormField(
                      controller: _patenteController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Patente'),
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Ubicación del Neumático
                    UbicacionDropdown(
                      ubicacion: _neumatico!.ubicacion,
                      onChanged: (newUbicacion) {
                        setState(() {
                          _neumatico!.ubicacion = newUbicacion;
                          _updateTipoNeumatico();
                        });
                      },
                      patente: widget.patente,
                    ),
                    const SizedBox(height: 16),
                    // Tipo de Neumático
                    TextFormField(
                      controller: _tipoNeumaticoController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Tipo de Neumático'),
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Kilometraje
                    TextFormField(
                      controller: _kmController,
                      decoration: const InputDecoration(labelText: 'Kilometraje Total'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el kilometraje total';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _neumatico!.kmTotal = int.parse(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    // Fecha de Ingreso
                    Text('Fecha de Ingreso:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _neumatico!.fechaIngreso.toLocal().toString().split(' ')[0],
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectFechaIngreso(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Botón de Guardar Cambios
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: (_neumatico!.ubicacion != 0 && _neumatico!.tipoNeumatico != 0) 
                            ? _submitForm 
                            : null,
                        child: const Text('Guardar Cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
