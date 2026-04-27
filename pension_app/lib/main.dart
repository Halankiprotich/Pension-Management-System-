import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/members_screen.dart';
import 'screens/contributions_screen.dart';
import 'screens/balance_screen.dart';
import 'services/api_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load token from storage at startup so all API calls include it
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(AppConstants.tokenKey);
  if (token != null) {
    ApiService().setToken(token);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        useMaterial3: true,
      ),
      initialRoute: AppConstants.loginRoute,
      routes: {
        AppConstants.loginRoute: (context) => const LoginScreen(),
        AppConstants.registerRoute: (context) => const RegisterScreen(),
        AppConstants.homeRoute: (context) => const HomeScreen(),
        AppConstants.membersRoute: (context) => const MembersScreen(),
        AppConstants.contributionsRoute: (context) => const ContributionsScreen(),
        AppConstants.balanceRoute: (context) => const BalanceScreen(),
      },
    );
  }
}