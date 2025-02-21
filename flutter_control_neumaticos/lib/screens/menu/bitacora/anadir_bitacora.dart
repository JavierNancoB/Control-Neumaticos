import 'package:flutter/material.dart';
import '../../../services/bitacora/bitacora_service.dart';
import '../../../widgets/bitacora/codigo_dropdown.dart';
import '../../../widgets/bitacora/observacion_field.dart';
import '../../../widgets/bitacora/submit_button.dart';
import '../../../utils/snackbar_util.dart'; // Importamos la función de snackbars

// Clase principal del widget de añadir bitácora
class AnadirBitacoraScreen extends StatefulWidget {
  final int idNeumatico;

  const AnadirBitacoraScreen({super.key, required this.idNeumatico});

  @override
  _AnadirBitacoraScreenState createState() => _AnadirBitacoraScreenState();
}

// Estado del widget AnadirBitacoraScreen
class _AnadirBitacoraScreenState extends State<AnadirBitacoraScreen> {
  final _formKey = GlobalKey<FormState>(); // Llave para el formulario
  late int _userId; // ID del usuario
  int? _codigo; // Código seleccionado
  int? _estado; // Estado del neumático
  final TextEditingController _observacionController = TextEditingController(); // Controlador para el campo de observación
  bool _confirmadoPinchazo = false; // Variable para confirmar pinchazo

  @override
  void initState() {
    super.initState();
    _getUserId(); // Obtener el ID del usuario al iniciar el estado
  }

  // Función para obtener el ID del usuario
  Future<void> _getUserId() async {
    _userId = await BitacoraService.getUserId();
    setState(() {}); // Actualizar el estado después de obtener el ID
  }

  // Función para enviar el formulario
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) { // Validar el formulario
      if (_codigo == 11 && !_confirmadoPinchazo) { // Verificar si el código es 11 y no se ha confirmado el pinchazo
        bool existenPinchazos = await BitacoraService.existenDosPinchazos(widget.idNeumatico);
        if (existenPinchazos) { // Mostrar diálogo si existen pinchazos previos
          _mostrarDialogoPinchazos();
          return;
        }
      }

      // Llamar al servicio para añadir la bitácora
      final response = await BitacoraService.addBitacora(
        widget.idNeumatico,
        _userId,
        _codigo,
        _estado,
        _observacionController.text,
      );

      // Mostrar snackbar según la respuesta del servicio
      if (response) {
        showCustomSnackBar(context, 'Bitácora añadida con éxito');
        Navigator.pop(context); // Cerrar la pantalla actual
      } else {
        showCustomSnackBar(context, 'Error al añadir bitácora', isError: true);
      }
    }
  }

  // Función para mostrar el diálogo de confirmación de pinchazos
  void _mostrarDialogoPinchazos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recomendación'),
          content: const Text(
            'Por recomendación, es mejor dar de baja el neumático debido a la cantidad de pinchazos previos. ¿Desea continuar?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _confirmadoPinchazo = true; // Confirmar pinchazo
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
                _submitForm(); // Enviar el formulario
                Navigator.of(context).pop(); // Cerrar la pantalla actual
              },
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Bitácora'), // Título de la pantalla
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asignar la llave del formulario
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ObservacionField(controller: _observacionController), // Campo de observación
                CodigoDropdown(
                  selectedCodigo: _codigo, // Código seleccionado
                  onChanged: (value) {
                    setState(() {
                      _codigo = value; // Actualizar el código seleccionado
                    });
                  },
                ),
                const SizedBox(height: 20), // Espacio entre widgets
                SubmitButton(onPressed: _submitForm), // Botón para enviar el formulario
              ],
            ),
          ),
        ),
      ),
    );
  }
}