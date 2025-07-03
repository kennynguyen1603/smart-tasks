import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_tasks/core/routes/go_router_refresh_stream.dart';
import 'package:smart_tasks/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:smart_tasks/features/auth/presentation/views/login_page.dart';
import 'package:smart_tasks/features/home/presentation/pages/home_page.dart';
import 'package:smart_tasks/features/profile/presentation/pages/profile_page.dart';
import 'package:smart_tasks/features/task/presentation/pages/add_task_page.dart';
import 'package:smart_tasks/features/task/presentation/pages/task_list_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = auth != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn) return isLoggingIn ? null : '/login';
      if (isLoggingIn && isLoggedIn) return '/';
      return null;
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePageWrapper(),
      ),
      GoRoute(
        path: '/add-task',
        builder: (context, state) => const AddTaskPage(),
      ),
      GoRoute(
        path: '/my-tasks',
        builder: (context, state) => const TaskListPage(),
      ),
    ],
  );
});

class ProfilePageWrapper extends ConsumerWidget {
  const ProfilePageWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider);
    if (user == null) return const SizedBox();
    return ProfilePage(user: user);
  }
}
