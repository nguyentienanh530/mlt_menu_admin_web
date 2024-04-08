import 'package:mlt_menu_admin_web/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin_web/common/widget/responsive.dart';
import 'package:mlt_menu_admin_web/features/print/view/screen/print_screen.dart';
import 'package:mlt_menu_admin_web/features/print/view/screen/print_setting.dart';
import 'package:mlt_menu_admin_web/features/user/bloc/user_bloc.dart';
import 'package:mlt_menu_admin_web/features/user/data/model/user_model.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:mlt_menu_admin_web/common/widget/common_bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin_web/features/user/view/screen/change_password.dart';
import 'package:mlt_menu_admin_web/features/user/view/screen/update_user.dart';

import '../../../../config/config.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../common/widget/loading_screen.dart';
import '../../../print/cubit/is_use_print_cubit.dart';
import '../../../print/data/print_data_source/print_data_source.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(), child: const ProfileView());
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() {
    if (!mounted) return;
    var userID = context.read<AuthBloc>().state.user.id;
    context.read<UserBloc>().add(UserFecthed(userID: userID));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
        buildWhen: (previous, current) =>
            context.read<UserBloc>().operation == ApiOperation.select,
        builder: (context, state) {
          return (switch (state.status) {
            Status.loading => const LoadingScreen(),
            Status.failure => ErrorScreen(errorMsg: state.error),
            Status.empty => const EmptyScreen(),
            Status.success => CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                        automaticallyImplyLeading:
                            Responsive.isDesktop(context) ? false : true,
                        expandedHeight: 300,
                        pinned: true,
                        stretch: true,
                        flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Container(
                                // padding: const EdgeInsets.only(bottom: 120),
                                margin: const EdgeInsets.only(bottom: 50),
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/image/backgroundProfile.png"))),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform.translate(
                                              offset: const Offset(0, 50),
                                              child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 50,
                                                  child: CircleAvatar(
                                                      radius: 49,
                                                      backgroundImage:
                                                          _buildImage(state
                                                                  .data ??
                                                              UserModel()))))
                                        ]))))),
                    SliverToBoxAdapter(
                        child: _buildBody(state.data ?? UserModel()))
                  ])
          });
        });
  }

  Widget _buildItem(BuildContext context, IconData icon, String title) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 15),
      const SizedBox(width: 3),
      Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5)))
    ]);
  }

  Widget _buildBody(UserModel user) {
    return SizedBox(
        height: context.sizeDevice.height,
        child: Column(
            children: [
          SizedBox(height: defaultPadding),
          Text(user.name),
          SizedBox(height: defaultPadding / 4),
          _buildItem(context, Icons.email_rounded, user.email),
          SizedBox(height: defaultPadding / 4),
          user.phoneNumber.isEmpty
              ? const SizedBox()
              : _buildItem(context, Icons.phone_android_rounded,
                  user.phoneNumber.toString()),
          const SizedBox(height: 16),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            _ItemProfile(
                svgPath: 'assets/icon/user_config.svg',
                title: 'Cập nhật thông tin',
                onTap: () => _handleUserUpdated(user)),
            _ItemProfile(
                svgPath: 'assets/icon/lock.svg',
                title: 'Đổi mật khẩu',
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        content:
                            SizedBox(width: 600, child: ChangePassword())))),
            _buildItemPrint(context),
            _ItemProfile(
                svgPath: 'assets/icon/logout.svg',
                title: 'Đăng xuất',
                onTap: () => _handleLogout())
          ])))
        ]
                .animate(interval: 50.ms)
                .slideX(
                    begin: -0.1,
                    end: 0,
                    curve: Curves.easeInOutCubic,
                    duration: 500.ms)
                .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)));
  }

  Widget _buildItemPrint(BuildContext context) {
    var isUsePrint = context.watch<IsUsePrintCubit>().state;

    return Column(children: [
      GestureDetector(
          onTap: () {},
          child: Card(
              child: SizedBox(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                Row(children: [
                  Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: SvgPicture.asset('assets/icon/print.svg',
                          colorFilter: ColorFilter.mode(
                              context.colorScheme.primary, BlendMode.srcIn))),
                  const Text('Sử dụng máy in')
                ]),
                Transform.scale(
                    scale: 0.8,
                    child: Switch(
                        activeTrackColor: context.colorScheme.secondary,
                        value: isUsePrint,
                        onChanged: (value) {
                          context
                              .read<IsUsePrintCubit>()
                              .onUsePrintChanged(value);
                          PrintDataSource.setIsUsePrint(value);
                        }))
              ])))),
      isUsePrint
          ? _ItemProfile(
              svgPath: 'assets/icon/file_setting.svg',
              title: 'Cấu hình máy in',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                        content: SizedBox(width: 600, child: PrintScreen())));
              })
          : const SizedBox()
    ]);
  }

  _buildImage(UserModel user) {
    return user.image.isEmpty
        ? const AssetImage('assets/icon/profile.png')
        : NetworkImage(user.image);
  }

  _handleUserUpdated(UserModel user) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(width: 600, child: UpdateUser(user: user)),
            )).then((result) {
      if (result is bool && result) {
        if (!mounted) return;
        var userID = context.read<AuthBloc>().state.user.id;
        context.read<UserBloc>().add(UserFecthed(userID: userID));
      }
    });
  }

  _handleLogout() async {
    // showCupertinoModalPopup<void>(
    //     context: context,
    //     builder: (context) => CommonBottomSheet(
    //         title: 'Chắc chắn muốn đăng xuất?',
    //         textCancel: 'Hủy',
    //         textConfirm: 'Đăng xuất',
    //         textConfirmColor: context.colorScheme.errorContainer,
    //         onConfirm: () {
    //           context.read<AuthBloc>().add(const AuthLogoutRequested());
    //           context.go(RouteName.login);
    //         }));

    await AppAlerts.warningDialog(context,
        title: 'Chắc chắn muốn đăng xuất?',
        textCancel: 'Hủy',
        textOk: 'Đăng xuất',
        btnCancelOnPress: () => context.pop(),
        btnOkOnPress: () {
          context.read<AuthBloc>().add(const AuthLogoutRequested());
          context.go(RouteName.login);
        });
  }
}

class _ItemProfile extends StatelessWidget {
  const _ItemProfile(
      {required this.svgPath, required this.title, required this.onTap});
  final String svgPath;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
            child: SizedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
              Row(children: [
                Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: SvgPicture.asset(svgPath,
                        colorFilter: ColorFilter.mode(
                            context.colorScheme.primary, BlendMode.srcIn))),
                Text(title)
              ]),
              Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 15))
            ]))));
  }
}

class _CardProfife extends StatelessWidget {
  const _CardProfife({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              user.image.isEmpty
                  ? _buildImageAsset(context)
                  : _buildImageNetwork(context),
              SizedBox(height: defaultPadding),
              Text(user.name),
              SizedBox(height: defaultPadding / 4),
              _buildItem(context, Icons.email_rounded, user.email),
              SizedBox(height: defaultPadding / 4),
              user.phoneNumber.isEmpty
                  ? const SizedBox()
                  : _buildItem(context, Icons.phone_android_rounded,
                      user.phoneNumber.toString())
            ])));
  }

  Widget _buildImageAsset(BuildContext context) {
    return Container(
        height: context.sizeDevice.width * 0.2,
        width: context.sizeDevice.width * 0.2,
        decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.primary),
            shape: BoxShape.circle,
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icon/profile.png'))));
  }

  Widget _buildImageNetwork(BuildContext context) {
    return Container(
        height: context.sizeDevice.width * 0.2,
        width: context.sizeDevice.width * 0.2,
        decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.primary),
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(user.image))));
  }

  Widget _buildItem(BuildContext context, IconData icon, String title) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 15),
      const SizedBox(width: 3),
      Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5)))
    ]);
  }
}
