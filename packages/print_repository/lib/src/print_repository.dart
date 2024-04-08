import 'package:cloud_firestore/cloud_firestore.dart';

class PrintRepository {
  // final _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  PrintRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getPrints() async {
    try {
      return await _firebaseFirestore.collection('prints').get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deletePrint({required String printID}) async {
    try {
      await _firebaseFirestore.collection('prints').doc(printID).delete();
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> createPrint({required Map<String, dynamic> dataJson}) async {
    try {
      var documentReference =
          await _firebaseFirestore.collection('prints').add(dataJson);
      await updatePrint(
          printID: documentReference.id,
          dataJson: {'id': documentReference.id});
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updatePrint(
      {required String printID, required Map<String, dynamic> dataJson}) async {
    try {
      await _firebaseFirestore
          .collection('prints')
          .doc(printID)
          .update(dataJson);
    } catch (e) {
      throw '$e';
    }
  }

  // Future<void> updateStatusTable(
  //     {required Map<String, dynamic> dataJson}) async {
  //   var tableID = dataJson['id'] as String;
  //   try {
  //     await _firebaseFirestore
  //         .collection('table')
  //         .doc(tableID)
  //         .update(dataJson);
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }
}
