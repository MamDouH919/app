import 'package:flutter/material.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/icons/custom_icon_icons.dart';
import 'package:starkids_app/widgets/badeIcon/badge_icon.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int? currentIndex;
  final String? userType;
  final Function? changeIndex;
  final bool loggedIn;
  final int? messagesCount;

  CustomBottomNavigationBar(
      {Key? key,
      this.currentIndex,
      this.userType,
      this.changeIndex,
      required this.loggedIn,
      this.messagesCount})
      : super(key: key);

  @override
  CustomBottomNavigationBarState createState() {
    return CustomBottomNavigationBarState();
  }
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex!,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ThemeSettings.homeAppbarColor,
      showUnselectedLabels: false,
      selectedFontSize: ThemeSettings.fontMedSize,
      iconSize: ThemeSettings.fontMedSize,
      items: [
        if (!widget.loggedIn)
          const BottomNavigationBarItem(
              icon: Icon(CustomIcon.signup, size: 20), label: "انشاء حساب"),
        if (widget.loggedIn)
          BottomNavigationBarItem(
              icon: BadgeIcon(
                  icon: const Icon(
                    Icons.message_rounded,
                    size: 20,
                  ),
                  badgeCount: widget.messagesCount!, badgeTextStyle: TextStyle(color:Colors.amber )),
              label: "الرسائل"),
        const BottomNavigationBarItem(
            icon: Icon(CustomIcon.browse, size: 20), label: "المتصفح"),
        const BottomNavigationBarItem(
            icon: Icon(CustomIcon.home, size: 20), label: "الرئيسية"),
      ],
      onTap: (index) {
        widget.changeIndex!(index);
      },
    );
  }
}
