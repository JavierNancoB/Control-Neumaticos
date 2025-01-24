import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'bitacora/informacion_neumatico.dart';

class PatentePage extends StatefulWidget {
  @override
  _PatentePageState createState() => _PatentePageState();
}

class _PatentePageState extends State<PatentePage> {
  final TextEditingController _patenteController = TextEditingController();
  Map<String, dynamic>? _movilData;
  List<dynamic>? _neumaticosData;

  Future<void> _fetchMovilData(String patente) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:5062/api/Movil/GetMovilByPatente?patente=$patente'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _movilData = json.decode(response.body);
      });
      _fetchNeumaticosData(_movilData!['iD_MOVIL']);
    } else {
      // Handle error
      setState(() {
        _movilData = null;
        _neumaticosData = null;
      });
    }
  }

  Future<void> _fetchNeumaticosData(int idMovil) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:5062/api/Neumaticos/GetNeumaticoByMovilID?idMovil=$idMovil'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _neumaticosData = json.decode(response.body);
      });
    } else {
      // Handle error
      setState(() {
        _neumaticosData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Movil por Patente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _patenteController,
                decoration: InputDecoration(
                  labelText: 'Ingrese Patente',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _fetchMovilData(_patenteController.text);
                },
                child: Text('Buscar'),
              ),
              SizedBox(height: 16),
              _movilData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID Movil: ${_movilData!['iD_MOVIL']}'),
                        Text('Patente: ${_movilData!['patente']}'),
                        Text('Marca: ${_movilData!['marca']}'),
                        Text('Modelo: ${_movilData!['modelo']}'),
                        Text('Ejes: ${_movilData!['ejes']}'),
                        Text('Cantidad de Neumaticos: ${_movilData!['cantidaD_NEUMATICOS']}'),
                        SizedBox(height: 16),
                        Text('Neumaticos:'),
                        _neumaticosData != null
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _neumaticosData!.length,
                                itemBuilder: (context, index) {
                                  final neumatico = _neumaticosData![index];
                                  return ListTile(
                                    title: Text('ID Neumatico: ${neumatico['iD_NEUMATICO']}'),
                                    subtitle: Text('Codigo: ${neumatico['codigo']}'),
                                    onTap: () {
                                      // Redirigir a la página de Información del Neumático
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InformacionNeumatico(
                                            nfcData: neumatico['codigo'].toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : Text('No se encontraron neumaticos.'),
                      ],
                    )
                  : Text('No se encontraron datos del movil.'),
            ],
          ),
        ),
      ),
    );
  }
}