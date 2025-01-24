// pages/alertas_page.dart
import 'package:flutter/material.dart';
import '../../../services/alerta_service.dart';
import '../../../widgets/alerta/alerta_card.dart';

class AlertasPage extends StatefulWidget {
  @override
  State<AlertasPage> createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  List<dynamic>? _alertas;
  bool _isLoading = true;
  String? _errorMessage;
  final AlertaService _alertaService = AlertaService();

  @override
  void initState() {
    super.initState();
    _fetchAlertas();
  }

  Future<void> _fetchAlertas() async {
    try {
      List<dynamic>? alertas = await _alertaService.fetchAlertas();

      setState(() {
        if (alertas != null) {
          _alertas = alertas;
        } else {
          _errorMessage = 'Token no encontrado.';
        }
        _isLoading = false;
      });
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
      return _buildLoadingScreen();
    }

    if (_errorMessage != null) {
      return _buildErrorScreen();
    }

    if (_alertas == null || _alertas!.isEmpty) {
      return _buildNoAlertasScreen();
    }

    return _buildAlertasList();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Alertas')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Alertas')),
      body: Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildNoAlertasScreen() {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Alertas')),
      body: Center(
        child: Text(
          'No se encontraron alertas.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildAlertasList() {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Alertas')),
      body: ListView.builder(
        itemCount: _alertas!.length,
        itemBuilder: (context, index) {
          final alerta = _alertas![index];
          return AlertCard(
            alerta: alerta,
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformacionAlerta(alerta: alerta),
                ),
              );
            */},
          );
        },
      ),
    );
  }
}
