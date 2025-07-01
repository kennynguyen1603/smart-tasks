// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/firebase_auth_service.dart';
// import '../../../profile/presentation/pages/profile_page.dart';

// class RegisterPage extends ConsumerStatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   ConsumerState<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends ConsumerState<RegisterPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _nameController = TextEditingController();
//   DateTime? _dob;
//   final _authService = FirebaseAuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register')),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Full Name'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),
//             const SizedBox(height: 12),
//             ListTile(
//               title: Text(
//                 _dob == null
//                     ? 'Choose Date of Birth'
//                     : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
//               ),
//               trailing: const Icon(Icons.calendar_today),
//               onTap: () async {
//                 final picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime(2000),
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime.now(),
//                 );
//                 if (picked != null) {
//                   setState(() => _dob = picked);
//                 }
//               },
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_dob == null) return;
//                 final user = await _authService.signUp(
//                   _emailController.text.trim(),
//                   _passwordController.text.trim(),
//                   _nameController.text.trim(),
//                   _dob!,
//                 );
//                 if (user != null && context.mounted) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => ProfilePage(user: user)),
//                   );
//                 }
//               },
//               child: const Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
