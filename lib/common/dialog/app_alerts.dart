import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../widget/common_text_style.dart';
import '../../core/utils/utils.dart';

@immutable
class AppAlerts {
  const AppAlerts._();

  static Widget successToast({String? msg}) => Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: kGreenColor),
      child: FittedBox(
          child: Row(children: [
        FittedBox(child: Icon(Icons.check, color: kWhiteColor, size: 15)),
        SizedBox(width: defaultPadding / 2),
        FittedBox(child: Text(msg ?? '', style: CommonTextStyle.normal()))
      ])));

  static Widget warningToast({String? msg}) => Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: kYellowColor),
      child: FittedBox(
          child: Row(children: [
        FittedBox(child: Icon(Icons.check, color: kWhiteColor, size: 15)),
        SizedBox(width: defaultPadding / 2),
        FittedBox(child: Text(msg ?? '', style: CommonTextStyle.normal()))
      ])));

  static Widget errorToast({String? msg}) => Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: Colors.red),
      child: FittedBox(
          child: Row(children: [
        FittedBox(child: Icon(Icons.error, color: kWhiteColor, size: 15)),
        SizedBox(width: defaultPadding / 2),
        FittedBox(child: Text(msg ?? '', style: CommonTextStyle.normal()))
      ])));

  static successDialog(BuildContext context,
      {String? title,
      String? desc,
      String? btnOkText,
      Function()? btnCancelOnPress,
      Function()? btnOkOnPress}) {
    AwesomeDialog(
      width: 500,
      dialogBackgroundColor: context.colorScheme.primary.withOpacity(0.3),
      dismissOnTouchOutside: false,
      titleTextStyle:
          context.textStyleLarge!.copyWith(fontWeight: FontWeight.bold),
      descTextStyle: context.textStyleSmall,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title ?? 'Thành công!',
      desc: desc ?? '',
      btnOkText: btnOkText ?? AppString.ok,
      btnCancelOnPress: btnCancelOnPress,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }

  static failureDialog(BuildContext context,
      {String? title,
      String? desc,
      Function()? btnCancelOnPress,
      Function()? btnOkOnPress}) {
    AwesomeDialog(
      width: 500,
      dismissOnTouchOutside: false,
      dialogBackgroundColor: context.colorScheme.background,
      titleTextStyle:
          context.textStyleLarge!.copyWith(fontWeight: FontWeight.bold),
      descTextStyle: context.textStyleSmall,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title ?? 'Thông báo',
      desc: desc ?? '',
      btnCancelOnPress: btnCancelOnPress,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }

  static Future<dynamic> warningDialog(BuildContext context,
      {String? title,
      String? desc,
      String? textCancel,
      String? textOk,
      Function()? btnCancelOnPress,
      Function()? btnOkOnPress}) async {
    await AwesomeDialog(
      width: 500,
      dismissOnTouchOutside: false,
      btnCancelText: textCancel ?? 'Cancel',
      btnOkText: textOk ?? 'Ok',
      titleTextStyle:
          context.textStyleLarge!.copyWith(fontWeight: FontWeight.bold),
      descTextStyle: context.textStyleSmall,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: title ?? 'Thông báo',
      desc: desc ?? '',
      btnCancelOnPress: () => btnCancelOnPress ?? context.pop(),
      btnOkOnPress: btnOkOnPress,
    ).show();
  }

  static loadingDialog(BuildContext context, {String? desc}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
            child: Card(
                child: Container(
                    height: context.sizeDevice.height * 0.2,
                    width: context.sizeDevice.height * 0.2,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius)),
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitCircle(
                              color: context.colorScheme.secondary, size: 30),
                          SizedBox(height: defaultPadding / 2),
                          Text(desc ?? 'Please wait...',
                              style: context.textStyleSmall)
                        ])))));
  }
}
