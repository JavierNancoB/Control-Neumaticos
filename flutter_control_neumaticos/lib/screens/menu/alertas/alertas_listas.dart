// screens/alert_list_page.dart
import 'package:flutter/material.dart';
import '../../../models/alertas.dart';
import '../../../services/alertas/alertas_service.dart';
import 'alertas_details.dart';

class AlertListPage extends StatefulWidget {
  final String endpoint; // Reutilizable según el endpoint

  const AlertListPage({super.key, required this.endpoint});

  @override
  _AlertListPageState createState() => _AlertListPageState();
}

class _AlertListPageState extends State<AlertListPage> {
  late Future<List<Alerta>> _alertas;
  final AlertaService _alertaService = AlertaService();

  @override
  void initState() {
    super.initState();
    _alertas = _alertaService.getAlertasPendientes(widget.endpoint);
  }

  // Método para actualizar la lista de alertas
  void _updateAlertList() {
    setState(() {
      _alertas = _alertaService.getAlertasPendientes(widget.endpoint); // Recargar las alertas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Alertas")),
      body: FutureBuilder<List<Alerta>>(
        future: _alertas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final alertas = snapshot.data!;

          if (alertas.isEmpty) {
            return Center(child: Text("No hay alertas disponibles."));
          }

          return ListView.builder(
            itemCount: alertas.length,
            itemBuilder: (context, index) {
              final alerta = alertas[index];

              // Definir el color basado en el estado
              Color estadoColor;
              String estadoTexto;

              if (alerta.estadoAlerta == 1) {
                estadoColor = const Color.fromARGB(255, 252, 237, 171); // Pendiente -> Rojo
                estadoTexto = 'Pendiente';
              } else if (alerta.estadoAlerta == 2) {
                estadoColor = const Color.fromARGB(255, 233, 245, 255); // Leído -> Azul
                estadoTexto = 'Leído';
              } else {
                estadoColor = const Color.fromARGB(255, 201, 201, 201); // Atendido -> Verde
                estadoTexto = 'Atendido';
              }

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: estadoColor, // Usando color con opacidad
                child: ListTile(
                  title: Text("Alerta ID: ${alerta.id}"),
                  subtitle: Text("Estado: $estadoTexto"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlertDetailPage(alertaId: alerta.id),
                      ),
                    ).then((_) {
                      // Actualiza la lista de alertas al regresar de la pantalla de detalles
                      _updateAlertList();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
