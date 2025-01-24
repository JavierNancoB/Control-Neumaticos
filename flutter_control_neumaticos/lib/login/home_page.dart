import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar el formato JSON
import 'package:shared_preferences/shared_preferences.dart'; // Para almacenar las preferencias

import '../options_page.dart'; // Importa la página de opciones
import 'recuperar_contrasena.dart'; // Importa la página de recuperar contraseña

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; // Para mostrar un indicador de carga
  bool _rememberMe = false; // Para manejar la opción de recordar correo y contraseña

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar los datos guardados
  }

  // Método para cargar el correo y la contraseña guardados en shared preferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');
    if (savedUsername != null && savedPassword != null) {
      _usernameController.text = savedUsername;
      _passwordController.text = savedPassword;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveUserData(String username, String password) async {
    if (_rememberMe) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);
      prefs.setString('password', password);
    }
  }
  // Método para guardar el correo y la contraseña si la opción está activada
  Future<void> _login() async {
  setState(() {
    _isLoading = true;
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String apiUrl = 'http://localhost:5062/api/Auth/Login';
    final body = json.encode({
      'Correo': username,
      'Clave': password,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Guarda el token en SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseBody['token']);

        // Guarda el ID del usuario en SharedPreferences
        
      if (responseBody['id'] != null) {
        await prefs.setInt('userId', responseBody['id']);
      } else {
        // Maneja el caso cuando 'id' es nulo, por ejemplo:
        print("ID de usuario no disponible");
      }

      // Redirige a la página principal
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OptionsPage()),
          
        );
        // Guarda el correo y contraseña si "Recordar" está activado
        _saveUserData(username, password);
        


      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'] ?? 'Error en el inicio de sesión')),
        );
      }
    } catch (e) {
      print('Error de conexión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con el servidor')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Campo de texto para el correo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de texto para la contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Opción para recordar el correo y la contraseña
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Recordar correo y contraseña'),
                ],
              ),

              const SizedBox(height: 20),

              // Botón de login
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 10),

              // Enlace para "Olvidaste tu contraseña"
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecuperarContrasenaPage()),
                  );
                },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
