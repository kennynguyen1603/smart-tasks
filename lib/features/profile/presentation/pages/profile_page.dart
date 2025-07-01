import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  Future<Map<String, dynamic>?> getUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    final name = user.displayName ?? 'Unknown';
    final email = user.email ?? 'No email';
    final photoUrl = user.photoURL;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final dob = data?['dob'] ?? 'Not set';

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                if (photoUrl != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
                    radius: 48,
                  )
                else
                  const CircleAvatar(
                    radius: 48,
                    child: Icon(Icons.person, size: 40),
                  ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: name,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: email,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  readOnly: true,
                  initialValue: dob,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
