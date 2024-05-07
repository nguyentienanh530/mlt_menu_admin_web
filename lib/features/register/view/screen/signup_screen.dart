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
import '../../../auth/bloc/auth_bloc.dart';
import '../../../user/bloc/user_bloc.dart';
import '../../../user/data/model/user_model.dart';
import '../../cubit/register_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider<RegisterCubit>(
            create: (_) =>
                RegisterCubit(context.read<AuthenticationRepository>()),
            child: const SignUpView()));
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _oneUpperCase = ValueNotifier(false);
  final _oneLowerCase = ValueNotifier(false);
  final _oneNumericNumber = ValueNotifier(false);
  final _oneSpecialCharacter = ValueNotifier(false);
  final _least8Characters = ValueNotifier(false);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
          height: context.sizeDevice.height,
          width: context.sizeDevice.width,
          child: Image.asset('assets/image/backgroundProfile.png',
              fit: BoxFit.cover)),
      Center(
          child: FittedBox(
              child: Container(
                  width: 500,
                  height: 400,
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  margin: EdgeInsets.symmetric(horizontal: defaultPadding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      color: context.colorScheme.background),
                  child: BlocListener<RegisterCubit, RegisterState>(
                      listener: (context, state) {
                        switch (state.status) {
                          case FormzSubmissionStatus.inProgress:
                            AppAlerts.loadingDialog(context);
                            break;
                          case FormzSubmissionStatus.failure:
                            AppAlerts.failureDialog(context,
                                title: AppString.registerFailureTitle,
                                desc: state.errorMessage, btnCancelOnPress: () {
                              context.read<RegisterCubit>().resetStatus();
                              pop(context, 2);
                            });
                            break;
                          case FormzSubmissionStatus.success:
                            context
                                .read<AuthBloc>()
                                .add(const AuthLogoutRequested());
                            _handleCreateUser();

                            AppAlerts.successDialog(context,
                                title: AppString.success,
                                desc: AppString.registerSuccessTitle,
                                btnOkOnPress: () {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthLogoutRequested());
                              context.go(RouteName.login);
                            });
                            break;
                          default:
                        }
                      },
                      child: _buildBody()))))
    ]);
  }

  void _handleCreateUser() {
    var userID = context.read<AuthBloc>().state.user.id;
    var user = UserModel().copyWith(
        id: userID,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        role: 'admin',
        createAt: DateTime.now().toString());
    context.read<UserBloc>().add(UserCreated(user: user));
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: defaultPadding),
            const Center(child: _Wellcome()),
            SizedBox(height: defaultPadding),
            _Name(namecontroller: _nameCtrl),
            SizedBox(height: defaultPadding / 2),
            _Email(emailcontroller: _emailCtrl),
            SizedBox(height: defaultPadding / 2),
            _buildPassword(),
            SizedBox(height: defaultPadding),
            _buildValidPassword(),
            SizedBox(height: defaultPadding),
            _ButtonSignUp(onTap: () => _handelRegister()),
            SizedBox(height: defaultPadding / 2),
            SizedBox(height: defaultPadding / 2),
            const Center(child: _ButtonSignIn()),
            SizedBox(height: defaultPadding),
          ]
              .animate(interval: 50.ms)
              .slideX(
                  begin: -0.1,
                  end: 0,
                  curve: Curves.easeInOutCubic,
                  duration: 400.ms)
              .fadeIn(curve: Curves.easeInOutCubic, duration: 400.ms)),
    );
  }

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
                ]),
          ),
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

  void _handelRegister() {
    var isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      context.read<RegisterCubit>().signUpFormSubmitted(
          email: _emailCtrl.text.trim(), password: _passwordCtrl.text.trim());
    }
  }
}

class _Wellcome extends StatelessWidget {
  const _Wellcome();

  @override
  Widget build(BuildContext context) {
    return Text(AppString.welcome,
        style: context.titleStyleLarge!.copyWith(
            color: context.colorScheme.secondaryContainer,
            fontWeight: FontWeight.bold));
  }
}

class _Name extends StatelessWidget {
  const _Name({required this.namecontroller});
  final TextEditingController namecontroller;
  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        controller: namecontroller,
        keyboardType: TextInputType.emailAddress,
        hintText: 'Tên người dùng',
        prefixIcon: const Icon(Icons.person),
        validator: (name) =>
            name != null && name.isNotEmpty ? null : 'tên không được để trống',
        onChanged: (value) {});
  }
}

class _Email extends StatelessWidget {
  const _Email({required this.emailcontroller});
  final TextEditingController emailcontroller;
  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        controller: emailcontroller,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        hintText: AppString.email,
        prefixIcon: const Icon(Icons.email_rounded),
        validator: (email) =>
            Ultils.validateEmail(email) ? null : 'Email không hợp lệ',
        onChanged: (value) {});
  }
}

class _ButtonSignUp extends StatelessWidget {
  const _ButtonSignUp({required this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CommonButton(text: AppString.signup, onTap: onTap);
  }
}

class _ButtonSignIn extends StatelessWidget {
  const _ButtonSignIn();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.replace(RouteName.login);
        },
        child: CommonLineText(
            title: AppString.haveAnAccount,
            value: AppString.signin,
            titleStyle: context.textStyleSmall,
            valueStyle: context.titleStyleMedium!.copyWith(
                color: context.colorScheme.secondaryContainer,
                fontWeight: FontWeight.bold)));
  }
}
