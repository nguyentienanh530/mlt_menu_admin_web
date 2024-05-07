import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/common/widget/responsive.dart';
import 'package:mlt_menu_admin/config/config.dart';
import 'package:mlt_menu_admin/core/utils/extensions.dart';

class CommonSideMenu extends StatelessWidget {
  const CommonSideMenu(
      {super.key, required this.globalKey, required this.controller});
  final GlobalKey<ScaffoldState> globalKey;
  final SideMenuController controller;

  _handelCloseDrawer(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      globalKey.currentState!.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        margin: const EdgeInsets.only(top: 16, bottom: 16),
        child: SideMenu(
            controller: controller,
            style: SideMenuStyle(
                // showTooltip: false,
                displayMode: SideMenuDisplayMode.open,
                showHamburger: false,
                hoverColor: context.colorScheme.primary.withOpacity(0.3),
                selectedHoverColor:
                    context.colorScheme.primary.withOpacity(0.3),
                selectedColor: context.colorScheme.primary,
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
                unselectedIconColorExpandable: Colors.white,
                selectedIconColorExpandable: Colors.white,
                unselectedIconColor: Colors.white,
                arrowOpen: Colors.white,
                arrowCollapse: Colors.white,
                unselectedTitleTextStyle: const TextStyle(color: Colors.white),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                itemOuterPadding: const EdgeInsets.all(5),
                itemBorderRadius: const BorderRadius.all(Radius.circular(5.0))),
            title: Column(children: [
              const SizedBox(height: 16),
              GestureDetector(
                  onTap: () => context.go(RouteName.home),
                  child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxHeight: 150, maxWidth: 150),
                      child: Image.asset("assets/image/logo.png"))),
              const Divider(indent: 8.0, endIndent: 8.0)
            ]),
            footer: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                    height: 100,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Divider(indent: 8.0, endIndent: 8.0),
                          // const SizedBox(height: 16),
                          Expanded(
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('Minh Long Technology',
                                      style: context.titleStyleMedium!.copyWith(
                                          fontWeight: FontWeight.bold)))),
                          Expanded(
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('0799909487',
                                      style: context.textStyleSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.white.withOpacity(0.3))))),
                          Expanded(
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                      'Tổ 21 Finom - Hiệp Thạnh - Đức Trọng - Lâm Đồng',
                                      textAlign: TextAlign.center,
                                      style: context.textStyleSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.white.withOpacity(0.3)))))
                        ]))),
            items: [
              SideMenuItem(
                  title: 'Dashboard',
                  onTap: (index, _) {
                    _handelCloseDrawer(context);
                    controller.changePage(index);
                    context.go(RouteName.dashboard);
                  },
                  iconWidget: SvgPicture.asset("assets/icon/home.svg",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                  tooltipContent: "This is a tooltip for Dashboard item"),
              SideMenuExpansionItem(
                  title: "Món ăn",
                  iconWidget: SvgPicture.asset("assets/icon/food.svg",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                  children: [
                    SideMenuItem(
                        title: 'Đang hiển thị',
                        onTap: (index, _) {
                          _handelCloseDrawer(context);
                          controller.changePage(index);
                          context.goNamed(RouteName.listFood,
                              pathParameters: {'show': 'show'});
                        }),
                    SideMenuItem(
                        title: 'Đang ẩn',
                        onTap: (index, _) {
                          _handelCloseDrawer(context);
                          controller.changePage(index);
                          context.goNamed(RouteName.listFood,
                              pathParameters: {'show': 'hide'});
                        })
                  ]),
              SideMenuExpansionItem(
                  title: "Đơn hàng",
                  iconWidget: SvgPicture.asset("assets/icon/ordered.svg",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
                  children: [
                    SideMenuItem(
                        title: 'Đơn hiện tại',
                        onTap: (index, _) {
                          _handelCloseDrawer(context);
                          controller.changePage(index);
                          context.go(RouteName.currentOrder);
                        }),
                    SideMenuItem(
                        title: 'Lịch sử đơn',
                        onTap: (index, _) {
                          _handelCloseDrawer(context);
                          controller.changePage(index);
                          context.go(RouteName.historyOrder);
                        })
                  ]),
              SideMenuItem(
                  title: 'Bàn ăn',
                  onTap: (index, _) {
                    _handelCloseDrawer(context);
                    controller.changePage(index);
                    context.go(RouteName.table);
                  },
                  iconWidget: SvgPicture.asset("assets/icon/chair.svg",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              SideMenuItem(
                  title: 'Danh mục',
                  onTap: (index, _) {
                    _handelCloseDrawer(context);
                    controller.changePage(index);
                    context.go(RouteName.categoriesScreen);
                  },
                  iconWidget: SvgPicture.asset("assets/icon/category.svg",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              SideMenuItem(
                  title: 'Banner',
                  onTap: (index, _) {
                    _handelCloseDrawer(context);
                    controller.changePage(index);
                    context.go(RouteName.banner);
                  },
                  iconWidget: SvgPicture.asset("assets/icon/images.svg",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              SideMenuItem(
                  title: 'Cài đặt',
                  onTap: (index, _) {
                    _handelCloseDrawer(context);
                    controller.changePage(index);
                    context.go(RouteName.profile);
                  },
                  iconWidget: SvgPicture.asset("assets/icon/setting.svg",
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)))
            ]));
  }
}
