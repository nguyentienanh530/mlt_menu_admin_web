import 'dart:async';

import 'package:banner_repository/banner_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/features/banner/data/model/banner_model.dart';
import 'package:mlt_menu_admin/features/banner/data/provider/banner_repo.dart';

part 'banner_event.dart';

typedef Emit = Emitter<GenericBlocState<BannerModel>>;

class BannerBloc extends Bloc<BannerEvent, GenericBlocState<BannerModel>>
    with BlocHelper<BannerModel> {
  BannerBloc() : super(GenericBlocState.loading()) {
    on<BannerFetched>(_fetchBanner);
    on<BannerCreated>(_createBanner);
    on<BannerDeleted>(_deleteBanner);
  }
  final _bannerRepository = BannerRepo(
      bannerRepository:
          BannerRepository(firebaseFirestore: FirebaseFirestore.instance));
  FutureOr<void> _fetchBanner(BannerFetched event, Emit emit) async {
    await getItems(_bannerRepository.getBanner(), emit);
  }

  FutureOr<void> _createBanner(BannerCreated event, Emit emit) async {
    await createItem(
        _bannerRepository.createBanner(bannerModel: event.bannerModel), emit);
  }

  FutureOr<void> _deleteBanner(BannerDeleted event, Emit emit) async {
    await deleteItem(
        _bannerRepository.deleteBanner(printModel: event.bannerModel), emit);
  }
}
