import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  // final _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  UserRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUser() async {
    try {
      return await _firebaseFirestore.collection('users').get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(
      {required String userID}) async {
    try {
      return await _firebaseFirestore.collection('users').doc(userID).get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  // Future<void> deleteTable({required String idTable}) async {
  //   try {
  //     await _firebaseFirestore.collection('table').doc(idTable).delete();
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }

  Future<void> createUser({required Map<String, dynamic> userJson}) async {
    try {
      var userID = userJson['id'] as String;
      await _firebaseFirestore.collection('users').doc(userID).set(userJson);
      await createUserToken(userID: userID, tokenJson: {'token': ''});
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateUser(
      {required String userID, required Map<String, dynamic> userJson}) async {
    try {
      await _firebaseFirestore.collection('users').doc(userID).update(userJson);
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateAdminToken(
      {required String userID, required String token}) async {
    try {
      await _firebaseFirestore
          .collection('admin_tokens')
          .doc(userID)
          .update({'token': token});
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> createUserToken(
      {required String userID, required Map<String, dynamic> tokenJson}) async {
    try {
      await _firebaseFirestore
          .collection('admin_tokens')
          .doc(userID)
          .set(tokenJson);
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      final newUser = FirebaseAuth.instance.currentUser;
      var cred = EmailAuthProvider.credential(
          email: newUser!.email!, password: currentPassword);
      newUser.reauthenticateWithCredential(cred).then((value) {
        newUser.updatePassword(newPassword);
      });
    } catch (e) {
      throw '$e';
    }
  }
}
