import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'alertas/alertas.dart';

class AlertasPage extends StatefulWidget {
  @override
  State<AlertasPage> createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  List<dynamic>? _alertas;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAlertas();
  }

  Future<void> _fetchAlertas() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        setState(() {
          _errorMessage = "Token no encontrado.";
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse('http://localhost:5062/api/Alerta');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _alertas = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error al obtener los datos: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Alertas'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Alertas'),
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    if (_alertas == null || _alertas!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Alertas'),
        ),
        body: Center(
          child: Text(
            'No se encontraron alertas.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Alertas'),
      ),
      body: ListView.builder(
        itemCount: _alertas!.length,
        itemBuilder: (context, index) {
          final alerta = _alertas![index];
          return Card(
            child: ListTile(
              title: Text("ID Alerta: ${alerta["id"]}"),
              subtitle: Text(
                "Fecha: ${_formatFecha(alerta["fechA_ALERTA"])} - Código: ${alerta["codigO_ALERTA"]}",
              ),
              onTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformacionAlerta(alerta: alerta),
                  ),
                );
              },
              
            ),
          );
        },
      ),
    );
  }

  String _formatFecha(String fecha) {
    DateTime date = DateTime.parse(fecha);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
