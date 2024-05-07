// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
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
      Function()? btnOkOnPress}) async {
    await Dialogs.materialDialog(
        barrierDismissible: false,
        color: context.colorScheme.background,
        titleStyle:
            context.titleStyleLarge!.copyWith(fontWeight: FontWeight.bold),
        msgStyle: context.textStyleSmall!,
        msg: desc,
        title: title,
        titleAlign: TextAlign.center,
        msgAlign: TextAlign.center,
        lottieBuilder:
            Lottie.asset('assets/animations/success.json', fit: BoxFit.contain),
        dialogWidth: kIsWeb ? 0.3 : null,
        context: context,
        actions: [
          IconsButton(
              onPressed: btnOkOnPress ?? () {},
              text: btnOkText ?? AppString.ok,
              iconData: Icons.done,
              color: context.colorScheme.secondary,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              iconColor: Colors.white)
        ]);
  }

  static failureDialog(BuildContext context,
      {String? title, String? desc, Function()? btnCancelOnPress}) async {
    await Dialogs.materialDialog(
        barrierDismissible: false,
        color: context.colorScheme.background,
        titleStyle:
            context.titleStyleLarge!.copyWith(fontWeight: FontWeight.bold),
        msgStyle: context.textStyleSmall!,
        msg: desc,
        title: title,
        titleAlign: TextAlign.center,
        msgAlign: TextAlign.center,
        lottieBuilder:
            Lottie.asset('assets/animations/error.json', fit: BoxFit.contain),
        dialogWidth: kIsWeb ? 0.3 : null,
        context: context,
        actions: [
          IconsButton(
              onPressed: btnCancelOnPress ?? () {},
              text: 'Ok',
              iconData: Icons.error,
              color: Colors.red,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              iconColor: Colors.white)
        ]);
  }

  static warningDialog(BuildContext context,
      {String? title,
      String? desc,
      String? textCancel,
      String? textOk,
      Function()? btnCancelOnPress,
      Function()? btnOkOnPress}) async {
    await Dialogs.materialDialog(
        barrierDismissible: false,
        color: context.colorScheme.background,
        titleStyle:
            context.titleStyleLarge!.copyWith(fontWeight: FontWeight.bold),
        msgStyle: context.textStyleSmall!,
        msg: desc,
        title: title,
        titleAlign: TextAlign.center,
        msgAlign: TextAlign.center,
        lottieBuilder:
            Lottie.asset('assets/animations/warning.json', fit: BoxFit.contain),
        dialogWidth: kIsWeb ? 0.3 : null,
        context: context,
        actions: [
          IconsButton(
              onPressed: btnCancelOnPress ??
                  () {
                    context.pop();
                  },
              text: textCancel ?? 'Hủy',
              iconData: Icons.highlight_remove_rounded,
              color: Colors.red,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              iconColor: Colors.white),
          IconsButton(
              onPressed: btnOkOnPress ?? () {},
              text: textOk ?? 'Ok',
              iconData: Icons.done,
              color: context.colorScheme.secondary,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              iconColor: Colors.white)
        ]);
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
                          // SpinKitCircle(
                          //     color: context.colorScheme.secondary, size: 30),

                          Lottie.asset('assets/animations/loading.json'),
                          SizedBox(height: defaultPadding / 2),
                          FittedBox(
                              child: Text(desc ?? 'Vui lòng đợi...',
                                  style: context.textStyleSmall))
                        ])))));
  }
}
