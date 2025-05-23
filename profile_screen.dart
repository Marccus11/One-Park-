// Profile screen modeled exactly on the Figma structure
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.black12,
              child: Icon(Icons.person, size: 40, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const Text("Daniel",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.directions_car),
              title: Text("Saved Vehicle"),
              subtitle: Text("TSX-2929"),
            ),
            const ListTile(
              leading: Icon(Icons.history),
              title: Text("Parking History"),
              subtitle: Text("12 sessions"),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              subtitle: Text("Notifications, Account Info"),
            ),
          ],
        ),
      ),
    );
  }
}
