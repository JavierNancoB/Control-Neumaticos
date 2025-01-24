import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'bitacora/informacion_neumatico.dart'; // Importa la página de información

class NFCReader extends StatefulWidget {
  const NFCReader({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<NFCReader> {
  String nfcData = 'Acerca tu dispositivo NFC para leerlo...'; // Inicializamos con el mensaje de "acerca el chip"
  bool isNfcReading = false; // Para saber si estamos leyendo el chip

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
      _startNFC(); // Inicia automáticamente la lectura del NFC si está habilitado
    }
  }
  void _startNFC() async {
  bool isNfcAvailable = await NfcManager.instance.isAvailable(); // Comprobar si está habilitado
  if (!isNfcAvailable) {
    setState(() {
      nfcData = 'NFC no está habilitado en este dispositivo.';
    });
  } else {
    setState(() {
      nfcData = 'Acerque el chip para leerlo...';
    });
    // Aquí se inicia la sesión de lectura
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var nfcMessage = await _extractNfcData(tag);
        setState(() {
          nfcData = nfcMessage;  // Mostrar el ID extraído
        });
        // Deja de leer hasta que el usuario vuelva a presionar el botón
      },
    );
  }
}

@override
void dispose() {
    // Detener la sesión NFC al cerrar la pantalla o la app
    NfcManager.instance.stopSession();
    super.dispose();
}

  // Método para extraer el ID del mensaje NDEF
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
      appBar: AppBar(title: const Text('Bitacora')),
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
                          // Si ya se ha leído un chip, redirige a otra pantalla
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InformacionNeumatico(nfcData: nfcData,)
                              ),
                          );
                        }
                      : _startNFC, // Si no se ha leído nada, empieza a leer
              child: Text(nfcData != 'Acerca tu dispositivo NFC para leerlo...' ? 'Ver Información' : 'Leer Chip Neumatico'),
            ),
          ],
        ),
      ),
    );
  }
}