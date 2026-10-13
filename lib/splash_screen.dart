import 'package:blogger_app/auth_provider.dart';
import 'package:blogger_app/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startApp();
  }

  Future<void> startApp() async {
    final auth = context.read<AuthProvider>();
    final blogProvider = context.read<BlogProvider>();

    await auth.loadData();
    await blogProvider.loadBlogs();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (auth.currentUser != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 173, 3),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.apps, size: 100, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Blogger App',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
