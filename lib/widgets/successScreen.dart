import 'package:yolo_business/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Overlaying SpinKitDoubleBounce with Icon widget
            Stack(
              alignment: Alignment.center,
              children: [
                // Animated container to create a padding around the circles
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                // SpinKitDoubleBounce with adjusted size and position
                Positioned(
                  left: 10,
                  top: 10,
                  child: SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 100.0,
                  ),
                ),
                // Tick mark
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 100.0,
                ),
              ],
            ),
            SizedBox(height: 20),
            // Success message
            Text(
              'Room Detail Entred is  Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            // Button to navigate back or perform another action
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
