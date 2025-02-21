import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/ingresar_patente_service.dart';
import '../../../widgets/button.dart';

class IngresarPatentePage extends StatefulWidget {
  final String tipo;
  final String codigo;

  const IngresarPatentePage({super.key, required this.tipo, required this.codigo});

  @override
  _IngresarPatentePageState createState() => _IngresarPatentePageState();
}

class _IngresarPatentePageState extends State<IngresarPatentePage> {
  // Controlador para el campo de texto de la patente
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
        title: Text('Buscar Patente'), // Título de la AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding alrededor del cuerpo
        child: Column(
          children: [
            _buildAutocompleteField(), // Campo de autocompletado para la patente
            SizedBox(height: 20), // Espacio entre el campo y el botón
            _buildSubmitButton(context), // Botón para enviar la patente
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
            // Si el campo de texto está vacío, no mostrar sugerencias
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            try {
              // Obtener las patentes sugeridas desde el servicio
              return await IngresarPatenteService.fetchPatentesSugeridas(textEditingValue.text);
            } catch (e) {
              return const Iterable<String>.empty();
            }
          },
          onSelected: (String selection) {
            // Actualizar el controlador con la selección
            _patenteController.text = selection;
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller, // Controlador del campo de texto
              focusNode: focusNode, // Nodo de enfoque
              decoration: const InputDecoration(
                labelText: 'Seleccione la patente del móvil', // Etiqueta del campo de texto
              ),
              onEditingComplete: onEditingComplete, // Acción al completar la edición
              onChanged: (value) {
                // Si el campo de texto está vacío, limpiar el controlador
                if (value.isEmpty) {
                  _patenteController.clear();
                }
              },
            );
          },
        ),
        // Mostrar un mensaje adicional si el tipo no es 'movil'
        if (widget.tipo != 'movil') 
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Si no SELECCIONA ninguna patente, el neumático no se asignará a ningun movil.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  /// **Botón para Enviar la Patente**
  Widget _buildSubmitButton(BuildContext context) {
    // Reemplazar ElevatedButton por StandarButton
    return StandarButton(
      onPressed: () async {
        final patente = _patenteController.text.trim(); // Obtener y limpiar la patente

        // Si la patente está vacía, no mostrar mensaje de error y continuar
        if (patente.isEmpty) {
          // Proceder igual, sin mostrar el mensaje de error.
          IngresarPatenteService.handlePatente(
            context: context,
            patente: patente,
            tipo: widget.tipo,
            codigo: widget.codigo,
          );
          return; // No se muestra el SnackBar porque es un flujo válido.
        }

        // Verificar si la patente existe
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token'); // Obtener el token de autenticación
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se encontró el token de autenticación.')),
          );
          return;
        }

        // Llamada al servicio para verificar la existencia de la patente
        bool patenteExiste = await IngresarPatenteService.checkPatenteExistence(patente, token);
        if (!patenteExiste) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('La patente ingresada no existe.')),
          );
          return;
        }

        // Si la patente existe, proceder con la lógica original
        IngresarPatenteService.handlePatente(
          context: context,
          patente: patente,
          tipo: widget.tipo,
          codigo: widget.codigo,
        );
      },
      text: 'Ir a Modificar ${widget.tipo == 'movil' ? 'Móvil' : 'Neumático'}', // Texto del botón
    );
  }
}