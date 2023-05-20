import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:intl/intl.dart';
import 'package:starkids_app/utils/functions.dart';

class KidAttendanceMonth extends StatefulWidget {
  final Map<String, dynamic> kidAttendanceMonth;
  KidAttendanceMonth(this.kidAttendanceMonth);
  @override
  _KidAttendanceMonthState createState() => _KidAttendanceMonthState();
}

class _KidAttendanceMonthState extends State<KidAttendanceMonth> {
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
                  child: Column(children: [
                for (var i = 0;
                    i < widget.kidAttendanceMonth['list'].length;
                    i++)
                  if (widget.kidAttendanceMonth['list'][i] != null &&
                      widget.kidAttendanceMonth['list'][i].isNotEmpty)
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 145,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: ThemeSettings.kidsColor),
                            borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("رقم الحصة: ",
                                                    style: TextStyle(
                                                        color: ThemeSettings
                                                            .kidsColor,
                                                        fontSize: ThemeSettings
                                                            .fontMedSize)),
                                                Text(
                                                    widget.kidAttendanceMonth[
                                                            'list'][i]
                                                            ['session_number']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize,
                                                        color: Colors.black))
                                              ],
                                            )),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("اليوم: ",
                                                    style: TextStyle(
                                                        color: ThemeSettings
                                                            .kidsColor,
                                                        fontSize: ThemeSettings
                                                            .fontMedSize)),
                                                // Text(
                                                //     arabicDayName(DateFormat(
                                                //             'EEE')
                                                //         .format(DateTime.parse(
                                                //             widget.kidAttendanceMonth[
                                                //                     'list'][i][
                                                //                 'session_date']))),
                                                //     style: TextStyle(
                                                //         fontSize: ThemeSettings
                                                //             .fontMedSize,
                                                //         color: Colors.black))
                                              ],
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("وقت الوصول: ",
                                                style: TextStyle(
                                                    color:
                                                        ThemeSettings.kidsColor,
                                                    fontSize: ThemeSettings
                                                        .fontMedSize)),
                                            widget.kidAttendanceMonth['list'][i]
                                                        ['arrival_time'] !=
                                                    null
                                                ? Text(
                                                    replaceAmPM(DateFormat("hh:mm a")
                                                        .format(DateTime.parse(
                                                            "2021-12-23 " +
                                                                widget.kidAttendanceMonth['list'][i]['arrival_time']
                                                                    .toString()))),
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize,
                                                        color: Colors.black))
                                                : Icon(Icons.close,
                                                    size: 12, color: Colors.red)
                                          ],
                                        ),
                                      ],
                                    ))),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("التاريخ: ",
                                            style: TextStyle(
                                                color: ThemeSettings.kidsColor,
                                                fontSize:
                                                    ThemeSettings.fontMedSize)),
                                        Text(
                                            widget.kidAttendanceMonth['list'][i]
                                                ['session_date'],
                                            style: TextStyle(
                                                fontSize:
                                                    ThemeSettings.fontMedSize,
                                                color: Colors.black))
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("الحضور: ",
                                            style: TextStyle(
                                                color: ThemeSettings.kidsColor,
                                                fontSize:
                                                    ThemeSettings.fontMedSize)),
                                        widget.kidAttendanceMonth['list'][i]
                                                    ['arrival_time'] !=
                                                null
                                            ? Icon(Icons.check,
                                                size: 12, color: Colors.green)
                                            : Icon(Icons.close,
                                                size: 12, color: Colors.red)
                                      ],
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("وقت الرحيل: ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    widget.kidAttendanceMonth['list'][i]
                                                ['leave_time'] !=
                                            null
                                        ? Text(
                                            replaceAmPM(DateFormat("hh:mm a").format(
                                                DateTime.parse("2021-12-23 " +
                                                    widget
                                                        .kidAttendanceMonth['list']
                                                            [i]['leave_time']
                                                        .toString()))),
                                            style: TextStyle(
                                                fontSize:
                                                    ThemeSettings.fontMedSize,
                                                color: Colors.black))
                                        : Icon(Icons.close,
                                            size: 12, color: Colors.red)
                                  ],
                                ),
                              ],
                            ))
                          ],
                        ))
              ])),
              title: " شهر " + widget.kidAttendanceMonth['month'],
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
