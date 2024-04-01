import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrderOnTable(
      {String? tableID}) {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where("tableID", isEqualTo: tableID)
          .where("status", isEqualTo: 'new')
          .snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> getOrders(
  //     {required String nameTable}) {
  //   try {
  //     return _firebaseFirestore
  //         .collection("AllOrder")
  //         .where("table", isEqualTo: nameTable)
  //         .where("isPay", isEqualTo: false)
  //         .get();
  //   } on FirebaseException catch (e) {
  //     throw '$e';
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }

  Future<QuerySnapshot<Map<String, dynamic>>> getOrders(
      {required String tableID}) async {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where("tableID", isEqualTo: tableID)
          .where("status", isEqualTo: 'new')
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getHistoryOrder() {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where("status", isEqualTo: 'success')
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersOnDay() {
    try {
      return _firebaseFirestore
          .collection("orders")
          .orderBy('payTime', descending: false)
          .where("status", isEqualTo: 'success')
          .snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllOrderOnDay() {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where('status', isEqualTo: 'success')
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNewOrder() {
    try {
      return _firebaseFirestore
          .collection("orders")
          .where('status', isEqualTo: 'new')
          .snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrderByID(
      {required String orderID}) async {
    try {
      return await _firebaseFirestore.collection("orders").doc(orderID).get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateOrder({required Map<String, dynamic> jsonData}) async {
    var orderID = jsonData['id'];
    try {
      await _firebaseFirestore
          .collection('orders')
          .doc(orderID)
          .update(jsonData);
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteOrder({required String orderID}) async {
    try {
      await _firebaseFirestore.collection('orders').doc(orderID).delete();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> paymentOrder({required String orderID}) async {
    try {
      await _firebaseFirestore
          .collection('orders')
          .doc(orderID)
          .update({'status': 'success', "payTime": DateTime.now().toString()});
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }
}
