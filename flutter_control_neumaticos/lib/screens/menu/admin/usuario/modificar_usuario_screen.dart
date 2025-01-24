import 'package:flutter/material.dart';
import '../../../../services/admin/usuarios/modificar_usaurio.dart';
import '../../../../models/usuario_modifcar.dart';

class ModificarUsuarioPage extends StatefulWidget {
  final String email;

  const ModificarUsuarioPage({Key? key, required this.email}) : super(key: key);

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
  bool _isCodigoPerfilModified = false;

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _codigoPerfilController = TextEditingController();

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
          _codigoPerfilController.text = usuario.codigoPerfil.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos del usuario')),
      );
    }
  }

  // Save changes made to the user
  Future<void> _saveChanges() async {
    try {
      // Validar el código de perfil antes de enviarlo
      String codigoPerfilText = _codigoPerfilController.text.trim();
      int codigoPerfilInt;

      try {
        codigoPerfilInt = int.parse(codigoPerfilText); // Intentar convertir a entero
      } catch (e) {
        print("Error: Código de Perfil no es un entero válido: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código de Perfil no es válido')),
        );
        return; // No enviar el formulario si el código no es válido
      }

      // Actualizamos el objeto _usuario con los nuevos valores
      _usuario.nombres = _nombresController.text;
      _usuario.apellidos = _apellidosController.text;
      _usuario.correo = _correoController.text;
      _usuario.codigoPerfil = codigoPerfilInt;

      // Mostrar los valores antes de enviar la solicitud
      print("Saving changes with values: ");
      print("Nombres: ${_nombresController.text}");
      print("Apellidos: ${_apellidosController.text}");
      print("Correo: ${_correoController.text}");
      print("Código de Perfil: ${_usuario.codigoPerfil}");

      // Llamada al servicio para guardar cambios
      bool success = await usuarioService.modificarDatosUsuario(_usuario);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos modificados con éxito')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar los datos')),
        );
      }
    } catch (e) {
      print("Error al guardar los cambios: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los cambios')),
      );
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
                  TextField(
                    controller: _codigoPerfilController,
                    decoration: InputDecoration(
                      labelText: 'Código de Perfil',
                      filled: _isCodigoPerfilModified ? true : false,
                      fillColor: _isCodigoPerfilModified ? Colors.yellow : null,
                    ),
                    onChanged: (_) => setState(() => _isCodigoPerfilModified = true),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
    );
  }
}
