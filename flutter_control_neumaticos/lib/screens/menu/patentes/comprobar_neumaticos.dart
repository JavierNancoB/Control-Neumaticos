import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/button.dart';
import '../../../widgets/diccionario.dart';
import '../../../services/movil/comprobar_neumatico_service.dart';
import '../../../utils/snackbar_util.dart'; // Importa la función del snackbar

class ComprobarNeumaticosScreen extends StatefulWidget {
  final List<dynamic>? neumaticosData;
  final String patente;

  const ComprobarNeumaticosScreen({super.key, required this.neumaticosData, required this.patente});

  @override
  _ComprobarNeumaticosScreenState createState() => _ComprobarNeumaticosScreenState();
}

class _ComprobarNeumaticosScreenState extends State<ComprobarNeumaticosScreen> {
  String? mensajeEstado = 'Acerca el dispositivo para leer el código NFC.';
  bool escaneando = false;
  Set<String> codigosEscaneados = <String>{};

  @override
  void initState() {
    super.initState();
    _iniciarEscaneoNFC();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<void> _iniciarEscaneoNFC() async {
    setState(() => escaneando = true);

    try {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        String? codigo = await _extractNfcData(tag);
        if (codigo != null) {
          _verificarCodigo(codigo);
        }
      });
    } catch (e) {
      showCustomSnackBar(context, 'Error al iniciar la sesión NFC', isError: true);
    }
  }

  Future<String?> _extractNfcData(NfcTag tag) async {
    try {
      var ndef = tag.data['ndef'];
      if (ndef != null && ndef['cachedMessage'] != null) {
        var payload = ndef['cachedMessage']['records'][0]['payload'];
        String message = String.fromCharCodes(payload);
        RegExp regExp = RegExp(r"ID:(\d+)");
        Match? match = regExp.firstMatch(message);
        return match?.group(1);
      }
    } catch (e) {
      showCustomSnackBar(context, 'Error al leer la etiqueta NFC', isError: true);
    }
    return null;
  }

  void _verificarCodigo(String codigo) {
    bool existe = widget.neumaticosData?.any((neumatico) => neumatico['codigo'].toString() == codigo) ?? false;

    setState(() {
      if (existe) {
        mensajeEstado = 'Código válido: $codigo';
        codigosEscaneados.add(codigo);
      } else {
        mensajeEstado = 'Código $codigo no encontrado';
        codigosEscaneados.add(codigo);
      }
    });
  }

  Future<void> _finalizarComprobacion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUsuario = prefs.getInt('userId');

    if (idUsuario == null) {
      showCustomSnackBar(context, 'Error: No se encontró el ID de usuario', isError: true);
      return;
    }

    List<String> codigosNoEscaneados = widget.neumaticosData!
        .where((neumatico) => !codigosEscaneados.contains(neumatico['codigo'].toString()))
        .map((neumatico) => neumatico['codigo'].toString())
        .toList();

    List<String> codigosEscaneadosNoEncontrados = codigosEscaneados.where((codigo) {
      return !widget.neumaticosData!.any((neumatico) => neumatico['codigo'].toString() == codigo);
    }).toList();

    String observaciones = '';
    if (codigosNoEscaneados.isNotEmpty) {
      observaciones += 'Neumáticos no escaneados: ${codigosNoEscaneados.join(', ')}\n';
    }
    if (codigosEscaneadosNoEncontrados.isNotEmpty) {
      observaciones += 'Neumáticos escaneados no encontrados: ${codigosEscaneadosNoEncontrados.join(', ')}\n';
    }

    observaciones = observaciones.isEmpty ? 'Comprobación exitosa, ¿deseas finalizar?' : observaciones;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(observaciones == 'Comprobación exitosa, ¿deseas finalizar?' ? 'Comprobación exitosa' : 'Observación'),
          content: Text(observaciones),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                HistorialMovilService historialService = HistorialMovilService();
                await historialService.registrarHistorial(
                  patente: widget.patente,
                  codigosNoEscaneados: codigosNoEscaneados,
                  codigosNoEncontrados: codigosEscaneadosNoEncontrados,
                );
                showCustomSnackBar(context, 'Comprobación registrada correctamente');
                Navigator.of(context).pop();
              },
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comprobar Neumáticos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Escanea los Neumáticos del Móvil: ${widget.patente}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (mensajeEstado != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                mensajeEstado!,
                style: TextStyle(
                  fontSize: 16,
                  color: mensajeEstado == 'Acerca el dispositivo para leer el código NFC.'
                      ? Colors.black
                      : (mensajeEstado!.contains('válido') ? Colors.green : Colors.red),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.neumaticosData?.length ?? 0,
              itemBuilder: (context, index) {
                final neumatico = widget.neumaticosData![index];
                String codigo = neumatico['codigo'].toString();
                String ubicacionDescripcion = Diccionario.obtenerDescripcion(Diccionario.ubicacionNeumaticos, neumatico['ubicacion'] ?? 1);
                bool esEscaneado = codigosEscaneados.contains(codigo);

                return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                color: esEscaneado ? Colors.green : null,
                child: ListTile(
                  leading: Icon(
                    esEscaneado ? Icons.check_circle_outline : Icons.info_outline,
                    color: esEscaneado ? Colors.white : null, // Ícono blanco si está escaneado
                  ),
                  title: Text(
                    'Código: $codigo',
                    style: TextStyle(color: esEscaneado ? Colors.white : null), // Texto blanco si está escaneado
                  ),
                  subtitle: Text(
                    'Ubicación: $ubicacionDescripcion',
                    style: TextStyle(color: esEscaneado ? Colors.white : null), // Texto blanco si está escaneado
                  ),
                ),
              );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: StandarButton(
              text: 'Confirmar',
              onPressed: _finalizarComprobacion,
            ),
          ),
        ],
      ),
    );
  }
}