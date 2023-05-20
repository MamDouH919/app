import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/store/appState/appState.dart';
// import 'package:starkids_app/widgets/navigationSnackBar/index.dart';

class Picks extends StatefulWidget {
  @override
  _PicksState createState() => _PicksState();
}

class _PicksState extends State<Picks> {
  String userType = "none";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            Scaffold(
                key: _scaffoldKey,
                body: Builder(builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Column(children: [
                      Stack(children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2.7,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("lib/assets/picks/appbar.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Center(
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 2.7,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          "lib/assets/picks/logo.svg",
                                          semanticsLabel: "logo"),
                                      Text("http://www.starkids-academy.com/",
                                          style: TextStyle(
                                            fontFamily: 'Tajawal',
                                            fontSize: ThemeSettings.fontMedSize,
                                            color: ThemeSettings.linkColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ))
                                    ]))),
                        Container(
                          height: MediaQuery.of(context).size.height / 2.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    ThemeSettings.picksAppBarGradientColor
                                        .withOpacity(0.3),
                                  ],
                                  stops: [
                                    0.0,
                                  ])),
                        ),
                      ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text("الدخول كـ",
                                  style: TextStyle(
                                      fontSize: ThemeSettings.fontCardSize,
                                      fontFamily: 'Tajawal',
                                      color: ThemeSettings.submitBtnColor)),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userType = "parent";
                                });
                                // showNavigationSnackBar(
                                //     context, "تم اختيار ولى الامر");
                                _handleSubmitted();
                              },
                              child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  child: SvgPicture.asset(
                                      "lib/assets/picks/parent.svg",
                                      semanticsLabel: "ولى امر")),
                            ),
                            // GestureDetector(
                            //     onTap: () {
                            //       setState(() {
                            //         userType = "teacher";
                            //       });
                            //       showNavigationSnackBar(
                            //           context, "تم اختيار  المدرس");
                            //     },
                            //     child: Container(
                            //       height: 150,
                            //       child: SvgPicture.asset(
                            //           "lib/assets/picks/teacher.svg",
                            //           semanticsLabel: "مدرس"),
                            //     )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    userType = "guest";
                                  });
                                  // showNavigationSnackBar(
                                  //     context, "تم اختيار  الزائر");
                                  _handleSubmitted();
                                },
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  child: SvgPicture.asset(
                                      "lib/assets/picks/guest.svg",
                                      semanticsLabel: "زائر"),
                                )),
                            // Padding(
                            //     padding: EdgeInsets.only(top: 67, bottom: 21),
                            //     child: ButtonTheme(
                            //         minWidth: 300,
                            //         height: 50,
                            //         child: RaisedButton(
                            //           color: ThemeSettings.submitBtnColor,
                            //           onPressed: _handleSubmitted, //
                            //           child: Text("تأكيد",
                            //               style: TextStyle(
                            //                   fontSize:
                            //                       ThemeSettings.fontNormalSize,
                            //                   fontFamily: 'Tajawal',
                            //                   color: Colors.white)),
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(5)),
                            //         ))),
                          ])
                    ]),
                  );
                })));
  }

  //submit user type
  void _handleSubmitted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (userType == "none") {
      // showInSnackBar("اختار نوع التسجيل");
    } else {
      prefs.setString("userType", userType);
      if (userType == "guest") {
        Navigator.pushNamed(context, '/home');
      } else {
        Navigator.pushNamed(context, '/login', arguments: userType);
      }
    }
  }

  //show helpful msgs
  // void showInSnackBar(String value) {
  //   _scaffoldKey.currentState?.showSnackBar(SnackBar(
  //       content: Text(
  //     value,
  //     textAlign: TextAlign.center,
  //   )));
  // }
}
