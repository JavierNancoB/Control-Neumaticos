import 'package:flutter/material.dart';
import '../../widgets/login/username_field.dart';
import '../../widgets/login/password_field.dart';
import '../../widgets/login/remember_me_checkbox.dart';
import '../../widgets/login/login_button.dart';
import '../../widgets/login/forgot_password_link.dart';
import '../../services/auth_service.dart';
import '../menu/menu_screen.dart';
import 'recover_password.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await _authService.loadUserData();
    if (userData['username'] != null && userData['password'] != null) {
      _usernameController.text = userData['username']!;
      _passwordController.text = userData['password']!;
      setState(() {
        _rememberMe = true;
      });
    }
  }

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

    var response = await _authService.login(username, password);

    if (response['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'])),
      );
    } else {
      String token = response['token'];
      int? userId = response['iD_USUARIO']; // Usamos 'iD_USUARIO' en lugar de 'id'

      // Imprimir en consola los valores de 'token' y 'userId'
      print("Token: $token");
      print("User ID: $userId");

      // Si 'userId' es null, podemos proceder de todas maneras
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID de usuario no disponible, pero puedes continuar.')),
        );
      }

      // Guarda siempre el token y el userId si está disponible
      await _authService.saveTokenAndUserId(token, userId ?? 0); // Si userId es null, guardamos 0
      await _authService.saveUserData(username, password, _rememberMe);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }


  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
              UsernameField(controller: _usernameController),
              const SizedBox(height: 20),
              PasswordField(
                controller: _passwordController,
                obscureText: _obscureText,
                toggleVisibility: _togglePasswordVisibility,
              ),
              const SizedBox(height: 20),
              RememberMeCheckbox(
                rememberMe: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              LoginButton(isLoading: _isLoading, onPressed: _login),
              const SizedBox(height: 10),
              ForgotPasswordLink(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecuperarContrasenaPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
