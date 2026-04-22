import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/member.dart';
import '../models/contribution.dart';
import '../models/balance.dart';

class ApiService {
  final String _baseUrl = AppConstants.baseUrl;
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ─── AUTH ─────────────────────────────────────────────────────────────────

  /// POST /auth/login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'username': username, 'password': password}),
    );
    return _handleResponse(response);
  }

  /// POST /auth/register
  Future<Map<String, dynamic>> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({'username': username, 'password': password}),
    );
    return _handleResponse(response);
  }

  // ─── MEMBERS ──────────────────────────────────────────────────────────────

  /// GET /api/members
  Future<List<Member>> getMembers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/members'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    // handles both wrapped { data: [...] } and plain list [...]
    final list = data is List ? data : (data['data'] ?? data['content'] ?? data);
    return (list as List).map((m) => Member.fromJson(m)).toList();
  }

  /// GET /api/members/{memberNumber}/balance
  Future<Balance> getMemberBalance(String memberNumber) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/members/$memberNumber/balance'),
      headers: _headers,
    );
    return Balance.fromJson(_handleResponse(response));
  }

  // ─── CONTRIBUTIONS ────────────────────────────────────────────────────────

  /// GET /api/contributions
  Future<List<Contribution>> getAllContributions() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/contributions'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    final list = data is List ? data : (data['data'] ?? data['content'] ?? data);
    return (list as List).map((c) => Contribution.fromJson(c)).toList();
  }

  /// GET /api/contributions/member/{memberNumber}
  Future<List<Contribution>> getContributionsByMember(String memberNumber) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/contributions/member/$memberNumber'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    final list = data is List ? data : (data['data'] ?? data['content'] ?? data);
    return (list as List).map((c) => Contribution.fromJson(c)).toList();
  }

  /// POST /api/contributions
  Future<Map<String, dynamic>> addContribution({
    required String memberNumber,
    required double amount,
    String? paymentMethod,
    String? referenceNumber,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/contributions'),
      headers: _headers,
      body: jsonEncode({
        'memberNumber': memberNumber,
        'amount': amount,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
        if (referenceNumber != null) 'referenceNumber': referenceNumber,
        if (notes != null) 'notes': notes,
      }),
    );
    return _handleResponse(response);
  }

  // ─── HELPER ───────────────────────────────────────────────────────────────
  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      throw Exception(AppConstants.unauthorizedError);
    } else {
      final message = body is Map ? (body['message'] ?? body['error'] ?? AppConstants.networkError) : AppConstants.networkError;
      throw Exception(message);
    }
  }
}