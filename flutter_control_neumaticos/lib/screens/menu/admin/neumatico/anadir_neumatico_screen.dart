import 'package:flutter/material.dart';
import '../../../../models/admin/neumatico_crear.dart';
import '../../../../widgets/admin/neumatico/ubicacion_dropdown.dart';
import '../../../../services/admin/neumaticos/anadir_neumatico_service.dart';
import '../../../../widgets/diccionario.dart';
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

class AnadirNeumaticoScreen extends StatefulWidget {
  final String patente;
  final String nfcData;

  const AnadirNeumaticoScreen({required this.patente, required this.nfcData, super.key});

  @override
  _AnadirNeumaticoScreenState createState() => _AnadirNeumaticoScreenState();
}

class _AnadirNeumaticoScreenState extends State<AnadirNeumaticoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late NeumaticoCrear _neumatico;
  final TextEditingController _tipoNeumaticoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa el objeto NeumaticoCrear con valores por defecto
    _neumatico = NeumaticoCrear(
      codigo: widget.nfcData,
      patente: widget.patente.isEmpty ? 'SIN PATENTE' : widget.patente,
      ubicacion: 0, // Ubicación por defecto
      fechaIngreso: DateTime.now(),
      kilometrajeTotal: 0,
      tipo: 2, // Valor por defecto (Direccional)
      estado: 1, // Valor por defecto (Habilitado)
    );

    // Establece el texto del controlador del tipo de neumático
    _tipoNeumaticoController.text = Diccionario.tipoNeumatico[_neumatico.tipo] ?? 'Desconocido';
  }

  // Actualiza el tipo de neumático según la ubicación seleccionada
  void _actualizarTipoSegunUbicacion(int nuevaUbicacion) {
    setState(() {
      _neumatico.ubicacion = nuevaUbicacion;

      if (nuevaUbicacion == 1) {
        _neumatico.tipo = 4; // GUARDADO
      } else if (nuevaUbicacion == 2 || nuevaUbicacion == 3) {
        _neumatico.tipo = 2; // DIRECCIONAL
      } else if (nuevaUbicacion >= 4 && nuevaUbicacion <= 15) {
        _neumatico.tipo = 1; // TRACCIONAL
      } else if (nuevaUbicacion == 16) {
        _neumatico.tipo = 3; // REPUESTO
      }

      // Actualiza el texto del controlador del tipo de neumático
      _tipoNeumaticoController.text = Diccionario.tipoNeumatico[_neumatico.tipo] ?? 'Desconocido';
    });
  }

  // Envía el formulario para añadir un nuevo neumático
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await NeumaticoService.addNeumatico(_neumatico, widget.patente);
        showCustomSnackBar(context, 'Neumático añadido correctamente');

        Navigator.pop(context); // Regresa a la pantalla anterior tras éxito
      } catch (e) {
        showCustomSnackBar(context, 'Error al añadir el neumático: $e', isError: true);
      }
    }
  }

  @override
  void dispose() {
    _tipoNeumaticoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Neumático')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de texto para el código del neumático
              TextFormField(
                initialValue: _neumatico.codigo.toUpperCase(),
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Código Neumático'),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Campo de texto para la patente
              TextFormField(
                initialValue: widget.patente.isEmpty ? 'SIN PATENTE' : widget.patente.toUpperCase(),
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Patente'),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Dropdown para seleccionar la ubicación del neumático
              UbicacionDropdown(
                ubicacion: _neumatico.ubicacion,
                onChanged: _actualizarTipoSegunUbicacion,
                patente: widget.patente,
              ),
              const SizedBox(height: 16),
              // Campo de texto para el tipo de neumático
              TextFormField(
                controller: _tipoNeumaticoController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tipo de Neumático'),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Campo de texto para la fecha de ingreso
              Text('Fecha de Ingreso', style: Theme.of(context).textTheme.titleMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_neumatico.fechaIngreso.toLocal().toString().split(' ')[0], style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _neumatico.fechaIngreso,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _neumatico.fechaIngreso = selectedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Campo de texto para el kilometraje total
              TextFormField(
                initialValue: _neumatico.kilometrajeTotal.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Kilometraje Total'),
                onChanged: (value) {
                  setState(() {
                    _neumatico.kilometrajeTotal = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Dropdown para seleccionar el estado del neumático
              DropdownButtonFormField<int>(
                value: _neumatico.estado,
                onChanged: (newValue) => setState(() => _neumatico.estado = newValue!),
                decoration: const InputDecoration(labelText: 'Estado'),
                items: Diccionario.estadoNeumaticos.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Botón para guardar los cambios
              Align(
                alignment: Alignment.center,
                child: StandarButton(
                  onPressed: _neumatico.ubicacion == 0 || _neumatico.tipo == 0
                      ? null // Deshabilitado si ubicación o tipo no están seleccionados
                      : _submitForm,
                  text: 'Guardar Cambios',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
