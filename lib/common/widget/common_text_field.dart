import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField(
      {super.key,
      this.errorText,
      required this.onChanged,
      this.hintText,
      this.keyboardType,
      this.obscureText,
      this.suffixIcon,
      this.validator,
      this.controller,
      this.prefixIcon,
      this.maxLines});
  final String? errorText;
  final TextInputType? keyboardType;
  final Function(String) onChanged;
  final String? hintText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller!,
        validator: validator,
        textAlignVertical: TextAlignVertical.center,
        key: key,
        maxLines: maxLines,
        style: context.textStyleSmall,
        textAlign: TextAlign.start,
        keyboardType: keyboardType ?? TextInputType.text,
        autocorrect: false,
        readOnly: false,
        autofocus: false,
        obscureText: obscureText ?? false,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
            isDense: true,
            // enabled: false,
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                borderSide: BorderSide(color: context.colorScheme.error)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                borderSide: BorderSide(color: context.colorScheme.error)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                borderSide: BorderSide(color: context.colorScheme.primary)),
            suffixIcon: suffixIcon ?? const SizedBox(),
            prefixIcon: prefixIcon ?? const SizedBox(),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                borderSide: BorderSide(color: context.colorScheme.primary)),
            errorText: errorText,
            contentPadding: EdgeInsets.only(left: defaultPadding),
            filled: true,
            hintText: hintText,
            errorStyle: context.textStyleSmall!
                .copyWith(color: context.colorScheme.error),
            hintStyle: context.textStyleSmall,
            labelStyle: context.textStyleSmall),
        onChanged: onChanged);
  }
}
