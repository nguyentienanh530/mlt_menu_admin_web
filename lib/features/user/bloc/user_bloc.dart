import 'dart:async';

import 'package:mlt_menu_admin/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/features/user/data/provider/remote/user_repo.dart';
import 'package:mlt_menu_admin/features/user/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';

typedef Emit = Emitter<GenericBlocState<UserModel>>;
typedef User = UserModel;

class UserBloc extends Bloc<UserEvent, GenericBlocState<User>>
    with BlocHelper<User> {
  UserBloc() : super(GenericBlocState.loading()) {
    on<UserCreated>(_createUser);
    on<UpdateToken>(_updateToken);
    on<UserFecthed>(_getUser);
    on<UserUpdated>(_updateUser);
    on<PasswordChanged>(_changedPassword);
    on<UsersFetched>(_fetchUsers);
  }

  final _userRepository = UserRepo(
      userRepository:
          UserRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _createUser(UserCreated event, Emit emit) async {
    await createItem(_userRepository.createUser(userModel: event.user), emit);
  }

  FutureOr<void> _updateToken(UpdateToken event, Emit emit) async {
    await updateItem(
        _userRepository.updateToken(userID: event.userID, token: event.token),
        emit);
  }

  FutureOr<void> _getUser(UserFecthed event, Emit emit) async {
    await getItem(_userRepository.getUser(userID: event.userID), emit);
  }

  FutureOr<void> _updateUser(
      UserUpdated event, Emitter<GenericBlocState<User>> emit) async {
    await updateItem(_userRepository.updateUser(user: event.user), emit);
  }

  FutureOr<void> _changedPassword(PasswordChanged event, Emit emit) async {
    await updateItem(
        _userRepository.updatePassword(
            currentPass: event.currentPassword, newPass: event.newPassword),
        emit);
  }

  FutureOr<void> _fetchUsers(
      UsersFetched event, Emitter<GenericBlocState<User>> emit) async {
    await getItems(_userRepository.getUsers(), emit);
  }
}
