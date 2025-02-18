import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart'; // Importa la página de inicio

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Puedes eliminar todo el código relacionado con dotenv aquí.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
