import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter App',
      home: Scaffold(
        appBar: AppBar(title: const Text('')),
        body: LoginScreen(),
      ),
    );
  }
}
