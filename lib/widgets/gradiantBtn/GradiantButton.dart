import 'package:flutter/material.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/widgets/loader/index.dart';

class GradientButton extends StatelessWidget {
  final Icon? icon;
  final String?labelText;
  final Function onPressed;
  final double? fontSize;
  final bool isDisabled;
  final bool isLoading;
  final Color? bgColor;

  const GradientButton(
      {Key? key,
      this.icon,
      this.labelText,
      required this.onPressed,
      this.fontSize,
      this.isDisabled = false,
      this.isLoading = false,
      this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? StandardLoading()
        : ElevatedButton(
            onPressed: () {
              if (!isDisabled) onPressed();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ThemeSettings.borderRadius)),
              onPrimary: Colors.white, // foreground
              padding: const EdgeInsets.all(0.0),
            ),
            child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(ThemeSettings.borderRadius),
                  color: isDisabled
                      ? Colors.grey
                      : bgColor != null
                          ? bgColor
                          : ThemeSettings.homeAppbarColor,
                ),
                padding: const EdgeInsets.only(
                  left: ThemeSettings.standardPadding,
                  right: ThemeSettings.standardPadding,
                ),
                child: SizedBox(
                  height: ThemeSettings.buttonHeight,
                  width: ThemeSettings.buttonWidth,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        icon != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    right: ThemeSettings.textPadding),
                                child: icon,
                              )
                            : const SizedBox.shrink(),
                        Text(labelText!)
                      ],
                    ),
                  ),
                )),
          );
  }
}
