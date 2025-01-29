import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../menu/bitacora/informacion_neumatico.dart';
import '../menu/admin/neumatico/deshabilitar_neumatico_screen.dart';
import '../menu/admin/ingresar_patente.dart';
import '../../services/nfc_verification_reader.dart';
import '../menu/admin/admin_actions_screen.dart';

class NFCReader extends StatefulWidget {
  final String action;  // El parámetro que indica qué acción realizar

  const NFCReader({super.key, required this.action});

  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<NFCReader> {
  String nfcData = 'Acerca tu dispositivo NFC para leerlo...';
  bool isNfcReading = false;
  String? statusMessage; // Mensaje que muestra si el neumático está habilitado o no.

  @override
  void initState() {
    super.initState();
    _checkNfcAvailability();
  }

  void _checkNfcAvailability() async {
    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    print('¿NFC disponible?: $isNfcAvailable');
    
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

          // Primero, verificar si el neumático existe
          NfcVerificationReader reader = NfcVerificationReader();
          bool exists = await reader.verificarSiNeumaticoExiste(int.parse(nfcMessage));

          if (exists) {
            // Si el neumático existe, verificar si está habilitado
            bool isHabilitado = await reader.verificarSiNeumaticoHabilitado(nfcMessage);
            setState(() {
              statusMessage = isHabilitado ? 'Neumático Habilitado' : 'Lea Nuevamente';
              if (!isHabilitado) {
                // No redirigir, solo mostrar que está deshabilitado
                nfcData = 'Neumatico Deshabilitado: ';
                _showAbleNeumaticoDialog(nfcMessage);
              }
            });
          } else {
            // Si no existe, preguntar si desea añadirlo
            setState(() {
              nfcData = 'Neumático no encontrado.';
              statusMessage = null; // Limpiar mensaje de estado
            });
            _showAddNeumaticoDialog(nfcMessage);
          }
        },
      );
    }
  }


  Future<void> _showAddNeumaticoDialog(String nfcMessage) async {
    print('Mostrando diálogo para añadir neumático...');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Neumático no encontrado'),
          content: Text('¿Deseas añadir un nuevo neumático con este código?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                print('Redirigiendo para añadir neumático...');
                Navigator.push(context, MaterialPageRoute(builder: (context) => IngresarPatentePage(tipo: 'Añadir', codigo: nfcMessage)));
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAbleNeumaticoDialog(String nfcMessage) async {
    print('Mostrando diálogo para añadir neumático...');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Neumático no Habilitado'),
          content: Text('¿Deseas habilitar el neumático con este código?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                print('Redirigiendo para habilitar neumático...');
                Navigator.push(context, MaterialPageRoute(builder: (context) => InhabilitarNeumaticoPage(nfcData: nfcMessage)));
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
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
            if (statusMessage != null)
              Text(
                statusMessage!, // Mostrar el estado de habilitación
                style: TextStyle(fontSize: 18, color: statusMessage == 'Neumático Habilitado' ? Colors.green : Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isNfcReading
                  ? null
                  : nfcData != 'Acerque el chip para leerlo...'
                      ? () {
                          if (nfcData == 'No se pudo leer un ID válido.' ||
                              nfcData == 'No se encontró mensaje NDEF.' ||
                              nfcData == 'Error al procesar los datos.' ||
                              nfcData == 'Neumático no encontrado.' ||
                              nfcData == 'NFC no está habilitado en este dispositivo.' ||
                              nfcData == 'Neumatico Deshabilitado: '
                              ) {
                            setState(() {
                              nfcData = 'Acerca tu dispositivo NFC para leerlo...';
                              statusMessage = null;
                            });
                            _startNFC();
                          } else {
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
