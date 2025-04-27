// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_training/screens/chat_screen.dart';
import 'package:flutter_application_training/screens/doctor_detail_screen.dart';
import 'package:flutter_application_training/screens/doctors_list_screen.dart';
import 'package:flutter_application_training/screens/login_screen.dart';
import 'package:flutter_application_training/screens/register_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(const MyApp());
}

mixin AwaitLogger {
  Future<T> loggedAwait<T>(Future<T> future, {String? tag}) async {
    debugPrint('⌛ [Await Start] $tag');

    final result = await future;
    debugPrint('✅ [Await End] $tag');
    return result;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        duration: Durations.medium4,
        reverseDuration: Durations.medium4,
        overlayColor: Colors.grey.withValues(alpha: 0.8),
        child: MaterialApp(
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
        ));
  }
}
