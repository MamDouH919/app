import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';

class CourseDetails extends StatefulWidget {
  final Map<String, dynamic> courseDetails;
  CourseDetails(this.courseDetails);
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  String _baseUrl = AppData.serverURL;

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
              title: "الكورسات",
              screenIndex: widget.courseDetails['index'],
              appBarBGColor: ThemeSettings.coursesAppBar,
              child: Builder(builder: (BuildContext context) {
                return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget
                                                .courseDetails['courseData']
                                                .photo ==
                                            "default"
                                        ? _baseUrl +
                                            '/media/courses/default.png'
                                        : _baseUrl +
                                            widget.courseDetails['courseData']
                                                .photo),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 3.2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        ThemeSettings.picksAppBarGradientColor
                                            .withOpacity(0.5),
                                      ],
                                      stops: [
                                        0.0,
                                      ])),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.2,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3.2) *
                                            0.55,
                                        right: 20),
                                    child: Text(
                                        "كورسات " +
                                            widget.courseDetails['courseData']
                                                .title,
                                        style: TextStyle(
                                            fontSize:
                                                ThemeSettings.fontMedCardSize,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                          ]),
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 25),
                            child: Text("تفاصيل الكورس",
                                style: TextStyle(
                                    fontSize: ThemeSettings.fontMedCardSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 20),
                            child: Row(
                              children: [
                                Text(
                                  "السن: ",
                                  style: TextStyle(
                                      color: ThemeSettings.homeAppbarColor,
                                      fontSize: ThemeSettings.fontNormalSize),
                                ),
                                Text(
                                  "من " +
                                      widget
                                          .courseDetails['courseData'].minAge +
                                      " الى " +
                                      widget.courseDetails['courseData'].maxAge,
                                  style: TextStyle(
                                      fontSize: ThemeSettings.fontNormalSize,
                                      color: ThemeSettings.textColor),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 20),
                            child: Text(
                                widget.courseDetails['courseData'].description),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 70),
                              child: Center(
                                  child: ButtonTheme(
                                      minWidth: 300,
                                      height: 50,
                                      child: ElevatedButton(
                                        // color: ThemeSettings.homeAppbarColor,
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                            backgroundColor: ThemeSettings.homeAppbarColor,
                                          ),
                                        onPressed: () async {
                                          final bool isAuthed =
                                              state.user != null &&
                                                  state.user!.token != null;
                                          if (isAuthed) {
                                            Navigator.pushNamed(
                                                context, '/courseRegister',
                                                arguments: {
                                                  "index": widget
                                                      .courseDetails['index'],
                                                  "courseData":
                                                      widget.courseDetails[
                                                          'courseData']
                                                });
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
            ));
  }
}
