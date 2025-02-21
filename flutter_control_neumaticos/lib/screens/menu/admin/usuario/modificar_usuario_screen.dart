import 'package:flutter/material.dart';
import 'package:pentacrom_neumaticos_2/widgets/button.dart';
import '../../../../services/admin/usuarios/modificar_usaurio.dart';
import '../../../../models/admin/usuario_modifcar.dart';
import '../../../../utils/snackbar_util.dart';


class ModificarUsuarioPage extends StatefulWidget {
  final String email;

  const ModificarUsuarioPage({super.key, required this.email});

  @override
  _ModificarUsuarioPageState createState() => _ModificarUsuarioPageState();
}

class _ModificarUsuarioPageState extends State<ModificarUsuarioPage> {
  final UsuarioService usuarioService = UsuarioService();
  late Usuario _usuario;
  bool _isLoading = true;

  // Añadimos un estado por campo para modificar solo el que se cambia
  bool _isNombresModified = false;
  bool _isApellidosModified = false;
  bool _isCorreoModified = false;
// Cambiado a "Perfil"

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  
  // Modificado para almacenar el perfil
  int _perfilSeleccionado = 1; // 1 por defecto (Administrador)
  
  final List<Map<String, dynamic>> _perfiles = [
    {'label': 'Administrador', 'value': 1},
    {'label': 'Jefe de Planta', 'value': 2},
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsuarioData();
  }

  // Fetch the user data by email
  Future<void> _fetchUsuarioData() async {
    try {
      Usuario? usuario = await usuarioService.getUsuarioByEmail(widget.email);
      if (usuario != null) {
        setState(() {
          _usuario = usuario;
          _nombresController.text = usuario.nombres;
          _apellidosController.text = usuario.apellidos;
          _correoController.text = usuario.correo;
          _perfilSeleccionado = usuario.codigoPerfil; // Asignar el perfil existente
          _isLoading = false;
        });
      }
    } catch (e) {
      showCustomSnackBar(context, 'Error al cargar los datos del usuario', isError: true);
    }
  }

  // Save changes made to the user
  // Save changes made to the user
  Future<void> _saveChanges() async {
    try {
      // Actualizamos el objeto _usuario con los nuevos valores
      _usuario.nombres = _nombresController.text;
      _usuario.apellidos = _apellidosController.text;
      _usuario.correo = _correoController.text; // El nuevo correo aquí
      _usuario.codigoPerfil = _perfilSeleccionado; // Guardamos el perfil seleccionado

      // Mostrar los valores antes de enviar la solicitud
      // Perfil ahora es el código de perfil

      // Llamada al servicio para guardar cambios
      bool success = await usuarioService.modificarDatosUsuario(_usuario, widget.email);
      if (success) {
        showCustomSnackBar(context, 'Datos modificados con éxito');
        // Regresar a la página anterior si los cambios son exitosos
        Navigator.pop(context);
      } else {
        showCustomSnackBar(context, 'Error al modificar los datos', isError: true);
      }
    } catch (e) {
      showCustomSnackBar(context, 'Error al guardar los cambios', isError: true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Usuario'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nombresController,
                    decoration: InputDecoration(
                      labelText: 'Nombres',
                      filled: _isNombresModified ? true : false,
                      fillColor: _isNombresModified ? Colors.yellow : null,
                    ),
                    onChanged: (_) => setState(() => _isNombresModified = true),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _apellidosController,
                    decoration: InputDecoration(
                      labelText: 'Apellidos',
                      filled: _isApellidosModified ? true : false,
                      fillColor: _isApellidosModified ? Colors.yellow : null,
                    ),
                    onChanged: (_) => setState(() => _isApellidosModified = true),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _correoController,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      filled: _isCorreoModified ? true : false,
                      fillColor: _isCorreoModified ? Colors.yellow : null,
                    ),
                    onChanged: (_) => setState(() => _isCorreoModified = true),
                  ),
                  SizedBox(height: 10),
                  // Dropdown para seleccionar el perfil
                  DropdownButtonFormField<int>(
                    value: _perfilSeleccionado,
                    decoration: InputDecoration(labelText: 'Perfil'),
                    items: _perfiles.map((perfil) {
                      return DropdownMenuItem<int>(
                        value: perfil['value'],
                        child: Text(perfil['label']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _perfilSeleccionado = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  StandarButton(
                    onPressed: _saveChanges,
                    text: 'Guardar Cambios',
                  ),
                ],
              ),
            ),
    );
  }
}
