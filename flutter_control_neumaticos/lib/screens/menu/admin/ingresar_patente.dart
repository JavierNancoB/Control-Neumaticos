import 'package:flutter/material.dart';
import '../../../services/ingresar_patente_service.dart';

class IngresarPatentePage extends StatefulWidget {
  final String tipo;  // Primer parámetro
  final String codigo;  // Segundo parámetro
  
  IngresarPatentePage({required this.tipo, required this.codigo});

  @override
  _IngresarPatentePageState createState() => _IngresarPatentePageState();
}

class _IngresarPatentePageState extends State<IngresarPatentePage> {
  final TextEditingController _patenteController = TextEditingController();

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
            _buildPatenteField(),
            SizedBox(height: 20),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPatenteField() {
    return TextField(
      controller: _patenteController,
      decoration: InputDecoration(
        labelText: 'Ingresa la patente del móvil',
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final patente = _patenteController.text.trim();
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
