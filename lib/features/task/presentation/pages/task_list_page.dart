import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_tasks/injection.dart';

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskStream = ref.watch(userTasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: taskStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (snapshot) {
          final docs = snapshot.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No Tasks Yet!', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Stay productive—add something to do'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final task = docs[index];
              final title = task['title'] ?? 'Untitled';
              final description = task['description'] ?? '';
              final status = task['status'] ?? 'Pending';
              final dueDate = (task['dueDate'] as Timestamp).toDate();

              final color = switch (status) {
                'In Progress' => Colors.yellow[100],
                'Completed' => Colors.green[100],
                'Pending' => Colors.red[100],
                _ => Colors.grey[100],
              };

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(description),
                    const SizedBox(height: 8),
                    Text('Status: $status'),
                    Text(DateFormat('HH:mm yyyy-MM-dd').format(dueDate)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
