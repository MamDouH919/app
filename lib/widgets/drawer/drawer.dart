import 'package:flutter/material.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/services/user/userApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/actions/SignOut.action.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerTab extends StatelessWidget {
  bool isCurrentRoute(String routeName, AppState state) =>
      state.ui?.currentRoute == routeName;

  void navigate(String routeName, AppState state, BuildContext context) {
    if (!isCurrentRoute(routeName, state)) {
      Navigator.pushNamed(context, routeName);
    } else {
      // close drawer
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___, ____) =>
            Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Drawer(
                  child: new ListView(
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "lib/assets/drawer/drawer_logo.png")),
                        ),
                        child: Text(''),
                      ),
                      new ListTile(
                        title: new Text("تواصل معنا",
                            style: TextStyle(
                                color: ThemeSettings.textColor,
                                fontSize: ThemeSettings.fontMedCardSize)),
                        onTap: () => navigate("/contactUs", state, context),
                      ),
                      if (state.user != null && state.user!.token != null)
                        ListTile(
                          title: new Text("الاعدادات",
                              style: TextStyle(
                                  color: ThemeSettings.textColor,
                                  fontSize: ThemeSettings.fontMedCardSize)),
                          onTap: () => navigate("/settings", state, context),
                        ),
                      if (state.user != null && state.user!.token != null)
                        ListTile(
                          title: new Text("تسجيل الخروج",
                              style: TextStyle(
                                  color: ThemeSettings.homeAppbarColor,
                                  fontSize: ThemeSettings.fontMedCardSize)),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            try {
                              await UserApi.updateUserFirebaseToken("none");
                            } on ApiException catch (exception) {
                              for (final ApiError error in exception.errors) {
                                print(error.message);
                              }
                            }

                            GlobalRedux.dispatch(EnableLoadingAction());
                            GlobalRedux.dispatch(SignOutAction());
                            showNavigationSnackBar(
                                context, 'تم تسجيل خروجك بنجاح');

                            prefs.setString("userType", "guest");
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (_) => false);
                          },
                        ),
                      if (state.user == null)
                        ListTile(
                          title: new Text("تسجيل الدخول",
                              style: TextStyle(
                                  color: ThemeSettings.homeAppbarColor,
                                  fontSize: ThemeSettings.fontMedCardSize)),
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (_) => false);
                          },
                        ),
                    ],
                  ),
                )));
  }
}
