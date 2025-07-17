import 'package:bloc_login/data/data_sources/auth_remote_data_source.dart';
import 'package:bloc_login/data/repositories/auth_repo.dart';
import 'package:bloc_login/domain/repositories/auth_repository.dart';
import 'package:bloc_login/domain/use_cases/login_use_case.dart';
import 'package:bloc_login/presentation/bloc/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_login/data/helpers/auth_local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Register SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => prefs);
  // Register Dio
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );

  // Register AuthRepository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepo(locator<AuthRemoteDataSource>()),
  );

  // Register Use Cases
  locator.registerFactory(() => LoginUseCase(locator<AuthRepository>()));

  // Register Blocs
  locator.registerFactory<AuthBloc>(() => AuthBloc(locator<LoginUseCase>()));

  locator.registerLazySingleton(
    () => AuthLocalStorage(locator<SharedPreferences>()),
  );
}
