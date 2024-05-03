import 'package:banner_repository/banner_repository.dart';
import 'package:mlt_menu_admin/features/banner/data/model/banner_model.dart';
import '../../../../../common/firebase/firebase_base.dart';
import '../../../../../common/firebase/firebase_result.dart';

class BannerRepo extends FirebaseBase<BannerModel> {
  final BannerRepository _bannerRepository;

  BannerRepo({required BannerRepository bannerRepository})
      : _bannerRepository = bannerRepository;

  Future<FirebaseResult<List<BannerModel>>> getBanner() async {
    return await getItems(
        await _bannerRepository.getBanners(), BannerModel.fromJson);
  }

  Future<FirebaseResult<bool>> createBanner(
      {required BannerModel bannerModel}) async {
    return await createItem(
        _bannerRepository.createBanner(dataJson: bannerModel.toJson()));
  }

  Future<FirebaseResult<bool>> updateBanner(
      {required BannerModel bannerModel}) async {
    return await updateItem(_bannerRepository.updateBanner(
        bannerID: bannerModel.id ?? '', dataJson: bannerModel.toJson()));
  }

  Future<FirebaseResult<bool>> deleteBanner(
      {required BannerModel printModel}) async {
    return await deleteItem(
        _bannerRepository.deleteBanner(bannerID: printModel.id ?? ''));
  }
}
