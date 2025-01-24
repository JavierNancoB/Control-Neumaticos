import 'package:flutter/material.dart';
import '../../../../models/neumatico.dart';
import '../../../../services/admin/neumaticos/anadir_neumatico_service.dart';

class AnadirNeumaticoScreen extends StatefulWidget {
  final String nfcData;

  const AnadirNeumaticoScreen({super.key, required this.nfcData});

  @override
  _AnadirNeumaticoScreenState createState() => _AnadirNeumaticoScreenState();
}

class _AnadirNeumaticoScreenState extends State<AnadirNeumaticoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _patente;
  int? _ubicacion;
  DateTime _fechaIngreso = DateTime.now();
  int _estado = 1;
  int _kmTotal = 0;
  int? _tipoNeumatico;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Obtener el ID del móvil si se especificó patente
        int? idMovil;
        if (_patente != null && _patente!.isNotEmpty) {
          idMovil = await NeumaticoService.getMovilByPatente(_patente!);
        }

        // Crear un objeto Neumatico
        final neumatico = Neumatico(
          codigo: widget.nfcData,
          ubicacion: _ubicacion,
          idMovil: idMovil,
          idBodega: 1, // Valor fijo o configurable según tu lógica
          fechaIngreso: _fechaIngreso.toIso8601String(),
          estado: _estado,
          kmTotal: _kmTotal,
          tipoNeumatico: _tipoNeumatico,
        );

        // Llamar al servicio para añadir el neumático
        await NeumaticoService.addNeumatico(neumatico);

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Neumático añadido con éxito')),
        );

        // Volver a la pantalla anterior
        Navigator.pop(context);
      } catch (e) {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaIngreso,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaIngreso = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Neumático'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Patente
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patente'),
                onSaved: (value) => _patente = value,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Ingrese una patente válida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ubicación
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Ubicación'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Ubicación 1')),
                  DropdownMenuItem(value: 2, child: Text('Ubicación 2')),
                ],
                onChanged: (value) => setState(() => _ubicacion = value),
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione una ubicación.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fecha de ingreso
              ListTile(
                title: Text('Fecha de ingreso: ${_fechaIngreso.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),

              // Estado
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Habilitado')),
                  DropdownMenuItem(value: 2, child: Text('Inhabilitado')),
                ],
                onChanged: (value) => setState(() => _estado = value!),
              ),
              const SizedBox(height: 16),

              // Kilometraje total
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kilometraje Total'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _kmTotal = int.tryParse(value ?? '0') ?? 0,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Ingrese un valor numérico válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tipo de neumático
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Tipo de Neumático'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Tipo 1')),
                  DropdownMenuItem(value: 2, child: Text('Tipo 2')),
                ],
                onChanged: (value) => setState(() => _tipoNeumatico = value),
              ),
              const SizedBox(height: 32),

              // Botón de envío
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Añadir Neumático'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
