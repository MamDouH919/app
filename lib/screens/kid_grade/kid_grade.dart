import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:percent_indicator/percent_indicator.dart';

class KidGrade extends StatefulWidget {
  final Map<String, dynamic> kidDetails;
  KidGrade(this.kidDetails);
  @override
  _KidGradeState createState() => _KidGradeState();
}

class _KidGradeState extends State<KidGrade> {
  List kidGrade = [
    {'eval_average': 0}
  ];

  void initState() {
    getKidEval();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getKidEval() async {
    KidsAPi.getKidPercentage(
            widget.kidDetails['kid_id'], widget.kidDetails['c_type'])
        .then((value) {
      setState(() {
        kidGrade = List.castFrom(value['percentage']) ?? [];
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            StandardScreen(
              child: RefreshIndicator(
                color: ThemeSettings.homeAppbarColor,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 20),
                              child: Text(
                                "التقييم الكلى",
                                style: TextStyle(
                                    color: ThemeSettings.kidsColor,
                                    fontSize: ThemeSettings.fontCardSize,
                                    fontWeight: FontWeight.bold),
                              )),
                          kidGrade[0] != null &&
                                  kidGrade[0]['eval_average'] != null &&
                                  kidGrade[0]['eval_average'] != 0
                              ? new CircularPercentIndicator(
                                  backgroundColor: ThemeSettings.indicatorColor,
                                  radius: 150.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent: (double.parse(
                                          kidGrade[0]['eval_average']) /
                                      100),
                                  center: new Text(
                                    double.parse(kidGrade[0]['eval_average'])
                                            .toInt()
                                            .toString() +
                                        ' %',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontCardSize),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: ThemeSettings.kidsColor,
                                )
                              : Text("لايوجد بعد",
                                  style: TextStyle(
                                    fontSize: ThemeSettings.fontSubHeaderSize,
                                  )),
                        ]))),
                onRefresh: () {
                  return Future.delayed(
                    Duration(milliseconds: 500),
                    () {
                      getKidEval();
                    },
                  );
                },
              ),
              title: " التقييم " + widget.kidDetails['level_name'],
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
