import 'package:mlt_menu_admin_web/common/firebase/firebase_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseBase<T> {
  late final T data;

  Future<FirebaseResult<bool>> _requestMethodTemplate(
      Future<void> firebaseCallback) async {
    try {
      await firebaseCallback;
      return const FirebaseResult.success(true);
    } on FirebaseException catch (e) {
      return FirebaseResult.failure(e.toString());
    } catch (e) {
      return FirebaseResult.failure(e.toString());
    }
  }

  Future<FirebaseResult<bool>> createItem(Future<void> firebaseCallback) async {
    return _requestMethodTemplate(firebaseCallback);
  }

  Future<FirebaseResult<bool>> updateItem(Future<void> firebaseCallback) async {
    return _requestMethodTemplate(firebaseCallback);
  }

  Future<FirebaseResult<bool>> deleteItem(Future<void> firebaseCallback) async {
    return _requestMethodTemplate(firebaseCallback);
  }

  Future<FirebaseResult<List<T>>> getItems(
      QuerySnapshot<Map<String, dynamic>> firebaseCallback,
      T Function(Map<String, dynamic> json) getJsonCallback) async {
    try {
      final List<Map<String, dynamic>> dataList = firebaseCallback.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data())
          .toList();

      final List<T> typedList =
          dataList.map((item) => getJsonCallback(item)).toList();
      return FirebaseResult.success(typedList);
    } on FirebaseException catch (e) {
      final errorMessage = e.toString();
      return FirebaseResult.failure(errorMessage);
    } catch (e) {
      return FirebaseResult.failure(e.toString());
    }
  }

  Stream<FirebaseResult<List<T>>> getItemsOnStream(
      Stream<QuerySnapshot<Map<String, dynamic>>> firebaseCallback,
      T Function(Map<String, dynamic> json) getJsonCallback) {
    try {
      return firebaseCallback.map((event) {
        final List<Map<String, dynamic>> dataList = event.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) => e.data())
            .toList();

        final List<T> typedList =
            dataList.map((item) => getJsonCallback(item)).toList();
        return FirebaseResult.success(typedList);
      });
    } on FirebaseException catch (e) {
      final errorMessage = e.toString();
      throw FirebaseResult.failure(errorMessage);
    } catch (e) {
      throw FirebaseResult.failure(e.toString());
    }
  }

  Stream<FirebaseResult<T>> getItemOnStream(
      Stream<DocumentSnapshot<Map<String, dynamic>>> firebaseCallback,
      T Function(Map<String, dynamic> json) getJsonCallback) {
    try {
      return firebaseCallback.map((event) {
        final Map<String, dynamic> dataList = event.data()!;

        final T typedList = getJsonCallback(dataList);
        return FirebaseResult.success(typedList);
      });
    } on FirebaseException catch (e) {
      final errorMessage = e.toString();
      throw FirebaseResult.failure(errorMessage);
    } catch (e) {
      throw FirebaseResult.failure(e.toString());
    }
  }

  Future<FirebaseResult<T>> getItem(
      DocumentSnapshot<Map<String, dynamic>> firebaseCallback,
      T Function(Map<String, dynamic> json) getJsonCallback) async {
    try {
      final Map<String, dynamic>? dataList = firebaseCallback.data();

      final T typedList = getJsonCallback(dataList!);

      return FirebaseResult.success(typedList);
    } on FirebaseException catch (e) {
      final errorMessage = e.toString();
      return FirebaseResult.failure(errorMessage);
    } catch (e) {
      return FirebaseResult.failure(e.toString());
    }
  }
}
