import 'package:flutter/material.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';

class StandardDropdownField<T> extends StatelessWidget {
  final Icon? icon;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final T? initialValue;
  final String Function(T?)? validator;
  final void Function(T?)? onChanged;
  final Map<T, String> values;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? focusedErrorBorder;
  final Color? primaryColor;

  const StandardDropdownField(
      {Key? key,
      this.icon,
      this.labelText,
      this.hintText,
      this.errorText,
      this.initialValue,
      this.validator,
      required this.onChanged,
      required this.values,
      this.enabledBorder,
      this.focusedBorder,
      this.errorBorder,
      this.focusedErrorBorder,
      this.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: new ThemeData(
          primaryColor: primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: ThemeSettings.standardPadding),
          child: DropdownButtonFormField<T>(
            value: initialValue,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: icon,
              labelText: labelText,
              hintText: hintText,
              errorText: errorText,
              enabledBorder: enabledBorder,
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ThemeSettings.smallBorderRadius),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: ThemeSettings.errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ThemeSettings.smallBorderRadius),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: ThemeSettings.errorColor,
                ),
              ),
            ),
            items: values.entries
                .map(
                  (MapEntry<T, String> entry) => DropdownMenuItem<T>(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
          ),
        ));
  }
}
