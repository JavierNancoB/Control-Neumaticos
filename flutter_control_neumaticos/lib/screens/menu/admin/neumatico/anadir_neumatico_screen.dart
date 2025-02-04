import 'package:flutter/material.dart';
import '../../../../models/neumatico_crear.dart';
import '../../../../widgets/admin/neumatico/ubicacion_dropdown.dart';
import '../../../../services/admin/neumaticos/anadir_neumatico_service.dart';
import '../../../../widgets/diccionario.dart';

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
    _neumatico = NeumaticoCrear(
      codigo: widget.nfcData,
      patente: widget.patente.isEmpty ? 'SIN PATENTE' : widget.patente,
      ubicacion: 0, // Ubicación por defecto
      fechaIngreso: DateTime.now(),
      kilometrajeTotal: 0,
      tipo: 2, // Valor por defecto (Direccional)
      estado: 1, // Valor por defecto (Habilitado)
    );

    // Inicializa el tipo de neumático en el controlador
    _tipoNeumaticoController.text = Diccionario.tipoNeumatico[_neumatico.tipo] ?? 'Desconocido';
  }

  void _actualizarTipoSegunUbicacion(int nuevaUbicacion) {
    setState(() {
      _neumatico.ubicacion = nuevaUbicacion;
      // Actualiza el tipo de neumático según la ubicación
      if (nuevaUbicacion == 1) {
        _neumatico.tipo = 4; // Tipo 4 (GUARDADO) para ubicación 1
      } else if (nuevaUbicacion == 2 || nuevaUbicacion == 3) {
        _neumatico.tipo = 2; // Tipo 1 (DIRECCIONAL) para ubicaciones 2 y 3
      } else if (nuevaUbicacion >= 4 && nuevaUbicacion <= 15) {
        _neumatico.tipo = 1; // Tipo 2 (TRACCIONAL) para ubicaciones 4 a 15
      } else if (nuevaUbicacion == 16) {
        _neumatico.tipo = 3; // Tipo 3 (REPUESTO) para ubicación 16
      }

      // Actualiza el texto en el controlador para reflejar el nuevo tipo
      _tipoNeumaticoController.text = Diccionario.tipoNeumatico[_neumatico.tipo] ?? 'Desconocido';
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamada al servicio para añadir el neumático
        await NeumaticoService.addNeumatico(_neumatico, widget.patente);
        
        // Confirmación de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Neumático añadido correctamente')));
        
        // Volver a la pantalla anterior o hacer otra acción
        Navigator.pop(context);
      } catch (e) {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir el neumático: $e')));
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
      appBar: AppBar(
        title: const Text('Añadir Neumático'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Código Neumático
              TextFormField(
                initialValue: _neumatico.codigo.toUpperCase(),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Código Neumático',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: TextStyle(color: Colors.grey),
              ),
              // Patente
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.patente.isEmpty ? 'SIN PATENTE' : widget.patente.toUpperCase(),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Patente',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: TextStyle(color: Colors.grey),
              ),
              // Ubicación
              const SizedBox(height: 16),
              UbicacionDropdown(
                ubicacion: _neumatico.ubicacion,
                onChanged: (newUbicacion) {
                  _actualizarTipoSegunUbicacion(newUbicacion); // Actualiza el tipo según la ubicación
                },
                patente: widget.patente,
              ),
              // Tipo de Neumático (como TextFormField)
              const SizedBox(height: 16),
              TextFormField(
                controller: _tipoNeumaticoController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Neumático',
                ),
                style: TextStyle(color: Colors.grey),
              ),
              // Fecha de Ingreso
              const SizedBox(height: 16),
              Text(
                'Fecha de Ingreso',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _neumatico.fechaIngreso.toLocal().toString().split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
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
              // Kilometraje Total
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _neumatico.kilometrajeTotal.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Kilometraje Total'),
                onChanged: (value) {
                  setState(() {
                    _neumatico.kilometrajeTotal = int.parse(value);
                  });
                },
              ),
              // Estado
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _neumatico.estado,
                onChanged: (newValue) {
                  setState(() {
                    _neumatico.estado = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Estado'),
                items: Diccionario.estadoNeumaticos.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
              ),
              // Botón de Guardar Cambios
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _neumatico.ubicacion == 0 || _neumatico.tipo == 0
                      ? null // Deshabilita el botón si ubicación o tipo no están seleccionados
                      : _submitForm,
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
