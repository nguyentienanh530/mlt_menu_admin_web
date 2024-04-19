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
      return Column(children: [
        SizedBox(
            height: 100,
            child: Row(children: [
              _buildNewOrder(),
              orderOnDay,
              _buildItem(
                  svg: 'assets/icon/dinner_table.svg',
                  title: 'Bàn sử dụng',
                  value: tableIsUseNumber.toString())
            ])),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                        height: context.sizeDevice.height * 0.3,
                        child: Row(children: [
                          Expanded(child: dailyRevenue),
                          Expanded(child: performance)
                        ])),
                    const SizedBox(height: 16),
                    listTable,
                    const SizedBox(height: 16)
                  ])),
          const SizedBox(width: 16),
          Expanded(
              child: Column(children: [
            _leftInfo,
            const SizedBox(height: 16),
            _buildTitle(title: 'Món đặt nhiều'),
            const SizedBox(height: 16),
            const FoodBestSeller(),
            const SizedBox(height: 16)
          ]))
        ])
      ]);
    });
  }
}
