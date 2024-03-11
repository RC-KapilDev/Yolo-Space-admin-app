import 'package:flutter/material.dart';
import 'package:yolo_business/Screens/checkscreen.dart';
import 'package:yolo_business/Screens/deleteScreen.dart';
import 'package:yolo_business/main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Yolo-Business',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'YB',
                style: TextStyle(
                  color: Color.fromARGB(255, 96, 104, 189),
                  fontSize: 20,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 96, 104, 189),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.add, color: Color.fromARGB(255, 44, 8, 101)),
            title: const Text('Add Details'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle,
                color: Color.fromARGB(255, 62, 16, 114)),
            title: const Text('Approve Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CheckScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle,
                color: Color.fromARGB(255, 62, 16, 114)),
            title: const Text('Room Details Delete'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeleteScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
