import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'añadir_neumatico.dart';
import 'modificar_neumatico.dart';
import 'inhabilitar_neumatico.dart';

class NfcNeumaticoPage extends StatefulWidget {
  final String action;

  const NfcNeumaticoPage({super.key, required this.action});

  @override
  _NfcNeumaticoPageState createState() => _NfcNeumaticoPageState();
}

class _NfcNeumaticoPageState extends State<NfcNeumaticoPage> {
  String nfcData = 'Acerca tu dispositivo NFC para leerlo...';
  bool isNfcReading = false;
  bool isNfcReadSuccessful = false;

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
        isNfcReading = true;
      });
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var nfcMessage = await _extractNfcData(tag);
          setState(() {
            nfcData = nfcMessage;
            isNfcReading = false;
            isNfcReadSuccessful = nfcMessage.startsWith("ID leído:");
          });
        },
      );
    }
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
          return "ID leído: ${match.group(1)}";
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

  void _navigateToActionPage() {
    String id = nfcData.replaceAll("ID leído: ", "");
    Widget page;
    switch (widget.action) {
      case 'Añadir':
        page = AnadirNeumaticoPage(nfcData: id);
        break;
      case 'Modificar':
        page = AnadirNeumaticoPage(nfcData: id);
        break;
      case 'Inhabilitar/Habilitar':
        page = InhabilitarNeumaticoPage(nfcData: id);
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leer NFC Neumático')),
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
              onPressed: isNfcReading ? null : _startNFC,
              child: Text(isNfcReading ? 'Leyendo...' : 'Leer/Reintentar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isNfcReadSuccessful ? _navigateToActionPage : null,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}