import 'package:flutter/material.dart';
import '../../../../models/neumatico_crear.dart';
import '../../../../widgets/admin/neumatico/ubicacion_dropdown.dart';
import '../../../../services/admin/neumaticos/anadir_neumatico_service.dart'; // Asegúrate de tener importado el servicio

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

  @override
  void initState() {
    super.initState();
    _neumatico = NeumaticoCrear(
      codigo: widget.nfcData,
      patente: widget.patente.isEmpty ? 'SIN PATENTE' : widget.patente,
      ubicacion: 2, // Ubicación por defecto
      fechaIngreso: DateTime.now(),
      kilometrajeTotal: 0,
      tipo: 1, // Valor por defecto (Direccional)
      estado: 1, // Valor por defecto (Habilitado)
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamada al servicio para añadir el neumático
        await NeumaticoService.addNeumatico(_neumatico, widget.patente);
        
        // Confirmación de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Neumático añadido correctamente')),
        );
        
        // Volver a la pantalla anterior o hacer otra acción
        Navigator.pop(context);
      } catch (e) {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir el neumático: $e')),
        );
      }
    }
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
                initialValue: _neumatico.codigo.toUpperCase(), // Asegúrate de que el código esté en mayúsculas
                readOnly: true, // No editable
                decoration: const InputDecoration(
                  labelText: 'Código Neumático',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Borde gris cuando no está enfocado
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Borde gris cuando está enfocado
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey, // Color gris para el texto
                ),
              ),
              // Patente
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.patente.isEmpty ? 'SIN PATENTE' : widget.patente.toUpperCase(), // Si no hay patente, muestra 'SIN PATENTE'
                readOnly: true, // No editable
                decoration: InputDecoration(
                  labelText: 'Patente',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Línea gris cuando no está enfocado
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Línea gris cuando está enfocado
                  ),
                ),
                style: TextStyle(color: Colors.grey), // Color gris para el texto
              ),
              // Ubicación
              const SizedBox(height: 16),
              UbicacionDropdown(
                ubicacion: _neumatico.ubicacion,
                onChanged: (newUbicacion) {
                  setState(() {
                    _neumatico.ubicacion = newUbicacion;
                  });
                },
                patente: widget.patente, // Aquí pasa la patente al widget
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
                    // ignore: unnecessary_null_comparison
                    _neumatico.fechaIngreso != null 
                        ? _neumatico.fechaIngreso.toLocal().toString().split(' ')[0] 
                        : 'Selecciona una fecha',
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
              // Tipo de Neumático
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _neumatico.tipo,
                onChanged: (newValue) {
                  setState(() {
                    _neumatico.tipo = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de Neumático'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('DIRECCIONAL')),
                  DropdownMenuItem(value: 2, child: Text('TRACCIONAL')),
                ],
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
                items: [
                  DropdownMenuItem(value: 1, child: Text('HABILITADO')),
                  DropdownMenuItem(value: 0, child: Text('DESHABILITADO')),
                ],
              ),
              // Botón de Guardar Cambios
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _submitForm,
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
