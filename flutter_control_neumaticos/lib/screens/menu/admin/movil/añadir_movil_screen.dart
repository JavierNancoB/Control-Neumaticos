// Pantalla de Añadir Móvil
import 'package:flutter/material.dart';
import '../../../../models/movil.dart';
import '../../../../services/admin/movil/añadir_movil_service.dart';

class AnadirMovilPage extends StatefulWidget {
  const AnadirMovilPage({super.key});

  @override
  _AnadirMovilPageState createState() => _AnadirMovilPageState();
}

class _AnadirMovilPageState extends State<AnadirMovilPage> {
  final TextEditingController _patenteController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();

  String _tipoMovilSeleccionado = "4x2";
  int _ejes = 6;
  int _neumaticos = 2;

  final Map<String, Map<String, int>> _tipoMovilData = {
    "4x2": {"ejes": 6, "neumaticos": 2},
    "6x2": {"ejes": 10, "neumaticos": 3},
    "Rampla": {"ejes": 12, "neumaticos": 3},
  };

  // Método para guardar el móvil
  Future<void> _guardarMovil() async {
    final String patente = _patenteController.text;
    final String marca = _marcaController.text;
    final String modelo = _modeloController.text;

    if (patente.isEmpty || marca.isEmpty || modelo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Crear un nuevo móvil
    final movil = Movil(
      patente: patente,
      marca: marca,
      modelo: modelo,
      ejes: _ejes,
      cantidadNeumaticos: _neumaticos,
      tipoMovil: _tipoMovilSeleccionado == "4x2" ? 1 : _tipoMovilSeleccionado == "6x2" ? 2 : 3,
      estado: 1, // Siempre habilitado por defecto
      bodega: 1, // Cambiar según sea necesario
    );

    try {
      // Llamar al servicio para crear el móvil
      await MovilService.crearMovil(movil);

      // Si la creación fue exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Móvil creado con éxito')),
      );
      Navigator.pop(context); // Regresa a la página anterior
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Móvil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _patenteController,
                decoration: const InputDecoration(labelText: 'Patente'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _tipoMovilSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo de Móvil'),
                items: _tipoMovilData.keys.map((String tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoMovilSeleccionado = value!;
                    _ejes = _tipoMovilData[value]!["ejes"]!;
                    _neumaticos = _tipoMovilData[value]!["neumaticos"]!;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Ejes'),
                controller: TextEditingController(text: _ejes.toString()),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Cantidad de Neumáticos'),
                controller: TextEditingController(text: _neumaticos.toString()),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarMovil,
                child: const Text('Guardar Móvil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
