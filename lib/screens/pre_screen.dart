import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // After 2 seconds, navigate to the main screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/start');
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/splash.jpg'), // Your image
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("Welcome!")),
    );
  }
}
