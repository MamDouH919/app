import 'package:flutter/material.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';

class StandardLoading extends StatelessWidget {
  final Color backgroundColor;

  const StandardLoading(
      {Key? key, this.backgroundColor = ThemeSettings.homeAppbarColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      backgroundColor: this.backgroundColor,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
    ));
  }
}
