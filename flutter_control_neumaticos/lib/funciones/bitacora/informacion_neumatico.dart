import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ver_bitacora.dart';
import 'añadir_bitacora.dart';

class InformacionNeumatico extends StatefulWidget {
  final String nfcData;

  InformacionNeumatico({required this.nfcData});

  @override
  State<InformacionNeumatico> createState() => _InformacionNeumaticoState();
}

class _InformacionNeumaticoState extends State<InformacionNeumatico> {
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
          'http://localhost:5062/api/Neumaticos/GetNeumaticoByCodigo?codigo=${widget.nfcData}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _neumaticoInfo = json.decode(response.body);
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
          title: Text('Información del Neumático'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Información del Neumático'),
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    if (_neumaticoInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Información del Neumático'),
        ),
        body: Center(
          child: Text(
            'No se encontraron datos del neumático.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
  appBar: AppBar(
    title: Text('Información del Neumático'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            "Detalles del Neumático",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow("ID Neumático", _neumaticoInfo!["iD_NEUMATICO"].toString()),
          _buildInfoRow("Código", _neumaticoInfo!["codigo"].toString()),
          _buildInfoRow("Ubicación", _neumaticoInfo!["ubicacion"].toString()),
          _buildInfoRow(
            "ID Móvil",
            _neumaticoInfo!["iD_MOVIL"] != null
                ? _neumaticoInfo!["iD_MOVIL"].toString()
                : "N/A",
          ),
          _buildInfoRow("ID Bodega", _neumaticoInfo!["iD_BODEGA"].toString()),
          _buildInfoRow(
            "Fecha Ingreso",
            _formatFecha(_neumaticoInfo!["fechA_INGRESO"].toString()),
          ),
          _buildInfoRow(
            "Fecha Salida",
            _neumaticoInfo!["fechA_SALIDA"] != null
                ? _formatFecha(_neumaticoInfo!["fechA_SALIDA"].toString())
                : "N/A",
          ),
          _buildInfoRow("Estado", _neumaticoInfo!["estado"].toString()),
          _buildInfoRow("KM Total", "${_neumaticoInfo!["kM_TOTAL"]} km"),
          _buildInfoRow("Tipo Neumático", _neumaticoInfo!["tipO_NEUMATICO"].toString()),
          const SizedBox(height: 24),
          // Añadimos los botones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => AnadirBitacoraScreen(
                         idNeumatico: _neumaticoInfo!["iD_NEUMATICO"],
                       ),
                     ),
                     
                   );
                },
                child: Text('Añadir Bitácora'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de ver bitácora
                  Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => VerBitacoraScreen(
                         idNeumatico: _neumaticoInfo!["iD_NEUMATICO"],
                       ),
                     ),
                   );
                },
                child: Text('Ver Bitácora'),
              ),
            ],
          ),
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
