import 'package:flutter/material.dart';
import '../../../../models/neumatico_modifcar.dart';
import '../../../../services/admin/neumaticos/modificar_neumatico.dart';
import '../../../../widgets/admin/neumatico/ubicacion_dropdown.dart';
import 'package:flutter/services.dart';

class ModificarNeumaticoPage extends StatefulWidget {
  final String patente;
  final String nfcData;

  const ModificarNeumaticoPage({required this.patente, required this.nfcData, Key? key})
      : super(key: key);

  @override
  _ModificarNeumaticoPageState createState() => _ModificarNeumaticoPageState();
}

class _ModificarNeumaticoPageState extends State<ModificarNeumaticoPage> {
  Neumatico? _neumatico;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _patenteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNeumaticoData();
    _patenteController.text = widget.patente.isEmpty ? 'Sin Patente' : widget.patente.toUpperCase();
    _neumatico = Neumatico(
      codigo: widget.nfcData,
      ubicacion: 2, // Ubicación por defecto
      idBodega: 1,
      idMovil: null,
      fechaIngreso: DateTime.now(),
      fechaSalida: null,
      kmTotal: 0,
      tipoNeumatico: 1, // Valor por defecto (Direccional)
      estado: 1, // Valor por defecto (Habilitado)
    );
  }

  void _loadNeumaticoData() async {
    try {
      Neumatico? neumatico = await NeumaticoService.fetchNeumaticoByCodigo(widget.nfcData);
      setState(() {
        _neumatico = neumatico;
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

    void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Modificar el neumático usando el servicio
        await NeumaticoService.modificarNeumatico(_neumatico!, widget.patente);
        print('Datos modificados correctamente');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Neumático modificado con éxito')),
        );
        Navigator.pop(context); // Vuelve a la página anterior
      } catch (e) {
        print('Error al modificar los datos: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar los datos: Neumatico no existe en la base de datos')),
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _patenteController,
                      readOnly: true, // Esto lo hace no editable
                      decoration: InputDecoration(
                        labelText: 'Patente',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Línea gris para indicar que no es editable
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Línea gris cuando está enfocado
                        ),
                      ),
                      style: TextStyle(color: Colors.grey), // Color gris para el texto
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')), // Asegura que solo se ingresen letras y números
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(text: newValue.text.toUpperCase()),
                        ), // Convierte el texto ingresado a mayúsculas
                      ],
                    ),
                    // Ubicación
                    const SizedBox(height: 16),
                    // Imprime el valor de patente
                    UbicacionDropdown(
                      ubicacion: _neumatico!.ubicacion,
                      onChanged: (newUbicacion) {
                        setState(() {
                          _neumatico!.ubicacion = newUbicacion;
                        });
                      },
                      patente: widget.patente, // Aquí pasa la patente al widget
                    ),
                    // Fecha de Ingreso
                    const SizedBox(height: 16),
                    Text(
                      'Fecha de Ingreso', // Título para la fecha de ingreso
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Muestra la fecha seleccionada
                        Text(
                          // ignore: unnecessary_null_comparison
                          _neumatico!.fechaIngreso != null
                              ? _neumatico!.fechaIngreso.toLocal().toString().split(' ')[0]
                              : 'Selecciona una fecha', // Muestra la fecha o un texto indicativo
                          style: TextStyle(fontSize: 16), // Estilo de la fecha
                        ),
                        // Botón de calendario
                        IconButton(
                          icon: Icon(Icons.calendar_today), // Ícono del calendario
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
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
                          },
                        ),
                      ],
                    ),
                    /*
                    // Fecha de Salida
                    const SizedBox(height: 16),
                    Text(
                      'Fecha de Salida (Se deshabilitó el neumático)', // Título para la fecha de salida
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // Si fecha de salida es null, mostramos un campo de texto en vez del selector de fecha
                    _neumatico!.fechaSalida == null
                        ? Text(
                            'No definida', // Indicamos que no está definida
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        : FechaPicker(
                            fecha: _neumatico!.fechaSalida!,
                            onChanged: (newDate) {
                              setState(() {
                                _neumatico!.fechaSalida = newDate!;
                              });
                            },
                          ),

                    // Estado
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _neumatico!.estado,
                      onChanged: (newValue) {
                        setState(() {
                          _neumatico!.estado = newValue!;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Estado'),
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Habilitado')),
                        DropdownMenuItem(value: 0, child: Text('Deshabilitado')),
                      ],
                    ),
                    */
                    // Kilometraje Total
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _neumatico!.kmTotal.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Kilometraje Total'),
                      onChanged: (value) {
                        setState(() {
                          _neumatico!.kmTotal = int.parse(value);
                        });
                      },
                    ),
                    // Tipo de Neumático
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _neumatico!.tipoNeumatico,
                      onChanged: (newValue) {
                        setState(() {
                          _neumatico!.tipoNeumatico = newValue!;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Tipo de Neumático'),
                      items: [
                        DropdownMenuItem(value: 1, child: Text('DIRECCIONAL')),
                        DropdownMenuItem(value: 2, child: Text('TRACCIONAL')),
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
