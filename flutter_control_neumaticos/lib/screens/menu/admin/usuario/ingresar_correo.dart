import 'package:flutter/material.dart';
import 'modificar_usuario_screen.dart';
import '../../../../services/admin/usuarios/ingresar_correo_service.dart';

class IngresarCorreoPage extends StatefulWidget {
  const IngresarCorreoPage({super.key});

  @override
  _IngresarCorreoPageState createState() => _IngresarCorreoPageState();
}

class _IngresarCorreoPageState extends State<IngresarCorreoPage> {
  final TextEditingController emailController = TextEditingController();
  final UsuarioService usuarioService = UsuarioService();
  List<String> emailSuggestions = []; // Lista de sugerencias de correos

  // Función para obtener sugerencias de correos mientras el usuario escribe
  void buscarUsuarios() async {
    if (emailController.text.isNotEmpty) {
      var resultados = await usuarioService.buscarUsuariosPorCorreo(emailController.text);
      setState(() {
        emailSuggestions = resultados;
      });
    } else {
      setState(() {
        emailSuggestions = [];
      });
    }
  }

  // Función que se llama cuando se presiona el botón "Modificar"
  void modificarUsuario() async {
    String correoIngresado = emailController.text;

    if (correoIngresado.isNotEmpty) {
      // Verificamos si el usuario está habilitado
      bool usuarioExiste = await usuarioService.buscarUsuarioPorCorreo(correoIngresado);

      if (usuarioExiste) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModificarUsuarioPage(email: correoIngresado),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario deshabilitado/no encontrado')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese un correo válido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar Correo del Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Añadido para permitir desplazamiento
          child: Column(
            children: [
              // Campo de texto con sugerencias
              TextField(
                controller: emailController,
                onChanged: (text) => buscarUsuarios(),
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                ),
              ),
              // Desplegable de sugerencias
              if (emailSuggestions.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: emailSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(emailSuggestions[index]),
                      onTap: () {
                        emailController.text = emailSuggestions[index]; // Seleccionar correo
                      },
                    );
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: modificarUsuario,
                child: Text('Modificar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
