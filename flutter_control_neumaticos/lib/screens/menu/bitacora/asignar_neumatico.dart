import 'package:flutter/material.dart';
import '../../../../models/neumatico_modifcar.dart';
import '../../../../services/admin/neumaticos/modificar_neumatico.dart';
import '../../../../widgets/admin/neumatico/ubicacion_dropdown.dart';
import '../../../../widgets/diccionario.dart';
import '../../../../widgets/button.dart';

class AsignarNeumaticoPage extends StatefulWidget {
  final String patente;
  final String nfcData;

  const AsignarNeumaticoPage({required this.patente, required this.nfcData, super.key});

  @override
  _AsignarNeumaticoPageState createState() => _AsignarNeumaticoPageState();
}

class _AsignarNeumaticoPageState extends State<AsignarNeumaticoPage> {
  Neumatico? _neumatico;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _patenteController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _tipoNeumaticoController = TextEditingController();
  bool _alertaTipoMostrada = false;

  @override
  void initState() {
    super.initState();
    _patenteController.text = widget.patente.isEmpty ? 'Sin Patente' : widget.patente.toUpperCase();
    
    _neumatico = Neumatico(
      codigo: widget.nfcData,
      ubicacion: 0, // Ubicación no seleccionada por defecto
      idBodega: 1,
      idMovil: null,
      fechaIngreso: DateTime.now(),
      fechaSalida: null,
      kmTotal: 0,
      tipoNeumatico: 0, // Tipo no seleccionado por defecto
      estado: 1,
    );
    
    _tipoNeumaticoController.text = Diccionario.obtenerDescripcion(Diccionario.tipoNeumatico, _neumatico!.tipoNeumatico);
    _loadNeumaticoData();
  }

  void _loadNeumaticoData() async {
    Neumatico? neumatico = await NeumaticoService.fetchNeumaticoByCodigo(widget.nfcData);
    setState(() {
      _neumatico = neumatico;
      _kmController.text = _neumatico!.kmTotal.toString();
      _updateTipoNeumatico();
    });
}

  void _updateTipoNeumatico() {
    if (_neumatico != null) {
      int tipoAnterior = _neumatico!.tipoNeumatico; // Guardamos el tipo anterior
      switch (_neumatico!.ubicacion) {
        case 1:
          _neumatico!.tipoNeumatico = 4;
          break;
        case 2:
        case 3:
          _neumatico!.tipoNeumatico = 2;
          break;
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
          _neumatico!.tipoNeumatico = 1;
          break;
        case 16:
          _neumatico!.tipoNeumatico = 3;
          break;
        default:
          _neumatico!.tipoNeumatico = 1;
          break;
      }
      setState(() {
        _tipoNeumaticoController.text = Diccionario.obtenerDescripcion(Diccionario.tipoNeumatico, _neumatico!.tipoNeumatico);
      });
      // Verificamos si el tipo anterior era 1 (traccional) y el nuevo es 2 (direccional)
      if (tipoAnterior == 1 && _neumatico!.tipoNeumatico == 2 && !_alertaTipoMostrada) {
        // Mostrar alerta solo si no se ha mostrado antes
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Por seguridad no se recomienda traspasar un neumático traccional a direccional.',
              style: TextStyle(color: Colors.black), // Texto blanco
            ),
            backgroundColor: Colors.yellow, // Fondo rojo
          ),
        );
        _alertaTipoMostrada = true; // Marcar que ya se mostró la alerta
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_neumatico!.ubicacion == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe seleccionar una ubicación válida.')),
        );
        return;
      }

      try {
        await NeumaticoService().modificarNeumatico(_neumatico!, widget.patente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Neumático modificado con éxito')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar los datos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Neumático'),
      ),
      body: _neumatico == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Código Neumático
                    TextFormField(
                      initialValue: _neumatico!.codigo.toString(),
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Código Neumático'),
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Patente
                    TextFormField(
                      controller: _patenteController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Patente'),
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Ubicación del Neumático
                    UbicacionDropdown(
                      ubicacion: _neumatico!.ubicacion,
                      onChanged: (newUbicacion) {
                        setState(() {
                          _neumatico!.ubicacion = newUbicacion;
                          _updateTipoNeumatico();
                        });
                      },
                      patente: widget.patente,
                    ),
                    const SizedBox(height: 16),
                    // Tipo de Neumático
                    TextFormField(
                      controller: _tipoNeumaticoController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Tipo de Neumático'),
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Botón de Guardar Cambios
                    Align(
                      alignment: Alignment.center,
                      // Cambiamos elevatedButton por nuestro widget StandarButton
                      child: StandarButton(
                        onPressed: (_neumatico!.ubicacion != 0 && _neumatico!.tipoNeumatico != 0) 
                            ? _submitForm 
                            : null,
                        text: 'Guardar Cambios',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
