import 'package:mlt_menu_admin_web/common/widget/common_icon_button.dart';
import 'package:mlt_menu_admin_web/config/config.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody(context));
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

  _buildAppbar(BuildContext context) => AppBar(
          centerTitle: true,
          title: Text('Cấu hình máy in', style: context.titleStyleMedium),
          actions: [
            CommonIconButton(
                icon: Icons.add,
                color: Colors.green,
                onTap: () async => await context
                        .push(RouteName.createOrUpdatePrint, extra: {
                      'mode': Mode.create,
                      'print': PrintModel()
                    }).then((value) {
                      if (value is bool && value) {
                        _getData(context);
                      }
                    })),
            const SizedBox(width: 8)
          ]);

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
                    await context.push(RouteName.createOrUpdatePrint, extra: {
                      'mode': Mode.update,
                      'print': printModel
                    }).then((value) {
                      if (value is bool && value) {
                        _getData(context);
                      }
                    });
                  },
                  icon: Icons.edit),
              const SizedBox(width: 8),
              CommonIconButton(
                  onTap: () {},
                  icon: Icons.delete,
                  color: context.colorScheme.errorContainer)
            ])
          ]));
}
