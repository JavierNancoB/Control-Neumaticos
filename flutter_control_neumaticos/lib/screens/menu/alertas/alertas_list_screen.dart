// alertas/screens/alertas_list_screen.dart
import 'package:flutter/material.dart';
import '../../../services/alerta_service.dart';
import '../../../widgets/alerta/alerta_card.dart';
import 'informacion_alertas_screen.dart';

class AlertasListScreen extends StatefulWidget {
  const AlertasListScreen({super.key});

  @override
  State<AlertasListScreen> createState() => _AlertasListScreenState();
}

class _AlertasListScreenState extends State<AlertasListScreen> {
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
      final alertas = await _alertaService.fetchAlertas();
      setState(() {
        _alertas = alertas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar las alertas: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Alertas'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Alertas'),
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas'),
      ),
      body: ListView.builder(
        itemCount: _alertas?.length ?? 0,
        itemBuilder: (context, index) {
          return AlertCard(
            alerta: _alertas![index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformacionAlertaScreen(
                    alerta: _alertas![index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
