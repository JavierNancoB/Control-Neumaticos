import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnadirNeumaticoPage extends StatefulWidget {
  final String nfcData;

  AnadirNeumaticoPage({required this.nfcData});

  @override
  _AnadirNeumaticoPageState createState() => _AnadirNeumaticoPageState();
}

class _AnadirNeumaticoPageState extends State<AnadirNeumaticoPage> {
  final _formKey = GlobalKey<FormState>();
  int? _ubicacion;
  String? _patente;
  DateTime _fechaIngreso = DateTime.now();
  int _estado = 1;
  int _kmTotal = 0;
  int? _tipoNeumatico;
  int _idBodega = 1;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle token not found
        return;
      }

      int? idMovil;
      if (_patente != null && _patente!.isNotEmpty) {
        final response = await http.get(
          Uri.parse('http://localhost:5062/api/Movil/GetMovilByPatente?patente=$_patente'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          idMovil = data['ID_MOVIL'];
        } else {
          // Handle error
          return;
        }
      }

      final neumaticoData = {
        "ID_NEUMATICO": null,
        "CODIGO": widget.nfcData,
        "UBICACION": _ubicacion,
        "ID_MOVIL": idMovil,
        "ID_BODEGA": _idBodega,
        "FECHA_INGRESO": _fechaIngreso.toIso8601String(),
        "ESTADO": _estado,
        "KM_TOTAL": _kmTotal,
        "TIPO_NEUMATICO": _tipoNeumatico,
      };

      final response = await http.post(
        Uri.parse('http://localhost:5062/api/Neumaticos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(neumaticoData),
      );

      if (response.statusCode == 201) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Neumático añadido con éxito')));
      } else if (response.statusCode == 400) {
        // Handle bad request
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('El código del neumático ya está registrado.')));
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Neumático'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Patente'),
                onSaved: (value) => _patente = value,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Ubicación'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Ubicación 1')),
                  DropdownMenuItem(value: 2, child: Text('Ubicación 2')),
                  // Add more locations as needed
                ],
                onChanged: (value) => setState(() => _ubicacion = value),
              ),
              ListTile(
                title: Text('Fecha de Ingreso: ${_fechaIngreso.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Estado'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Habilitado')),
                  DropdownMenuItem(value: 2, child: Text('Inhabilitado')),
                ],
                onChanged: (value) => setState(() => _estado = value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Kilometraje Total'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _kmTotal = int.parse(value!),
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Tipo de Neumático'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Tipo 1')),
                  DropdownMenuItem(value: 2, child: Text('Tipo 2')),
                  // Add more types as needed
                ],
                onChanged: (value) => setState(() => _tipoNeumatico = value),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Añadir Neumático'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaIngreso,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaIngreso)
      setState(() {
        _fechaIngreso = picked;
      });
  }
}