import 'package:bloc_login/domain/repositories/auth_repository.dart';
import 'package:bloc_login/data/data_sources/auth_remote_data_source.dart';
import 'package:bloc_login/domain/entities/user_entity.dart';

class AuthRepo extends AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepo(this.remoteDataSource);
  @override
  Future<UserEntity> login(String email, String password) {
    final token = DateTime.now().millisecondsSinceEpoch.toString();
    return Future.value(
      UserEntity(token: token, email: email, password: password),
    );
  }
}
