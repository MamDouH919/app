import 'package:flutter/material.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';

class StandardTextField extends StatelessWidget {
  final Icon? icon;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String Function(String?)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final InputBorder? enabledBorder;
  final OutlineInputBorder?focusedBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? focusedErrorBorder;
  final FocusNode? focusNode;
  final bool? filled;
  final Color? filledColor;
  final UnderlineInputBorder? border;
  final EdgeInsets? contentPadding;
  final Color? primaryColor;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final IconButton? sendIcon;
  final bool? iconBtn;
  final void Function()? onTap;
  final Icon? suffixIcon;
  final Color? hintColor;
  const StandardTextField(
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
      this.obscureText = false,
      this.enabledBorder,
      this.focusedBorder,
      this.errorBorder,
      this.focusedErrorBorder,
      this.focusNode,
      this.filled,
      this.filledColor,
      this.border,
      this.contentPadding,
      this.primaryColor,
      this.enabled,
      this.minLines,
      this.maxLines,
      this.onTap,
      this.suffixIcon,
      this.hintColor,
      this.sendIcon,
      this.iconBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          primaryColor: primaryColor,
          // useTextSelectionTheme: true,
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: primaryColor //thereby
                  ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: ThemeSettings.standardPadding),
          child: TextFormField(
            style: TextStyle(color: primaryColor),
            minLines: minLines,
            maxLines: maxLines,
            enabled: enabled,
            focusNode: focusNode,
            onChanged: onChanged,
            controller: controller,
            initialValue: initialValue,
            keyboardType: keyboardType,
            maxLength: maxLength,
            onTap: onTap,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              border: border,
              filled: filled,
              fillColor: filledColor,
              prefixIcon: icon,
              suffixIcon: iconBtn != null && iconBtn! ? sendIcon : suffixIcon,
              labelText: labelText,
              hintText: hintText,
              hintStyle: TextStyle(
                  color:
                      hintColor != null ? hintColor : ThemeSettings.textColor),
              labelStyle: TextStyle(
                  color:
                      hintColor != null ? hintColor : ThemeSettings.textColor),
              errorText: errorText,
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: focusedErrorBorder,
            ),
            validator: validator,
            obscureText: obscureText,
          ),
        ));
  }
}
