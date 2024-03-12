import 'package:yolo_business/Screens/addscreen.dart';

import 'package:flutter/material.dart';

class UnsuccessfulScreen extends StatelessWidget {
  const UnsuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 100.0,
            ),
            const SizedBox(height: 20),
            // Error message
            const Text(
              'Room Detail Entred is  UnSuccessful',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Button to navigate back or retry
            ElevatedButton(
              onPressed: () {
                // Navigate back or retry action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
