import 'package:flutter/material.dart';
import '../../../services/bitacora/bitacora_service.dart';
import '../../../widgets/bitacora/codigo_dropdown.dart';
import '../../../widgets/bitacora/observacion_field.dart';
import '../../../widgets/bitacora/submit_button.dart';

class AnadirBitacoraScreen extends StatefulWidget {
  final int idNeumatico;

  const AnadirBitacoraScreen({super.key, required this.idNeumatico});

  @override
  _AnadirBitacoraScreenState createState() => _AnadirBitacoraScreenState();
}

class _AnadirBitacoraScreenState extends State<AnadirBitacoraScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _userId;
  int? _codigo;
  int? _estado;
  final TextEditingController _observacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Obtener el userId desde SharedPreferences
  Future<void> _getUserId() async {
    _userId = await BitacoraService.getUserId();
    setState(() {});
  }

  // Función para enviar el formulario
  Future<void> _submitForm() async {

  if (_formKey.currentState!.validate()) {
    // Verificar si el código es 11 (pinchazo)
    if (_codigo == 11) {
      bool existenPinchazos = await BitacoraService.existenDosPinchazos(widget.idNeumatico);

      if (existenPinchazos) { // AHORA EL DIÁLOGO SE MUESTRA CUANDO ES TRUE
        _mostrarDialogoPinchazos();
        return; // DETIENE EL ENVÍO HASTA QUE EL USUARIO CONFIRME
      } else {
      }
    }

    // Si no hay problemas con los pinchazos, enviar la bitácora
    final response = await BitacoraService.addBitacora(
      widget.idNeumatico,
      _userId,
      _codigo,
      _estado,
      _observacionController.text,
    );

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitácora añadida con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al añadir bitácora')),
      );
    }
  } else {
  }
}


  // Función para mostrar el diálogo de recomendación
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
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitForm(); // Si el usuario acepta, se envía la bitácora
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
        title: const Text('Añadir Bitácora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ObservacionField(controller: _observacionController),
                CodigoDropdown(
                  selectedCodigo: _codigo,
                  onChanged: (value) {
                    setState(() {
                      _codigo = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SubmitButton(onPressed: _submitForm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
