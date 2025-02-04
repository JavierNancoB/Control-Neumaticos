import 'package:flutter/material.dart';
import '../../../services/movile_service.dart';
import '../../../widgets/movil/movil_info.dart';

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
      List<String> patentes = await MovilService.fetchPatentesSugeridas(query);
      setState(() {
        _sugerenciasPatentes = patentes;
      });
    } catch (e) {
      setState(() {
        _sugerenciasPatentes = [];
      });
      print('Error al obtener patentes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función que obtiene los datos del móvil por patente
  Future<void> _fetchMovilData(String patente) async {
    var movilResponse = await MovilService.getMovilDataByPatente(patente);
    if (movilResponse != null) {
      setState(() {
        _movilData = movilResponse;
      });
      _fetchNeumaticosData(_movilData!['iD_MOVIL']);
    } else {
      setState(() {
        _movilData = null;
        _neumaticosData = null;
      });
    }
  }

  // Función para obtener los neumáticos
  Future<void> _fetchNeumaticosData(int idMovil) async {
    var neumaticosResponse = await MovilService.getNeumaticosDataByMovilId(idMovil);
    if (neumaticosResponse != null) {
      setState(() {
        _neumaticosData = neumaticosResponse;
      });
    } else {
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
      body: SingleChildScrollView( // Permite el desplazamiento
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Autocomplete para las patentes
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  // Cuando el usuario está escribiendo
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  } else {
                    // Buscar patentes a medida que el usuario escribe
                    _buscarPatentes(textEditingValue.text);
                    return _sugerenciasPatentes;
                  }
                },
                onSelected: (String selection) {
                  // Al seleccionar una patente
                  _patenteController.text = selection;
                  _fetchMovilData(selection);
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Ingrese Patente del Movil',
                      suffixIcon: _isLoading
                          ? const CircularProgressIndicator()
                          : null, // Mostrar un cargando mientras buscamos
                    ),
                    onEditingComplete: onEditingComplete,
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _fetchMovilData(_patenteController.text);
                },
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 16),
              // Mostrar los datos del móvil o mensaje de error
              _movilData != null
                  ? MovilInfo(movilData: _movilData!, neumaticosData: _neumaticosData)
                  : const Text('No se encontraron datos del movil.'),
            ],
          ),
        ),
      ),
    );
  }
}
