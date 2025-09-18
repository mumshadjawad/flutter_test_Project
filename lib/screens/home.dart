import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Navigate back to LoginScreen and remove HomeScreen from stack
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Email: admin@example.com'),
            const SizedBox(height: 20),
            const Text(
              'Your Tasks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Finish login screen UI'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Design home screen layout'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Connect backend (optional)'),
            ),
          ],
        ),
      ),
    );
  }
}
