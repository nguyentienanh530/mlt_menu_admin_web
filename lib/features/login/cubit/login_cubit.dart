import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void resetStatus() {
    emit(state.copyWith(status: FormzSubmissionStatus.initial));
  }

  Future<void> logInWithCredentials(
      {required String email, required String password}) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: email, password: password);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
            errorMessage: e.message, status: FormzSubmissionStatus.failure),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  // Future<void> logInWithGoogle() async {
  //   emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
  //   try {
  //     await _authenticationRepository.logInWithGoogle();
  //     emit(state.copyWith(status: FormzSubmissionStatus.success));
  //   } on LogInWithGoogleFailure catch (e) {
  //     emit(
  //       state.copyWith(
  //         errorMessage: e.message,
  //         status: FormzSubmissionStatus.failure,
  //       ),
  //     );
  //   } catch (_) {
  //     emit(state.copyWith(status: FormzSubmissionStatus.failure));
  //   }
  // }
}
