import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Importa intl para formatear la fecha
import '../../../services/alertas/alerta_details_service.dart';
import '../../menu/bitacora/informacion_neumatico.dart';
import '../../../models/admin/usuario_alertas.dart';
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
  Usuario? usuarioLeido;
  Usuario? usuarioAtendido;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedAlerta = await _alertaService.getAlertaById(widget.alertaId);
      final fetchedNeumatico = await _alertaService.getNeumaticoById(fetchedAlerta['iD_NEUMATICO']);
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
        usuarioLeido = leido;
        usuarioAtendido = atendido;
      });
    } catch (e) {
      _mostrarError("Ha ocurrido un error al intentar cargar los datos de la alerta.");
    }
  }

  Future<void> _mostrarError(String mensaje) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: Text("Aceptar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Función para formatear la fecha
  String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm'); // El formato que desees
      return formatter.format(parsedDate);
    } catch (e) {
      return date; // Si ocurre un error, se regresa la fecha original
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAlertInfo(),
                  SizedBox(height: 16),
                  _buildUserInfo(),
                  SizedBox(height: 16),
                  _buildActions(),
                ],
              ),
            ),
    );
  }

  Widget _buildAlertInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ALERTA: ${Diccionario.obtenerDescripcion(Diccionario.codigoAlerta, alerta!['codigO_ALERTA'])}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Fecha Ingreso: ${formatDate(alerta!['fechA_INGRESO'])}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Estado: ${Diccionario.obtenerDescripcion(Diccionario.estadoAlerta, alerta!['estadO_ALERTA'])}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (usuarioLeido != null)
              Text("Leído por: ${usuarioLeido!.nombres} ${usuarioLeido!.apellidos}",
                  style: TextStyle(fontSize: 16)),
            if (alerta!['fechA_LEIDO'] != null)
              Text("Fecha de Leído: ${formatDate(alerta!['fechA_LEIDO'])}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            if (usuarioAtendido != null)
              Text("Atendido por: ${usuarioAtendido!.nombres} ${usuarioAtendido!.apellidos}",
                  style: TextStyle(fontSize: 16)),
            if (alerta!['fechA_ATENDIDO'] != null)
              Text("Fecha de Atendido: ${formatDate(alerta!['fechA_ATENDIDO'])}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        StandarButton(
          text: "Ver Información del Neumático",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InformacionNeumatico(nfcData: neumatico!['codigo'].toString()),
            ),
          ),
        ),
        SizedBox(height: 16),
        StandarButton(text: "Marcar Pendiente", onPressed: () => _mostrarConfirmacion("Pendiente", 1)),
        SizedBox(height: 16),
        StandarButton(text: "Marcar Leído", onPressed: () => _mostrarConfirmacion("Leído", 2)),
        SizedBox(height: 16),
        StandarButton(text: "Marcar Atendido", onPressed: () => _mostrarConfirmacion("Atendido", 3)),
      ],
    );
  }

  Future<void> _mostrarConfirmacion(String accion, int estado) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar acción"),
        content: Text("¿Estás seguro de que deseas marcar como '$accion'?"),
        actions: [
          TextButton(child: Text("Cancelar"), onPressed: () => Navigator.of(context).pop()),
          TextButton(
            child: Text("Aceptar"),
            onPressed: () async {
              await _cambiarEstado(estado);  // Cambiar estado
              Navigator.of(context).pop();  // Cerrar el dialogo
            },
          ),
        ],
      ),
    );
  }

  Future<void> _cambiarEstado(int estado) async {
    await _alertaService.cambiarEstadoAlerta(widget.alertaId, estado);
    _fetchData();  // Actualizar datos después de cam
  }
}