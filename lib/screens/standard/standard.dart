import 'package:flutter/material.dart';
import 'package:starkids_app/services/user/userApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/widgets/bottomNavigationBar/index.dart';
import 'package:starkids_app/widgets/drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/widgets/loader/index.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class StandardScreen extends StatefulWidget {
  final String? title;
  final Widget? child;
  final Alignment? alignment;
  final bool showDrawer;
  final bool showNavigator;
  final bool showAppBar;
  final GlobalKey? scafoldKey;
  final int? screenIndex;
  final Color? appBarBGColor;

  const StandardScreen(
      {Key? key,
      @required this.child,
      this.title,
      this.alignment = Alignment.topCenter,
      this.showDrawer = true,
      this.showNavigator = true,
      this.showAppBar = true,
      this.screenIndex,
      this.scafoldKey,
      this.appBarBGColor = ThemeSettings.homeAppbarColor})
      : super(key: key);

  _StandardScreenState createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {
  int? _currentIndex;
  SharedPreferences? sharedPreferences;
  String? userType;
  bool updateRouter = false;
  int messagesCount = 0;

  void initState() {
    getUserType();
    if (GlobalRedux.state.user != null &&
        GlobalRedux.state.user!.token != null) {
      getUserMessagesCount();
    }
    super.initState();
    _currentIndex = widget.screenIndex ?? 2;
  }

  void getUserMessagesCount() async {
    UserApi.getUserMessagesCount().then((value) {
      setState(() {
        messagesCount = int.parse(value['messages_count'] ?? 0) ?? 0;
      });
    });
  }

  void getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString("userType");
    });
  }

  void changeIndex(index) {
    setState(() {
      _currentIndex = index;
      updateRouter = true;
    });

    Future.delayed(Duration(milliseconds: 50), () {
      if (index == 2 && GlobalRedux.store.state.ui!.currentRoute != '/home') {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false,
            arguments: index);
      } else if (index == 1 &&
          GlobalRedux.store.state.ui!.currentRoute != '/courses') {
        Navigator.pushNamedAndRemoveUntil(context, '/courses', (_) => false,
            arguments: index);
      } else if (index == 0 &&
          GlobalRedux.store.state.ui!.currentRoute != '/register' &&
          GlobalRedux.store.state.user == null) {
        Navigator.pushNamedAndRemoveUntil(context, '/register', (_) => false,
            arguments: index);
      } else if (index == 0 &&
          GlobalRedux.store.state.ui!.currentRoute != '/Messages' &&
          GlobalRedux.store.state.user != null &&
          GlobalRedux.store.state.user!.token != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/Messages', (_) => false,
            arguments: index);
      } else if (index == 3 &&
          GlobalRedux.store.state.ui!.currentRoute != '/settings') {
        Navigator.pushNamedAndRemoveUntil(context, '/settings', (_) => false,
            arguments: index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder:
            (BuildContext context, _, AppState state, __, ___, Widget? child) =>
                Scaffold(
                    key: widget.scafoldKey,
                    resizeToAvoidBottomInset: true,
                    appBar: widget.showAppBar
                        ? AppBar(
                            centerTitle: true,
                            backgroundColor: widget.appBarBGColor,
                            title: Text(widget.title!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ThemeSettings.fontSubHeaderSize)),
                          )
                        : null,
                    drawer: widget.showDrawer ? DrawerTab() : null,
                    bottomNavigationBar: widget.showNavigator
                        ? CustomBottomNavigationBar(
                            currentIndex: _currentIndex!,
                            userType: userType!,
                            changeIndex: changeIndex,
                            loggedIn:
                                state.user != null && state.user!.token != null,
                            messagesCount: messagesCount,
                          )
                        : null,
                    body: Builder(
                      builder: (BuildContext context) => SafeArea(
                          child: state.ui?.loading == true
                              ? StandardLoading(
                                  backgroundColor: widget.appBarBGColor!)
                              : widget.child!),
                    )));
  }
}
