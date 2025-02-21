// screens/alert_list_page.dart
import 'package:flutter/material.dart';
import '../../../models/menu/alertas.dart';
import '../../../services/alertas/alertas_service.dart';
import 'alertas_details.dart';
import '../../../widgets/diccionario.dart';

// Clase principal que representa la página de lista de alertas
class AlertListPage extends StatefulWidget {
  final String endpoint; // Reutilizable según el endpoint

  const AlertListPage({super.key, required this.endpoint});

  @override
  _AlertListPageState createState() => _AlertListPageState();
}

// Estado de la clase AlertListPage
class _AlertListPageState extends State<AlertListPage> {
  late Future<List<Alerta>> _alertas; // Futuro que contendrá la lista de alertas
  final AlertaService _alertaService = AlertaService(); // Servicio para obtener las alertas

  @override
  void initState() {
    super.initState();
    // Inicializa el futuro de alertas al iniciar el estado
    _alertas = _alertaService.getAlertasPendientes(widget.endpoint);
  }

  // Método para actualizar la lista de alertas
  void _updateAlertList() {
    setState(() {
      // Recargar las alertas
      _alertas = _alertaService.getAlertasPendientes(widget.endpoint);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Alertas")), // Título de la AppBar
      body: FutureBuilder<List<Alerta>>(
        future: _alertas, // Futuro que se está esperando
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se espera el futuro
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si ocurre un error
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final alertas = snapshot.data!; // Obtiene la lista de alertas del snapshot

          if (alertas.isEmpty) {
            // Muestra un mensaje si no hay alertas disponibles
            return Center(child: Text("No hay alertas disponibles."));
          }

          // Construye una lista de alertas
          return ListView.builder(
            itemCount: alertas.length, // Número de elementos en la lista
            itemBuilder: (context, index) {
              final alerta = alertas[index]; // Alerta actual

              // Definir el color basado en el estado
              Color estadoColor;
              String estadoTexto;

              if (alerta.estadoAlerta == 1) {
                estadoColor = Colors.yellow; // Pendiente -> Amarillo
                estadoTexto = 'Pendiente';
              } else if (alerta.estadoAlerta == 2) {
                estadoColor = const Color.fromARGB(255, 233, 245, 255); // Leído -> Azul
                estadoTexto = 'Leído';
              } else {
                estadoColor = const Color.fromARGB(255, 201, 201, 201); // Atendido -> Verde
                estadoTexto = 'Atendido';
              }

              // Construye una tarjeta para cada alerta
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Margen de la tarjeta
                color: estadoColor, // Usando color con opacidad
                child: ListTile(
                  title: Text(
                    Diccionario.obtenerDescripcion(Diccionario.codigoAlerta, alerta.codigoAlerta),
                    style: TextStyle(color: Colors.black), // Letras negras
                  ),
                  subtitle: Text(
                    "Estado: $estadoTexto\nFecha: ${alerta.fechaIngreso}\nID: ${alerta.id}",
                    style: TextStyle(color: Colors.black), // Letras negras
                  ),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black), // Icono negro
                  onTap: () {
                    // Navega a la página de detalles de la alerta al hacer tap
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
