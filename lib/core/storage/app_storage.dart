import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static final AppStorage instance = AppStorage._internal();
  late SharedPreferences _prefs;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  AppStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _cachedAccessToken = _prefs.getString(_accessTokenKey);
    _cachedRefreshToken = _prefs.getString(_refreshTokenKey);
  }

  // CACHED GETTERS (No await needed!)
  String? get accessToken => _cachedAccessToken;
  String? get refreshToken => _cachedRefreshToken;

  // Saving tokens (also update cached)
  Future<void> saveAccessToken(String token) async {
    _cachedAccessToken = token;
    await _prefs.setString(_accessTokenKey, token);
  }

  Future<void> saveRefreshToken(String token) async {
    _cachedRefreshToken = token;
    await _prefs.setString(_refreshTokenKey, token);
  }

  // Removing tokens
  Future<void> removeAccessToken() async {
    _cachedAccessToken = null;
    await _prefs.remove(_accessTokenKey);
  }

  Future<void> removeRefreshToken() async {
    _cachedRefreshToken = null;
    await _prefs.remove(_refreshTokenKey);
  }

  Future<void> clearAll() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await _prefs.clear();
  }
}
