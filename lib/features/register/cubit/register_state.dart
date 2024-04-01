part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final FormzSubmissionStatus status;

  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
