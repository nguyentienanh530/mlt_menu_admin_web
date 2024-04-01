import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository {
  // final _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getCategories() async {
    try {
      var res = await _firebaseFirestore.collection('category').get();
      return res;
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    try {
      var doc = await _firebaseFirestore.collection('category').add(data);
      await updateCategory(categoryID: doc.id, data: {'id': doc.id});
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateCategory(
      {required String categoryID, required Map<String, dynamic> data}) async {
    try {
      await _firebaseFirestore
          .collection('category')
          .doc(categoryID)
          .update(data);
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteCategory({required String categoryID}) async {
    try {
      await _firebaseFirestore.collection('category').doc(categoryID).delete();
    } catch (e) {
      throw '$e';
    }
  }
}
