import 'package:flutter/material.dart';

class NeumaticoForm extends StatelessWidget {
  final TextEditingController codigoController;
  final TextEditingController ubicacionController;
  final TextEditingController patenteController;
  final TextEditingController fechaIngresoController;
  final TextEditingController fechaSalidaController;
  final TextEditingController estadoController;
  final TextEditingController kmTotalController;
  final TextEditingController tipoNeumaticoController;
  final VoidCallback onSubmit;

  final bool isUbicacionModified;
  final bool isPatenteModified;
  final bool isFechaIngresoModified;
  final bool isFechaSalidaModified;
  final bool isEstadoModified;
  final bool isKmTotalModified;
  final bool isTipoNeumaticoModified;
  final Function(String, String) onFieldChanged;

  const NeumaticoForm({
    Key? key,
    required this.codigoController,
    required this.ubicacionController,
    required this.patenteController,
    required this.fechaIngresoController,
    required this.fechaSalidaController,
    required this.estadoController,
    required this.kmTotalController,
    required this.tipoNeumaticoController,
    required this.onSubmit,
    required this.isUbicacionModified,
    required this.isPatenteModified,
    required this.isFechaIngresoModified,
    required this.isFechaSalidaModified,
    required this.isEstadoModified,
    required this.isKmTotalModified,
    required this.isTipoNeumaticoModified,
    required this.onFieldChanged,
  }) : super(key: key);

  Future<void> _selectDateIn(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      onFieldChanged('fechaIngreso', controller.text);
    }
  }

  Future<void> _selectDateSal(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      onFieldChanged('fechaSalida', controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: [
          TextFormField(
            controller: codigoController,
            decoration: InputDecoration(labelText: 'Código'),
            readOnly: true,
          ),
          TextFormField(
            controller: ubicacionController,
            decoration: InputDecoration(
              labelText: 'Ubicación',
              filled: isUbicacionModified,
              fillColor: isUbicacionModified ? Colors.yellow : null,
            ),
            onChanged: (value) => onFieldChanged('ubicacion', value),
          ),
          TextFormField(
            controller: patenteController,
            decoration: InputDecoration(
              labelText: 'Patente',
              filled: isPatenteModified,
              fillColor: isPatenteModified ? Colors.yellow : null,
            ),
            onChanged: (value) => onFieldChanged('patente', value),
          ),
          TextFormField(
            controller: fechaIngresoController,
            decoration: InputDecoration(
              labelText: 'Fecha de Ingreso',
              filled: isFechaIngresoModified,
              fillColor: isFechaIngresoModified ? Colors.yellow : null,
            ),
            onTap: () => _selectDateIn(context, fechaIngresoController),
            onChanged: (value) => onFieldChanged('fechaIngreso', value),
          ),
          TextFormField(
            controller: fechaSalidaController,
            decoration: InputDecoration(
              labelText: 'Fecha de Salida',
              filled: isFechaSalidaModified,
              fillColor: isFechaSalidaModified ? Colors.yellow : null,
            ),
            onTap: () => _selectDateSal(context, fechaSalidaController),
            onChanged: (value) => onFieldChanged('fechaSalida', value),
          ),
          TextFormField(
            controller: estadoController,
            decoration: InputDecoration(
              labelText: 'Estado',
              filled: isEstadoModified,
              fillColor: isEstadoModified ? Colors.yellow : null,
            ),
            onChanged: (value) => onFieldChanged('estado', value),
          ),
          TextFormField(
            controller: kmTotalController,
            decoration: InputDecoration(
              labelText: 'Kilómetros Totales',
              filled: isKmTotalModified,
              fillColor: isKmTotalModified ? Colors.yellow : null,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => onFieldChanged('kmTotal', value),
          ),
          TextFormField(
            controller: tipoNeumaticoController,
            decoration: InputDecoration(
              labelText: 'Tipo de Neumático',
              filled: isTipoNeumaticoModified,
              fillColor: isTipoNeumaticoModified ? Colors.yellow : null,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => onFieldChanged('tipoNeumatico', value),
          ),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text('Modificar Neumático'),
          ),
        ],
      ),
    );
  }
}
