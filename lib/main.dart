import 'package:bloc_login/core/storage/app_storage.dart';
import 'package:bloc_login/di/injector.dart';
import 'package:bloc_login/presentation/auth/bloc/auth_bloc.dart';
import 'package:bloc_login/presentation/home_screen/screens/home_screen.dart';
import 'package:bloc_login/presentation/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.instance.init();
  // Initialize the dependency injection
  await init();

  final isLoggedIn = AppStorage.instance.accessToken != null;
  // ignore: unused_local_variable

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
