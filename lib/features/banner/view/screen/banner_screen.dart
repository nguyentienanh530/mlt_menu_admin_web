import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/widget/empty_screen.dart';
import 'package:mlt_menu_admin/common/widget/error_screen.dart';
import 'package:mlt_menu_admin/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:mlt_menu_admin/features/banner/bloc/banner_bloc.dart';

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
            Status.success => _buildBody()
          };
        }));
  }

  Widget _buildBody() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildBannerItem();
      },
    );
  }

  Widget _buildBannerItem() {
    return SizedBox();
  }

  // Widget
}
