// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_training/screens/chat_screen.dart';
import 'package:flutter_application_training/screens/doctor_detail_screen.dart';
import 'package:flutter_application_training/screens/doctors_list_screen.dart';
import 'package:flutter_application_training/screens/login_screen.dart';
import 'package:flutter_application_training/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Медицинское Приложение',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/doctors': (context) => const DoctorsListScreen(),
        '/doctor-detail': (context) => const DoctorDetailScreen(),
        '/chat_screen': (context) => ChatScreen(),
      },
    );
  }
}