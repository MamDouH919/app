import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class KidAttendance extends StatefulWidget {
  final Map<String, dynamic> kidClassDetails;
  KidAttendance(this.kidClassDetails);
  @override
  _KidAttendanceState createState() => _KidAttendanceState();
}

class _KidAttendanceState extends State<KidAttendance> {
  dynamic monthsAttendance;
  int startingMonth = 0;
  void initState() {
    getKidClassAttendance();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getKidClassAttendance() async {
    KidsAPi.getKidClassAttendance(
            widget.kidClassDetails['kid_id'], widget.kidClassDetails['c_type'])
        .then((value) {
      setState(() {
        monthsAttendance = value['attendance_month'] ?? [];
        startingMonth = value['starting_month'] ?? 0;
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
              child: monthsAttendance == null || monthsAttendance.isEmpty
                  ? Center(
                      child: Text("لا يوجد حضور بعد"),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(8),
                      children: [
                          if (monthsAttendance != null)
                            for (var i = startingMonth;
                                i <= monthsAttendance.length + startingMonth;
                                i++)
                              if (monthsAttendance[(i).toString()] != null)
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/kidAttendanceMonth',
                                            arguments: {
                                              "list": monthsAttendance[
                                                      (i).toString()] ??
                                                  [],
                                              "month": (i).toString()
                                            });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 110,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            color: ThemeSettings.kidsColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(" شهر " + (i).toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ThemeSettings
                                                    .fontSubHeaderSize)),
                                      )),
                                ),
                        ]),
              title: " غياب " + widget.kidClassDetails['level_name'],
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
