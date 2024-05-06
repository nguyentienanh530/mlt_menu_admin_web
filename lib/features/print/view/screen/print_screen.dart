import 'package:mlt_menu_admin/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin/common/dialog/progress_dialog.dart';
import 'package:mlt_menu_admin/common/dialog/retry_dialog.dart';
import 'package:mlt_menu_admin/common/widget/common_icon_button.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/features/print/view/screen/create_or_update_print.dart';

import '../../../../../common/bloc/generic_bloc_state.dart';
import '../../../../../common/widget/empty_screen.dart';
import '../../../../../common/widget/error_screen.dart';
import '../../../../../common/widget/loading_screen.dart';
import '../../bloc/print_bloc.dart';
import '../../cubit/print_cubit.dart';
import '../../data/model/print_model.dart';
import '../../data/print_data_source/print_data_source.dart';

class PrintScreen extends StatelessWidget {
  const PrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PrintBloc()..add(PrintsFetched()),
        child: const PrintView());
  }
}

// ignore: must_be_immutable
class PrintView extends StatelessWidget {
  const PrintView({super.key});

  void _getData(BuildContext context) {
    context.read<PrintBloc>().add(PrintsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            CommonIconButton(
                icon: Icons.add,
                color: Colors.green,
                onTap: () async => await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            content: SizedBox(
                                width: 600,
                                child: CreateOrUpdatePrint(
                                    mode: Mode.create,
                                    printModel: PrintModel())))).then((value) {
                      if (value is bool && value) {
                        _getData(context);
                      }
                    })),
            IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.highlight_remove_rounded))
          ]),
      Expanded(child: _buildBody(context))
    ]);
  }

  Widget _buildBody(BuildContext context) {
    var printState = context.watch<PrintBloc>().state;

    return switch (printState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => const EmptyScreen(),
      Status.failure => ErrorScreen(errorMsg: printState.error),
      Status.success => ListView.builder(
          itemCount: printState.datas!.length,
          itemBuilder: (context, index) =>
              _buildItemPrint(context, printState.datas![index], index)
                  .animate()
                  .slideX(
                      begin: -0.1,
                      end: 0,
                      curve: Curves.easeInOutCubic,
                      duration: 500.ms)
                  .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))
    };
  }

  Widget _buildItemPrint(BuildContext context, PrintModel print, int index) {
    var isPrintActive = ValueNotifier(false);
    var printCubit = context.watch<PrintCubit>().state;
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [
          _buildHeader(context, index + 1, print),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset('assets/icon/print.svg',
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn))),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(print.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Row(children: [
                              _buildChildItem(context, 'IP: ', print.ip)
                            ]),
                            _buildChildItem(context, 'port: ', print.port)
                          ])
                    ]),
                    ValueListenableBuilder(
                        valueListenable: isPrintActive,
                        builder: (context, value, child) {
                          if (value) {
                            _handleSavePrint(print);
                            context.read<PrintCubit>().onPrintChanged(print);
                          }
                          return Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                  activeTrackColor:
                                      context.colorScheme.secondary,
                                  value:
                                      printCubit.id == print.id ? true : false,
                                  onChanged: (value) {
                                    isPrintActive.value = value;
                                  }));
                        })
                  ]))
        ]));
  }

  void _handleSavePrint(PrintModel print) {
    PrintDataSource.setPrint(print);
  }

  Widget _buildChildItem(BuildContext context, String label, value) {
    return Row(children: [
      Text(label),
      Text(value, style: TextStyle(color: Colors.white.withOpacity(0.4)))
    ]);
  }

  _buildHeader(BuildContext context, int index, PrintModel printModel) =>
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 40,
          color: context.colorScheme.primary.withOpacity(0.3),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('#$index',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [
              CommonIconButton(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            content: SizedBox(
                                width: 600,
                                child: CreateOrUpdatePrint(
                                    mode: Mode.update,
                                    printModel: printModel)))).then((value) {
                      if (value is bool && value) {
                        _getData(context);
                      }
                    });
                  },
                  icon: Icons.edit),
              const SizedBox(width: 8),
              CommonIconButton(
                  onTap: () => _deletePrintSubmit(context, printModel),
                  icon: Icons.delete,
                  color: context.colorScheme.errorContainer)
            ])
          ]));

  _deletePrintSubmit(BuildContext context, PrintModel printModel) async {
    await AppAlerts.warningDialog(context,
            title: 'Xóa "${printModel.name}"?',
            desc: 'Kiểm tra kĩ trước khi xóa!',
            textCancel: 'Hủy',
            textOk: 'Xóa',
            btnCancelOnPress: () => context.pop(),
            btnOkOnPress: () => _handleDeletePrint(context, printModel))
        .then((value) {
      print(value);
      if (value is bool && value) {
        _getData(context);
      }
    });
  }

  _handleDeletePrint(BuildContext context, PrintModel printModel) async {
    showDialog(
        context: context,
        builder: (context) => BlocProvider(
            create: (context) =>
                PrintBloc()..add(PrintDeleted(printModel: printModel)),
            child: Builder(builder: (context) {
              var state = context.watch<PrintBloc>().state;
              return switch (state.status) {
                Status.loading => const ProgressDialog(
                    descriptrion: 'Đang xóa...', isProgressed: true),
                Status.empty => const SizedBox(),
                Status.failure => RetryDialog(
                    title: state.error ?? '',
                    onRetryPressed: () => context
                        .read<PrintBloc>()
                        .add(PrintDeleted(printModel: printModel))),
                Status.success => ProgressDialog(
                    descriptrion: 'Đang xóa...',
                    isProgressed: false,
                    onPressed: () {
                      pop(context, 2);
                      // _getData(context);
                    })
              };
            }))).then((value) {
      if (value is bool && value) {
        _getData(context);
      }
    });
  }
}
