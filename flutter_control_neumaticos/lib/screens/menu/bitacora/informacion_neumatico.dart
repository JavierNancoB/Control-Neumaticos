import 'package:flutter/material.dart';
import '../../../services/informacion_neumatico_service.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/info_row.dart';
import 'anadir_bitacora.dart';
import 'ver_bitacora_screen.dart';
import '../../../widgets/diccionario.dart';

class InformacionNeumatico extends StatefulWidget {
  final String nfcData;

  const InformacionNeumatico({super.key, required this.nfcData});

  @override
  State<InformacionNeumatico> createState() => _InformacionNeumaticoState();
}

class _InformacionNeumaticoState extends State<InformacionNeumatico> {
  Map<String, dynamic>? _neumaticoInfo;
  String? _bodegaName;
  String? movilPatente = "N/A";
  bool _isLoading = true;
  String? _errorMessage;


  @override
  void initState() {
    super.initState();
    _fetchNeumaticoData();
  }

    Future<void> _fetchNeumaticoData() async {
    try {
      final data = await fetchNeumaticoData(widget.nfcData);

      final idMovil = data["iD_MOVIL"].toString();
      final idBodega = data["iD_BODEGA"].toString();

      if (idMovil.isNotEmpty) {
        try {
          movilPatente = await fetchMovilPatente(idMovil);  // Solo intenta obtener la patente si idMovil no es vacío
        } catch (e) {
          // Si ocurre un error al obtener la patente, lo logueamos y asignamos "N/A"
          movilPatente = "N/A";
        }
      } else {
        movilPatente = "N/A";  // Si no hay idMovil, asignamos "N/A"
      }

      final bodegaName = await fetchBodegaName(idBodega);

      setState(() {
        _neumaticoInfo = data;
        _bodegaName = bodegaName;
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
            InfoRow(label: "Ubicación", value: _getUbicacion(_neumaticoInfo!["ubicacion"])),
            InfoRow(label: "Patente Móvil", value: movilPatente ?? "N/A"),
            InfoRow(label: "Fecha Ingreso", value: _formatFecha(_neumaticoInfo!["fechA_INGRESO"].toString())),
            InfoRow(label: "Fecha Salida", value: _neumaticoInfo!["fechA_SALIDA"] != null ? _formatFecha(_neumaticoInfo!["fechA_SALIDA"].toString()) : "N/A"),
            InfoRow(label: "Estado", value: _getEstado(_neumaticoInfo!["estado"])),
            InfoRow(label: "KM Total", value: "${_neumaticoInfo!["kM_TOTAL"]} km"),
            InfoRow(label: "Tipo Neumático", value: _getTipoNeumatico(_neumaticoInfo!["tipO_NEUMATICO"])),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  label: 'Añadir Evento',
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
                  label: 'Ver Historial',
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

  String _getEstado(int estado) {
    return Diccionario.estadoNeumaticos[estado] ?? "Desconocido";
  }

  String _getTipoNeumatico(int tipo) {
    return Diccionario.tipoNeumatico[tipo] ?? "Desconocido";
  }

  String _getUbicacion(int ubicacion) {
  if (ubicacion == 1 && _bodegaName != null) {
    return "${Diccionario.ubicacionNeumaticos[ubicacion]} - $_bodegaName";
  }
  return Diccionario.ubicacionNeumaticos[ubicacion] ?? "Desconocida";
}
}
