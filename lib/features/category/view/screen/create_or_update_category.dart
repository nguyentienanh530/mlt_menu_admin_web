import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/common/dialog/app_alerts.dart';
import 'package:mlt_menu_admin_web/common/dialog/progress_dialog.dart';
import 'package:mlt_menu_admin_web/common/dialog/retry_dialog.dart';
import 'package:mlt_menu_admin_web/common/widget/common_text_field.dart';
import 'package:mlt_menu_admin_web/common/widget/empty_widget.dart';
import 'package:mlt_menu_admin_web/core/utils/contants.dart';
import 'package:mlt_menu_admin_web/core/utils/extensions.dart';
import 'package:mlt_menu_admin_web/core/utils/util.dart';
import 'package:mlt_menu_admin_web/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu_admin_web/features/category/data/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateOrUpdateCategory extends StatefulWidget {
  const CreateOrUpdateCategory(
      {super.key, required this.categoryModel, required this.mode});
  final CategoryModel categoryModel;
  final Mode mode;

  @override
  State<CreateOrUpdateCategory> createState() => _CreateOrUpdateCategoryState();
}

class _CreateOrUpdateCategoryState extends State<CreateOrUpdateCategory> {
  late Mode _mode;
  late CategoryModel _categoryModel;
  Uint8List? _imageFile;
  String _image = '';
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _desCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _uploadImageProgress = ValueNotifier(0.0);
  final _isUploadImage = ValueNotifier(false);

  @override
  void initState() {
    _mode = widget.mode;
    _initData();
    super.initState();
  }

  void _initData() {
    if (_mode == Mode.update) {
      _categoryModel = widget.categoryModel;
      _nameCtrl.text = _categoryModel.name ?? '';
      _desCtrl.text = _categoryModel.description ?? '';
      _image = _categoryModel.image ?? noImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    var buildWidget = SafeArea(
        child: Form(
            key: _formKey,
            child: Column(children: [
              _buildAppbar(),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    _buildImageCatagory(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildTitle('Tên danh mục (*):'),
                          const SizedBox(height: 8),
                          _buildNameCatagory(),
                          const SizedBox(height: 16),
                          _buildTitle('Mô tả:'),
                          const SizedBox(height: 8),
                          _buildDescriptionCatagory()
                        ]),
                    const SizedBox(height: 32),
                    _buildButton(),
                    const SizedBox(height: 8),
                    Text('(*) không được để trống',
                        style: context.textStyleSmall!.copyWith(
                            fontStyle: FontStyle.italic,
                            color: context.colorScheme.error))
                  ]))
            ])));

    var uploadImageWidget = ValueListenableBuilder(
        valueListenable: _uploadImageProgress,
        builder: (context, value, child) {
          logger.d(value);
          return Scaffold(
              body: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                            value: value / 100,
                            color: context.colorScheme.secondary,
                            backgroundColor: context.colorScheme.primary),
                        const SizedBox(height: 16),
                        Text('Uploading ${(value).toStringAsFixed(2)} %')
                      ])));
        });

    return ValueListenableBuilder(
        valueListenable: _isUploadImage,
        builder: (context, value, child) =>
            value ? uploadImageWidget : buildWidget);
  }

  _buildTitle(String title) => Text(title,
      style: context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold));

  _buildNameCatagory() => CommonTextField(
      hintText: 'Tên danh mục',
      controller: _nameCtrl,
      prefixIcon: const Icon(Icons.abc),
      validator: (value) =>
          value == null || value.isEmpty ? 'Tên danh mục không hợp lệ' : null,
      onChanged: (p0) {});

  _buildDescriptionCatagory() => CommonTextField(
      controller: _desCtrl,
      hintText: 'Mô tả',
      prefixIcon: const Icon(Icons.description),
      onChanged: (p0) {});

  _buildButton() => FilledButton(
      onPressed: _mode == Mode.create
          ? () => _handelCreateCategory()
          : () => _handelUpdateCategory(),
      child: Text(_mode == Mode.create ? 'Thêm danh mục' : 'Chỉnh sửa'));

  _handelCreateCategory() async {
    final invalid = _formKey.currentState?.validate() ?? false;
    final toast = FToast()..init(context);
    if (invalid) {
      if (_imageFile == null) {
        toast.showToast(child: AppAlerts.errorToast(msg: 'chưa chọn hình'));
      } else {
        _isUploadImage.value = true;
        _image = await uploadImage(
            path: 'category',
            file: _imageFile!,
            progress: _uploadImageProgress);
        _isUploadImage.value = false;
        var newCategory = CategoryModel(
            name: _nameCtrl.text, description: _desCtrl.text, image: _image);
        _createCategory(newCategory);
      }
    }
  }

  void _updateCategory(CategoryModel categoryModel) {
    context
        .read<CategoryBloc>()
        .add(CategoryUpdated(categoryModel: categoryModel));
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<CategoryBloc,
                GenericBlocState<CategoryModel>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => Container(color: Colors.transparent),
                  Status.empty => const EmptyWidget(),
                  Status.failure => RetryDialog(
                      title: state.error ?? '',
                      onRetryPressed: () => context
                          .read<CategoryBloc>()
                          .add(CategoryUpdated(categoryModel: categoryModel))),
                  Status.success => ProgressDialog(
                      descriptrion: 'Chỉnh sửa thành công!',
                      isProgressed: false,
                      onPressed: () {
                        pop(context, 2);
                      })
                }));
  }

  void _createCategory(CategoryModel newCategory) {
    context
        .read<CategoryBloc>()
        .add(CategoryCreated(categoryModel: newCategory));
    showDialog(
        context: context,
        builder: (context) =>
            BlocBuilder<CategoryBloc, GenericBlocState<CategoryModel>>(
                builder: (context, state) => switch (state.status) {
                      Status.loading => Container(color: Colors.transparent),
                      Status.empty => const EmptyWidget(),
                      Status.failure => RetryDialog(
                          title: state.error ?? '',
                          onRetryPressed: () => context
                              .read<CategoryBloc>()
                              .add(
                                  CategoryCreated(categoryModel: newCategory))),
                      Status.success => ProgressDialog(
                          descriptrion: 'Tạo danh mục thành công!',
                          isProgressed: false,
                          onPressed: () {
                            pop(context, 2);
                          })
                    }));
  }

  _handelUpdateCategory() async {
    final invalid = _formKey.currentState?.validate() ?? false;

    if (invalid) {
      if (_imageFile == null) {
        _categoryModel = _categoryModel.copyWith(
            image: _image, name: _nameCtrl.text, description: _desCtrl.text);
        _updateCategory(_categoryModel);
      } else {
        _isUploadImage.value = true;
        _image = await uploadImage(
            path: 'category',
            file: _imageFile!,
            progress: _uploadImageProgress);
        _isUploadImage.value = false;
        _categoryModel = _categoryModel.copyWith(
            image: _image, name: _nameCtrl.text, description: _desCtrl.text);
        _updateCategory(_categoryModel);
      }
    }
  }

  _buildImageCatagory() {
    return Stack(children: [
      _imageFile == null
          ? Container(
              height: context.sizeDevice.width * 0.3,
              width: context.sizeDevice.width * 0.3,
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.primary),
                  shape: BoxShape.circle),
              child: Image.network(_image.isEmpty ? noImage : _image))
          : Container(
              height: context.sizeDevice.width * 0.3,
              width: context.sizeDevice.width * 0.3,
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.primary),
                  shape: BoxShape.circle),
              child: Image.memory(_imageFile!)),
      Positioned(
          top: context.sizeDevice.width * 0.3 - 25,
          left: (context.sizeDevice.width * 0.3 - 20) / 2,
          child: GestureDetector(
              onTap: () async {
                await pickImage().then((value) {
                  setState(() {
                    _imageFile = value;
                  });
                });
              },
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white)))
    ]);
  }

  _buildAppbar() => AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
              _mode == Mode.create ? 'Thêm danh mục' : "Chỉnh sửa danh mục",
              style: context.titleStyleMedium),
          actions: [
            IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.highlight_remove_rounded))
          ]);
}
