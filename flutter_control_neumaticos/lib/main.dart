import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart'; // Importa la página de inicio
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Asegúrate de importar flutter_dotenv
// Importa para obtener el directorio de trabajo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  
  // Imprimir el directorio de trabajo correctamente

  // Cargar el archivo .env desde los assets
  await dotenv.load(fileName: 'assets/.env');
  


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
