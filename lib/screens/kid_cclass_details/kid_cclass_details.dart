import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/utils/functions.dart';
import 'package:intl/intl.dart';

class KidCclassDetails extends StatefulWidget {
  final Map<String, dynamic> classDetails;
  KidCclassDetails(this.classDetails);
  @override
  _KidCclassDetailsState createState() => _KidCclassDetailsState();
}

class _KidCclassDetailsState extends State<KidCclassDetails> {
  var schedule = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.classDetails['classType'] == 'c') {
      schedule = jsonDecode(widget.classDetails['kidClassResponse'].schedule);
    }
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            StandardScreen(
                child: Builder(builder: (BuildContext context) {
                  return SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: Text(
                                "هذا الفصل فى شهر ${widget.classDetails['kidClassResponse'].month} الحصة رقم ${widget.classDetails['kidClassResponse'].currentSessionNumber}",
                                style: TextStyle(
                                    color: ThemeSettings.kidsColor,
                                    fontSize: ThemeSettings.fontMedSize),
                              ),
                            )),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: ThemeSettings.bgClassTextColor,
                              padding: EdgeInsets.all(20),
                              child: Text(
                                widget.classDetails['kidClassResponse']
                                    .courseMessage,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ThemeSettings.fontMedSize),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (widget.classDetails['kidClassResponse'].teachers
                                .isNotEmpty)
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Text(
                                      "المدرسة : ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize),
                                    ),
                                    Text(
                                      widget.classDetails['kidClassResponse']
                                          .teachers[0]['name'],
                                      style: TextStyle(
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: Center(
                                    child: ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    color: ThemeSettings
                                                        .btnBorderColor,
                                                    width: 2)),
                                            backgroundColor: Colors.white,
                                          ),
                                          // color: Colors.white,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/kidTeacherNotes',
                                                arguments: {
                                                  "c_type": widget.classDetails[
                                                      'classType'],
                                                  "kid_class_id": widget
                                                      .classDetails['kidId'],
                                                  "level_name": widget
                                                      .classDetails[
                                                          'kidClassResponse']
                                                      .levelName,
                                                });
                                          }, //
                                          child: Text("ارسل ملاحظة للمدرس",
                                              style: TextStyle(
                                                  fontSize: ThemeSettings
                                                      .fontNormalSize,
                                                  fontFamily: 'Tajawal',
                                                  color:
                                                      ThemeSettings.kidsColor)),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5),
                                          //     side: BorderSide(
                                          //         color:
                                          //             ThemeSettings.kidsColor,
                                          //         width: 2)),
                                        )))),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Divider(
                                    color: ThemeSettings.breakLineColor)),
                            Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Wrap(children: [
                                  Text("مصاريف الاشتراك : ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(widget.classDetails['kidClassResponse']
                                              .classPaid ==
                                          'true'
                                      ? "✔️"
                                      : "✖️")
                                ])),
                            if (widget.classDetails['classType'] == 'n' &&
                                widget.classDetails['kidClassResponse']
                                        .classPaid ==
                                    'true' &&
                                widget.classDetails['kidClassResponse']
                                        .nextPaymentDate !=
                                    null)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text("حتى تاريخ : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .nextPaymentDate)
                                  ])),
                            if (widget.classDetails['classType'] == 'c' &&
                                widget.classDetails['kidClassResponse']
                                        .classPaid ==
                                    'true' &&
                                widget.classDetails['kidClassResponse']
                                        .nextpaymentSessionNo !=
                                    null)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text("حتى حصة رقم : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .nextpaymentSessionNo)
                                  ])),
                            if (widget.classDetails['classType'] == 'c' &&
                                widget.classDetails['kidClassResponse']
                                        .classPaid ==
                                    'true' &&
                                widget.classDetails['kidClassResponse']
                                        .nextpaymentSessionNo !=
                                    null)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text("حتى تاريخ : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .nextPaymentDate)
                                  ])),
                            if (widget.classDetails['kidClassResponse']
                                .booksMarkup.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        "الكتب: ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize),
                                      ),
                                      Text(
                                          widget
                                              .classDetails['kidClassResponse']
                                              .booksMarkup
                                              .replaceAll("check", " ✔️ ")
                                              .replaceAll("times", " ✖️ "),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ThemeSettings.fontMedSize))
                                    ],
                                  )),
                            if (widget.classDetails['kidClassResponse']
                                .uniformsMarkup.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        "الزى: ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize),
                                      ),
                                      Text(
                                          widget
                                              .classDetails['kidClassResponse']
                                              .uniformsMarkup
                                              .replaceAll("check", " ✔️ ")
                                              .replaceAll("times", " ✖️ "),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ThemeSettings.fontMedSize))
                                    ],
                                  )),
                            if (widget.classDetails['kidClassResponse']
                                .miscMarkup.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        "الاداوات: ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize),
                                      ),
                                      Text(
                                          widget
                                              .classDetails['kidClassResponse']
                                              .miscMarkup
                                              .replaceAll("check", " ✔️ ")
                                              .replaceAll("times", " ✖️ "),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ThemeSettings.fontMedSize))
                                    ],
                                  )),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Divider(
                                    color: ThemeSettings.breakLineColor)),
                            Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Wrap(children: [
                                  Text("الفرع: ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(widget
                                      .classDetails['kidClassResponse'].branch)
                                ])),
                            if (widget.classDetails['classType'] == 'n')
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text("وقت البدء: ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(replaceAmPM(DateFormat("h:mma").format(
                                        DateFormat("hh:mm:ss").parse(widget
                                            .classDetails['kidClassResponse']
                                            .startTime))))
                                  ])),
                            if (widget.classDetails['classType'] == 'n')
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text("وقت الانتهاء: ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(replaceAmPM(DateFormat("h:mma").format(
                                        DateFormat("hh:mm:ss").parse(widget
                                            .classDetails['kidClassResponse']
                                            .endTime))))
                                  ])),
                            if (widget.classDetails['classType'] == 'c')
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Table(
                                    children: [
                                      TableRow(
                                          decoration: BoxDecoration(
                                              color: ThemeSettings.tableColor),
                                          children: [
                                            Column(children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  child: Text('اليوم',
                                                      style: TextStyle(
                                                          fontSize: ThemeSettings
                                                              .fontMedSize)))
                                            ]),
                                            Column(children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  child: Text('وقت الوصول',
                                                      style: TextStyle(
                                                          fontSize: ThemeSettings
                                                              .fontMedSize)))
                                            ]),
                                            Column(children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  child: Text('وقت الرحيل',
                                                      style: TextStyle(
                                                          fontSize: ThemeSettings
                                                              .fontMedSize)))
                                            ]),
                                          ]),
                                      for (var i = 0; i < schedule.length; i++)
                                        TableRow(children: [
                                          Column(children: [
                                            // Padding(
                                            //     padding: EdgeInsets.only(
                                            //         top: 10, bottom: 10),
                                            //     child: Text(
                                            //         arabicDayName(
                                            //             schedule[i]['day']),
                                            //         style: TextStyle(
                                            //             fontSize: ThemeSettings
                                            //                 .fontMedSize)))
                                          ]),
                                          Column(children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Text(
                                                    replaceAmPM(
                                                        schedule[i]['start']),
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize)))
                                          ]),
                                          Column(children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Text(
                                                    replaceAmPM(
                                                        schedule[i]['end']),
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize)))
                                          ]),
                                        ])
                                    ],
                                  )),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Divider(
                                    color: ThemeSettings.breakLineColor)),
                            Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: Center(
                                    child: ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    color: ThemeSettings
                                                        .btnBorderColor,
                                                    width: 2)),
                                            backgroundColor: Colors.white,
                                          ),
                                          // color: Colors.white,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/kidAttendance',
                                                arguments: {
                                                  "c_type": widget.classDetails[
                                                      'classType'],
                                                  "kid_id": widget
                                                      .classDetails['kidId'],
                                                  "level_name": widget
                                                      .classDetails[
                                                          'kidClassResponse']
                                                      .levelName,
                                                });
                                          }, //
                                          child: Text("الغياب",
                                              style: TextStyle(
                                                  fontSize: ThemeSettings
                                                      .fontNormalSize,
                                                  fontFamily: 'Tajawal',
                                                  color: ThemeSettings
                                                      .btnBorderColor)),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5),
                                          //     side: BorderSide(
                                          //         color: ThemeSettings
                                          //             .btnBorderColor,
                                          //         width: 2)),
                                        )))),
                            Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: Center(
                                    child: ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    color: ThemeSettings
                                                        .btnBorderColor,
                                                    width: 2)),
                                            backgroundColor: Colors.white,
                                          ),
                                          // color: Colors.white,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/kidGrade',
                                                arguments: {
                                                  "c_type": widget.classDetails[
                                                      'classType'],
                                                  "kid_id": widget
                                                      .classDetails['kidId'],
                                                  "level_name": widget
                                                      .classDetails[
                                                          'kidClassResponse']
                                                      .levelName,
                                                });
                                          }, //
                                          child: Text("التقييم",
                                              style: TextStyle(
                                                  fontSize: ThemeSettings
                                                      .fontNormalSize,
                                                  fontFamily: 'Tajawal',
                                                  color: ThemeSettings
                                                      .btnBorderColor)),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5),
                                          //     side: BorderSide(
                                          //         color: ThemeSettings
                                          //             .btnBorderColor,
                                          //         width: 2)),
                                        )))),
                            Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: Center(
                                    child: ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    color: ThemeSettings
                                                        .btnBorderColor,
                                                    width: 2)),
                                            backgroundColor: Colors.white,
                                          ),
                                          // color: Colors.white,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/kidNotes',
                                                arguments: {
                                                  "c_type": widget.classDetails[
                                                      'classType'],
                                                  "kid_id": widget
                                                      .classDetails['kidId'],
                                                  "level_name": widget
                                                      .classDetails[
                                                          'kidClassResponse']
                                                      .levelName,
                                                });
                                          }, //
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("الملاحظات",
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontNormalSize,
                                                        fontFamily: 'Tajawal',
                                                        color: ThemeSettings
                                                            .btnBorderColor)),
                                                if (widget
                                                            .classDetails[
                                                                'kidClassResponse']
                                                            .notes !=
                                                        null &&
                                                    int.parse(widget
                                                            .classDetails[
                                                                'kidClassResponse']
                                                            .notes) >
                                                        0)
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child:
                                                          Icon(Icons.warning))
                                              ]),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5),
                                          //     side: BorderSide(
                                          //         color: ThemeSettings
                                          //             .btnBorderColor,
                                          //         width: 2)),
                                        )))),
                            Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: Center(
                                    child: ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    color: ThemeSettings
                                                        .btnBorderColor,
                                                    width: 2)),
                                            backgroundColor: Colors.white,
                                          ),
                                          // color: Colors.white,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/kidFinancials',
                                                arguments: {
                                                  "c_type": widget.classDetails[
                                                      'classType'],
                                                  "kid_id": widget
                                                      .classDetails['kidId'],
                                                  "level_name": widget
                                                      .classDetails[
                                                          'kidClassResponse']
                                                      .levelName,
                                                });
                                          }, //
                                          child: Text("الماليات",
                                              style: TextStyle(
                                                  fontSize: ThemeSettings
                                                      .fontNormalSize,
                                                  fontFamily: 'Tajawal',
                                                  color: ThemeSettings
                                                      .btnBorderColor)),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5),
                                          //     side: BorderSide(
                                          //         color: ThemeSettings
                                          //             .btnBorderColor,
                                          //         width: 2)),
                                        )))),
                          ]));
                }),
                screenIndex: widget.classDetails['index'],
                title: " المستوى " +
                    widget.classDetails['kidClassResponse'].levelName));
  }
}
