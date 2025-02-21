import 'package:flutter/material.dart';
import 'modificar_usuario_screen.dart';
import 'seleccionar_restablecimiento_page.dart';
import '../../../../services/admin/usuarios/ingresar_correo_service.dart';
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

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

  // Método para buscar usuarios por correo
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

  // Método para realizar la acción correspondiente según el tipo de acción
  void realizarAccion() async {
    String correoIngresado = emailController.text;

    if (correoIngresado.isNotEmpty) {
      bool usuarioExiste = await usuarioService.buscarUsuarioPorCorreo(correoIngresado);

      if (usuarioExiste) {
        late Widget destinoPage;

        if (widget.actionType == 'usuario') {
          destinoPage = ModificarUsuarioPage(email: correoIngresado);
        } else {
          // Redirigir a la página de selección de método de restablecimiento
          destinoPage = SeleccionarRestablecimientoPage(email: correoIngresado);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinoPage),
        );
      } else {
        showCustomSnackBar(context, 'Usuario invalido, por favor ingrese un correo existente y habilitado', isError: true);
      }
    } else {
      showCustomSnackBar(context, 'Por favor, ingrese un correo valido', isError: true);
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
              // Campo de texto para ingresar el correo electrónico
              TextField(
                controller: emailController,
                onChanged: (text) => buscarUsuarios(),
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                ),
              ),
              // Lista de sugerencias de correos electrónicos
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
              // Botón para realizar la acción (modificar usuario o restablecer contraseña)
              StandarButton(
                text: widget.actionType == 'usuario' ? 'Modificar Usuario' : 'Restablecer Contraseña',
                onPressed: realizarAccion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
