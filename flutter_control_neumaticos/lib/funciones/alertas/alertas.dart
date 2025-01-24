import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InformacionAlerta extends StatefulWidget {
  final Map<String, dynamic> alerta;

  InformacionAlerta({required this.alerta});

  @override
  State<InformacionAlerta> createState() => _InformacionAlertaState();
}

class _InformacionAlertaState extends State<InformacionAlerta> {
  Map<String, dynamic>? _neumaticoInfo;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNeumaticoData();
  }

  Future<void> _fetchNeumaticoData() async {
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

    final url = Uri.parse(
        'http://localhost:5062/api/neumaticos?id=${widget.alerta["iD_NEUMATICO"]}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Convertir la respuesta JSON a una lista
      List<dynamic> jsonResponse = json.decode(response.body);

      // Verificar que la lista no esté vacía y tomar el primer elemento
      if (jsonResponse.isNotEmpty) {
        setState(() {
          _neumaticoInfo = jsonResponse[0]; // Tomar el primer objeto
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "No se encontró información del neumático.";
          _isLoading = false;
        });
      }
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
          title: Text('Información de la Alerta'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Información de la Alerta'),
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Información de la Alerta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Detalles de la Alerta",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow("ID Alerta", widget.alerta["id"].toString()),
            _buildInfoRow(
                "Fecha Alerta", _formatFecha(widget.alerta["fechA_ALERTA"])),
            _buildInfoRow("Código Alerta", widget.alerta["codigO_ALERTA"].toString()),
            const SizedBox(height: 24),
            Text(
              "Detalles del Neumático",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow("ID Neumático", _neumaticoInfo!["iD_NEUMATICO"].toString()),
            _buildInfoRow("Código", _neumaticoInfo!["codigo"].toString()),
            _buildInfoRow("Ubicación", _neumaticoInfo!["ubicacion"].toString()),
            _buildInfoRow(
                "ID Móvil",
                _neumaticoInfo!["iD_MOVIL"] != null
                    ? _neumaticoInfo!["iD_MOVIL"].toString()
                    : "No disponible"),
            _buildInfoRow("ID Bodega", _neumaticoInfo!["iD_BODEGA"].toString()),
            _buildInfoRow(
                "Fecha Ingreso",
                _formatFecha(_neumaticoInfo!["fechA_INGRESO"])),
            _buildInfoRow(
                "Fecha Salida",
                _neumaticoInfo!["fechA_SALIDA"] != null
                    ? _formatFecha(_neumaticoInfo!["fechA_SALIDA"])
                    : "No disponible"),
            _buildInfoRow("Estado", _neumaticoInfo!["estado"].toString()),
            _buildInfoRow("KM Total", _neumaticoInfo!["kM_TOTAL"].toString()),
            _buildInfoRow("Tipo Neumático",
                _neumaticoInfo!["tipO_NEUMATICO"].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatFecha(String fecha) {
    DateTime date = DateTime.parse(fecha);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
