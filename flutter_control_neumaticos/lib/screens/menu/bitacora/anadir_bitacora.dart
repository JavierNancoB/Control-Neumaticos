import 'package:flutter/material.dart';
import '../../../services/bitacora/bitacora_service.dart';
import '../../../widgets/bitacora/codigo_dropdown.dart';
import '../../../widgets/bitacora/observacion_field.dart';
import '../../../widgets/bitacora/submit_button.dart';
import '../../../utils/snackbar_util.dart'; // Importamos la función de snackbars

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
  bool _confirmadoPinchazo = false;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    _userId = await BitacoraService.getUserId();
    setState(() {});
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_codigo == 11 && !_confirmadoPinchazo) {
        bool existenPinchazos = await BitacoraService.existenDosPinchazos(widget.idNeumatico);
        if (existenPinchazos) {
          _mostrarDialogoPinchazos();
          return;
        }
      }

      final response = await BitacoraService.addBitacora(
        widget.idNeumatico,
        _userId,
        _codigo,
        _estado,
        _observacionController.text,
      );

      if (response) {
        showCustomSnackBar(context, 'Bitácora añadida con éxito');
        Navigator.pop(context);
      } else {
        showCustomSnackBar(context, 'Error al añadir bitácora', isError: true);
      }
    }
  }

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
                setState(() {
                  _confirmadoPinchazo = true;
                });
                Navigator.of(context).pop();
                _submitForm();
                Navigator.of(context).pop();
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