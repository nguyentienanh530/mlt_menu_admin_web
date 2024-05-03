import 'package:cloud_firestore/cloud_firestore.dart';

class BannerRepository {
  // final _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  BannerRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getBanners() async {
    try {
      return await _firebaseFirestore.collection('banner').get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteBanner({required String bannerID}) async {
    try {
      await _firebaseFirestore.collection('banner').doc(bannerID).delete();
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> createBanner({required Map<String, dynamic> dataJson}) async {
    try {
      var documentReference =
          await _firebaseFirestore.collection('banner').add(dataJson);
      await updateBanner(
          bannerID: documentReference.id,
          dataJson: {'id': documentReference.id});
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateBanner(
      {required String bannerID,
      required Map<String, dynamic> dataJson}) async {
    try {
      await _firebaseFirestore
          .collection('banner')
          .doc(bannerID)
          .update(dataJson);
    } catch (e) {
      throw '$e';
    }
  }
}
