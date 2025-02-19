import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/button.dart';
import '../../../widgets/diccionario.dart';
import '../../../services/movil/comprobar_neumatico_service.dart';

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
  bool escaneando = false;
  Set<String> codigosEscaneados = <String>{};
  Set<String> codigosNoEncontrados = <String>{};

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
  setState(() {
    escaneando = true;
  });

  try {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      String? codigo = await _extractNfcData(tag);
      if (codigo != null) {
        print('NFC data extracted: $codigo'); // Verificar el código extraído
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

  setState(() {
    escaneando = true;
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
  print('Verificando código: $codigo'); // Para ver qué código estamos verificando

  bool existe = widget.neumaticosData?.any((neumatico) {
    return neumatico['codigo'].toString() == codigo;
  }) ?? false;

  if (existe) {
    print('Código $codigo encontrado en los datos de neumáticos'); // Si el código está en los datos
  } else {
    print('Código $codigo no encontrado en los datos de neumáticos'); // Si el código no está en los datos
  }

  setState(() {
    if (existe) {
      mensajeEstado = 'Código válido: $codigo';
      codigosEscaneados.add(codigo);
      print('Añadido a códigos escaneados: $codigo'); // Verificar que se añadió a la lista
    } else {
      mensajeEstado = 'Código $codigo no encontrado';
      codigosEscaneados.add(codigo);
      print('Añadido a códigos no encontrados: $codigo'); // Verificar que se añadió a la lista de no encontrados
    }
  });
}

Future<void> _finalizarComprobacion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? idUsuario = prefs.getInt('userId');

  if (idUsuario == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: No se encontró el ID de usuario')),
    );
    return;
  }

  // Generar lista de códigos no escaneados
  List<String> codigosNoEscaneados = widget.neumaticosData!
      .where((neumatico) => !codigosEscaneados.contains(neumatico['codigo'].toString()))
      .map((neumatico) => neumatico['codigo'].toString())
      .toList();

  print('Codigos no escaneados: ${codigosNoEscaneados.join(', ')}'); // Verificar la lista de códigos no escaneados

  // Mostrar los neumáticos que no se han escaneado
  widget.neumaticosData!.forEach((neumatico) {
    String codigo = neumatico['codigo'].toString();
    if (!codigosEscaneados.contains(codigo)) {
      print('Neumático no escaneado: $codigo');
    }
  });

  // Generar lista de códigos escaneados pero no encontrados en los datos
  List<String> codigosEscaneadosNoEncontrados = codigosEscaneados.where((codigo) {
    bool encontrado = widget.neumaticosData!.any((neumatico) => neumatico['codigo'].toString() == codigo);
    print('Código escaneado: $codigo, ¿encontrado?: $encontrado'); // Verificar el proceso de búsqueda
    return !encontrado;
  }).toList();

  print('Codigos escaneados no encontrados: ${codigosEscaneadosNoEncontrados.join(', ')}'); // Verificar la lista de códigos escaneados no encontrados

  // Generar el mensaje de observaciones
  String observaciones = '';
  if (codigosNoEscaneados.isNotEmpty) {
    observaciones += 'Neumáticos no escaneados: ${codigosNoEscaneados.join(', ')}\n';
  }
  if (codigosEscaneadosNoEncontrados.isNotEmpty) {
    observaciones += 'Neumáticos escaneados no encontrados: ${codigosEscaneadosNoEncontrados.join(', ')}\n';
  }

  // Si no hay observaciones, mostrar el mensaje de comprobación exitosa
  if (observaciones.isEmpty) {
    observaciones = 'Comprobación exitosa, ¿deseas finalizar?';
  }

  print('Observaciones: $observaciones'); // Verificar las observaciones generadas

  // Aquí se muestra la ventana emergente
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(observaciones == 'Comprobación exitosa, ¿deseas finalizar?' ? 'Comprobación exitosa' : 'Observación'),
        content: Text(observaciones),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Cancela la operación
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();  // Cierra el cuadro de diálogo

              // Guardar el registro
              HistorialMovilService historialService = HistorialMovilService();
              await historialService.registrarHistorial(
                patente: widget.patente,
                codigosNoEscaneados: codigosNoEscaneados,
                codigosNoEncontrados: codigosEscaneadosNoEncontrados,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Comprobación registrada correctamente')),
              );

              Navigator.of(context).pop();  // Vuelve atrás en la navegación
            },
            child: Text('Finalizar'),
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
                String codigo = neumatico['codigo']?.toString() ?? '';
                int ubicacionCodigo = neumatico['ubicacion'] ?? 1;
                String ubicacionDescripcion = Diccionario.obtenerDescripcion(Diccionario.ubicacionNeumaticos, ubicacionCodigo);

                bool esEscaneado = codigosEscaneados.contains(codigo);

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: esEscaneado ? Colors.green : null,
                  child: ListTile(
                    leading: Icon(esEscaneado ? Icons.check_circle_outline : Icons.info_outline),
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
              onPressed: _finalizarComprobacion,
            ),
          ),
        ],
      ),
    );
  }
}
