// services/nfc_service.dart
import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  // Método para iniciar la lectura del NFC
  Future<String> startReadingNfc() async {
    String nfcData = 'Acerca tu dispositivo NFC para leerlo...';

    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      return 'NFC no está habilitado en este dispositivo.';
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        nfcData = await _extractNfcData(tag);
      },
    );

    return nfcData;
  }

  // Método para extraer los datos del tag NFC
  Future<String> _extractNfcData(NfcTag tag) async {
    try {
      var ndef = tag.data['ndef'];
      if (ndef != null && ndef['cachedMessage'] != null) {
        var payload = ndef['cachedMessage']['records'][0]['payload'];
        String message = String.fromCharCodes(payload);
        RegExp regExp = RegExp(r"ID:(\d+)");
        Match? match = regExp.firstMatch(message);

        if (match != null) {
          return "${match.group(1)}"; // Devuelve el ID del chip
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

  // Método para detener la sesión de NFC
  void stopSession() {
    NfcManager.instance.stopSession();
  }
}
