import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pentacrom_neumaticos_2/widgets/button.dart';
import '../menu/bitacora/informacion_neumatico.dart';
import '../menu/admin/neumatico/deshabilitar_neumatico_screen.dart';
import '../menu/admin/ingresar_patente.dart';
import '../../services/nfc_verification_reader.dart';

// Clase principal del lector NFC
class NFCReader extends StatefulWidget {
  final String action;  // El parámetro que indica qué acción realizar

  const NFCReader({super.key, required this.action});

  @override
  _NFCReaderState createState() => _NFCReaderState();
}

// Estado del lector NFC
class _NFCReaderState extends State<NFCReader> {
  String nfcData = 'Acerca tu dispositivo NFC para leerlo...'; // Mensaje inicial
  bool isNfcReading = false; // Bandera para saber si se está leyendo NFC
  bool isLoading = false; // Bandera para saber si está cargando
  String? statusMessage; // Mensaje de estado

  @override
  void initState() {
    super.initState();
    _checkNfcAvailability(); // Verificar disponibilidad de NFC al iniciar
  }

  // Verificar si el NFC está disponible en el dispositivo
  void _checkNfcAvailability() async {
    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    
    if (!isNfcAvailable) {
      setState(() {
        nfcData = 'NFC no está habilitado en este dispositivo.'; // Mensaje si NFC no está disponible
      });
    } else {
      setState(() {
        nfcData = 'NFC habilitado. Acerca el chip para leerlo.'; // Mensaje si NFC está disponible
      });
      _startNFC(); // Iniciar lectura de NFC
    }
  }

  // Iniciar la sesión de lectura NFC
  void _startNFC() async {
    setState(() {
      isLoading = true; // Marcar como cargando
      nfcData = 'Acerca tu dispositivo NFC para leerlo...'; // Mostrar mensaje de carga
    });

    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      setState(() {
        nfcData = 'NFC no está habilitado en este dispositivo.'; // Mensaje si NFC no está disponible
        isLoading = false; // Terminar carga
      });
    } else {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var nfcMessage = await _extractNfcData(tag); // Extraer datos del tag NFC
          setState(() {
            nfcData = nfcMessage; // Actualizar datos NFC
          });

          NfcVerificationReader reader = NfcVerificationReader();
          bool exists = await reader.verificarSiNeumaticoExiste(int.parse(nfcMessage)); // Verificar si el neumático existe

          if (exists) {
            bool isHabilitado = await reader.verificarSiNeumaticoHabilitado(nfcMessage); // Verificar si el neumático está habilitado
            setState(() {
              statusMessage = isHabilitado ? 'Neumático Habilitado' : 'Lea Nuevamente'; // Actualizar mensaje de estado
              if (!isHabilitado) {
                nfcData = 'Neumático Deshabilitado: ';
                _showAbleNeumaticoDialog(nfcMessage); // Mostrar diálogo para habilitar neumático
              }
              isLoading = false; // Terminar carga
            });
          } else {
            setState(() {
              nfcData = 'Neumático no encontrado.'; // Mensaje si el neumático no se encuentra
              statusMessage = null;
              isLoading = false; // Terminar carga
            });
            _showAddNeumaticoDialog(nfcMessage); // Mostrar diálogo para añadir neumático
          }
        },
      );
    }
  }

  // Mostrar diálogo para añadir neumático
  Future<void> _showAddNeumaticoDialog(String nfcMessage) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Neumático no encontrado'),
          content: Text('¿Deseas añadir un nuevo neumático con este código?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IngresarPatentePage(tipo: 'Añadir', codigo: nfcMessage)), // Navegar a la página de añadir patente
                );
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar diálogo para habilitar neumático
  Future<void> _showAbleNeumaticoDialog(String nfcMessage) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Neumático no Habilitado'),
          content: Text('¿Deseas habilitar el neumático con este código?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Cerrar diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InhabilitarNeumaticoPage(nfcData: nfcMessage)), // Navegar a la página de inhabilitar neumático
                );
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
    NfcManager.instance.stopSession(); // Detener la sesión NFC al destruir el widget
    super.dispose();
  }

  // Extraer datos del tag NFC
  Future<String> _extractNfcData(NfcTag tag) async {
    try {
      var ndef = tag.data['ndef'];
      if (ndef != null && ndef['cachedMessage'] != null) {
        var payload = ndef['cachedMessage']['records'][0]['payload'];
        String message = String.fromCharCodes(payload);
        RegExp regExp = RegExp(r"ID:(\d+)");
        Match? match = regExp.firstMatch(message);

        if (match != null) {
          return "${match.group(1)}"; // Retornar el ID extraído
        } else {
          return "No se pudo leer un ID válido."; // Mensaje si no se pudo leer un ID válido
        }
      } else {
        return "No se encontró mensaje NDEF."; // Mensaje si no se encontró mensaje NDEF
      }
    } catch (e) {
      return "Error al procesar los datos."; // Mensaje si hubo un error al procesar los datos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lector NFC')), // Título de la app bar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              nfcData, // Mostrar datos NFC
              style: const TextStyle(fontSize: 18),
            ),
            if (statusMessage != null)
              Text(
                statusMessage!, // Mostrar mensaje de estado
                style: TextStyle(fontSize: 18, color: statusMessage == 'Neumático Habilitado' ? Colors.green : Colors.red),
              ),
            const SizedBox(height: 20),
            StandarButton(
              onPressed: isLoading
                  ? null // Deshabilitar el botón mientras se está procesando
                  : isNfcReading
                      ? null
                      : () {
                          if (nfcData == 'No se pudo leer un ID válido.' ||
                              nfcData == 'No se encontró mensaje NDEF.' ||
                              nfcData == 'Error al procesar los datos.' ||
                              nfcData == 'Neumático no encontrado.' ||
                              nfcData == 'NFC no está habilitado en este dispositivo.' ||
                              nfcData == 'Neumático Deshabilitado: ') {
                            setState(() {
                              nfcData = 'Acerca tu dispositivo NFC para leerlo...'; // Reiniciar mensaje
                              statusMessage = null;
                            });
                            _startNFC(); // Reiniciar lectura NFC
                          } else {
                            if (widget.action == 'informacion') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InformacionNeumatico(nfcData: nfcData)), // Navegar a la página de información del neumático
                              );
                            } else if (widget.action == 'Añadir') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => IngresarPatentePage(tipo: 'Añadir', codigo: nfcData)), // Navegar a la página de añadir patente
                              );
                            } else if (widget.action == 'Modificar') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => IngresarPatentePage(tipo: 'Modificar', codigo: nfcData)), // Navegar a la página de modificar patente
                              );
                            } else if (widget.action == 'Deshabilitar') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InhabilitarNeumaticoPage(nfcData: nfcData)), // Navegar a la página de inhabilitar neumático
                              );
                            }
                          }
                        },
              text: nfcData != 'Acerca tu dispositivo NFC para leerlo...'
                  ? widget.action == 'Añadir'
                      ? 'Añadir Neumático'
                      : widget.action == 'Modificar'
                          ? 'Modificar Neumático'
                          : widget.action == 'Deshabilitar'
                              ? 'Deshabilitar Neumático'
                              : 'Visualizar Información'
                  : 'Leer Chip Neumatico', // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}
