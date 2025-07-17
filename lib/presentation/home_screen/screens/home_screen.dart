import 'package:bloc_login/core/dio/api_client.dart';
import 'package:bloc_login/core/dio/get_request.dart';
import 'package:bloc_login/core/storage/app_storage.dart';
import 'package:bloc_login/presentation/auth/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bloc_login/presentation/auth/bloc/auth_bloc.dart';
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

              Row(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      try {
                        final dio = ApiClient().dio;
                        final response = await dio.get('user/me');

                        // Step 2: If success, show data
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('✅ Data: ${response.data}')),
                        );
                      } on DioException catch (e) {
                        if (e.response?.statusCode == 401) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Token expired... refreshing...'),
                            ),
                          );
                        }

                        //Retrying the request
                        final retry = await GetRequest.get('user/me');

                        if (retry != null && retry.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ Data (after refresh): ${retry.data}',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Failed even after refresh'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Fetch Data'),
                  ),

                  SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () async {
                      //Expire token manually for testing

                      await AppStorage.instance.saveAccessToken(
                        'expired_token',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token expired manually')),
                      );
                    },
                    child: const Text('Test expired token'),
                  ),
                ],
              ),
              if (userData != null)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    'Fetched Data:\n\n$userData',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
