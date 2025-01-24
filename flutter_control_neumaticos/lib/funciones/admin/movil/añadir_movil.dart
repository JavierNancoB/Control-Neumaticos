import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar JSON
import 'package:shared_preferences/shared_preferences.dart';

class AnadirMovilPage extends StatefulWidget {
  const AnadirMovilPage({super.key});

  @override
  _AnadirMovilPageState createState() => _AnadirMovilPageState();
}

class _AnadirMovilPageState extends State<AnadirMovilPage> {
  final TextEditingController _patenteController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _ejesController = TextEditingController();
  final TextEditingController _neumaticosController = TextEditingController();

  int _tipoSeleccionado = 1; // Valor inicial
  int _estadoSeleccionado = 1; // Valor inicial

  final List<int> _tipos = List<int>.generate(10, (i) => i + 1); // 1 al 10
  final List<int> _estados = [1, 2]; // 1 y 2

  Future<void> _guardarMovil() async {
    final String patente = _patenteController.text;
    final String marca = _marcaController.text;
    final String modelo = _modeloController.text;
    final int? ejes = int.tryParse(_ejesController.text);
    final int? neumaticos = int.tryParse(_neumaticosController.text);
    final int tipoMovil = _tipoSeleccionado;
    final int estado = _estadoSeleccionado;

    if (patente.isEmpty || marca.isEmpty || modelo.isEmpty || ejes == null || neumaticos == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      _redirigirAlLogin();
      return;
    }

    final String apiUrl = 'http://localhost:5062/api/Movil';
    final body = json.encode({
      'PATENTE': patente,
      'MARCA': marca,
      'MODELO': modelo,
      'EJES': ejes,
      'TIPO_MOVIL': tipoMovil,
      'ID_BODEGA': 1,
      'CANTIDAD_NEUMATICOS': neumaticos,
      'ESTADO': estado,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Móvil creado con éxito')),
        );
        Navigator.pop(context); // Regresa a la página anterior
      } else if (response.statusCode == 401) {
        _redirigirAlLogin();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con el servidor')),
      );
    }
  }

  void _redirigirAlLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión expirada. Por favor, inicia sesión de nuevo.')),
    );
    Navigator.pushReplacementNamed(context, '/login'); // Reemplaza por tu ruta de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Móvil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _patenteController,
                decoration: const InputDecoration(labelText: 'Patente'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ejesController,
                decoration: const InputDecoration(labelText: 'Ejes'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _neumaticosController,
                decoration: const InputDecoration(labelText: 'Cantidad de Neumáticos'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _tipoSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo de Móvil'),
                items: _tipos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoSeleccionado = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _estadoSeleccionado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: _estados.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _estadoSeleccionado = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarMovil,
                child: const Text('Guardar Móvil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
