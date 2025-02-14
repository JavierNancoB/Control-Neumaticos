import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../../widgets/button.dart';
import '../../../widgets/diccionario.dart';

class ComprobarNeumaticosScreen extends StatefulWidget {
  final List<dynamic>? neumaticosData;
  final String patente;

  const ComprobarNeumaticosScreen({super.key, required this.neumaticosData, required this.patente});

  @override
  _ComprobarNeumaticosScreenState createState() => _ComprobarNeumaticosScreenState();
}

class _ComprobarNeumaticosScreenState extends State<ComprobarNeumaticosScreen> {
  String? mensajeEstado = 'Acerca el dispositivo para leer el código NFC.';
  String? codigoEscaneado;
  bool escaneando = false; // Para controlar si la sesión NFC está iniciada
  Set<String> codigosEscaneados = Set<String>(); // Conjunto para almacenar los códigos escaneados

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
    // Cambiar el estado para mostrar el mensaje mientras escaneamos
    setState(() {
      escaneando = true; // Mostrar mensaje de instrucciones
    });

    try {
      // Iniciar la sesión NFC
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        // Una vez que el tag es detectado, se procesa el código
        String? codigo = await _extractNfcData(tag);
        if (codigo != null) {
          setState(() {
            codigoEscaneado = codigo;
          });
          _verificarCodigo(codigo);
        }
      });
    } catch (e) {
      setState(() {
        mensajeEstado = 'Error al iniciar la sesión NFC';
      });
    }

    // Después de iniciar el escaneo, cambiamos el estado
    setState(() {
      escaneando = true; // Ya iniciamos el escaneo
    });
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
      setState(() {
        mensajeEstado = 'Error al leer la etiqueta NFC';
      });
    }
    return null;
  }

  void _verificarCodigo(String codigo) {
    bool existe = widget.neumaticosData?.any((neumatico) => neumatico['codigo'].toString() == codigo) ?? false;
    setState(() {
      if (existe) {
        mensajeEstado = 'Código válido: $codigo';
        codigosEscaneados.add(codigo); // Agregar el código escaneado al conjunto
      } else {
        mensajeEstado = 'Código $codigo no encontrado';
      }
    });
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
          // Mostrar el mensaje de instrucciones mientras no se ha iniciado el escaneo
          if (escaneando && mensajeEstado == null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50, // Ajusta este valor para reservar espacio
                alignment: Alignment.center,
                child: Text(
                  'Acerca el dispositivo para leer el código NFC.',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ),
          // Mostrar el mensaje de estado
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
                String codigo = neumatico['codigo']?.toString() ?? '';
                int ubicacionCodigo = neumatico['ubicacion'] ?? 1;
                String ubicacionDescripcion = Diccionario.obtenerDescripcion(Diccionario.ubicacionNeumaticos, ubicacionCodigo);
                bool esEscaneado = codigosEscaneados.contains(codigo); // Verificamos si el código está en el conjunto

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: esEscaneado ? Colors.green : null,
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text('Código: $codigo'),
                    subtitle: Text('Ubicación: $ubicacionDescripcion'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: StandarButton(
              text: 'Confirmar',
              onPressed: () {
                // Acción de confirmación
              },
            ),
          ),
        ],
      ),
    );
  }
}
