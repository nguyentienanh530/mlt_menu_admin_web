import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_admin_web/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin_web/features/user/bloc/user_bloc.dart';
import 'package:mlt_menu_admin_web/features/user/data/model/user_model.dart';
import 'package:mlt_menu_admin_web/common/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../common/bloc/bloc_helper.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../core/utils/utils.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final TextEditingController currentCtrl = TextEditingController();
  final TextEditingController newCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          _buildAppbar(context),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                _CurrentPassword(currentCtrl: currentCtrl),
                const SizedBox(height: 16),
                _NewPassword(newCtrl: newCtrl),
                const SizedBox(height: 32),
                _buildButtonSubmit(context)
              ]))
        ]));
  }

  Widget _buildButtonSubmit(BuildContext context) {
    return FilledButton.icon(
        onPressed: () => handleChangePass(context),
        icon: const Icon(Icons.update_rounded),
        label: Text('Cập nhật',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)));
  }

  void handleChangePass(BuildContext context) {
    var isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      logger.i(currentCtrl.text);
      logger.i(newCtrl.text);
      context.read<UserBloc>().add(PasswordChanged(
          currentPassword: currentCtrl.text, newPassword: newCtrl.text));
      showDialog(
          context: context,
          builder: (context) =>
              BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
                  buildWhen: (previous, current) =>
                      context.read<UserBloc>().operation == ApiOperation.update,
                  builder: (context, state) => switch (state.status) {
                        Status.empty => const SizedBox(),
                        Status.loading => Center(
                            child: SpinKitCircle(
                                color: context.colorScheme.secondary,
                                size: 30)),
                        Status.failure => RetryDialog(
                            title: state.error ?? "Error",
                            onRetryPressed: () => context.read<UserBloc>().add(
                                PasswordChanged(
                                    currentPassword: currentCtrl.text,
                                    newPassword: newCtrl.text))),
                        Status.success => ProgressDialog(
                            descriptrion: "Thành công",
                            onPressed: () {
                              pop(context, 2);
                            },
                            isProgressed: false)
                      }));
    }
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_remove_rounded))
      ],
      title: Text('Đổi mật khẩu', style: context.titleStyleMedium));
}

class _CurrentPassword extends StatelessWidget {
  const _CurrentPassword({required this.currentCtrl});
  final TextEditingController currentCtrl;

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        controller: currentCtrl,
        prefixIcon: const Icon(Icons.lock),
        onChanged: (value) {
          currentCtrl.text = value;
        },
        hintText: 'Mật khẩu hiện tại',
        validator: (value) {
          if (value != '' &&
              value!.contains(RegExp(
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))) {
            return null;
          }
          return 'Mật khẩu không hợp lệ!';
        });
  }
}

class _NewPassword extends StatelessWidget {
  const _NewPassword({required this.newCtrl});
  final TextEditingController newCtrl;

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        controller: newCtrl,
        prefixIcon: const Icon(Icons.lock),
        hintText: 'Mật khẩu mới',
        onChanged: (value) {
          newCtrl.text = value;
        },
        validator: (value) {
          if (value != '' &&
              value!.contains(RegExp(
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))) {
            return null;
          }
          return 'Mật khẩu không hợp lệ!';
        });
  }
}
