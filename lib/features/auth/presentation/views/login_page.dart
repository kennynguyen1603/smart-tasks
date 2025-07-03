// 📁 lib/features/auth/presentation/views/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_tasks/features/auth/presentation/viewmodels/auth_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authViewModelProvider);

    if (user != null) {
      // Nếu đã đăng nhập rồi thì chuyển luôn về homepage
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/');
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Image.asset('assets/images/logo.png', height: 120),
            const SizedBox(height: 24),
            const Text(
              'Smart Tasks',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'A simple and efficient to-do app',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : const Text('Sign in with Google'),
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      await ref
                          .read(authViewModelProvider.notifier)
                          .signInWithGoogle();
                      if (!mounted) return;
                      setState(() => _loading = false);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '© UTHSmartTasks',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
