import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_tasks/features/auth/presentation/views/login_page.dart';
import 'package:smart_tasks/shared/services/shared_prefs_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isDarkMode = ref.watch(sharedPrefsServiceProvider).isDarkMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const LoginPage(),
    );
  }
}
