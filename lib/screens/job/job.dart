import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/job/job_response.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/widgets/bulletList/bulletList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Job extends StatefulWidget {
  final JobResponse job;
  Job(this.job);

  @override
  _JobState createState() => _JobState();
}

class _JobState extends State<Job> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? sharedPreferences;
  String? userType;

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
            StandardScreen(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 3.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "lib/assets/job/job_details_background.png"),
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
                              height: MediaQuery.of(context).size.height / 3.2,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: (MediaQuery.of(context).size.height /
                                              3.2) *
                                          0.55,
                                      right: 20),
                                  child: Text(widget.job.title,
                                      style: TextStyle(
                                          fontSize:
                                              ThemeSettings.fontMedCardSize,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)))),
                        ]),
                        Padding(
                            padding: EdgeInsets.only(top: 18, right: 20),
                            child: Text(
                              "مهام الوظيفه",
                              style: TextStyle(
                                  color: ThemeSettings.homeAppbarColor,
                                  fontSize: ThemeSettings.fontSubHeaderSize,
                                  fontWeight: FontWeight.bold),
                            )),
                        BulletList(removeEmptyValues(
                            widget.job.description.split('.'))),
                        Padding(
                            padding: EdgeInsets.only(top: 18, right: 20),
                            child: Text(
                              "المهارات المطلوبه للوظيفه",
                              style: TextStyle(
                                  color: ThemeSettings.homeAppbarColor,
                                  fontSize: ThemeSettings.fontSubHeaderSize,
                                  fontWeight: FontWeight.bold),
                            )),
                        BulletList(
                            removeEmptyValues(widget.job.skills.split('.'))),
                        Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: 67, bottom: 21),
                                child: ButtonTheme(
                                    minWidth: 300,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        backgroundColor: Colors.blue,
                                      ),
                                      // color: ThemeSettings.submitBtnColor,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/jobApplication',
                                            arguments: widget.job);
                                      }, //
                                      child: Text("تقديم",
                                          style: TextStyle(
                                              fontSize:
                                                  ThemeSettings.fontNormalSize,
                                              fontFamily: 'Tajawal',
                                              color: Colors.white)),
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(5)),
                                    )))),
                      ]),
                ),
                title: " وظيفة " + widget.job.title));
  }

  List<String> removeEmptyValues(List array) {
    List<String> output = [];

    array.forEach((element) {
      if (element.trim().isNotEmpty) {
        output.add(element.trim());
      }
    });

    return output;
  }

  //show helpful msgs
  // void showInSnackBar(String value) {
  //   _scaffoldKey.currentState!.showSnackBar(SnackBar(
  //       content: Text(
  //     value,
  //     textAlign: TextAlign.center,
  //   )));
  // }
}
