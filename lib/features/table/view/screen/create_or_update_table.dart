import 'dart:io';
import 'package:mlt_menu_admin_web/common/dialog/progress_dialog.dart';
import 'package:mlt_menu_admin_web/features/table/bloc/table_bloc.dart';
import 'package:mlt_menu_admin_web/features/table/data/model/table_model.dart';
import 'package:mlt_menu_admin_web/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin_web/core/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_text_field.dart';

class CreateTable extends StatefulWidget {
  const CreateTable({super.key, required this.mode, this.tableModel});
  final Mode mode;
  final TableModel? tableModel;
  @override
  State<CreateTable> createState() => _CreateTableState();
}

class _CreateTableState extends State<CreateTable> {
  final TextEditingController _nameController = TextEditingController();

  final _seats = ['2', '4', '6', '8', '10', '12', '14', '16', '18', '20'];
  var _seat = '';
  final _formKey = GlobalKey<FormState>();
  var _loading = false;
  final _tableStatus = ValueNotifier(true);
  //  = BlocProvider.of<IsLoadingCubit>(context);

  @override
  void initState() {
    initValue();
    super.initState();
  }

  void initValue() {
    if (widget.tableModel != null && widget.mode == Mode.update) {
      _seat = widget.tableModel!.seats.toString();
      _tableStatus.value = widget.tableModel?.isUse ?? false;
      _nameController.text = widget.tableModel!.name;
    }
  }

  Widget _buildSeats() {
    return Wrap(
        spacing: 4.0,
        runSpacing: 2.0,
        children: _seats
            .map((e) => SizedBox(
                height: 25,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(_seat == e
                            ? context.colorScheme.errorContainer
                            : context.colorScheme.primaryContainer)),
                    onPressed: () {
                      setState(() {
                        _seat = e;
                      });
                    },
                    child: Text(e))))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
        child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: SizedBox(
                    height: context.sizeDevice.height,
                    child: Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: defaultPadding / 2),
                                    SizedBox(height: defaultPadding / 2),
                                    _buildTitle('Tên bàn:'),
                                    SizedBox(height: defaultPadding / 2),
                                    _NameTable(nameController: _nameController),
                                    SizedBox(height: defaultPadding / 2),
                                    _buildTitle('Số ghế:'),
                                    SizedBox(height: defaultPadding / 2),
                                    _buildSeats(),
                                    SizedBox(height: defaultPadding / 2),
                                    SizedBox(height: defaultPadding / 2),
                                    _buildTableStatus()
                                  ]
                                      .animate(interval: 50.ms)
                                      .slideX(
                                          begin: -0.1,
                                          end: 0,
                                          curve: Curves.easeInOutCubic,
                                          duration: 500.ms)
                                      .fadeIn(
                                          curve: Curves.easeInOutCubic,
                                          duration: 500.ms)))),
                      SizedBox(height: defaultPadding / 2),
                      _buildButtonSubmited(),
                    ])))));
  }

  Widget _buildTableStatus() {
    return ValueListenableBuilder(
        valueListenable: _tableStatus,
        builder: (context, value, child) => Row(children: [
              Text('Trạng thái: ', style: context.titleStyleMedium),
              Row(children: [
                Radio<bool>(
                    value: true,
                    groupValue: _tableStatus.value,
                    activeColor: context.colorScheme.secondary,
                    onChanged: (value) {
                      _tableStatus.value = value ?? false;
                    }),
                const Text('Sử dụng'),
                Radio<bool>(
                    value: false,
                    activeColor: context.colorScheme.secondary,
                    groupValue: _tableStatus.value,
                    onChanged: (value) {
                      _tableStatus.value = value ?? false;
                    }),
                const Text('trống')
              ])
            ]));
  }

  Widget _buildButtonSubmited() {
    var mode = widget.mode;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _loading
          ? SpinKitCircle(color: context.colorScheme.secondary, size: 30)
          : FilledButton.icon(
              onPressed: () => mode == Mode.create
                  ? handleCreateTable()
                  : handleUpdateTable(widget.tableModel!.id!),
              icon: const Icon(Icons.add_box),
              label: mode == Mode.create
                  ? _buildTitle('Thêm bàn')
                  : _buildTitle('Cập nhật'))
    ]);
  }

  Future<void> handleUpdateTable(String idTable) async {
    final toast = FToast()..init(context);

    if (_formKey.currentState!.validate()) {
      if (_seat.isEmpty) {
        toast.showToast(child: AppAlerts.errorToast(msg: 'Chưa chọn số ghế!'));
      } else {
        setState(() {
          _loading = true;
        });

        var table = TableModel(
            id: idTable,
            isUse: _tableStatus.value,
            name: _nameController.text,
            seats: int.parse(_seat));
        updateTable(table);
      }
    }
  }

  Future<void> handleCreateTable() async {
    final toast = FToast()..init(context);

    if (_formKey.currentState!.validate()) {
      if (_seat == '') {
        toast.showToast(child: AppAlerts.errorToast(msg: 'Chưa chọn số ghế!'));
      } else {
        setState(() {
          _loading = true;
        });
        var table = TableModel(
            id: '',
            name: _nameController.text,
            seats: int.parse(_seat),
            isUse: false);
        createTable(table);
      }
    }
  }

  void updateTable(TableModel tableModel) {
    context.read<TableBloc>().add(TableUpdated(table: tableModel));
    setState(() {
      _loading = false;
    });
    showDialog(
        context: context,
        builder: (_) {
          return BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
              builder: (context, state) {
            return switch (state.status) {
              Status.empty => const SizedBox(),
              Status.loading => const SizedBox(),
              Status.failure => RetryDialog(
                  title: state.error ?? "Error",
                  onRetryPressed: () => context
                      .read<TableBloc>()
                      .add(TableUpdated(table: tableModel))),
              Status.success => ProgressDialog(
                  descriptrion: "Đã cập nhật bàn: ${tableModel.name}",
                  onPressed: () {
                    pop(context, 2);
                  },
                  isProgressed: false)
            };
          });
        });
  }

  void createTable(TableModel tableModel) {
    context.read<TableBloc>().add(TableCreated(tableModel: tableModel));
    setState(() {
      _loading = false;
    });
    showDialog(
        context: context,
        builder: (_) {
          return BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
              builder: (context, state) {
            return switch (state.status) {
              Status.empty => const SizedBox(),
              Status.loading => const SizedBox(),
              Status.failure => RetryDialog(
                  title: state.error ?? "Error",
                  onRetryPressed: () => context
                      .read<TableBloc>()
                      .add(TableCreated(tableModel: tableModel))),
              Status.success => ProgressDialog(
                  descriptrion: "Đã tạo bàn: ${tableModel.name}",
                  onPressed: () {
                    pop(context, 2);
                  },
                  isProgressed: false)
            };
          });
        });
  }

  Widget _buildTitle(String title) {
    return Text(title, style: context.titleStyleMedium);
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Text(widget.mode == Mode.create ? 'Tạo bàn ăn' : 'Cập nhật',
            style: context.titleStyleMedium));
  }
}

class _ImageFood extends StatelessWidget {
  final File? imageFile;
  final String image;
  final Function()? onTap;

  const _ImageFood(
      {required this.onTap, required this.imageFile, required this.image});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: imageFile == null
            ? _buildImage(context)
            : Container(
                height: context.sizeDevice.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: FileImage(imageFile!), fit: BoxFit.cover))));
  }

  _buildImage(BuildContext context) {
    return image.isEmpty
        ? Container(
            height: context.sizeDevice.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius)),
            child: DottedBorder(
                dashPattern: const [6, 6],
                color: context.colorScheme.secondary,
                strokeWidth: 1,
                radius: Radius.circular(defaultBorderRadius),
                borderType: BorderType.RRect,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  border: Border.all(
                                      color: context.colorScheme.primary,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(
                                      defaultBorderRadius)),
                              child: Icon(Icons.add,
                                  color: context.colorScheme.secondary))),
                      SizedBox(height: defaultPadding / 2),
                      Text("Hình ảnh món ăn", style: context.textStyleSmall)
                    ])))
        : GestureDetector(
            onTap: onTap,
            child: Container(
                height: context.sizeDevice.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover))),
          );
  }
}

class _NameTable extends StatelessWidget {
  final TextEditingController nameController;

  const _NameTable({required this.nameController});

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.food_bank_rounded),
        hintText: 'Tên bàn ăn',
        controller: nameController,
        validator: (value) {
          if (value == null || value == '') {
            return 'Tên không được để trống';
          } else {
            return null;
          }
        },
        onChanged: (text) {
          nameController.text = text;
        });
  }
}
