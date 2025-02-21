import 'package:flutter/material.dart';
import 'package:pentacrom_neumaticos_2/widgets/button.dart';
import '../../../../services/admin/usuarios/modificar_usaurio.dart';
import '../../../../models/admin/usuario_modifcar.dart';
import '../../../../utils/snackbar_util.dart';

// Clase principal de la página para modificar un usuario
class ModificarUsuarioPage extends StatefulWidget {
  final String email; // Email del usuario a modificar

  const ModificarUsuarioPage({super.key, required this.email});

  @override
  _ModificarUsuarioPageState createState() => _ModificarUsuarioPageState();
}

// Estado de la página ModificarUsuarioPage
class _ModificarUsuarioPageState extends State<ModificarUsuarioPage> {
  final UsuarioService usuarioService = UsuarioService(); // Servicio para manejar usuarios
  late Usuario _usuario; // Objeto usuario que se va a modificar
  bool _isLoading = true; // Estado de carga

  // Estados para saber si los campos han sido modificados
  bool _isNombresModified = false;
  bool _isApellidosModified = false;
  bool _isCorreoModified = false;

  // Controladores para los campos de texto
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  
  // Estado para almacenar el perfil seleccionado
  int _perfilSeleccionado = 1; // 1 por defecto (Administrador)
  
  // Lista de perfiles disponibles
  final List<Map<String, dynamic>> _perfiles = [
    {'label': 'Administrador', 'value': 1},
    {'label': 'Jefe de Planta', 'value': 2},
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsuarioData(); // Llamada para obtener los datos del usuario
  }

  // Método para obtener los datos del usuario por email
  Future<void> _fetchUsuarioData() async {
    try {
      Usuario? usuario = await usuarioService.getUsuarioByEmail(widget.email);
      if (usuario != null) {
        setState(() {
          _usuario = usuario; // Asignar el usuario obtenido
          _nombresController.text = usuario.nombres; // Asignar nombres
          _apellidosController.text = usuario.apellidos; // Asignar apellidos
          _correoController.text = usuario.correo; // Asignar correo
          _perfilSeleccionado = usuario.codigoPerfil; // Asignar perfil existente
          _isLoading = false; // Cambiar estado de carga
        });
      }
    } catch (e) {
      showCustomSnackBar(context, 'Error al cargar los datos del usuario', isError: true); // Mostrar error
    }
  }

  // Método para guardar los cambios realizados en el usuario
  Future<void> _saveChanges() async {
    try {
      // Actualizar el objeto _usuario con los nuevos valores
      _usuario.nombres = _nombresController.text;
      _usuario.apellidos = _apellidosController.text;
      _usuario.correo = _correoController.text; // El nuevo correo aquí
      _usuario.codigoPerfil = _perfilSeleccionado; // Guardar el perfil seleccionado

      // Llamada al servicio para guardar cambios
      bool success = await usuarioService.modificarDatosUsuario(_usuario, widget.email);
      if (success) {
        showCustomSnackBar(context, 'Datos modificados con éxito'); // Mostrar éxito
        Navigator.pop(context); // Regresar a la página anterior si los cambios son exitosos
      } else {
        showCustomSnackBar(context, 'Error al modificar los datos', isError: true); // Mostrar error
      }
    } catch (e) {
      showCustomSnackBar(context, 'Error al guardar los cambios', isError: true); // Mostrar error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Usuario'), // Título de la página
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Mostrar indicador de carga si está cargando
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Campo de texto para nombres
                  TextField(
                    controller: _nombresController,
                    decoration: InputDecoration(
                      labelText: 'Nombres',
                      filled: _isNombresModified ? true : false,
                      fillColor: _isNombresModified ? Colors.yellow : null,
                    ),
                    onChanged: (_) => setState(() => _isNombresModified = true), // Marcar como modificado cambia a color amarillo
                  ),
                  SizedBox(height: 10),
                  // Campo de texto para apellidos
                  TextField(
                    controller: _apellidosController,
                    decoration: InputDecoration(
                      labelText: 'Apellidos',
                      filled: _isApellidosModified ? true : false,
                      fillColor: _isApellidosModified ? Colors.yellow : null,
                    ),
                    onChanged: (_) => setState(() => _isApellidosModified = true), // Marcar como modificado
                  ),
                  SizedBox(height: 10),
                  // Campo de texto para correo
                  TextField(
                    controller: _correoController,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      filled: _isCorreoModified ? true : false,
                      fillColor: _isCorreoModified ? Colors.yellow : null,
                    ),
                    onChanged: (_) => setState(() => _isCorreoModified = true), // Marcar como modificado
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
                        _perfilSeleccionado = value!; // Actualizar perfil seleccionado
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Botón para guardar cambios
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
