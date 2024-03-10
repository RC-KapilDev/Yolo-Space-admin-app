import 'package:yolo_business/main.dart';
import 'package:flutter/material.dart';

class UnsuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(height: 20),
            // Error message
            Text(
              'Room Detail Entred is  UnSuccessful',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            // Button to navigate back or retry
            ElevatedButton(
              onPressed: () {
                // Navigate back or retry action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
