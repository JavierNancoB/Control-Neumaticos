import 'package:flutter/material.dart';
import '../../../services/informacion_neumatico_service.dart';
import '../../../widgets/info_row.dart';
import 'anadir_bitacora.dart';
import 'ver_bitacora_screen.dart';
import '../../../widgets/diccionario.dart';
import '../../../widgets/button.dart';
import '../../menu/admin/ingresar_patente.dart';

// Clase principal que representa la pantalla de información del neumático
class InformacionNeumatico extends StatefulWidget {
  final String nfcData; // Dato NFC del neumático

  const InformacionNeumatico({super.key, required this.nfcData});

  @override
  State<InformacionNeumatico> createState() => _InformacionNeumaticoState();
}

class _InformacionNeumaticoState extends State<InformacionNeumatico> {
  Map<String, dynamic>? _neumaticoInfo; // Información del neumático
  String? _bodegaName; // Nombre de la bodega
  String? movilPatente = "N/A"; // Patente del móvil, por defecto "N/A"
  bool _isLoading = true; // Indicador de carga
  String? _errorMessage; // Mensaje de error

  @override
  void initState() {
    super.initState();
    _fetchNeumaticoData(); // Llamada para obtener los datos del neumático al iniciar
  }

  // Método para obtener los datos del neumático
  Future<void> _fetchNeumaticoData() async {
    try {
      final data = await fetchNeumaticoData(widget.nfcData); // Llamada al servicio para obtener datos

      final idMovil = data["iD_MOVIL"].toString(); // ID del móvil
      final idBodega = data["iD_BODEGA"].toString(); // ID de la bodega

      if (idMovil.isNotEmpty) {
        try {
          movilPatente = await fetchMovilPatente(idMovil); // Obtener la patente del móvil si el ID no está vacío
        } catch (e) {
          movilPatente = "N/A"; // Si ocurre un error, asignar "N/A"
        }
      } else {
        movilPatente = "N/A"; // Si no hay ID del móvil, asignar "N/A"
      }

      final bodegaName = await fetchBodegaName(idBodega); // Obtener el nombre de la bodega

      setState(() {
        _neumaticoInfo = data; // Asignar los datos del neumático
        _bodegaName = bodegaName; // Asignar el nombre de la bodega
        _isLoading = false; // Finalizar la carga
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error: $e'; // Asignar mensaje de error
        _isLoading = false; // Finalizar la carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostrar indicador de carga mientras se obtienen los datos
      return Scaffold(
        appBar: AppBar(title: const Text('Información del Neumático')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      // Mostrar mensaje de error si ocurre algún problema
      return Scaffold(
        appBar: AppBar(title: const Text('Información del Neumático')),
        body: Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 18))),
      );
    }

    if (_neumaticoInfo == null) {
      // Mostrar mensaje si no se encuentran datos del neumático
      return Scaffold(
        appBar: AppBar(title: const Text('Información del Neumático')),
        body: const Center(child: Text('No se encontraron datos del neumático.', style: TextStyle(fontSize: 18))),
      );
    }

    // Mostrar la información del neumático
    return Scaffold(
      appBar: AppBar(title: const Text('Información del Neumático')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Neumático: ${_neumaticoInfo!["codigo"].toString()}', // Mostrar el código del neumático
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InfoRow(label: "Ubicación", value: _getUbicacion(_neumaticoInfo!["ubicacion"])), // Mostrar ubicación
            InfoRow(label: "Tipo Neumático", value: _getTipoNeumatico(_neumaticoInfo!["tipO_NEUMATICO"])), // Mostrar tipo de neumático
            InfoRow(label: "Patente Móvil", value: movilPatente ?? "No asignado"), // Mostrar patente del móvil
            InfoRow(label: "Fecha Ingreso", value: _formatFecha(_neumaticoInfo!["fechA_INGRESO"].toString())), // Mostrar fecha de ingreso
            InfoRow(label: "Fecha Salida", value: _neumaticoInfo!["fechA_SALIDA"] != null ? _formatFecha(_neumaticoInfo!["fechA_SALIDA"].toString()) : "N/A"), // Mostrar fecha de salida
            InfoRow(label: "Estado", value: _getEstado(_neumaticoInfo!["estado"])), // Mostrar estado del neumático
            InfoRow(label: "KM Total", value: "${_neumaticoInfo!["kM_TOTAL"]} km"), // Mostrar kilómetros totales

            const SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 16),
                StandarButton(
                  text: 'Añadir Evento', // Botón para añadir evento
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnadirBitacoraScreen(
                          idNeumatico: _neumaticoInfo!["iD_NEUMATICO"], // Pasar ID del neumático
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                StandarButton(
                  text: 'Ver Historial', // Botón para ver historial
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerBitacoraScreen(
                          idNeumatico: _neumaticoInfo!["iD_NEUMATICO"], // Pasar ID del neumático
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                StandarButton(
                  text: 'Reasignar Neumático', // Botón para reasignar neumático
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IngresarPatentePage(
                          tipo: 'Asignar', // Tipo de acción
                          codigo: widget.nfcData, // Pasar dato NFC
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para formatear la fecha
  String _formatFecha(String fecha) {
    DateTime date = DateTime.parse(fecha);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // Método para obtener el estado del neumático
  String _getEstado(int estado) {
    return Diccionario.estadoNeumaticos[estado] ?? "Desconocido";
  }

  // Método para obtener el tipo de neumático
  String _getTipoNeumatico(int tipo) {
    return Diccionario.tipoNeumatico[tipo] ?? "Desconocido";
  }

  // Método para obtener la ubicación del neumático
  String _getUbicacion(int ubicacion) {
    if (ubicacion == 1 && _bodegaName != null) {
      return "${Diccionario.ubicacionNeumaticos[ubicacion]} - $_bodegaName";
    }
    return Diccionario.ubicacionNeumaticos[ubicacion] ?? "Desconocida";
  }
}
