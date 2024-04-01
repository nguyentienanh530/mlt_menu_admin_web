import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../data/remote/register_repo.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(AuthenticationRepository authenticationRepository)
      : _authenticationRepository = authenticationRepository,
        super(const RegisterState());

  final AuthenticationRepository _authenticationRepository;

  void resetStatus() {
    emit(state.copyWith(status: FormzSubmissionStatus.initial));
  }

  Future<void> signUpFormSubmitted(
      {required String email, required String password}) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await RegisterRepo(authenticationRepository: _authenticationRepository)
          .register(email: email, password: password);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzSubmissionStatus.failure));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
