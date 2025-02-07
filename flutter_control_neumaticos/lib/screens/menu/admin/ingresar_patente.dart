import 'package:flutter/material.dart';
import '../../../services/ingresar_patente_service.dart';

class IngresarPatentePage extends StatefulWidget {
  final String tipo;
  final String codigo;

  const IngresarPatentePage({super.key, required this.tipo, required this.codigo});

  @override
  _IngresarPatentePageState createState() => _IngresarPatentePageState();
}

class _IngresarPatentePageState extends State<IngresarPatentePage> {
  final TextEditingController _patenteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Limpiar el controlador cuando se navega a esta pantalla
    _patenteController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar Patente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAutocompleteField(),
            SizedBox(height: 20),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  /// **Autocomplete para la Patente**
  Widget _buildAutocompleteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            try {
              return await IngresarPatenteService.fetchPatentesSugeridas(textEditingValue.text);
            } catch (e) {
              return const Iterable<String>.empty();
            }
          },
          onSelected: (String selection) {
            _patenteController.text = selection;
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Ingresa la patente del móvil',
              ),
              onEditingComplete: onEditingComplete,
              onChanged: (value) {
                // Si el campo de texto está vacío, limpiar el controlador
                if (value.isEmpty) {
                  _patenteController.clear();
                }
              },
            );
          },
        ),
        if (widget.tipo != 'movil') 
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Si no ingresa ninguna patente, el neumático no se asignará a ningun movil.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  /// **Botón para Enviar la Patente**
  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final patente = _patenteController.text.trim();
        if (patente.isEmpty) {
          _patenteController.clear(); // Limpiar el controlador si está vacío
        }
        IngresarPatenteService.handlePatente(
          context: context,
          patente: patente,
          tipo: widget.tipo,
          codigo: widget.codigo,
        );
      },
      child: Text('Ir a Modificar ${widget.tipo == 'movil' ? 'Móvil' : 'Neumático'}'),
    );
  }
}
