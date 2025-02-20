import 'package:flutter/material.dart';
import '../../widgets/login/username_field.dart';
import '../../widgets/login/password_field.dart';
import '../../widgets/login/remember_me_checkbox.dart';
import '../../widgets/login/login_button.dart';
import '../../widgets/login/forgot_password_link.dart';
import '../../services/auth_service.dart';
import '../../screens/menu/menu_screen.dart';
import '../../screens/login/recover_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
        SnackBar(
          content: Text(
            'Por favor, llena todos los campos',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
          backgroundColor: Colors.red, // Fondo rojo
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var response = await _authService.login(username, password);

    if (response['error'] != null) {
      if (response['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['error'],
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
            backgroundColor: Colors.red, // Fondo rojo
          ),
        );
      }

    } else {
      String token = response['token'];
      int? userId = response['iD_USUARIO'];
      int? perfil = response['codigO_PERFIL'];
      String correo = response['correo'];
      String dateString = response['fechA_CLAVE'];
      String? contrasenaTemporal = response['contraseñA_TEMPORAL'];
      DateTime date = DateTime.parse(dateString);
      String nombreUsuario = response['nombres'];

      await _authService.saveTokenAndUserId(
        token, userId ?? 0, perfil ?? 0, correo, date, contrasenaTemporal ?? '', nombreUsuario);

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID de usuario no disponible, pero puedes continuar.')),
        );
      }

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
      resizeToAvoidBottomInset: true, // Asegúrate de que esto esté habilitado
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      UsernameField(controller: _usernameController),
                      const SizedBox(height: 20),
                      PasswordField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        toggleVisibility: _togglePasswordVisibility,
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
