import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/dialog/app_alerts.dart';
import '../../../../common/widget/common_button.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../../../config/config.dart';
import '../../../../core/utils/utils.dart';
import '../../cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider<LoginCubit>(
            create: (context) =>
                LoginCubit(context.read<AuthenticationRepository>()),
            child: const LoginView()));
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailCtrl =
      TextEditingController(text: 'minhlong@gmail.com');
  final TextEditingController _passwordCtrl =
      TextEditingController(text: 'Minhlong@123');
  final _formKey = GlobalKey<FormState>();
  final _oneUpperCase = ValueNotifier(false);
  final _oneLowerCase = ValueNotifier(false);
  final _oneNumericNumber = ValueNotifier(false);
  final _oneSpecialCharacter = ValueNotifier(false);
  final _least8Characters = ValueNotifier(false);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SizedBox(
          height: context.sizeDevice.height,
          width: context.sizeDevice.width,
          child:
              Image.asset('assets/image/onBoarding3.jpeg', fit: BoxFit.cover)),
      _buildMobileWidget(),
    ]));
  }

  _buildMobileWidget() => Center(
      child: FittedBox(
          child: Container(
              width: 500,
              height: 400,
              margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  color: context.colorScheme.background),
              child: BlocListener<LoginCubit, LoginState>(
                  listener: (context, state) {
                    switch (state.status) {
                      case FormzSubmissionStatus.inProgress:
                        AppAlerts.loadingDialog(context);
                        break;
                      case FormzSubmissionStatus.failure:
                        AppAlerts.failureDialog(context,
                            title: AppString.errorTitle,
                            desc: state.errorMessage, btnCancelOnPress: () {
                          context.read<LoginCubit>().resetStatus();
                          pop(context, 2);
                        });
                        break;
                      case FormzSubmissionStatus.success:
                        context.go(RouteName.home);
                        context.pushReplacement(RouteName.home);
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         const HomeScreen()));
                        break;
                      default:
                    }
                  },
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: defaultPadding),
                            const Center(child: _Wellcome()),
                            SizedBox(height: defaultPadding),
                            _Email(emailcontroller: _emailCtrl),
                            SizedBox(height: defaultPadding / 2),
                            _buildPassword(),
                            SizedBox(height: defaultPadding / 2),
                            _buildValidPassword(),
                            SizedBox(height: defaultPadding),
                            _ButtonLogin(onTap: () => _handleLoginSubmited()),
                            SizedBox(height: defaultPadding / 2),
                            const Center(child: _ButtonSignUp()),
                            SizedBox(height: defaultPadding)
                          ]
                              .animate(interval: 50.ms)
                              .slideX(
                                  begin: -0.1,
                                  end: 0,
                                  curve: Curves.easeInOutCubic,
                                  duration: 400.ms)
                              .fadeIn(
                                  curve: Curves.easeInOutCubic,
                                  duration: 400.ms)))))));

  Widget _buildPassword() {
    var isShowPassword = ValueNotifier(false);
    return ValueListenableBuilder(
        valueListenable: isShowPassword,
        builder: (context, value, child) {
          return CommonTextField(
              maxLines: 1,
              controller: _passwordCtrl,
              hintText: AppString.password,
              validator: (password) => Ultils.validatePassword(password)
                  ? null
                  : 'password không hợp lệ',
              onChanged: (value) {
                // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                // _passwordCtrl.text = value;
                RegExp(r'^(?=.*?[A-Z])').hasMatch(value)
                    ? _oneUpperCase.value = true
                    : _oneUpperCase.value = false;
                RegExp(r'^(?=.*?[a-z])').hasMatch(value)
                    ? _oneLowerCase.value = true
                    : _oneLowerCase.value = false;
                RegExp(r'^(?=.*?[a-z])').hasMatch(value)
                    ? _oneLowerCase.value = true
                    : _oneLowerCase.value = false;
                RegExp(r'^(?=.*?[0-9])').hasMatch(value)
                    ? _oneNumericNumber.value = true
                    : _oneNumericNumber.value = false;
                RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)
                    ? _oneSpecialCharacter.value = true
                    : _oneSpecialCharacter.value = false;
                value.length >= 8
                    ? _least8Characters.value = true
                    : _least8Characters.value = false;
              },
              obscureText: !value,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                  onTap: () => isShowPassword.value = !isShowPassword.value,
                  child: Icon(
                      !value ? Icons.visibility_off : Icons.remove_red_eye)));
        });
  }

  Widget _buildValidPassword() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _buildItemValidPassword(
                    valueListenable: _oneUpperCase, label: 'Ký tự hoa'),
                _buildItemValidPassword(
                    valueListenable: _oneLowerCase, label: 'Ký tự thường')
              ])),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _buildItemValidPassword(
                    valueListenable: _oneNumericNumber, label: 'Ký tự số'),
                _buildItemValidPassword(
                    valueListenable: _oneSpecialCharacter,
                    label: 'Ký tự đặc biệt')
              ])),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _buildItemValidPassword(
                    valueListenable: _least8Characters,
                    label: 'Ít nhất 8 ký tự')
              ]))
        ]);
  }

  Widget _buildItemValidPassword(
      {required ValueListenable<bool> valueListenable, required String label}) {
    return FittedBox(
        child: ValueListenableBuilder<bool>(
            valueListenable: valueListenable,
            builder: (context, value, child) => Row(children: [
                  Icon(Icons.check_circle_rounded,
                      color: value ? Colors.greenAccent : null),
                  const SizedBox(width: 8),
                  Text(label,
                      style: context.textStyleSmall!
                          .copyWith(color: value ? Colors.greenAccent : null))
                ])));
  }

  void _handleLoginSubmited() {
    var isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      context.read<LoginCubit>().logInWithCredentials(
          email: _emailCtrl.text.trim(), password: _passwordCtrl.text.trim());
    }
  }
}

class _Wellcome extends StatelessWidget {
  const _Wellcome();

  @override
  Widget build(BuildContext context) {
    return Text(AppString.welcomeBack,
        style: context.titleStyleLarge!.copyWith(
            color: context.colorScheme.tertiaryContainer,
            fontWeight: FontWeight.bold));
  }
}

class _Email extends StatelessWidget {
  const _Email({required this.emailcontroller});
  final TextEditingController emailcontroller;
  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        controller: emailcontroller,
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        hintText: AppString.email,
        prefixIcon: const Icon(Icons.email_rounded),
        validator: (value) =>
            Ultils.validateEmail(value) ? null : 'Email kkhông hợp lệ',
        onChanged: (p0) {});
  }
}

class _ButtonLogin extends StatelessWidget {
  const _ButtonLogin({required this.onTap});
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return CommonButton(text: AppString.login, onTap: onTap);
  }
}

class _ButtonSignUp extends StatelessWidget {
  const _ButtonSignUp();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.go(RouteName.register),
        child: CommonLineText(
            title: AppString.noAccount,
            value: AppString.signup,
            titleStyle: context.textStyleSmall,
            valueStyle: context.titleStyleMedium!.copyWith(
                color: context.colorScheme.tertiaryContainer,
                fontWeight: FontWeight.bold)));
  }
}
