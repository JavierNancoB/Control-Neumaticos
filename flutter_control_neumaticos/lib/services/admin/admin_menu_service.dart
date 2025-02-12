import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para manejar SharedPreferences.

class AuthService {
  // Función para obtener el perfil del usuario desde SharedPreferences.
  Future<int?> getPerfil() async {
    // Obtiene la instancia de SharedPreferences, que permite acceder a los datos guardados localmente.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Retorna el valor del 'perfil' guardado en SharedPreferences. Si no existe, retornará null.
    return prefs.getInt('perfil');
  }
}
