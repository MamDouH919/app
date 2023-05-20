import 'package:flutter/material.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';

class BulletList extends StatelessWidget {
  final List<String> strings;

  BulletList(this.strings);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(0, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u2022',
                style: TextStyle(
                    fontSize: ThemeSettings.fontNormalSize,
                    height: 1.55,
                    fontWeight: FontWeight.bold,
                    color: ThemeSettings.homeAppbarColor),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    str,
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: ThemeSettings.fontNormalSize,
                      color: ThemeSettings.textColor,
                      height: 1.55,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
