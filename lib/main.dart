import 'package:flutter/material.dart'; // ❗ Required for MaterialApp, etc.
import 'screens/login.dart'; // ✅ Make sure this file exists

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
        appBar: AppBar(
          title: const Text(''), // ✅ Placeholder, can be improved
        ),
        body: const LoginScreen(), // ✅ Add `const` if LoginScreen is constant
      ),
    );
  }
}
