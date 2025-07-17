import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_login/domain/use_cases/login_use_case.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? accessToken;
  String? refreshToken;
  String? username;
  String? password;

  final LoginUseCase loginUser;
  AuthBloc(this.loginUser) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        username = event.username;
        password = event.password;
        final user = await loginUser(event.username, event.password);

        emit(AuthSuccess());
        print("User Token: ${user.token}");
      } catch (e) {
        emit(AuthFailure('Login failed: ${e.toString()}'));
      }
    });
  }
}
