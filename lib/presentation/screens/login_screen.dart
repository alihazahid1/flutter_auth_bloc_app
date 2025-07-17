import 'package:bloc_login/presentation/bloc/bloc/auth_bloc.dart';
import 'package:bloc_login/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  final bool isLoggedIn;
  const LoginScreen({super.key, required this.isLoggedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AuthFailure) {
                return Center(child: Text(state.message));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              username: _usernameController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                        },
                        color: Colors.blue,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
