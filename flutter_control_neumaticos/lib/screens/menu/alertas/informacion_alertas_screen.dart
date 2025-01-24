// alertas/screens/informacion_alerta_screen.dart
import 'package:flutter/material.dart';
import '../../../services/alerta_service.dart';
import '../../../widgets/info_row.dart';


class InformacionAlertaScreen extends StatefulWidget {
  final Map<String, dynamic> alerta;

  const InformacionAlertaScreen({super.key, required this.alerta});

  @override
  State<InformacionAlertaScreen> createState() => _InformacionAlertaScreenState();
}

class _InformacionAlertaScreenState extends State<InformacionAlertaScreen> {
  Map<String, dynamic>? _neumaticoInfo;
  bool _isLoading = true;
  String? _errorMessage;
  final AlertaService _alertaService = AlertaService();

  @override
  void initState() {
    super.initState();
    _fetchNeumaticoData();
  }

  Future<void> _fetchNeumaticoData() async {
    try {
      final neumaticoInfo = await _alertaService.fetchNeumaticoData(widget.alerta["iD_NEUMATICO"].toString());

      setState(() {
        _neumaticoInfo = neumaticoInfo;
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
      return Scaffold(
        appBar: AppBar(
          title: const Text('Información de la Alerta'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Información de la Alerta'),
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
        title: const Text('Información de la Alerta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Detalles de la Alerta",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InfoRow(label: "ID Alerta", value: widget.alerta["id"].toString()),
            InfoRow(label: "Fecha Alerta", value: _formatFecha(widget.alerta["fechA_ALERTA"])),
            InfoRow(label: "Código Alerta", value: widget.alerta["codigO_ALERTA"].toString()),
            const SizedBox(height: 24),
            const Text(
              "Detalles del Neumático",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InfoRow(label: "ID Neumático", value: _neumaticoInfo?["iD_NEUMATICO"].toString() ?? "No disponible"),
            InfoRow(label: "Código", value: _neumaticoInfo?["codigo"].toString() ?? "No disponible"),
            InfoRow(label: "Ubicación", value: _neumaticoInfo?["ubicacion"].toString() ?? "No disponible"),
            InfoRow(label: "ID Móvil", value: _neumaticoInfo?["iD_MOVIL"]?.toString() ?? "No disponible"),
            InfoRow(label: "ID Bodega", value: _neumaticoInfo?["iD_BODEGA"].toString() ?? "No disponible"),
            InfoRow(label: "Fecha Ingreso", value: _formatFecha(_neumaticoInfo?["fechA_INGRESO"] ?? "")),
            InfoRow(label: "Fecha Salida", value: _formatFecha(_neumaticoInfo?["fechA_SALIDA"] ?? "")),
            InfoRow(label: "Estado", value: _neumaticoInfo?["estado"].toString() ?? "No disponible"),
            InfoRow(label: "KM Total", value: _neumaticoInfo?["kM_TOTAL"].toString() ?? "No disponible"),
            InfoRow(label: "Tipo Neumático", value: _neumaticoInfo?["tipO_NEUMATICO"].toString() ?? "No disponible"),
          ],
        ),
      ),
    );
  }

  String _formatFecha(String fecha) {
    if (fecha.isEmpty) return "No disponible";
    DateTime date = DateTime.parse(fecha);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
