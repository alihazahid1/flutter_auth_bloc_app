import 'package:bloc/bloc.dart';
import 'package:bloc_login/core/dio/post_request.dart';
import 'package:bloc_login/core/storage/app_storage.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? accessToken;
  String? refreshToken;
  String? username;
  String? password;

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        username = event.username;
        password = event.password;

        final response = await PostRequest.postFullUrl(
          'https://whale-app-pqthm.ondigitalocean.app/api/v0/auth/',
          {'login': username, 'password': password},
        );

        if (response != null && response.statusCode == 200) {
          final accessToken = response.data['accessToken'];
          final refreshToken = response.data['refreshToken'];

          await AppStorage.instance.saveAccessToken(accessToken);
          await AppStorage.instance.saveRefreshToken(refreshToken);

          emit(AuthSuccess());
        } else {
          emit(AuthFailure('Login failed: Invalid credentials'));
        }
      } catch (e) {
        emit(AuthFailure('Login failed: ${e.toString()}'));
      }
    });
  }
}
