import 'package:flutter/material.dart';
import '../../../services/informacion_neumatico_service.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/info_row.dart';
import 'añadir_bitacora.dart';
import 'ver_bitacora_screen.dart';

class InformacionNeumatico extends StatefulWidget {
  final String nfcData;

  const InformacionNeumatico({super.key, required this.nfcData});

  @override
  State<InformacionNeumatico> createState() => _InformacionNeumaticoState();
}

class _InformacionNeumaticoState extends State<InformacionNeumatico> {
  Map<String, dynamic>? _neumaticoInfo;
  String? _bodegaName;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print("Código recibido en InformacionNeumatico: ${widget.nfcData}");  // Verificar el dato recibido
    _fetchNeumaticoData();
  }

  Future<void> _fetchNeumaticoData() async {
    try {
      print("Buscando datos para el neumático con código: ${widget.nfcData}");  // Verificar el código utilizado
      final data = await fetchNeumaticoData(widget.nfcData);
      print("Datos recibidos: $data");  // Verificar los datos recibidos

      // Obtener el nombre de la bodega
      final idBodega = data["iD_BODEGA"].toString();
      final bodegaName = await fetchBodegaName(idBodega);

      setState(() {
        _neumaticoInfo = data;
        _bodegaName = bodegaName;  // Actualizar con el nombre de la bodega
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error: $e';
        _isLoading = false;
      });
      print("Error al obtener datos del neumático: $e");  // Imprimir error si ocurre
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Información del Neumático')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Información del Neumático')),
        body: Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 18))),
      );
    }

    if (_neumaticoInfo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Información del Neumático')),
        body: const Center(child: Text('No se encontraron datos del neumático.', style: TextStyle(fontSize: 18))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Información del Neumático')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Detalles del Neumático",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InfoRow(label: "ID Neumático", value: _neumaticoInfo!["iD_NEUMATICO"].toString()),
            InfoRow(label: "Código", value: _neumaticoInfo!["codigo"].toString()),
            InfoRow(label: "Ubicación", value: _neumaticoInfo!["ubicacion"].toString()),
            InfoRow(label: "ID Móvil", value: _neumaticoInfo!["iD_MOVIL"]?.toString() ?? "N/A"),
            // Mostrar el nombre de la bodega en lugar del ID
            InfoRow(label: "Bodega", value: _bodegaName ?? "Cargando..."),
            InfoRow(label: "Fecha Ingreso", value: _formatFecha(_neumaticoInfo!["fechA_INGRESO"].toString())),
            InfoRow(
                label: "Fecha Salida", value: _neumaticoInfo!["fechA_SALIDA"] != null ? _formatFecha(_neumaticoInfo!["fechA_SALIDA"].toString()) : "N/A"),
            InfoRow(label: "Estado", value: _neumaticoInfo!["estado"].toString()),
            InfoRow(label: "KM Total", value: "${_neumaticoInfo!["kM_TOTAL"]} km"),
            InfoRow(label: "Tipo Neumático", value: _neumaticoInfo!["tipO_NEUMATICO"].toString()),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  label: 'Añadir Bitácora',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnadirBitacoraScreen(
                          idNeumatico: _neumaticoInfo!["iD_NEUMATICO"],
                        ),
                      ),
                    );
                  },
                ),
                ActionButton(
                  label: 'Ver Bitácora',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerBitacoraScreen(
                          idNeumatico: _neumaticoInfo!["iD_NEUMATICO"],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatFecha(String fecha) {
    DateTime date = DateTime.parse(fecha);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
