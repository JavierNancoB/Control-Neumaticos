import 'package:flutter/material.dart';
import 'modificar_usuario_screen.dart';
import 'seleccionar_restablecimiento_page.dart';
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
        late Widget destinoPage;

        if (widget.actionType == 'usuario') {
          destinoPage = ModificarUsuarioPage(email: correoIngresado);
        } else{
          // Redirigir a la página de selección de método de restablecimiento
          destinoPage = SeleccionarRestablecimientoPage(email: correoIngresado);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinoPage),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario invalido, por favor ingrese un correo existente y habilitado')),
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
