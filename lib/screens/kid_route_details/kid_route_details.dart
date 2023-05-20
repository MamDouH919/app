import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';

class KidRouteDetails extends StatefulWidget {
  final Map<String, dynamic> classDetails;
  KidRouteDetails(this.classDetails);
  @override
  _KidRouteDetailsState createState() => _KidRouteDetailsState();
}

class _KidRouteDetailsState extends State<KidRouteDetails> {
  var schedule = [];
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
                child: Builder(builder: (BuildContext context) {
                  return SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: ThemeSettings.bgClassTextColor,
                              padding: EdgeInsets.all(20),
                              child: Text(
                                widget.classDetails['kidClassResponse']
                                    .kidMessage,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ThemeSettings.fontMedSize),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Divider(
                                    color: ThemeSettings.breakLineColor)),
                            if (widget.classDetails['classType'] == 'n' &&
                                widget.classDetails['kidClassResponse']
                                    .paymentString.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text("الشهور المدفوعه : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .paymentString)
                                  ])),
                            if (widget.classDetails['classType'] == 'c' &&
                                widget.classDetails['kidClassResponse']
                                    .paymentString.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text("الدورات المدفوعه : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .paymentString)
                                  ])),
                            Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Wrap(children: [
                                  Text("الباص : ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(widget.classDetails['kidClassResponse']
                                              .busPaid ==
                                          'true'
                                      ? "✔️"
                                      : "✖️")
                                ])),
                            if (widget.classDetails['classType'] == 'n' &&
                                widget.classDetails['kidClassResponse'].endDate
                                    .isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text(" حتى تاريخ : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .renwalDate)
                                  ])),
                            if (widget.classDetails['classType'] == 'c' &&
                                widget.classDetails['kidClassResponse']
                                    .routePeriod.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text(" حتى الركوب رقم : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .rideNumber)
                                  ])),
                            if (widget.classDetails['classType'] == 'c' &&
                                widget.classDetails['kidClassResponse']
                                    .routePeriod.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Wrap(children: [
                                    Text(" رقم الدورة الحالية : ",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize)),
                                    Text(widget.classDetails['kidClassResponse']
                                        .currentPeriod)
                                  ])),
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
                                                context, '/kidRouteAttendance',
                                                arguments: {
                                                  "c_type": widget.classDetails[
                                                      'classType'],
                                                  "kid_id": widget
                                                      .classDetails['kidId'],
                                                  "route_id": widget
                                                      .classDetails[
                                                          'kidClassResponse']
                                                      .routeId,
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
                                                context, '/kidRouteFinancials',
                                                arguments: {
                                                  "c_type": widget.classDetails[
                                                      'classType'],
                                                  "kid_id": widget
                                                      .classDetails['kidId'],
                                                  "route_id": widget
                                                      .classDetails[
                                                          'kidClassResponse']
                                                      .routeId,
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
                title: " الخط " +
                    widget.classDetails['kidClassResponse'].routeId));
  }
}
