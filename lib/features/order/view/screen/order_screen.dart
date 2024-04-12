import 'package:mlt_menu_admin_web/core/utils/extensions.dart';
import 'package:mlt_menu_admin_web/features/order/view/screen/order_history_screen.dart';
import 'package:flutter/material.dart';

import 'order_current_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var pageCtrl = PageController();
  final List<Widget> _widgetOptions = [
    const CurrentOrder(),
    // const OrderHistoryScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Danh sách đơn', style: context.titleStyleMedium)),
        body: SafeArea(
            child: Column(children: [
          _buildTabbar((index) => pageCtrl.jumpToPage(index)),
          Expanded(
              child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageCtrl,
                  children: _widgetOptions))
        ])));
  }

  Widget _buildTabbar(Function(int)? onTap) {
    return DefaultTabController(
        length: 2,
        child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            indicatorColor: context.colorScheme.secondary,
            onTap: onTap,
            tabs: const [Tab(text: 'Đơn hiện tại'), Tab(text: 'Lịch sử đơn')]));
  }
}
