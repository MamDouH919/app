import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';

class NurseryDetails extends StatefulWidget {
  final Map<String, dynamic> nurseryDetails;
  NurseryDetails(this.nurseryDetails);
  @override
  _NurseryDetailsState createState() => _NurseryDetailsState();
}

class _NurseryDetailsState extends State<NurseryDetails> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            StandardScreen(
              child: Builder(builder: (BuildContext context) {
                return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 25),
                            child: Text("تفاصيل الحضانة",
                                style: TextStyle(
                                    fontSize: ThemeSettings.fontMedCardSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: 20, top: 20, left: 20),
                            child: Text(widget.nurseryDetails['nursery_text']),
                          ),
                          if (widget.nurseryDetails['offerData'].isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 25),
                              child: Text("يوجد عرض متاح سجل الان",
                                  style: TextStyle(
                                      fontSize: ThemeSettings.fontMedCardSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          if (widget.nurseryDetails['offerData'].isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "عدد الاشتراكات المتاحة: ",
                                    style: TextStyle(
                                        color: ThemeSettings.homeAppbarColor,
                                        fontSize: ThemeSettings.fontNormalSize),
                                  ),
                                  Text(
                                    widget.nurseryDetails['offerData']
                                            ['offer_numbers']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontNormalSize,
                                        color: ThemeSettings.textColor),
                                  )
                                ],
                              ),
                            ),
                          if (widget.nurseryDetails['offerData'].isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 20),
                              child: Text(widget.nurseryDetails['offerData']
                                      ['details']
                                  .trim()),
                            ),
                          Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 30),
                              child: Center(
                                  child: ButtonTheme(
                                      minWidth: 300,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          backgroundColor:
                                              ThemeSettings.homeAppbarColor,
                                        ),
                                        // color: ThemeSettings.homeAppbarColor,
                                        onPressed: () async {
                                          final bool isAuthed =
                                              state.user != null &&
                                                  state.user!.token != null;
                                          if (isAuthed) {
                                            Navigator.pushNamed(
                                                context, '/nurseryRegister');
                                          } else {
                                            showNavigationSnackBar(context,
                                                'يجب عليك تسجيل الدخول اولا');

                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                "userType", "parent");
                                            Future.delayed(
                                                Duration(milliseconds: 250),
                                                () {
                                              Navigator.pushNamed(
                                                  context, '/login',
                                                  arguments: "parent");
                                            });
                                          }
                                        }, //
                                        child: Text("سجل لطفلك",
                                            style: TextStyle(
                                                fontSize: ThemeSettings
                                                    .fontNormalSize,
                                                fontFamily: 'Tajawal',
                                                color: Colors.white)),
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(5)),
                                      )))),
                        ]));
              }),
              title: "الحضانة",
              screenIndex: 2,
              appBarBGColor: ThemeSettings.nurseryAppBar,
            ));
  }
}
