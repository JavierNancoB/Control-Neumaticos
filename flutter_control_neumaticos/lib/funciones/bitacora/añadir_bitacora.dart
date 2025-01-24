import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnadirBitacoraScreen extends StatefulWidget {
  final int idNeumatico;

  AnadirBitacoraScreen({required this.idNeumatico});

  @override
  _AnadirBitacoraScreenState createState() => _AnadirBitacoraScreenState();
}

class _AnadirBitacoraScreenState extends State<AnadirBitacoraScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _userId;
  int? _codigo;
  int? _estado;
  TextEditingController _observacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Obtener el userId desde SharedPreferences
  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId') ?? 1; // Default userId 1 if not found
    });
  }

  // Función para obtener el token de SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Suponiendo que el token se guarda como String
  }

  // Función para enviar el formulario
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Obtener el token de SharedPreferences
      String? token = await _getToken();

      // Si el token es nulo o vacío, mostrar un mensaje de error y no enviar la solicitud
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token de autenticación no disponible')),
        );
        return;
      }

      final data = {
        "idNeumatico": widget.idNeumatico,
        "idUsuario": _userId,
        "codigo": _codigo,
        "fecha": DateTime.now().toIso8601String(),
        "estado": _estado,
        "observacion": _observacionController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:5062/api/BitacoraNeumatico'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Añadir el token en el encabezado
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // Bitácora añadida exitosamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitácora añadida con éxito')),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior
      } else {
        // Error al añadir bitácora
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir bitácora')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Bitácora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Observación
                TextFormField(
                  controller: _observacionController,
                  decoration: InputDecoration(labelText: 'Observación'),
                  maxLength: 250,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una observación';
                    }
                    return null;
                  },
                ),

                // Desplegable Código
                DropdownButtonFormField<int>(
                  value: _codigo,
                  decoration: InputDecoration(labelText: 'Código'),
                  items: List.generate(10, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _codigo = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor seleccione un código';
                    }
                    return null;
                  },
                ),

                // Desplegable Estado
                DropdownButtonFormField<int>(
                  value: _estado,
                  decoration: InputDecoration(labelText: 'Estado'),
                  items: [
                    DropdownMenuItem(value: 1, child: Text('1')),
                    DropdownMenuItem(value: 2, child: Text('2')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _estado = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor seleccione un estado';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                // Botón de Enviar
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Añadir Bitácora'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
