import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/common/widget/empty_widget.dart';
import 'package:mlt_menu_admin/common/widget/error_widget.dart';
import 'package:mlt_menu_admin/common/widget/loading_screen.dart';
import 'package:mlt_menu_admin/features/category/bloc/category_bloc.dart';
import 'package:mlt_menu_admin/features/food/data/model/food_model.dart';
import 'package:mlt_menu_admin/common/dialog/app_alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../bloc/food_bloc.dart';

class CreateOrUpdateFoodScreen extends StatelessWidget {
  const CreateOrUpdateFoodScreen(
      {super.key, required this.food, required this.mode});
  final Food? food;
  final Mode mode;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => FoodBloc()),
      BlocProvider(
          create: (context) => CategoryBloc()..add(CategoriesFetched())),
    ], child: UpdateFoodView(food: food!, mode: mode));
  }
}

class UpdateFoodView extends StatefulWidget {
  const UpdateFoodView({super.key, required this.food, required this.mode});
  final Food food;
  final Mode mode;
  @override
  State<UpdateFoodView> createState() => _UpdateFoodViewState();
}

class _UpdateFoodViewState extends State<UpdateFoodView> {
  final TextEditingController _disController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _image = '';

  Uint8List? _imageFile, _imageFile1, _imageFile2, _imageFile3;

  var _categoryID = '';
  var _imageGallery1 = '';
  var _imageGallery2 = '';
  var _imageGallery3 = '';
  var _isDiscount = false;
  final _isShowFood = ValueNotifier(true);
  final _uploadImageProgress = ValueNotifier(0.0);
  final _uploadImage1Progress = ValueNotifier(0.0);
  final _uploadImage2Progress = ValueNotifier(0.0);
  final _uploadImage3Progress = ValueNotifier(0.0);
  final _isUploadImage = ValueNotifier(false);

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    if (!mounted) return;
    if (widget.mode == Mode.update) {
      _disController.text = widget.food.description;
      _nameController.text = widget.food.name;
      _priceCtrl.text = widget.food.price.toString();
      _discountController.text = widget.food.discount.toString();
      _image = widget.food.image;
      _categoryID = widget.food.categoryID;
      _isShowFood.value = widget.food.isShowFood;
      if (widget.food.photoGallery.isNotEmpty) {
        if (widget.food.photoGallery.isNotEmpty) {
          _imageGallery1 = widget.food.photoGallery[0] ?? '';
        }

        if (widget.food.photoGallery.length > 1) {
          _imageGallery2 = widget.food.photoGallery[1] ?? '';
        }

        if (widget.food.photoGallery.length > 2) {
          _imageGallery3 = widget.food.photoGallery[2] ?? '';
        }
      }
      _isDiscount = widget.food.isDiscount;
    }
  }

  @override
  void dispose() {
    _disController.dispose();
    _nameController.dispose();
    _priceCtrl.dispose();
    _discountController.dispose();
    super.dispose();
  }

  AppBar _buildAppbar() {
    return AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.highlight_remove_rounded))
        ],
        title: Text(
            widget.mode == Mode.update
                ? 'Cập nhật món ăn'.toUpperCase()
                : "Thêm món ăn".toUpperCase(),
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)));
  }

  Widget onSuccess(Food food) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        children: [
          _buildAppbar(),
          Expanded(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: defaultPadding / 2),
                          Text("Hình ảnh: (*)",
                              style: context.titleStyleMedium),
                          SizedBox(height: defaultPadding / 2),
                          _ImageFood(
                              image: _image,
                              imageFile: _imageFile,
                              onTap: () async => await pickAndResizeImage()
                                  .then((value) => setState(() {
                                        _imageFile = value;
                                      }))),
                          SizedBox(height: defaultPadding / 2),
                          Text("Tên món ăn: (*)",
                              style: context.titleStyleMedium),
                          SizedBox(height: defaultPadding / 2),
                          _NameFood(nameController: _nameController),
                          SizedBox(height: defaultPadding / 2),
                          Text("Gía bán: (*)", style: context.titleStyleMedium),
                          SizedBox(height: defaultPadding / 2),
                          _PriceFood(priceCtrl: _priceCtrl),
                          SizedBox(height: defaultPadding / 2),
                          _buildStatusFood(),
                          SizedBox(height: defaultPadding / 2),
                          Text("Danh mục: (*)",
                              style: context.titleStyleMedium),
                          SizedBox(height: defaultPadding / 2),
                          _categories(),
                          SizedBox(height: defaultPadding / 2),
                          Text("Mô tả chi tiết:",
                              style: context.titleStyleMedium),
                          SizedBox(height: defaultPadding / 2),
                          _Description(_disController),
                          SizedBox(height: defaultPadding / 2),
                          Text("Album hình ảnh: (*)",
                              style: context.titleStyleMedium),
                          SizedBox(height: defaultPadding / 2),
                          _PhotoGallery(
                              image1: _imageGallery1,
                              image2: _imageGallery2,
                              image3: _imageGallery3,
                              imageGallery1: _imageFile1,
                              imageGallery2: _imageFile2,
                              imageGallery3: _imageFile3,
                              onTapImage1: () async =>
                                  await pickAndResizeImage()
                                      .then((value) => setState(() {
                                            _imageFile1 = value;
                                          })),
                              onTapImage2: () async =>
                                  await pickAndResizeImage()
                                      .then((value) => setState(() {
                                            _imageFile2 = value;
                                          })),
                              onTapImage3: () async =>
                                  await pickAndResizeImage()
                                      .then((value) => setState(() {
                                            _imageFile3 = value;
                                          }))),
                          SizedBox(height: defaultPadding / 2),
                          Text("Áp dụng khuyến mãi ? (*)",
                              style: context.titleStyleMedium),
                          SizedBox(height: defaultPadding / 2),
                          _Discount(
                              discountController: _discountController,
                              isDiscount: _isDiscount,
                              onChanged: (value) {
                                setState(() {
                                  _isDiscount = value ?? false;
                                });
                              }),
                          SizedBox(height: defaultPadding / 2),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("(*): thông tin không được để trống.",
                                    style: context.textStyleSmall!.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: context.colorScheme.error))
                              ]),
                          SizedBox(height: defaultPadding),
                          _buttonCreateOrUpdateFood(),
                          SizedBox(height: defaultPadding / 2)
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFood() {
    return ValueListenableBuilder(
        valueListenable: _isShowFood,
        builder: (context, value, child) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Trạng thái: ', style: context.titleStyleMedium),
              Row(children: [
                Radio<bool>(
                    value: true,
                    groupValue: _isShowFood.value,
                    activeColor: context.colorScheme.secondary,
                    onChanged: (value) {
                      _isShowFood.value = value ?? false;
                    }),
                const Text('Hiển thị'),
                Radio<bool>(
                    value: false,
                    activeColor: context.colorScheme.secondary,
                    groupValue: _isShowFood.value,
                    onChanged: (value) {
                      _isShowFood.value = value ?? false;
                    }),
                const Text('Không hiển thị')
              ])
            ]));
  }

  Widget _categories() {
    var categoryState = context.watch<CategoryBloc>().state;

    return (switch (categoryState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => const EmptyWidget(),
      Status.failure =>
        ErrorWidgetCustom(errorMessage: categoryState.error ?? ''),
      Status.success => Wrap(
          spacing: 4.0,
          runSpacing: 2.0,
          children: categoryState.datas!
              .map((e) => SizedBox(
                  height: 25,
                  child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              _categoryID == e.id
                                  ? context.colorScheme.errorContainer
                                  : context.colorScheme.primaryContainer)),
                      onPressed: () {
                        setState(() {
                          _categoryID = e.id ?? '';
                        });
                      },
                      child: Text(e.name!))))
              .toList())
    });
  }

  Widget _buttonCreateOrUpdateFood() {
    return Center(
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 2,
                    color: widget.mode == Mode.create
                        ? Colors.green
                        : Colors.amber)),
            onPressed: () async => widget.mode == Mode.create
                ? _handelCreateFood(widget.food)
                : _handleUpdateFood(widget.food),
            child: Text(widget.mode == Mode.create ? 'Tạo món' : 'Cập nhật món',
                style: context.titleStyleMedium!
                    .copyWith(fontWeight: FontWeight.bold))));
  }

  void _handleUpdateFood(Food food) async {
    var toast = FToast()..init(context);
    var isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      // Update the food details
      food = food.copyWith(
        isShowFood: _isShowFood.value,
        name: _nameController.text,
        price: num.parse(_priceCtrl.text),
        categoryID: _categoryID,
        description: _disController.text,
        photoGallery: [_imageGallery1, _imageGallery2, _imageGallery3],
        isDiscount: _isDiscount,
        discount: _isDiscount ? int.tryParse(_discountController.text)! : 0,
      );

      if (_imageFile != null) {
        _isUploadImage.value = true;
        _image = await uploadImage(
            path: 'food', progress: _uploadImageProgress, file: _imageFile!);
        food = food.copyWith(image: _image);
      }

      if (_imageFile1 != null) {
        _isUploadImage.value = true;
        _imageGallery1 = await uploadImage(
            path: 'food', file: _imageFile1!, progress: _uploadImage1Progress);
      }

      if (_imageFile2 != null) {
        _isUploadImage.value = true;
        _imageGallery2 = await uploadImage(
            path: 'food', file: _imageFile2!, progress: _uploadImage2Progress);
      }

      if (_imageFile3 != null) {
        _isUploadImage.value = true;
        _imageGallery3 = await uploadImage(
            path: 'food', file: _imageFile3!, progress: _uploadImage3Progress);
      }
      _isUploadImage.value = false;
      food = food.copyWith(
        photoGallery: [_imageGallery1, _imageGallery2, _imageGallery3],
      );

      if (!mounted) return;
      context.read<FoodBloc>().add(FoodUpdated(food: food));
    } else {
      toast.showToast(
          child: AppAlerts.errorToast(msg: 'Chưa nhập đầy đủ thông tin'));
    }
  }

  void _handelCreateFood(Food food) async {
    var toast = FToast()..init(context);
    var isValid = _formKey.currentState?.validate() ?? false;
    if (isValid &&
        _imageFile != null &&
        _imageFile1 != null &&
        _imageFile2 != null &&
        _imageFile3 != null &&
        _categoryID.isNotEmpty) {
      _isUploadImage.value = true;
      _image = await uploadImage(
          path: 'food', file: _imageFile!, progress: _uploadImageProgress);
      _imageGallery1 = await uploadImage(
          path: 'food', file: _imageFile1!, progress: _uploadImage1Progress);
      _imageGallery2 = await uploadImage(
          path: 'food', file: _imageFile2!, progress: _uploadImage2Progress);
      _imageGallery3 = await uploadImage(
          path: 'food', file: _imageFile3!, progress: _uploadImage3Progress);
      _isUploadImage.value = false;
      var newFood = food.copyWith(
          isShowFood: _isShowFood.value,
          image: _image,
          name: _nameController.text,
          price: num.parse(_priceCtrl.text.toString()),
          categoryID: _categoryID,
          description: _disController.text,
          photoGallery: [_imageGallery1, _imageGallery2, _imageGallery3],
          isDiscount: _isDiscount,
          createAt: DateTime.now().toString(),
          discount: _isDiscount ? int.tryParse(_discountController.text)! : 0);

      if (!mounted) return;
      context.read<FoodBloc>().add(FoodCreated(food: newFood));
    } else {
      toast.showToast(
          child: AppAlerts.errorToast(msg: 'Chưa nhập đầy đủ thông tin'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var buildWidget = SizedBox(
        height: context.sizeDevice.height,
        child: BlocListener<FoodBloc, GenericBlocState<Food>>(
            listener: (context, state) => (switch (state.status) {
                  Status.loading => AppAlerts.loadingDialog(context),
                  Status.empty => const SizedBox(),
                  Status.failure =>
                    AppAlerts.failureDialog(context, btnOkOnPress: () {
                      context.pop();
                    }),
                  Status.success =>
                    AppAlerts.successDialog(context, btnOkOnPress: () {
                      if (_imageFile == null &&
                          _imageFile1 == null &&
                          _imageFile2 == null &&
                          _imageFile3 == null) {
                        pop(context, 2);
                      } else {
                        pop(context, 1);
                      }
                    })
                }),
            child: onSuccess(widget.food)));
    var uploadImageWidget = Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgessUploadImage(_uploadImageProgress),
                  _buildProgessUploadImage(_uploadImage1Progress),
                  _buildProgessUploadImage(_uploadImage2Progress),
                  _buildProgessUploadImage(_uploadImage3Progress),
                ])));
    // return uploadImageWidget;
    return ValueListenableBuilder(
        valueListenable: _isUploadImage,
        builder: (context, value, child) =>
            value ? uploadImageWidget : buildWidget);
  }

  Widget _buildProgessUploadImage(ValueNotifier valueNotifier) {
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, value, child) {
          logger.d(value);
          return Card(
              elevation: 10,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    LinearProgressIndicator(
                        value: value / 100,
                        // value: 0.3,
                        color: context.colorScheme.secondary,
                        backgroundColor: context.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Uploading ${(value).toStringAsFixed(2)}%'),
                  ])));
        });
  }
}

class _PriceFood extends StatelessWidget {
  final TextEditingController priceCtrl;

  const _PriceFood({required this.priceCtrl});

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.price_change_outlined),
        hintText: 'Giá bán',
        controller: priceCtrl,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || !value.contains(RegExp(r'^[0-9]+$'))) {
            return 'Giá không hợp lệ';
          }
          return null;
        },
        onChanged: (text) => priceCtrl.text = text);
  }
}

class _Discount extends StatelessWidget {
  final TextEditingController discountController;
  final bool isDiscount;
  final Function(bool?)? onChanged;
  const _Discount(
      {required this.discountController,
      required this.isDiscount,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildDiscount(context),
      SizedBox(height: defaultPadding / 2),
      isDiscount ? _buildTextFeildDiscount(context) : const SizedBox()
    ]);
  }

  Widget _buildDiscount(BuildContext context) {
    return Row(children: [
      Radio<bool>(
          value: true,
          groupValue: isDiscount,
          activeColor: context.colorScheme.secondary,
          onChanged: onChanged),
      const Text('Áp dụng'),
      Radio<bool>(
          value: false,
          activeColor: context.colorScheme.secondary,
          groupValue: isDiscount,
          onChanged: onChanged),
      const Text('Không áp dụng')
    ]);
  }

  Widget _buildTextFeildDiscount(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.discount_rounded),
        controller: discountController,
        hintText: 'Giá khuyến mãi (0%-100%)',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isNotEmpty &&
              value.contains(RegExp(r'^[0-9]+$')) &&
              int.parse(value) < 100 &&
              isDiscount) {
            return null;
          }
          return 'Khuyễn mãi không hợp lệ';
        },
        onChanged: (value) => discountController.text = value);
  }
}

class _PhotoGallery extends StatelessWidget {
  final String image1, image2, image3;
  final Uint8List? imageGallery1, imageGallery2, imageGallery3;
  final Function()? onTapImage1, onTapImage2, onTapImage3;
  const _PhotoGallery(
      {required this.image1,
      required this.image2,
      required this.image3,
      required this.imageGallery1,
      required this.imageGallery2,
      required this.imageGallery3,
      required this.onTapImage1,
      required this.onTapImage2,
      required this.onTapImage3});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery1,
              image: image1,
              onTap: onTapImage1)),
      SizedBox(width: defaultPadding / 2),
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery2,
              image: image2,
              onTap: onTapImage2)),
      SizedBox(width: defaultPadding / 2),
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery3,
              image: image3,
              onTap: onTapImage3))
    ]);
  }

  Widget _buildImageGallery(
      {required BuildContext context,
      dynamic imageFile,
      Function()? onTap,
      String? image}) {
    return GestureDetector(
        onTap: onTap,
        child: imageFile == null
            ? _buildImage(context, image!)
            : Container(
                height: context.sizeDevice.height * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: MemoryImage(imageFile!), fit: BoxFit.fill))));
  }

  Widget _buildImage(BuildContext context, String image) {
    return image == ''
        ? Container(
            height: context.sizeDevice.height * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius)),
            child: DottedBorder(
                dashPattern: const [6, 6],
                color: context.colorScheme.secondary,
                strokeWidth: 1,
                padding: EdgeInsets.all(defaultPadding),
                radius: Radius.circular(defaultBorderRadius),
                borderType: BorderType.RRect,
                child: Center(
                    child: Icon(Icons.add,
                        size: 40, color: context.colorScheme.secondary))))
        : Container(
            height: context.sizeDevice.height * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          );
  }
}

class _ImageFood extends StatelessWidget {
  const _ImageFood(
      {required this.image, required this.imageFile, required this.onTap});
  final String image;
  final Uint8List? imageFile;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: imageFile == null
            ? _buildImage(context)
            : Container(
                height: 155,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: MemoryImage(imageFile!), fit: BoxFit.cover))));
  }

  Widget _buildImage(BuildContext context) {
    return image == ''
        ? Container(
            height: 155,
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
        : Container(
            height: 155,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)));
  }
}

class _NameFood extends StatelessWidget {
  final TextEditingController nameController;

  const _NameFood({required this.nameController});

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.food_bank_rounded),
        hintText: 'Tên món ăn',
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Tên không được để trống';
          }
          return null;
        },
        onChanged: (text) => nameController.text = text);
  }
}

class _Description extends StatelessWidget {
  const _Description(this._disController);
  final TextEditingController _disController;
  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.description_outlined),
        hintText: "Nhập thông tin",
        controller: _disController,
        onChanged: (text) => _disController.text = text);
  }
}
