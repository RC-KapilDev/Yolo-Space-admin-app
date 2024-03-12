import 'package:yolo_business/Screens/addscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

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
                  duration: const Duration(milliseconds: 500),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                // SpinKitDoubleBounce with adjusted size and position
                const Positioned(
                  left: 10,
                  top: 10,
                  child: SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 100.0,
                  ),
                ),
                // Tick mark
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 100.0,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Success message
            const Text(
              'Room Detail Entred is  Successful',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Button to navigate back or perform another action
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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
