// alertas/screens/alertas_screen.dart
import 'package:flutter/material.dart';
import '../../../services/alertas/alerta_pendiente_service.dart';
import '../../../widgets/alerta/alerta_card.dart';

class AlertasPendientesScreen extends StatefulWidget {
  @override
  _AlertasPendientesScreenState createState() => _AlertasPendientesScreenState();
}

class _AlertasPendientesScreenState extends State<AlertasPendientesScreen> {
  List<dynamic> alertas = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAlertas();
  }

  Future<void> fetchAlertas() async {
    try {
      var alertasData = await AlertasService().getAlertasPendientes();
      setState(() {
        alertas = alertasData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar las alertas: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas Pendientes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: alertas.length,
                  itemBuilder: (context, index) {
                    var alerta = alertas[index];
                    return AlertCard(
                      alerta: alerta,
                      onTap: () {
                        // Redirigir a la página con más información
                        //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                            // builder: (context) => AlertDetailsScreen(alerta: alerta),
                          //),
                        //);
                      },
                    );
                  },
                ),
    );
  }
}
