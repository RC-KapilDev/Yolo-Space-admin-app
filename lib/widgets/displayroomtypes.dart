import 'package:flutter/material.dart';

class DisplayRoomTypes extends StatelessWidget {
  const DisplayRoomTypes(
      {super.key, required this.rent, required this.type, required this.icon});
  final int rent;
  final String type;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 96, 104, 189),
            foregroundColor: Colors.white,
            child: Center(
              child: Icon(icon),
            )),
        const SizedBox(
          width: 5,
        ),
        Column(
          children: [
            Text(type),
            const Text('Starting from'),
            Row(
              children: [
                Text(
                  '${rent.toString()} ',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const Text('/Month')
              ],
            )
          ],
        )
      ],
    );
  }
}
