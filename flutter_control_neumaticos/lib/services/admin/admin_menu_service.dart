import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<int?> getPerfil() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('perfil: ${prefs.getInt('perfil')}');
    return prefs.getInt('perfil');
  }
}
