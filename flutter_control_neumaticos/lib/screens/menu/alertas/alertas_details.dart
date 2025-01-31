import 'package:flutter/material.dart';
import '../../../models/alertas.dart';
import '../../../models/usuario_alertas.dart'; // Importamos el modelo de Usuario
import '../../../models/neumatico.dart'; // Asegúrate de tener el modelo de Neumatico
import '../../../services/alertas/alertas_service.dart';
import '../../../widgets/button.dart'; // Importamos el botón personalizado
import '../../../widgets/diccionario.dart'; // Importamos el diccionario de estados

class AlertDetailPage extends StatefulWidget {
  final int alertaId;

  const AlertDetailPage({super.key, required this.alertaId});

  @override
  _AlertDetailPageState createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  late Future<Alerta> _alerta;
  late Future<Neumatico> _neumatico;  // Mantenemos la declaración aquí

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontraron datos.'));
          }

          final alerta = snapshot.data!;

          // Imprime el ID del neumático antes de hacer la solicitud
          print("ID Neumático: ${alerta.idNeumatico}");

          // Asignamos el Future de neumático solo después de haber cargado la alerta
          _neumatico = _alertaService.getNeumaticoById(alerta.idNeumatico);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ID Alerta: ${alerta.id}"),
                  Text("Estado: ${alerta.estadoAlerta == 1 ? 'Pendiente' : alerta.estadoAlerta == 2 ? 'Leído' : 'Atendido'}"),
                  Text("ID Neumático: ${alerta.idNeumatico}"),

                  // Aquí se carga el neumático solo cuando se obtiene la alerta
                  FutureBuilder<Neumatico>(
                    future: _neumatico,
                    builder: (context, snapshotNeumatico) {
                      if (snapshotNeumatico.connectionState == ConnectionState.waiting) {
                        return Text("Cargando Neumático...");
                      } else if (snapshotNeumatico.hasError) {
                        return Text("Error al cargar neumático: ${snapshotNeumatico.error}");
                      } else if (!snapshotNeumatico.hasData) {
                        return Text("No se encontró neumático.");
                      }

                      final neumatico = snapshotNeumatico.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Código Neumático: ${neumatico.codigo}"),
                          Text("Patente Neumático: ${neumatico.idMovil}"),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  if (alerta.fechaIngreso.isNotEmpty) Text("Fecha Ingreso: ${alerta.fechaIngreso}"),
                  if (alerta.fechaLeido != null) Text("Fecha Leído: ${alerta.fechaLeido ?? 'No disponible'}"),
                  if (alerta.fechaAtendido != null) Text("Fecha Atendido: ${alerta.fechaAtendido ?? 'No disponible'}"),
                  Text("Código de Alerta: ${Diccionario.codigoAlerta[alerta.codigoAlerta]}"),
                  SizedBox(height: 20),
                  if (alerta.usuarioLeidoId != null) ...[ // Mostrar quien leyó la alerta
                    FutureBuilder<Usuario>(
                      future: _alertaService.getUsuarioById(alerta.usuarioLeidoId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Leyó la alerta: Cargando...");
                        }
                        if (snapshot.hasError) {
                          return Text("Error al cargar usuario");
                        }
                        if (!snapshot.hasData) {
                          return Text("Leyó la alerta: No disponible");
                        }

                        final usuario = snapshot.data!;
                        return Text("Leyó la alerta: ${usuario.nombres} ${usuario.apellidos}");
                      },
                    ),
                  ],
                  if (alerta.usuarioAtendidoId != null) ...[ // Mostrar quien atendió la alerta
                    FutureBuilder<Usuario>(
                      future: _alertaService.getUsuarioById(alerta.usuarioAtendidoId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Atendió la alerta: Cargando...");
                        }
                        if (snapshot.hasError) {
                          return Text("Error al cargar usuario");
                        }
                        if (!snapshot.hasData) {
                          return Text("Atendió la alerta: No disponible");
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
                        onPressed: () => _cambiarEstado(1),
                      ),
                      SizedBox(width: 10),
                      StandarButton(
                        text: 'Marcar como leído',
                        onPressed: () => _cambiarEstado(2),
                      ),
                      SizedBox(width: 10),
                      StandarButton(
                        text: 'Marcar como atendido',
                        onPressed: () => _cambiarEstado(3),
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
