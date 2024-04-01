import 'package:shared_preferences/shared_preferences.dart';

class UserDataSource {
  final userIDKey = 'userIDKey';
  final tokenFCMKey = 'tokenFCMKey';

  void saveUser(String userID) async {
    final ref = await SharedPreferences.getInstance();
    await ref.setString(userIDKey, userID);
  }

  void saveTokenFCM(String token) async {
    final ref = await SharedPreferences.getInstance();
    await ref.setString(tokenFCMKey, token);
  }

  Future<String> getTokenFCM() async {
    final ref = await SharedPreferences.getInstance();
    return ref.getString(tokenFCMKey) ?? '';
  }
}
