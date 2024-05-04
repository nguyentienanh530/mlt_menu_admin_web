import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin/common/widget/error_screen.dart';
import 'package:mlt_menu_admin/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin/common/widget/responsive.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:mlt_menu_admin/features/banner/bloc/banner_bloc.dart';

import '../../../../common/dialog/app_alerts.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_icon_button.dart';
import '../../data/model/banner_model.dart';
import 'create_banner.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BannerBloc()..add(BannerFetched()),
        child: const BannerView());
  }
}

class BannerView extends StatefulWidget {
  const BannerView({super.key});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  _getData() {
    if (!mounted) return;
    context.read<BannerBloc>().add(BannerFetched());
  }

  Widget _buildAddBanner() {
    return FloatingActionButton(
        mouseCursor: MaterialStateMouseCursor.clickable,
        tooltip: 'Thêm Banner',
        backgroundColor: context.colorScheme.secondary,
        onPressed: () => _showDialogCreateBanner(),
        child: const Icon(Icons.add));
  }

  void _showDialogCreateBanner() {
    showDialog(
        useSafeArea: false,
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: SizedBox(width: 600, child: CreateBanner()));
        }).then((value) async {
      if (value is bool && value) {
        _getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _buildAddBanner(),
        body: Builder(builder: (context) {
          var bannerState = context.watch<BannerBloc>().state;
          return switch (bannerState.status) {
            Status.loading => const LoadingScreen(),
            Status.empty => const EmptyScreen(),
            Status.failure => ErrorScreen(errorMsg: bannerState.error ?? ''),
            Status.success => Responsive(
                mobile: _buildBodyMobile(bannerState.datas ?? <BannerModel>[]),
                tablet: _buildBodyMobile(bannerState.datas ?? <BannerModel>[]),
                desktop: _buildBodyWeb(bannerState.datas ?? <BannerModel>[]))
          };
        }));
  }

  Widget _buildBodyMobile(List<BannerModel> banners) {
    return SizedBox(
        height: context.sizeDevice.height,
        child: ListView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return _buildBannerItem(banners[index], index);
            }));
  }

  Widget _buildBodyWeb(List<BannerModel> banners) {
    return SizedBox(
        height: context.sizeDevice.height,
        child: Row(children: [
          const Spacer(),
          Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: ListView.builder(
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    return _buildBannerItem(banners[index], index);
                  })),
          const Spacer()
        ]));
  }

  Widget _buildBannerItem(BannerModel bannerModel, int index) {
    return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            height: context.sizeDevice.height * 0.3,
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(bannerModel, index),
                  Expanded(
                      child: Image.network(bannerModel.image ?? noImage,
                          fit: BoxFit.cover))
                ])));
  }

  Widget _buildHeader(BannerModel bannerModel, int index) => Container(
      height: 50,
      color: context.colorScheme.primary.withOpacity(0.3),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('#${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [
              const SizedBox(width: 8),
              CommonIconButton(
                  icon: Icons.delete,
                  color: context.colorScheme.errorContainer,
                  onTap: () => _buildDeleteBanner(bannerModel))
            ])
          ])));

  _buildDeleteBanner(BannerModel bannerModel) {
    AppAlerts.warningDialog(
      context,
      title: "Bạn có muốn xóa Banner này không?",
      textOk: 'Xóa',
      textCancel: "Hủy",
      btnCancelOnPress: () => context.pop(),
      btnOkOnPress: () => _handleDeleteBanner(bannerModel),
    );
  }

  void _handleDeleteBanner(BannerModel bannerModel) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
              create: (context) =>
                  BannerBloc()..add(BannerDeleted(bannerModel: bannerModel)),
              child: Builder(builder: (context) {
                var state = context.watch<BannerBloc>().state;
                return switch (state.status) {
                  Status.empty => const SizedBox(),
                  Status.loading => const ProgressDialog(
                      isProgressed: true, descriptrion: 'Đang xóa'),
                  Status.failure => RetryDialog(
                      title: state.error ?? "Lỗi",
                      onRetryPressed: () => context
                          .read<BannerBloc>()
                          .add(BannerDeleted(bannerModel: bannerModel))),
                  Status.success => ProgressDialog(
                      descriptrion: 'Xóa thành công',
                      onPressed: () {
                        FToast()
                          ..init(context)
                          ..showToast(
                              child: AppAlerts.successToast(
                                  msg: 'Xóa thành công!'));
                        pop(context, 1);
                        _getData();
                      },
                      isProgressed: false)
                };
              }));
        });
  }
}
