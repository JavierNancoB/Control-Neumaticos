import 'package:flutter/material.dart';
import '../../../services/movil/buscar_movil_service.dart';
import '../../../widgets/movil/movil_info.dart';
import '../../../widgets/button.dart';

class PatentePage extends StatefulWidget {
  const PatentePage({super.key});

  @override
  _PatentePageState createState() => _PatentePageState();
}

class _PatentePageState extends State<PatentePage> {
  // Controlador para el campo de texto de la patente
  final TextEditingController _patenteController = TextEditingController();
  // Datos del móvil obtenidos por la patente
  Map<String, dynamic>? _movilData;
  // Datos de los neumáticos del móvil
  List<dynamic>? _neumaticosData;
  // Indicador de carga
  bool _isLoading = false;

  // Lista de patentes sugeridas
  List<String> _sugerenciasPatentes = [];

  // Función que obtiene las patentes sugeridas
  Future<void> _buscarPatentes(String query) async {
    // Si la consulta está vacía, limpiamos las sugerencias
    if (query.isEmpty) {
      setState(() {
        _sugerenciasPatentes = [];
      });
      return;
    }

    // Indicamos que estamos cargando
    setState(() {
      _isLoading = true;
    });

    try {
      // Llamamos al servicio para obtener las patentes sugeridas
      var movilService = MovilService();
      List<String> patentes = await movilService.fetchPatentesSugeridas(query);
      // Actualizamos las sugerencias con los resultados obtenidos
      setState(() {
        _sugerenciasPatentes = patentes;
      });
    } catch (e) {
      // En caso de error, limpiamos las sugerencias
      setState(() {
        _sugerenciasPatentes = [];
      });
    } finally {
      // Indicamos que hemos terminado de cargar
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función que obtiene los datos del móvil por patente
  Future<void> _fetchMovilData(String patente) async {
    // Indicamos que estamos cargando
    setState(() {
      _isLoading = true;
    });

    try {
      // Llamamos al servicio para obtener los datos del móvil
      var movilService = MovilService();
      var movilResponse = await movilService.getMovilDataByPatente(patente);
      if (movilResponse != null) {
        // Si obtenemos datos, los guardamos y buscamos los neumáticos
        setState(() {
          _movilData = movilResponse;
        });
        await _fetchNeumaticosData(_movilData!['iD_MOVIL']);
      } else {
        // Si no obtenemos datos, limpiamos las variables
        setState(() {
          _movilData = null;
          _neumaticosData = null;
        });
      }
    } catch (e) {
      // En caso de error, limpiamos las variables
      setState(() {
        _movilData = null;
        _neumaticosData = null;
      });
    } finally {
      // Indicamos que hemos terminado de cargar
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para obtener los neumáticos del móvil
  Future<void> _fetchNeumaticosData(int idMovil) async {
    try {
      // Llamamos al servicio para obtener los datos de los neumáticos
      var movilService = MovilService();
      var neumaticosResponse = await movilService.getNeumaticosDataByMovilId(idMovil);
      // Guardamos los datos obtenidos
      setState(() {
        _neumaticosData = neumaticosResponse;
      });
    } catch (e) {
      // En caso de error, limpiamos la variable
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
              // Si el campo de texto está vacío, no mostramos sugerencias
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              } else {
                // Buscamos las patentes sugeridas
                _buscarPatentes(textEditingValue.text);
                return _sugerenciasPatentes;
              }
            },
            onSelected: (String selection) {
              // Cuando se selecciona una patente, la buscamos
              _patenteController.text = selection;
              _fetchMovilData(selection);
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                textAlign: TextAlign.center, // Centra el texto que escribes
                decoration: InputDecoration(
                  labelText: 'Seleccione Patente del Movil',
                  labelStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  alignLabelWithHint: true, // Alinea el label con el hint
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  filled: true,
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color.fromRGBO(88, 83, 162, 1), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Ajuste vertical para centrar el label
                  suffixIcon: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const SizedBox(width: 24),
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
                // Buscamos los datos del móvil al presionar el botón
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
