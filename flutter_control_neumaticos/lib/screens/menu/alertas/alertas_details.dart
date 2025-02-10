import 'package:flutter/material.dart';
import '../../../services/alertas/alerta_details_service.dart';
import '../../menu/bitacora/informacion_neumatico.dart';
import '../../../models/usuario_alertas.dart';
import '../../../widgets/diccionario.dart';
import '../../../widgets/button.dart';

class AlertDetailPage extends StatefulWidget {
  final int alertaId;

  const AlertDetailPage({super.key, required this.alertaId});

  @override
  _AlertDetailPageState createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  final AlertaDetailsService _alertaService = AlertaDetailsService();
  Map<String, dynamic>? alerta;
  Map<String, dynamic>? neumatico;
  Usuario? usuarioCreador;
  Usuario? usuarioLeido;
  Usuario? usuarioAtendido;
  Usuario? usuarioFechaLeido;
  Usuario? usuarioFechaAtendido;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedAlerta = await _alertaService.getAlertaById(widget.alertaId);
      final fetchedNeumatico = await _alertaService.getNeumaticoById(fetchedAlerta['iD_NEUMATICO']);
      Usuario? creador;
      Usuario? leido;
      Usuario? atendido;

      if (fetchedAlerta['usuariO_LEIDO_ID'] != null) {
        leido = await _alertaService.getUsuarioById(fetchedAlerta['usuariO_LEIDO_ID']);
      }
      if (fetchedAlerta['usuariO_ATENDIDO_ID'] != null) {
        atendido = await _alertaService.getUsuarioById(fetchedAlerta['usuariO_ATENDIDO_ID']);
      }

      setState(() {
        alerta = fetchedAlerta;
        neumatico = fetchedNeumatico;
        usuarioCreador = creador;
        usuarioLeido = leido;
        usuarioAtendido = atendido;
      });
    } catch (e) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Ha ocurrido un error al intentar cargar los datos de la alerta."),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Función para mostrar la alerta de confirmación
  Future<void> _mostrarConfirmacion(String accion, int estado) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El diálogo no se puede cerrar tocando fuera de él
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar acción"),
          content: Text("¿Estás seguro de que deseas marcar como '$accion'?"),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                _cambiarEstado(estado); // Cambia el estado al confirmado
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cambiarEstado(int estado) async {
    try {
      await _alertaService.cambiarEstadoAlerta(widget.alertaId, estado);
      _fetchData(); // Recargar los datos para reflejar el cambio
    } catch (e) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Ha ocurrido un error al intentar cambiar el estado de la alerta."),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de Alerta")),
      body: alerta == null || neumatico == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(  // Esto centra todo el contenido
                child: Column(
                  mainAxisSize: MainAxisSize.min,  // Esto asegura que la columna ocupe solo el espacio necesario
                  crossAxisAlignment: CrossAxisAlignment.center, // Centra todo en el eje horizontal
                  children: [
                    Text("Alerta ID: ${alerta!['id']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Código de Alerta: ${Diccionario.obtenerDescripcion(Diccionario.codigoAlerta, alerta!['codigO_ALERTA'])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Fecha de Ingreso: ${alerta!['fechA_INGRESO']}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text("Estado de Alerta: ${Diccionario.obtenerDescripcion(Diccionario.estadoAlerta, alerta!['estadO_ALERTA'])}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text("Código de Neumático: ${neumatico!['codigo']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    if (usuarioLeido != null)
                      Text("Leído por: ${usuarioLeido!.nombres} ${usuarioLeido!.apellidos}", style: TextStyle(fontSize: 16)),
                    if (alerta!['fechA_LEIDO'] != null)
                      Text("Fecha de Leído: ${alerta!['fechA_LEIDO']}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    if (usuarioAtendido != null)
                      Text("Atendido por: ${usuarioAtendido!.nombres} ${usuarioAtendido!.apellidos}", style: TextStyle(fontSize: 16)),
                    if (alerta!['fechA_ATENDIDO'] != null)
                      Text("Fecha de Atendido: ${alerta!['fechA_ATENDIDO']}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    StandarButton(
                      text: "Ver Información del Neumático",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InformacionNeumatico(nfcData: neumatico!['codigo'].toString()),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    // Botones con separación uniforme
                    StandarButton(
                      text: "Marcar Pendiente",
                      onPressed: () => _mostrarConfirmacion("Pendiente", 1),
                    ),
                    SizedBox(height: 16),
                    StandarButton(
                      text: "Marcar Leído",
                      onPressed: () => _mostrarConfirmacion("Leído", 2),
                    ),
                    SizedBox(height: 16),
                    StandarButton(
                      text: "Marcar Atendido",
                      onPressed: () => _mostrarConfirmacion("Atendido", 3),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
