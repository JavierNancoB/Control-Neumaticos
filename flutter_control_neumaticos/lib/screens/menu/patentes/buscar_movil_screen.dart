import 'package:flutter/material.dart';
import '../../../services/buscar_movil_service.dart';
import '../../../widgets/movil/movil_info.dart';
import '../../../widgets/button.dart';

class PatentePage extends StatefulWidget {
  const PatentePage({super.key});

  @override
  _PatentePageState createState() => _PatentePageState();
}

class _PatentePageState extends State<PatentePage> {
  final TextEditingController _patenteController = TextEditingController();
  Map<String, dynamic>? _movilData;
  List<dynamic>? _neumaticosData;
  bool _isLoading = false;

  // Lista de patentes sugeridas
  List<String> _sugerenciasPatentes = [];

  // Función que obtiene las patentes sugeridas
  Future<void> _buscarPatentes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _sugerenciasPatentes = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var movilService = MovilService();
      List<String> patentes = await movilService.fetchPatentesSugeridas(query);
      setState(() {
        _sugerenciasPatentes = patentes;
      });
    } catch (e) {
      setState(() {
        _sugerenciasPatentes = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función que obtiene los datos del móvil por patente
  Future<void> _fetchMovilData(String patente) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var movilService = MovilService();
      var movilResponse = await movilService.getMovilDataByPatente(patente);
      if (movilResponse != null) {
        setState(() {
          _movilData = movilResponse;
        });
        await _fetchNeumaticosData(_movilData!['iD_MOVIL']);
      } else {
        setState(() {
          _movilData = null;
          _neumaticosData = null;
        });
      }
    } catch (e) {
      setState(() {
        _movilData = null;
        _neumaticosData = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para obtener los neumáticos
  Future<void> _fetchNeumaticosData(int idMovil) async {
    try {
      var movilService = MovilService();
      var neumaticosResponse = await movilService.getNeumaticosDataByMovilId(idMovil);
      setState(() {
        _neumaticosData = neumaticosResponse;
      });
    } catch (e) {
      setState(() {
        _neumaticosData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: const Text('Buscar Movil por Patente'),
    ),
    body: ListView( // Usamos ListView para el desplazamiento
      padding: const EdgeInsets.all(16.0),
      children: [
        // Autocomplete para las patentes
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            } else {
              _buscarPatentes(textEditingValue.text);
              return _sugerenciasPatentes;
            }
          },
          onSelected: (String selection) {
            _patenteController.text = selection;
            _fetchMovilData(selection);
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Seleccione Patente del Movil',
                suffixIcon: _isLoading
                    ? const CircularProgressIndicator() // Indicador de carga
                    : const SizedBox(width: 24), // Espacio vacío para que no cambie el tamaño
              ),
              onEditingComplete: onEditingComplete,
            );
          },
        ),
        const SizedBox(height: 16),

        // Centramos el botón
        Center(
          child: StandarButton(
            onPressed: () {
              _fetchMovilData(_patenteController.text);
            },
            text: 'Buscar',
          ),
        ),
        const SizedBox(height: 16),

        // Alineación del contenido principal (los datos o el mensaje de error)
        Align(
          alignment: Alignment.centerLeft, // Alineamos el contenido a la izquierda
          child: _movilData != null
              ? MovilInfo(movilData: _movilData!, neumaticosData: _neumaticosData)
              : const Text(''),
        ),
      ],
    ),
  );
  }
}
