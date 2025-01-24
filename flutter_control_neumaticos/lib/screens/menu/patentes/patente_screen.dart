import 'package:flutter/material.dart';
import '../../../services/movile_service.dart';
import '../../../widgets/movil/movil_info.dart';


class PatentePage extends StatefulWidget {
  @override
  _PatentePageState createState() => _PatentePageState();
}

class _PatentePageState extends State<PatentePage> {
  final TextEditingController _patenteController = TextEditingController();
  Map<String, dynamic>? _movilData;
  List<dynamic>? _neumaticosData;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _patenteController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese Patente',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _fetchMovilData(_patenteController.text);
                },
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 16),
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
