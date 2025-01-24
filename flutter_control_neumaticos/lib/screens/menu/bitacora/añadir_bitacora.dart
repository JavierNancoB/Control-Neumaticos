import 'package:flutter/material.dart';
import '../../../services/bitacora_service.dart';
import '../../../widgets/bitacora/codigo_dropdown.dart';
import '../../../widgets/bitacora/estado_dropdown.dart';
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
  TextEditingController _observacionController = TextEditingController();

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
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                EstadoDropdown(
                  selectedEstado: _estado,
                  onChanged: (value) {
                    setState(() {
                      _estado = value;
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
