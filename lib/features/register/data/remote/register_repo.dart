import 'package:authentication_repository/authentication_repository.dart';

class RegisterRepo {
  final AuthenticationRepository _authenticationRepository;

  RegisterRepo({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  Future<void> register(
      {required String email, required String password}) async {
    await _authenticationRepository.signUp(email: email, password: password);
  }
}
