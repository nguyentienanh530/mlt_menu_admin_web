import 'package:cloud_firestore/cloud_firestore.dart';

class TableRepository {
  // final _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  TableRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTable() async {
    try {
      return await _firebaseFirestore.collection('table').get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTablesOnStream() {
    try {
      return _firebaseFirestore.collection('table').snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteTable({required String idTable}) async {
    try {
      await _firebaseFirestore.collection('table').doc(idTable).delete();
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> createTable({required Map<String, dynamic> dataJson}) async {
    try {
      var documentReference =
          await _firebaseFirestore.collection('table').add(dataJson);
      await updateTable(
          tableID: documentReference.id,
          dataJson: {'id': documentReference.id});
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateTable(
      {required String tableID, required Map<String, dynamic> dataJson}) async {
    try {
      await _firebaseFirestore
          .collection('table')
          .doc(tableID)
          .update(dataJson);
    } catch (e) {
      throw '$e';
    }
  }
}
