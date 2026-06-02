import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes JWT App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreenState(), // Cek session di sini
    );
  }
}

class SplashScreenState extends StatefulWidget {
  const SplashScreenState({super.key});

  @override
  State<SplashScreenState> createState() => _SplashScreenStateState();
}

class _SplashScreenStateState extends State<SplashScreenState> {
  @override
  void initState() {
    super.initState();
    _initSession();
  }

  void _initSession() async {
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Jalankan pengecekan token di local storage
    await authProvider.checkSession();

    if (mounted) {
      if (authProvider.isAuthenticated) {
        // Jika token ada, langsung ke Home (Auto Login)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      } else {
        // Jika token kosong, harus login dulu
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading screen sembari cek token
      ),
    );
  }
}