import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart'; // Importa la página de inicio
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Asegúrate de importar flutter_dotenv

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar el archivo .env desde los assets
  print('Cargando archivo .env...');
  await dotenv.load(fileName: 'assets/.env');
  print('.env cargado correctamente');

  // Verificar si una variable en el archivo .env se cargó correctamente
  String? apiUrl = dotenv.env['API_URL'];
  if (apiUrl != null) {
    print('API_URL cargada: $apiUrl');
  } else {
    print('No se ha encontrado API_URL en el archivo .env');
  }

  // Comprobar si otras variables están presentes en el archivo .env
  String? anotherVariable = dotenv.env['ANOTHER_VARIABLE'];
  if (anotherVariable != null) {
    print('ANOTHER_VARIABLE: $anotherVariable');
  } else {
    print('No se ha encontrado ANOTHER_VARIABLE en el archivo .env');
  }

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
