import 'package:mlt_menu_admin_web/common/firebase/firebase_base.dart';
import 'package:mlt_menu_admin_web/common/firebase/firebase_result.dart';
import 'package:mlt_menu_admin_web/features/user/data/model/user_model.dart';
import 'package:user_repository/user_repository.dart';

class UserRepo extends FirebaseBase<UserModel> {
  final UserRepository _userRepository;

  UserRepo({required UserRepository userRepository})
      : _userRepository = userRepository;
  Future<FirebaseResult<bool>> createUser(
      {required UserModel userModel}) async {
    return await createItem(
        _userRepository.createUser(userJson: userModel.toJson()));
  }

  Future<FirebaseResult<bool>> updateToken(
      {required String userID, required String token}) async {
    return await updateItem(
        _userRepository.updateAdminToken(userID: userID, token: token));
  }

  Future<FirebaseResult<UserModel>> getUser({required String userID}) async {
    return await getItem(
        await _userRepository.getUser(userID: userID), UserModel.fromJson);
  }

  Future<FirebaseResult<bool>> updateUser({required UserModel user}) async {
    return await updateItem(
        _userRepository.updateUser(userID: user.id!, userJson: user.toJson()));
  }

  Future<FirebaseResult<bool>> updatePassword(
      {required String currentPass, required String newPass}) async {
    return await updateItem(_userRepository.updatePassword(
        currentPassword: currentPass, newPassword: newPass));
  }

  Future<FirebaseResult<List<UserModel>>> getUsers() async {
    return await getItems(
        await _userRepository.getAllUser(), UserModel.fromJson);
  }
}
