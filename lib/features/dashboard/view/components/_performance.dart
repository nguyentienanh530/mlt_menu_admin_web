part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get performance {
    var dailyRevenue = context.watch<DailyRevenueCubit>().state;
    var totalPriceYesterday = context.watch<TotalPriceYesterday>().state;
    var percentInCome = 0;
    if (totalPriceYesterday != 0) {
      var percent = (dailyRevenue / totalPriceYesterday) * 100;
      var parseToDouble = double.parse((percent - 100).toString());
      percentInCome = parseToDouble.truncate();
      logger.d('percent: $percentInCome');
    } else {
      logger.d(
          'Tổng doanh thu của ngày trước đó là 0, không thể tính phần trăm.');
    }

    price() => Text(Ultils.currencyFormat(totalPriceYesterday),
        style: context.titleStyleMedium!.copyWith(
            fontWeight: FontWeight.bold, color: context.colorScheme.secondary));
    title() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('Hiệu suất'.toUpperCase())]);

    return Card(
        elevation: 10,
        child: SizedBox(
            height: context.sizeDevice.height,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildHeader([title()]),
              const SizedBox(height: 8),
              // price(),
              Expanded(
                child: SizedBox(
                    child: Row(children: [
                  Expanded(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildCircularPercentIndicator(
                                  context, percentInCome)))),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [const Text('Doanh thu hôm qua'), price()]))
                ])),
              )
            ])));
  }

  double _handlePercent(int percentInCome) {
    if ((percentInCome / 100) < 0) {
      return 0.0;
    } else if ((percentInCome / 100) > 1) {
      return 1.0;
    } else {
      return (percentInCome / 100);
    }
  }

  Widget _buildHeader(List<Widget> children) => Container(
      height: 40,
      color: context.colorScheme.primary.withOpacity(0.3),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children)));

  Widget _buildCircularPercentIndicator(
          BuildContext context, int percentInCome) =>
      FittedBox(
          fit: BoxFit.scaleDown,
          child: CircularPercentIndicator(
              backgroundColor: context.colorScheme.primary.withOpacity(0.3),
              radius: context.sizeDevice.height * 0.08,
              lineWidth: 13.0,
              animation: true,
              percent: _handlePercent(percentInCome),
              center: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$percentInCome%',
                            style: context.titleStyleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: percentInCome < 0
                                    ? Colors.red
                                    : Colors.green)),
                        const SizedBox(width: 8),
                        percentInCome < 0
                            ? const Icon(Icons.arrow_circle_down_rounded,
                                color: Colors.red)
                            : const Icon(Icons.arrow_circle_up_rounded,
                                color: Colors.green),
                      ])),
              footer: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("Doanh thu so với hôm qua",
                      style: context.titleStyleMedium)),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.green));
}
