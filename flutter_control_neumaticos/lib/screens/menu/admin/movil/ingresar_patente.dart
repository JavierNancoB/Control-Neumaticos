import 'package:flutter/material.dart';
import 'modificar_movil.dart';
//import 'modificar_movil_page.dart'; // Asegúrate de importar la página de modificación.

class IngresarPatentePage extends StatefulWidget {
  @override
  _IngresarPatentePageState createState() => _IngresarPatentePageState();
}

class _IngresarPatentePageState extends State<IngresarPatentePage> {
  final TextEditingController _patenteController = TextEditingController();

  // Verifica si la patente tiene el formato correcto
  bool isValidPatente(String patente) {
    // Puedes agregar una validación más compleja si lo deseas
    return patente.isNotEmpty;
  }

  void _submitPatente() {
    String patente = _patenteController.text.trim();

    if (isValidPatente(patente)) {
      // Si la patente es válida, navega a la página para modificar el móvil
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModificarMovilPage(patente: patente),
        ),
      );
    } else {
      // Si no es válida, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patente inválida')),
      );
    }
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
            TextField(
              controller: _patenteController,
              decoration: InputDecoration(
                labelText: 'Ingresa la patente del móvil',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPatente,
              child: Text('Ir a Modificar Móvil'),
            ),
          ],
        ),
      ),
    );
  }
}
