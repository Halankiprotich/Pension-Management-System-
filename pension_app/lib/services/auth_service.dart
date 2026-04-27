import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  Future<AuthModel> login(String username, String password) async {
    final data = await _apiService.login(username, password);
    final auth = AuthModel.fromJson(data);
    await _saveSession(auth);
    _apiService.setToken(auth.token);
    return auth;
  }

  Future<AuthModel> register(String username, String password) async {
    final data = await _apiService.register(username, password);
    final auth = AuthModel.fromJson(data);
    await _saveSession(auth);
    _apiService.setToken(auth.token);
    return auth;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.usernameKey);
    await prefs.remove(AppConstants.roleKey);
    _apiService.clearToken();
  }

  Future<AuthModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    final username = prefs.getString(AppConstants.usernameKey);
    final role = prefs.getString(AppConstants.roleKey);
    if (token == null || username == null) return null;

    // Always re-set token on the singleton so API calls include it
    _apiService.setToken(token);

    return AuthModel(token: token, username: username, role: role ?? 'USER');
  }

  Future<bool> isLoggedIn() async {
    final session = await getSession();
    return session != null;
  }

  ApiService get apiService => _apiService;

  Future<void> _saveSession(AuthModel auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, auth.token);
    await prefs.setString(AppConstants.usernameKey, auth.username);
    await prefs.setString(AppConstants.roleKey, auth.role);
  }
}