import 'package:flutter/material.dart';
import '../../../../services/admin/usuarios/deshabilitar__usuario_service.dart';
import '../../../../widgets/button.dart';
import '../../../../utils/snackbar_util.dart';

class InhabilitarUsuarioPage extends StatefulWidget {
  const InhabilitarUsuarioPage({super.key});

  @override
  _InhabilitarUsuarioPageState createState() => _InhabilitarUsuarioPageState();
}

class _InhabilitarUsuarioPageState extends State<InhabilitarUsuarioPage> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  List<String> emailSuggestions = []; // Lista para las sugerencias de correo

  // Método para buscar sugerencias de correos mientras el usuario escribe
  void buscarUsuarios() async {
    if (emailController.text.isNotEmpty) {
      var resultados = await UsuarioService.buscarUsuariosPorCorreo(emailController.text);
      setState(() {
        emailSuggestions = resultados;
      });
    } else {
      setState(() {
        emailSuggestions = [];
      });
    }
  }

  // Método para modificar el estado del usuario
  Future<void> _modificarEstado(int estado) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Llama al servicio para modificar el estado del usuario
      await UsuarioService.modificarEstadoUsuario(emailController.text, estado);
      showCustomSnackBar(context, 'Estado modificado con éxito');
    } catch (e) {
      // Manejo de errores
      showCustomSnackBar(context, 'Error: ${e.toString()}', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Estado del Usuario'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(  // Añadido para permitir desplazamiento
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Campo para ingresar el correo electrónico
                    TextField(
                      controller: emailController,
                      onChanged: (text) => buscarUsuarios(),
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Desplegable de sugerencias de correos
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

                    const SizedBox(height: 20),
                    const Text(
                      '¿Desea habilitar o inhabilitar el usuario?',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Columna para botones, uno debajo del otro
                    Column(
                      children: [
                        StandarButton(
                          onPressed: () => _modificarEstado(1), // Estado "habilitado"
                          text: 'Habilitar',
                          color: Colors.green, // Ajusta el color si lo deseas
                        ),
                        const SizedBox(height: 10), // Espaciado entre botones
                        StandarButton(
                          onPressed: () => _modificarEstado(2), // Estado "inhabilitado"
                          text: 'Inhabilitar',
                          color: Colors.red, // Ajusta el color si lo deseas
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
