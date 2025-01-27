// screens/alert_detail_page.dart
import 'package:flutter/material.dart';
import '../../../models/alertas.dart';
import '../../../models/usuario_alertas.dart'; // Importamos el modelo de Usuario
import '../../../services/alertas/alertas_service.dart';
import '../../../widgets/button.dart'; // Importamos el botón personalizado

class AlertDetailPage extends StatefulWidget {
  final int alertaId;

  const AlertDetailPage({super.key, required this.alertaId});

  @override
  _AlertDetailPageState createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  late Future<Alerta> _alerta;
  late Future<Usuario> _usuarioLeido;
  late Future<Usuario> _usuarioAtendido;

  final AlertaService _alertaService = AlertaService();

  @override
  void initState() {
    super.initState();
    _alerta = _alertaService.getAlertaById(widget.alertaId); // Obtener alerta específica
  }

  void _cambiarEstado(int estado) async {
    try {
      await _alertaService.cambiarEstadoAlerta(widget.alertaId, estado);
      setState(() {
        _alerta = _alertaService.getAlertaById(widget.alertaId); // Actualizar estado
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalles de Alerta")),
      body: FutureBuilder<Alerta>(
        future: _alerta,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final alerta = snapshot.data!;
          if (alerta.usuarioLeidoId != null) {
            _usuarioLeido = _alertaService.getUsuarioById(alerta.usuarioLeidoId!); // Obtener el usuario que leyó la alerta
          }
          if (alerta.usuarioAtendidoId != null) {
            _usuarioAtendido = _alertaService.getUsuarioById(alerta.usuarioAtendidoId!); // Obtener el usuario que atendió la alerta
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ID Alerta: ${alerta.id}"),
                  Text("Estado: ${alerta.estadoAlerta == 1 ? 'Pendiente' : alerta.estadoAlerta == 2 ? 'Leído' : 'Atendido'}"),
                  SizedBox(height: 20),
                  if (alerta.fechaIngreso.isNotEmpty) Text("Fecha Ingreso: ${alerta.fechaIngreso}"),
                  if (alerta.fechaLeido != null) Text("Fecha Leído: ${alerta.fechaLeido}"),
                  if (alerta.fechaAtendido != null) Text("Fecha Atendido: ${alerta.fechaAtendido}"),
                  Text("Código Alerta: ${alerta.codigoAlerta}"),
                  SizedBox(height: 20),
                  if (alerta.usuarioLeidoId != null) ...[
                    FutureBuilder<Usuario>(
                      future: _usuarioLeido,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Leyó la alerta: Cargando...");
                        }
                        final usuario = snapshot.data!;
                        return Text("Leyó la alerta: ${usuario.nombres} ${usuario.apellidos}");
                      },
                    ),
                  ],
                  if (alerta.usuarioAtendidoId != null) ...[
                    FutureBuilder<Usuario>(
                      future: _usuarioAtendido,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Atendió la alerta: Cargando...");
                        }
                        final usuario = snapshot.data!;
                        return Text("Atendió la alerta: ${usuario.nombres} ${usuario.apellidos}");
                      },
                    ),
                  ],
                  SizedBox(height: 20),
                  Column(
                    children: [
                      StandarButton(
                        text: 'Marcar como pendiente',
                        onPressed: () => _cambiarEstado(1), // Marcar como pendiente
                      ),
                      SizedBox(width: 10),
                      StandarButton(
                        text: 'Marcar como leído',
                        onPressed: () => _cambiarEstado(2), // Marcar como leído
                      ),
                      SizedBox(width: 10),
                      StandarButton(
                        text: 'Marcar como atendido',
                        onPressed: () => _cambiarEstado(3), // Marcar como atendido
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
