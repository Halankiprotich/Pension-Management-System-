import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Pension Management System';

  static const String baseUrl = 'http://192.168.46.102:8080';
  //static const String baseUrl = 'http://10.0.2.2:8080'; // Android emulator → localhost
 //static const String baseUrl = 'http://localhost:8080';

  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String membersRoute = '/members';
  static const String contributionsRoute = '/contributions';
  static const String balanceRoute = '/balance';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String usernameKey = 'auth_username';
  static const String roleKey = 'auth_role';

  // Colors
  static const Color primaryColor = Color(0xFF1E6F5C);
  static const Color accentColor = Color(0xFF29BB89);
  static const Color errorColor = Color(0xFFE74C3C);

  // Messages
  static const String networkError = 'Network error. Please try again.';
  static const String unauthorizedError = 'Session expired. Please login again.';
}