part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get listTable => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                height: 50,
                child: Center(child: _buildTitle(title: 'Danh sách bàn ăn'))),
            const _ListTable(isScroll: false),
            SizedBox(height: defaultPadding)
          ]);
}

class _ListTable extends StatelessWidget {
  const _ListTable({required this.isScroll});
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    var tableState = context.watch<TableBloc>().state;
    switch (tableState.status) {
      case Status.empty:
        return const EmptyWidget();
      case Status.loading:
        return const LoadingScreen();
      case Status.failure:
        return ErrorWidgetCustom(errorMessage: tableState.error ?? '');
      case Status.success:
        var newTables = [...tableState.datas ?? <TableModel>[]];
        newTables.sort((a, b) => a.name.compareTo(b.name));
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 100),
            physics: isScroll
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newTables.length,
            itemBuilder: (context, index) =>
                ItemTable(table: newTables[index]));
    }
  }

  int countGridView(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return 6;
    } else if (Responsive.isTablet(context)) {
      return 6;
    } else {
      return 4;
    }
  }
}
