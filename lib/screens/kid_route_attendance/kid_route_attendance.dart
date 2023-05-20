import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class KidRouteAttendance extends StatefulWidget {
  final Map<String, dynamic> kidClassDetails;
  KidRouteAttendance(this.kidClassDetails);
  @override
  _KidRouteAttendanceState createState() => _KidRouteAttendanceState();
}

class _KidRouteAttendanceState extends State<KidRouteAttendance> {
  dynamic monthsAttendance;
  void initState() {
    getKidRouteAttendance();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getKidRouteAttendance() async {
    KidsAPi.getKidRouteAttendance(
            widget.kidClassDetails['kid_id'], widget.kidClassDetails['c_type'])
        .then((value) {
      setState(() {
        monthsAttendance = value['attendance_month'] ?? [];
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
                            for (var i = 0; i < monthsAttendance.length; i++)
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/kidRouteAttendanceMonth',
                                          arguments: {
                                            "list": monthsAttendance[
                                                    (i + 1).toString()] ??
                                                [],
                                            "month": (i + 1).toString()
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
                                      child: Text(" شهر " + (i + 1).toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ThemeSettings
                                                  .fontSubHeaderSize)),
                                    )),
                              ),
                        ]),
              title: " الغياب ",
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
