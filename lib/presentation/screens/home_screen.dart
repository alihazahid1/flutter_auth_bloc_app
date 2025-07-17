import 'package:bloc_login/data/repositories/user_repository.dart';
import 'package:bloc_login/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc_login/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userData;
  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Text(
              'Welcome to Home Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            Text('Username: ${authBloc.username ?? "Guest"}'),
            Text('Password: ${authBloc.password ?? "Guest"}'),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(isLoggedIn: false),
                  ),
                );
              },
              child: const Icon(Icons.logout),
            ),

            MaterialButton(
              onPressed: () async {
                final authBloc = context.read<AuthBloc>();

                final repo = UserRepository(
                  accessToken: authBloc.accessToken ?? 'INVALID_TOKEN',
                  refreshToken: authBloc.refreshToken ?? '',
                  authBloc: authBloc,
                );
                try {
                  final result = await repo.fetchUserData();
                  setState(() {
                    userData = result;
                  });
                } catch (e) {
                  print("❌ Error getting user data: $e");
                }
              },
              child: const Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}
