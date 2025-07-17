import 'package:bloc_login/data/helpers/auth_local_storage.dart';
import 'package:bloc_login/di/injector.dart';
import 'package:bloc_login/presentation/bloc/bloc/auth_bloc.dart';
import 'package:bloc_login/presentation/screens/home_screen.dart';
import 'package:bloc_login/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the dependency injection
  await init();

  final isLoggedIn = locator<AuthLocalStorage>().isLoggedIn();
  // ignore: unused_local_variable
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: isLoggedIn ? HomeScreen() : LoginScreen(isLoggedIn: isLoggedIn),
      ),
    );
  }
}
