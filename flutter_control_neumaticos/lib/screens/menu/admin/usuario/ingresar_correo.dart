import 'package:flutter/material.dart';
import 'modificar_usuario_screen.dart';
//import 'reestablecer_passw_page.dart';
import '../../../../services/admin/usuarios/ingresar_correo_service.dart';

class IngresarCorreoPage extends StatefulWidget {
  final String actionType;

  const IngresarCorreoPage({super.key, required this.actionType});

  @override
  _IngresarCorreoPageState createState() => _IngresarCorreoPageState();
}

class _IngresarCorreoPageState extends State<IngresarCorreoPage> {
  final TextEditingController emailController = TextEditingController();
  final UsuarioService usuarioService = UsuarioService();
  List<String> emailSuggestions = [];

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

  void realizarAccion() async {
    String correoIngresado = emailController.text;

    if (correoIngresado.isNotEmpty) {
      bool usuarioExiste = await usuarioService.buscarUsuarioPorCorreo(correoIngresado);

      if (usuarioExiste) {
        Widget destinoPage = widget.actionType == 'usuario'
            ? ModificarUsuarioPage(email: correoIngresado)
            : ModificarUsuarioPage(email: correoIngresado);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinoPage),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                onChanged: (text) => buscarUsuarios(),
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                ),
              ),
              if (emailSuggestions.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: emailSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(emailSuggestions[index]),
                      onTap: () {
                        emailController.text = emailSuggestions[index];
                      },
                    );
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: realizarAccion,
                child: Text(widget.actionType == 'usuario' ? 'Modificar Usuario' : 'Restablecer Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
