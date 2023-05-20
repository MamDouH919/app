import 'package:flutter/material.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/widgets/standardTextFieldWidget/index.dart';

class BorderedTextField extends StatelessWidget {
  final Icon? icon;
  final IconButton? sendIcon;
  final bool? iconBtn;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String Function(String?)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String?)? onChanged;
  final Color? primaryColor;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final InputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final void Function()? onTap;
  final Icon? suffixIcon;
  final UnderlineInputBorder? border;
  final Color? hintColor;
  const BorderedTextField(
      {Key? key,
      this.icon,
      this.labelText,
      this.hintText,
      this.errorText,
      this.initialValue,
      this.maxLength,
      this.keyboardType,
      this.validator,
      this.controller,
      this.onChanged,
      this.primaryColor,
      this.obscureText = false,
      this.enabled,
      this.maxLines,
      this.minLines,
      this.enabledBorder,
      this.focusedBorder,
      this.suffixIcon,
      this.border,
      this.onTap,
      this.hintColor,
      this.iconBtn,
      this.sendIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardTextField(
      enabled: enabled,
      onChanged: onChanged,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLength: maxLength,
      iconBtn: iconBtn,
      sendIcon: sendIcon,
      icon: icon,
      onTap: onTap,
      suffixIcon: suffixIcon,
      primaryColor: primaryColor,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      validator: validator,
      obscureText: obscureText,
      minLines: minLines,
      maxLines: maxLines,
      border: border,
      hintColor: hintColor,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeSettings.smallBorderRadius),
        borderSide: const BorderSide(
          width: 1.0,
          color: ThemeSettings.errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeSettings.smallBorderRadius),
        borderSide: const BorderSide(
          width: 1.0,
          color: ThemeSettings.errorColor,
        ),
      ),
    );
  }
}
