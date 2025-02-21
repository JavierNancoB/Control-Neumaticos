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
  final AlertaDetailsService _alertaService = AlertaDetailsService(); // Servicio para obtener detalles de la alerta
  Map<String, dynamic>? alerta; // Mapa para almacenar los detalles de la alerta
  Map<String, dynamic>? neumatico; // Mapa para almacenar los detalles del neumático
  Usuario? usuarioLeido; // Usuario que ha leído la alerta
  Usuario? usuarioAtendido; // Usuario que ha atendido la alerta

  @override
  void initState() {
    super.initState();
    _fetchData(); // Llamada para obtener los datos al iniciar el estado
  }

  // Función para obtener los datos de la alerta y el neumático
  Future<void> _fetchData() async {
    try {
      final fetchedAlerta = await _alertaService.getAlertaById(widget.alertaId); // Obtener alerta por ID
      final fetchedNeumatico = await _alertaService.getNeumaticoById(fetchedAlerta['iD_NEUMATICO']); // Obtener neumático por ID de alerta
      Usuario? leido;
      Usuario? atendido;

      // Obtener usuario que ha leído la alerta si existe
      if (fetchedAlerta['usuariO_LEIDO_ID'] != null) {
        leido = await _alertaService.getUsuarioById(fetchedAlerta['usuariO_LEIDO_ID']);
      }
      // Obtener usuario que ha atendido la alerta si existe
      if (fetchedAlerta['usuariO_ATENDIDO_ID'] != null) {
        atendido = await _alertaService.getUsuarioById(fetchedAlerta['usuariO_ATENDIDO_ID']);
      }

      // Actualizar el estado con los datos obtenidos
      setState(() {
        alerta = fetchedAlerta;
        neumatico = fetchedNeumatico;
        usuarioLeido = leido;
        usuarioAtendido = atendido;
      });
    } catch (e) {
      _mostrarError("Ha ocurrido un error al intentar cargar los datos de la alerta."); // Mostrar error si ocurre una excepción
    }
  }

  // Función para mostrar un diálogo de error
  Future<void> _mostrarError(String mensaje) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: Text("Aceptar"),
            onPressed: () => Navigator.of(context).pop(), // Cerrar el diálogo
          ),
        ],
      ),
    );
  }

  // Función para formatear la fecha
  String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date); // Parsear la fecha
      final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm'); // Formato deseado
      return formatter.format(parsedDate); // Formatear la fecha
    } catch (e) {
      return date; // Si ocurre un error, se regresa la fecha original
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de Alerta")), // Título de la AppBar
      body: alerta == null || neumatico == null
          ? Center(child: CircularProgressIndicator()) // Mostrar indicador de carga si los datos no están disponibles
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAlertInfo(), // Construir la información de la alerta
                  SizedBox(height: 16),
                  _buildUserInfo(), // Construir la información del usuario
                  SizedBox(height: 16),
                  _buildActions(), // Construir las acciones disponibles
                ],
              ),
            ),
    );
  }

  // Widget para construir la información de la alerta
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

  // Widget para construir la información del usuario
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

  // Widget para construir las acciones disponibles
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

  // Función para mostrar un diálogo de confirmación
  Future<void> _mostrarConfirmacion(String accion, int estado) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar acción"),
        content: Text("¿Estás seguro de que deseas marcar como '$accion'?"),
        actions: [
          TextButton(child: Text("Cancelar"), onPressed: () => Navigator.of(context).pop()), // Cerrar el diálogo
          TextButton(
            child: Text("Aceptar"),
            onPressed: () async {
              await _cambiarEstado(estado);  // Cambiar estado de la alerta
              Navigator.of(context).pop();  // Cerrar el diálogo
            },
          ),
        ],
      ),
    );
  }

  // Función para cambiar el estado de la alerta
  Future<void> _cambiarEstado(int estado) async {
    await _alertaService.cambiarEstadoAlerta(widget.alertaId, estado); // Llamar al servicio para cambiar el estado
    _fetchData();  // Actualizar datos después de cambiar el estado
  }
}