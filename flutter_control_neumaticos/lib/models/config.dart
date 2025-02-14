// Clase: Config 
// Propósito: Contiene la URL base para las peticiones a la API
/*
class Config {
  static const String awsUrl='http://localhost:5062';
}
*/
// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get awsUrl => dotenv.env['API_URL'] ?? 'http://localhost:5062';  // Valor por defecto si no se encuentra
}
