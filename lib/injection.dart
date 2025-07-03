import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_tasks/features/auth/presentation/viewmodels/auth_view_model.dart';

final selectedPageProvider = StateProvider<int>((ref) => 0);

final userTasksProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(authViewModelProvider);
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('tasks')
      .where('userId', isEqualTo: user.uid)
      .orderBy('dueDate')
      .snapshots();
});
