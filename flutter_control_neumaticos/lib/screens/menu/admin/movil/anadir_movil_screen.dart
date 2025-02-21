// Pantalla de Añadir Móvil
import 'package:flutter/material.dart';
import '../../../../models/admin/movil.dart';
import '../../../../services/admin/movil/anadir_movil_service.dart';
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

class AnadirMovilPage extends StatefulWidget {
  const AnadirMovilPage({super.key});

  @override
  _AnadirMovilPageState createState() => _AnadirMovilPageState();
}

class _AnadirMovilPageState extends State<AnadirMovilPage> {
  // Controladores para los campos de texto
  final TextEditingController _patenteController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();

  // Variables para almacenar el tipo de móvil seleccionado, ejes y neumáticos
  String _tipoMovilSeleccionado = "4x2";
  int _ejes = 2;
  int _neumaticos = 6;

  // Datos de los tipos de móviles
  final Map<String, Map<String, int>> _tipoMovilData = {
    "4x2": {"ejes": 2, "neumaticos": 6},
    "6x2": {"ejes": 3, "neumaticos": 10},
    "Rampla": {"ejes": 3, "neumaticos": 12},
  };

  // Método para guardar el móvil
  Future<void> _guardarMovil() async {
    final String patente = _patenteController.text;
    final String marca = _marcaController.text;
    final String modelo = _modeloController.text;

    // Validar que los campos no estén vacíos
    if (patente.isEmpty || marca.isEmpty || modelo.isEmpty) {
      showCustomSnackBar(context, 'Por favor, completa todos los campos', isError: true);
      return;
    }

    // Validación de la patente (4 letras y 2 números o 2 letras y 4 números)
    final patenteRegex = RegExp(r'^[A-Za-z]{4}\d{2}$|^[A-Za-z]{2}\d{4}$');
    if (!patenteRegex.hasMatch(patente)) {
      showCustomSnackBar(context, 'Patente inválida. Debe ser en formato ABCD12 o AB1234', isError: true);
      return;
    }

    // Validar que no haya caracteres no alfanuméricos en la patente
    final alphanumericRegex = RegExp(r'^[A-Za-z0-9]+$');
    if (!alphanumericRegex.hasMatch(patente)) {
      showCustomSnackBar(context, 'La patente solo puede contener letras y números.', isError: true);
      return;
    }

    // Crear un nuevo móvil con los datos ingresados
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

      // Si la creación fue exitosa, mostrar un mensaje y regresar a la página anterior
      showCustomSnackBar(context, 'Móvil creado con éxito');
      Navigator.pop(context);
    } catch (e) {
      // Manejo de errores
      showCustomSnackBar(context, 'Error: ${e.toString()}', isError: true);
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
              // Campo de texto para la patente
              TextField(
                controller: _patenteController,
                decoration: const InputDecoration(labelText: 'Patente'),
              ),
              const SizedBox(height: 10),
              // Campo de texto para la marca
              TextField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              const SizedBox(height: 10),
              // Campo de texto para el modelo
              TextField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              const SizedBox(height: 10),
              // Dropdown para seleccionar el tipo de móvil
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
              // Campo de texto para los ejes (solo lectura)
              TextField(
                decoration: const InputDecoration(labelText: 'Ejes'),
                controller: TextEditingController(text: _ejes.toString()),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              // Campo de texto para la cantidad de neumáticos (solo lectura)
              TextField(
                decoration: const InputDecoration(labelText: 'Cantidad de Neumáticos'),
                controller: TextEditingController(text: _neumaticos.toString()),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              // Botón para guardar el móvil
              StandarButton(
                text: 'Guardar Móvil',
                onPressed: _guardarMovil,
              )
            ],
          ),
        ),
      ),
    );
  }
}
