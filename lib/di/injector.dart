import 'package:bloc_login/domain/repositories/auth_repository.dart';
import 'package:bloc_login/presentation/auth/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Register SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => prefs);
  // Register Dio
  locator.registerFactory<AuthBloc>(() => AuthBloc());
  // Register Use Cases

  // Register Blocs
}
