import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../menu/bitacora/informacion_neumatico.dart';
import '../menu/admin/neumatico/deshabilitar_neumatico_screen.dart';
import '../menu/admin/ingresar_patente.dart';


class NFCReader extends StatefulWidget {
  final String action;  // El parámetro que indica qué acción realizar

  const NFCReader({super.key, required this.action});

  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<NFCReader> {
  String nfcData = 'Acerca tu dispositivo NFC para leerlo...';
  bool isNfcReading = false;

  @override
  void initState() {
    super.initState();
    _checkNfcAvailability();
  }

  void _checkNfcAvailability() async {
    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      setState(() {
        nfcData = 'NFC no está habilitado en este dispositivo.';
      });
    } else {
      setState(() {
        nfcData = 'NFC habilitado. Acerca el chip para leerlo.';
      });
      _startNFC();
    }
  }

  void _startNFC() async {
    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      setState(() {
        nfcData = 'NFC no está habilitado en este dispositivo.';
      });
    } else {
      setState(() {
        nfcData = 'Acerque el chip para leerlo...';
      });
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var nfcMessage = await _extractNfcData(tag);
          setState(() {
            nfcData = nfcMessage;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<String> _extractNfcData(NfcTag tag) async {
    try {
      var ndef = tag.data['ndef'];
      if (ndef != null && ndef['cachedMessage'] != null) {
        var payload = ndef['cachedMessage']['records'][0]['payload'];
        String message = String.fromCharCodes(payload);
        RegExp regExp = RegExp(r"ID:(\d+)");
        Match? match = regExp.firstMatch(message);

        if (match != null) {
          return "${match.group(1)}";
        } else {
          return "No se pudo leer un ID válido.";
        }
      } else {
        return "No se encontró mensaje NDEF.";
      }
    } catch (e) {
      return "Error al procesar los datos.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lector NFC')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              nfcData,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isNfcReading
                  ? null
                  : nfcData != 'Acerque el chip para leerlo...'
                      ? () {
                          // Redirige a la pantalla adecuada dependiendo de la acción
                          // Si el mensaje es uno de los errores, reiniciar la lectura NFC
                          if (nfcData == 'No se pudo leer un ID válido.' ||
                              nfcData == 'No se encontró mensaje NDEF.' ||
                              nfcData == 'Error al procesar los datos.') {
                            setState(() {
                              nfcData = 'Acerca tu dispositivo NFC para leerlo...';
                            });
                            _startNFC();
                          } else{
                            if (widget.action == 'informacion') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformacionNeumatico(nfcData: nfcData),
                              ),
                            );
                          } else if (widget.action == 'Añadir') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IngresarPatentePage(tipo: 'Añadir', codigo: nfcData)
                              ),
                            );
                          } else if (widget.action == 'Modificar') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IngresarPatentePage(tipo: 'Modificar', codigo: nfcData)
                              ),
                            );
                          } else if (widget.action == 'Deshabilitar') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InhabilitarNeumaticoPage(nfcData: nfcData)
                              ),
                            );
                          }
                          }                         
                        }
                      : _startNFC,
              child: Text(
                nfcData != 'Acerca tu dispositivo NFC para leerlo...'
                    ? widget.action == 'Añadir'
                        ? 'Añadir Neumático'
                        : widget.action == 'Modificar'
                            ? 'Modificar Neumático'
                            : widget.action == 'Deshabilitar'
                                ? 'Deshabilitar Neumático'
                                : 'Visualizar Información'
                    : 'Leer Chip Neumatico',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
