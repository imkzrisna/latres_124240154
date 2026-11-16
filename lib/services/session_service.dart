import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _kLogin = 'is_login';
  static const _kUser = 'username';

  static Future<void> saveLogin(String username) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kLogin, true);
    await p.setString(_kUser, username);
  }

  static Future<bool> isLoggedIn() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kLogin) ?? false;
  }

  static Future<String> getUsername() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kUser) ?? '';
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kLogin);
    await p.remove(_kUser);
  }
}
