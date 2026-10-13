import 'package:blogger_app/auth_provider.dart';
import 'package:blogger_app/blog_provider.dart';
import 'package:blogger_app/blog_screen.dart';
import 'package:blogger_app/home_screen.dart';
import 'package:blogger_app/login_screen.dart';
import 'package:blogger_app/search_screen.dart';
import 'package:blogger_app/signup_screen.dart';
import 'package:blogger_app/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BlogProvider()),
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blogger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/login': (context) =>  LoginScreen(),
        '/signup': (context) =>  SignupScreen(),
        '/home': (context) =>  HomeScreen(),
        '/create': (context) =>  CreateBlogScreen(),
        '/search': (context) =>  SearchScreen( ),
      },
    );
  }
}