import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/dialog/progress_dialog.dart';
import 'package:mlt_menu_admin/common/dialog/retry_dialog.dart';
import 'package:mlt_menu_admin/common/widget/common_text_field.dart';
import 'package:mlt_menu_admin/common/widget/empty_widget.dart';
import 'package:mlt_menu_admin/core/utils/contants.dart';
import 'package:mlt_menu_admin/core/utils/extensions.dart';
import 'package:mlt_menu_admin/core/utils/util.dart';
import 'package:mlt_menu_admin/features/print/bloc/print_bloc.dart';
import 'package:mlt_menu_admin/features/print/data/model/print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrUpdatePrint extends StatefulWidget {
  const CreateOrUpdatePrint({super.key, this.printModel, required this.mode});
  final PrintModel? printModel;
  final Mode mode;

  @override
  State<CreateOrUpdatePrint> createState() => _CreateOrUpdatePrintState();
}

class _CreateOrUpdatePrintState extends State<CreateOrUpdatePrint> {
  var _mode = Mode.create;
  var _printModel = PrintModel();
  final _namePrintCtrl = TextEditingController();
  final _ipPrintCtrl = TextEditingController();
  final _portPrintCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _printModel = widget.printModel ?? PrintModel();
    _mode = widget.mode;
    _initData();
    super.initState();
  }

  _initData() {
    if (_mode == Mode.update) {
      _namePrintCtrl.text = _printModel.name;
      _ipPrintCtrl.text = _printModel.ip;
      _portPrintCtrl.text = _printModel.port;
    }
  }

  @override
  void dispose() {
    _namePrintCtrl.dispose();
    _ipPrintCtrl.dispose();
    _portPrintCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PrintBloc(),
        child:
            Column(children: [_buildAppbar(), Expanded(child: _buildBody())]));
  }

  _buildAppbar() => AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_remove_rounded))
      ],
      title: Text(_mode == Mode.create ? 'Thêm máy in' : 'Cập nhật máy in',
          style: context.titleStyleMedium));

  Widget _buildBody() {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      _buildNamePrint(),
                      const SizedBox(height: 16),
                      _buildIpPrint(),
                      const SizedBox(height: 16),
                      _buildPortPrint(),
                      const SizedBox(height: 32),
                      _buildButtomCreateOrUpdate()
                    ])
                    .animate()
                    .slideX(
                        begin: -0.1,
                        end: 0,
                        curve: Curves.easeInOutCubic,
                        duration: 500.ms)
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))));
  }

  _buildNamePrint() => CommonTextField(
        controller: _namePrintCtrl,
        hintText: 'Tên máy in',
        prefixIcon: const Icon(Icons.print),
        validator: (value) => value != null && value.isNotEmpty
            ? null
            : 'Tên không được để trống',
        onChanged: (p0) {},
      );

  _buildIpPrint() => CommonTextField(
        controller: _ipPrintCtrl,
        hintText: 'Địa chỉ IP máy in',
        prefixIcon: const Icon(Icons.print),
        validator: (value) =>
            value != null && value.isNotEmpty ? null : 'IP không được để trống',
        onChanged: (p0) {},
      );

  _buildPortPrint() => CommonTextField(
        controller: _portPrintCtrl,
        hintText: 'Port máy in',
        prefixIcon: const Icon(Icons.print),
        validator: (value) => value != null && value.isNotEmpty
            ? null
            : 'Port không được để trống',
        onChanged: (p0) {},
      );

  _buildButtomCreateOrUpdate() {
    return FilledButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(context.colorScheme.tertiaryContainer)),
      child: _mode == Mode.create ? const Text('Thêm') : const Text('Cập nhật'),
      onPressed: () =>
          _mode == Mode.create ? _onCreateSubmit() : _onUpdateSubmit(),
    );
  }

  _onCreateSubmit() {
    var isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      var newPrint = PrintModel(
          name: _namePrintCtrl.text,
          ip: _ipPrintCtrl.text,
          port: _portPrintCtrl.text);
      _handelCreatePrint(newPrint);
    }
  }

  _onUpdateSubmit() {
    var isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      _printModel = _printModel.copyWith(
          name: _namePrintCtrl.text,
          ip: _ipPrintCtrl.text,
          port: _portPrintCtrl.text);
      _handelUpdatePrint(_printModel);
    }
  }

  void _handelUpdatePrint(PrintModel newPrint) {
    context.read<PrintBloc>().add(PrintUpdated(printModel: newPrint));
    showDialog(
        context: context,
        builder: (context) =>
            BlocBuilder<PrintBloc, GenericBlocState<PrintModel>>(
                builder: (context, state) => switch (state.status) {
                      Status.loading => const ProgressDialog(
                          descriptrion: 'Đang cập nhật...', isProgressed: true),
                      Status.empty => const EmptyWidget(),
                      Status.failure => RetryDialog(
                          title: 'Lối tạo máy in',
                          onRetryPressed: () => context
                              .read<PrintBloc>()
                              .add(PrintUpdated(printModel: newPrint))),
                      Status.success => ProgressDialog(
                          descriptrion: 'Cập nhật thành công',
                          isProgressed: false,
                          onPressed: () {
                            pop(context, 2);
                          })
                    }));
  }

  void _handelCreatePrint(PrintModel newPrint) {
    context.read<PrintBloc>().add(PrintCreated(printModel: newPrint));
    showDialog(
        context: context,
        builder: (context) =>
            BlocBuilder<PrintBloc, GenericBlocState<PrintModel>>(
                builder: (context, state) => switch (state.status) {
                      Status.loading => const ProgressDialog(
                          descriptrion: 'Đang thêm...', isProgressed: true),
                      Status.empty => const EmptyWidget(),
                      Status.failure => RetryDialog(
                          title: 'Lối tạo máy in',
                          onRetryPressed: () => context
                              .read<PrintBloc>()
                              .add(PrintCreated(printModel: newPrint))),
                      Status.success => ProgressDialog(
                          descriptrion: 'Thêm thành công',
                          isProgressed: false,
                          onPressed: () {
                            pop(context, 2);
                          })
                    }));
  }
}
