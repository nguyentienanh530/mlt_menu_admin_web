part of 'user_bloc.dart';

sealed class UserEvent {}

final class UserCreated extends UserEvent {
  final User user;

  UserCreated({required this.user});
}

final class UpdateToken extends UserEvent {
  final String userID;
  final String token;

  UpdateToken({required this.userID, required this.token});
}

final class UserFecthed extends UserEvent {
  final String userID;

  UserFecthed({required this.userID});
}

final class UserUpdated extends UserEvent {
  final User user;

  UserUpdated({required this.user});
}

final class PasswordChanged extends UserEvent {
  PasswordChanged({required this.currentPassword, required this.newPassword});

  final String currentPassword;
  final String newPassword;
}

final class UsersFetched extends UserEvent {}
