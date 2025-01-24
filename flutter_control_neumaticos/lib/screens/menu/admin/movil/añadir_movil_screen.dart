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
  final TextEditingController _ejesController = TextEditingController();
  final TextEditingController _neumaticosController = TextEditingController();

  int _tipoSeleccionado = 1;
  int _estadoSeleccionado = 1;

  final List<int> _tipos = List<int>.generate(10, (i) => i + 1); // 1 al 10
  final List<int> _estados = [1, 2]; // 1 y 2

  // Método para guardar el móvil
  Future<void> _guardarMovil() async {
    final String patente = _patenteController.text;
    final String marca = _marcaController.text;
    final String modelo = _modeloController.text;
    final int? ejes = int.tryParse(_ejesController.text);
    final int? neumaticos = int.tryParse(_neumaticosController.text);
    final int tipoMovil = _tipoSeleccionado;
    final int estado = _estadoSeleccionado;

    if (patente.isEmpty || marca.isEmpty || modelo.isEmpty || ejes == null || neumaticos == null) {
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
      ejes: ejes,
      cantidadNeumaticos: neumaticos,
      tipoMovil: tipoMovil,
      estado: estado,
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
        title: Text('Añadir Móvil'),
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
              TextField(
                controller: _ejesController,
                decoration: const InputDecoration(labelText: 'Ejes'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _neumaticosController,
                decoration: const InputDecoration(labelText: 'Cantidad de Neumáticos'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _tipoSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo de Móvil'),
                items: _tipos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoSeleccionado = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _estadoSeleccionado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: _estados.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _estadoSeleccionado = value!;
                  });
                },
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
