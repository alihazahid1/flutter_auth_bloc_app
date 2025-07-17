import 'package:bloc_login/domain/entities/user_entity.dart';
import 'package:bloc_login/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<UserEntity> call(String email, String password) async {
    return await authRepository.login(email, password);
  }
}
