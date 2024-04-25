part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get web {
    return Builder(builder: (context) {
      var tableState = context.watch<TableBloc>().state.datas;
      var tableIsUseNumber = 0;

      for (var element in tableState ?? <TableModel>[]) {
        if (element.isUse) {
          tableIsUseNumber++;
        }
      }
      return SizedBox(
          height: context.sizeDevice.height,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      SizedBox(
                          height: 100,
                          child: Row(children: [
                            _buildNewOrder(),
                            orderOnDay,
                            _buildItem(
                                icon: Icons.dining_rounded,
                                title: 'Bàn sử dụng',
                                value: tableIsUseNumber.toString())
                          ])),
                      const SizedBox(height: 16),
                      SizedBox(
                          height: 300,
                          child: Row(children: [
                            Expanded(child: dailyRevenue),
                            Expanded(child: performance)
                          ])),
                      const SizedBox(height: 16),
                      listTable,
                      const SizedBox(height: 16)
                    ]))),
                Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: Column(children: [
                              _leftInfo,
                              const SizedBox(height: 16),
                              _buildTitle(title: 'Món đặt nhiều'),
                              const SizedBox(height: 16),
                              const FoodBestSeller(),
                              const SizedBox(height: 16)
                            ]))))
              ]));
    });
  }
}
