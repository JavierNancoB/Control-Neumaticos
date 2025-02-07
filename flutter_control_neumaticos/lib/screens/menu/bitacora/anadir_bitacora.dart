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
    print("Obteniendo userId...");
    _userId = await BitacoraService.getUserId();
    print("userId obtenido: $_userId");
    setState(() {});
  }

  // Función para enviar el formulario
  Future<void> _submitForm() async {
  print('Iniciando _submitForm');
  print('Código seleccionado: $_codigo');

  if (_formKey.currentState!.validate()) {
    // Verificar si el código es 11 (pinchazo)
    if (_codigo == 11) {
      print('Código 11 detectado, verificando pinchazos...');
      bool existenPinchazos = await BitacoraService.existenDosPinchazos(widget.idNeumatico);
      print('Respuesta de la API existenDosPinchazos: $existenPinchazos');

      if (existenPinchazos) { // AHORA EL DIÁLOGO SE MUESTRA CUANDO ES TRUE
        print('Existen dos pinchazos, mostrando diálogo de advertencia.');
        _mostrarDialogoPinchazos();
        return; // DETIENE EL ENVÍO HASTA QUE EL USUARIO CONFIRME
      } else {
        print('No existen dos pinchazos, continuando con el proceso.');
      }
    }

    // Si no hay problemas con los pinchazos, enviar la bitácora
    print('Enviando bitácora...');
    final response = await BitacoraService.addBitacora(
      widget.idNeumatico,
      _userId,
      _codigo,
      _estado,
      _observacionController.text,
    );

    if (response) {
      print('Bitácora añadida correctamente.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitácora añadida con éxito')),
      );
      Navigator.pop(context);
    } else {
      print('Error al añadir bitácora.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al añadir bitácora')),
      );
    }
  } else {
    print('Formulario no válido.');
  }
}


  // Función para mostrar el diálogo de recomendación
  void _mostrarDialogoPinchazos() {
    print("Mostrando diálogo de recomendación");
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
                print("Usuario canceló el diálogo");
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                print("Usuario aceptó la recomendación");
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
                    print("Código cambiado a: $value");
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
