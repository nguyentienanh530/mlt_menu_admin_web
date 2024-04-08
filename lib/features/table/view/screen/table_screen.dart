import 'package:mlt_menu_admin_web/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin_web/common/widget/common_refresh_indicator.dart';
import 'package:mlt_menu_admin_web/features/table/bloc/table_bloc.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin_web/features/table/view/screen/create_or_update_table.dart';
import '../../../../common/bloc/bloc_helper.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_icon_button.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../../../common/widget/responsive.dart';
import '../../data/model/table_model.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../common/widget/loading_screen.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: CustomScrollView(slivers: [
      SliverAppBar(
          title: Text('Danh sách bàn ăn',
              style: context.titleStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
          pinned: true,
          stretch: true,
          automaticallyImplyLeading:
              Responsive.isDesktop(context) ? false : true,
          actions: [
            FilledButton.icon(
                onPressed: () async {
                  await showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                              content: SizedBox(
                                  width: 600,
                                  child:
                                      CreateOrUpdateTable(mode: Mode.create))))
                      .then((value) {
                    if (value != null && value) {
                      getData();
                    }
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm bàn'))
          ]),
      const SliverToBoxAdapter(child: TableView())
    ]));
  }

  getData() async {
    if (!mounted) return;
    context.read<TableBloc>().add(TablesFetched());
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        heroTag: 'addTable',
        backgroundColor: context.colorScheme.secondary,
        onPressed: () async {
          await showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                      content: SizedBox(
                          width: 600,
                          child: CreateOrUpdateTable(mode: Mode.create))))
              .then((value) {
            if (value != null && value) {
              getData();
            }
          });
        },
        child: const Icon(Icons.add));
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text("Bàn ăn", style: context.titleStyleMedium));

  @override
  bool get wantKeepAlive => true;
}

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          if (!context.mounted) return;
          context.read<TableBloc>().add(TablesFetched());
        },
        child: BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
            buildWhen: (previous, current) =>
                context.read<TableBloc>().operation == ApiOperation.select,
            builder: (context, state) {
              switch (state.status) {
                case Status.loading:
                  return const LoadingScreen();
                case Status.failure:
                  return ErrorScreen(errorMsg: state.error);
                case Status.empty:
                  return const EmptyScreen();
                case Status.success:
                  var newTables = [...state.datas ?? <TableModel>[]];
                  newTables.sort((a, b) => a.name.compareTo(b.name));
                  return _buildBody(context, newTables);
              }
            }));
  }

  Widget _buildBody(BuildContext context, List<TableModel> tables) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: tables.length,
        itemBuilder: (context, index) =>
            _buildItem(context, tables[index], index),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: countGridView(context),
            // childAspectRatio: 1.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16));
  }

  void _dialogDeleted(BuildContext context, TableModel table) async {
    // showCupertinoModalPopup(
    //     context: context,
    //     builder: (context) => CommonBottomSheet(
    //           title: 'Chắc chắn muốn xóa bàn: ${table.name}?',
    //           textCancel: 'Hủy',
    //           textConfirm: 'Xóa',
    //           textConfirmColor: context.colorScheme.errorContainer,
    //           onConfirm: () => onDeleteTable(context, table),
    //         ));

    await AppAlerts.warningDialog(context,
        title: 'Chắc chắn muốn xóa bàn: ${table.name}?',
        desc: 'Kiểm tra kĩ trước khi xóa!',
        textCancel: 'Hủy',
        textOk: 'Xóa',
        btnCancelOnPress: () => context.pop(),
        btnOkOnPress: () => onDeleteTable(context, table));
  }

  Widget _buildActionSlidable(BuildContext context,
      {Function()? onTap, String? title, IconData? icon, Color? color}) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
              width: context.sizeDevice.width * 0.3,
              height: context.sizeDevice.width * 0.3,
              decoration: BoxDecoration(color: color),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icon!, size: 18), Text(title!)])),
        ));
  }

  void onDeleteTable(BuildContext context, TableModel table) {
    context.read<TableBloc>().add(TableDeleted(idTable: table.id!));

    showDialog(
        context: context,
        builder: (_) => BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
            buildWhen: (previous, current) =>
                context.read<TableBloc>().operation == ApiOperation.delete &&
                previous.status != current.status,
            builder: (context, state) {
              logger.d(state.status);

              return switch (state.status) {
                Status.empty => const SizedBox(),
                Status.loading => const ProgressDialog(
                    descriptrion: "Deleting post...", isProgressed: true),
                Status.failure => RetryDialog(
                    title: state.error ?? "Error",
                    onRetryPressed: () => context
                        .read<TableBloc>()
                        .add(TableDeleted(idTable: table.id!))),
                Status.success => ProgressDialog(
                    descriptrion: "Đã xoá bàn: ${table.name}",
                    onPressed: () {
                      context.read<TableBloc>().add(TablesFetched());
                      pop(context, 1);
                    },
                    isProgressed: false)
              };
            }));
  }

  Widget _buildHeader(BuildContext context, TableModel tableModel, int index) =>
      Container(
          height: 40,
          color: context.colorScheme.primary.withOpacity(0.3),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('#${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(children: [
                      CommonIconButton(
                          icon: Icons.edit,
                          onTap: () async =>
                              await _goToEditTable(context, tableModel)),
                      const SizedBox(width: 8),
                      CommonIconButton(
                          icon: Icons.delete,
                          color: context.colorScheme.errorContainer,
                          onTap: () => _dialogDeleted(context, tableModel))
                    ])
                  ])));

  Widget _buildItem(BuildContext context, TableModel table, int index) {
    return Card(
        elevation: 10,
        // margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          _buildHeader(context, table, index),
          Container(
              width: context.sizeDevice.width,
              padding: const EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonLineText(
                        title: 'Tên bàn: ',
                        value: table.name,
                        valueStyle: TextStyle(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CommonLineText(
                        title: 'Số ghế: ', value: table.seats.toString()),
                    const SizedBox(height: 8),
                    CommonLineText(
                        title: 'Trạng thái: ',
                        value: Ultils.tableStatus(table.isUse),
                        valueStyle: TextStyle(
                            color: table.isUse
                                ? Colors.greenAccent
                                : Colors.redAccent))
                  ]))
        ]));
  }

  _goToEditTable(BuildContext context, TableModel tableModel) async {
    // context.push(RouteName.createTable,
    //     extra: {'mode': Mode.update, 'table': tableModel}).then((result) {
    //   if (result is bool && result) {
    //     context.read<TableBloc>().add(TablesFetched());
    //   }
    // });

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: SizedBox(
                width: 600,
                child: CreateOrUpdateTable(
                    mode: Mode.update, tableModel: tableModel)))).then((value) {
      if (value is bool && value) {
        context.read<TableBloc>().add(TablesFetched());
      }
    });
  }
}
