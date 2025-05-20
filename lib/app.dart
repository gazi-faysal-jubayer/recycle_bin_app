import 'package:flutter/material.dart';
import '/config/routes.dart';
import '/config/theme.dart';
import '/screens/home/home_screen.dart';
import '/screens/auth/login_screen.dart';
import '/screens/auth/register_screen.dart';
import '/screens/profile/profile_screen.dart';

class RecycleBinApp extends StatelessWidget {
  const RecycleBinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle Bin App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => const HomeScreen(),
        Routes.login: (context) => const LoginScreen(),
        Routes.register: (context) => const RegisterScreen(),
        Routes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}