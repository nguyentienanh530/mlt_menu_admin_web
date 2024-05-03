part of 'banner_bloc.dart';

class BannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BannerFetched extends BannerEvent {}

class BannerCreated extends BannerEvent {
  final BannerModel bannerModel;

  BannerCreated({required this.bannerModel});
}

class BannerDeleted extends BannerEvent {
  final BannerModel bannerModel;

  BannerDeleted({required this.bannerModel});
}
