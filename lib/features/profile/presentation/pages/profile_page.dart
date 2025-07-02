import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('User data not found.'));
          }

          final name = data['name'] ?? 'Unknown';
          final email = data['email'] ?? 'No email';
          final dob = data['dateOfBirth'] ?? '';
          final bio = data['bio'] ?? '';
          final photoUrl = data['profilePicture'];
          final dateJoined = data['dateJoined'] != null
              ? DateFormat(
                  'dd/MM/yyyy',
                ).format((data['dateJoined'] as Timestamp).toDate())
              : 'N/A';
          final isEmailVerified = data['isEmailVerified'] == true;

          final taskStats = data['taskStats'] ?? {};
          final completed = taskStats['tasksCompleted'] ?? 0;
          final total = taskStats['tasksTotal'] ?? 0;
          final inProgress = taskStats['tasksInProgress'] ?? 0;
          final overdue = taskStats['tasksOverdue'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: photoUrl != null && photoUrl != ''
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                          radius: 48,
                        )
                      : const CircleAvatar(
                          radius: 48,
                          child: Icon(Icons.person, size: 40),
                        ),
                ),
                const SizedBox(height: 24),

                // Name
                TextFormField(
                  initialValue: name,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  initialValue: email,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),

                // Email Verified
                Row(
                  children: [
                    const Text('Email verified:'),
                    const SizedBox(width: 8),
                    Icon(
                      isEmailVerified ? Icons.check_circle : Icons.cancel,
                      color: isEmailVerified ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Date of Birth
                TextFormField(
                  initialValue: dob,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                ),
                const SizedBox(height: 12),

                // Bio
                TextFormField(
                  initialValue: bio,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),

                // Date Joined
                TextFormField(
                  initialValue: dateJoined,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Date Joined'),
                ),
                const SizedBox(height: 24),

                const Text(
                  '📊 Task Statistics',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Total', total),
                    _buildStat('Completed', completed),
                    _buildStat('In Progress', inProgress),
                    _buildStat('Overdue', overdue),
                  ],
                ),

                const SizedBox(height: 36),
                // ElevatedButton(
                //   onPressed: () {
                //     if (context.mounted) {
                //       context.go('/');
                //     }
                //   },
                //   child: const Text('Back to Home'),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String title, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(title),
      ],
    );
  }
}
