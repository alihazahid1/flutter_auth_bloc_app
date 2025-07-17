import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  final SharedPreferences _prefs;

  AuthLocalStorage(this._prefs);

  static const tokenKey = 'token';

  Future<void> saveToken(String token) async {
    await _prefs.setString(tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(tokenKey);
  }

  Future<void> deleteToken() async {
    await _prefs.remove(tokenKey);
  }

  bool isLoggedIn() {
    return _prefs.containsKey(tokenKey);
  }
}
// This class handles local storage operations related to authentication tokens.