import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/kid_details/list_builder.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';

class KidDetails extends StatefulWidget {
  final Map<String, dynamic> kidDetails;
  KidDetails(this.kidDetails);

  @override
  _KidDetailsState createState() => _KidDetailsState();
}

class _KidDetailsState extends State<KidDetails> {
  String? kidImageData;
  String _baseUrl = AppData.serverURL;
  List courseClasses = [];
  List nurseryClasses = [];
  List courseRoutes = [];
  List nurseryRoutes = [];
  var kidImage;

  @override
  void initState() {
    super.initState();
    getKidsData();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getKidsData() async {
    KidsAPi.getClassesData(widget.kidDetails['kidResponse'].id).then((value) {
      setState(() {
        courseClasses = List.castFrom(value['cclasses'] ?? []);
        nurseryClasses = List.castFrom(value['nclasses'] ?? []);
        courseRoutes = List.castFrom(value['croutes'] ?? []);
        nurseryRoutes = List.castFrom(value['nroutes'] ?? []);
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  Future chooseImage(context) async {
    final picker = ImagePicker();
    PickedFile? image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      kidImage = File(image!.path);
    });
    image!.readAsBytes().then((value) {
      setState(() {
        kidImageData = base64Encode(value);
      });
    });
    try {
      var response = await KidsAPi.changeKidPicture(
          kidImageData, widget.kidDetails['kidResponse'].id);
      final Map<String, dynamic> responseObject = (response.body is Map)
          ? response.body as Map<String, dynamic>
          : jsonDecode(response.body) as Map<String, dynamic>;
      showNavigationSnackBar(context, responseObject['message']);
    } on ApiException catch (exception) {
      for (final ApiError error in exception.errors) {
        showNavigationSnackBar(context, error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            StandardScreen(
                child: Builder(builder: (BuildContext context) {
                  return RefreshIndicator(
                    color: ThemeSettings.homeAppbarColor,
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  constraints: BoxConstraints(maxHeight: 95),
                                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Row(children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 95,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // image: DecorationImage(
                                            //     image: kidImage != null
                                            //         ? FileImage(
                                            //             kidImage,
                                            //           )
                                            //         : NetworkImage(widget
                                            //                     .kidDetails[
                                            //                         'kidResponse']
                                            //                     .photo ==
                                            //                 "default"
                                            //             ? _baseUrl +
                                            //                 '/media/kids/default.png'
                                            //             : _baseUrl +
                                            //                 widget
                                            //                     .kidDetails[
                                            //                         'kidResponse']
                                            //                     .photo),
                                            //     fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 90,
                                          margin: EdgeInsets.only(top: 65),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5)),
                                              color: ThemeSettings.picChange
                                                  .withOpacity(0.5)),
                                        ),
                                        GestureDetector(
                                            onTap: () => chooseImage(context),
                                            child: Container(
                                              margin: EdgeInsets.only(top: 65),
                                              height: 30,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text("تغير الصورة",
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontSmallSize,
                                                        color: Colors.white)),
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 11,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 11),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "الاسم: ",
                                                  style: TextStyle(
                                                      color: ThemeSettings
                                                          .homeAppbarColor,
                                                      fontSize: ThemeSettings
                                                          .fontMedSize),
                                                ),
                                                Text(
                                                    widget
                                                        .kidDetails[
                                                            'kidResponse']
                                                        .name,
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize,
                                                        color: Colors.black))
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(top: 11),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "تاريح الميلاد: ",
                                                  style: TextStyle(
                                                      color: ThemeSettings
                                                          .homeAppbarColor,
                                                      fontSize: ThemeSettings
                                                          .fontMedSize),
                                                ),
                                                Text(
                                                    widget
                                                        .kidDetails[
                                                            'kidResponse']
                                                        .birthDate,
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize,
                                                        color: Colors.black))
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(top: 11),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "الديانة: ",
                                                  style: TextStyle(
                                                      color: ThemeSettings
                                                          .homeAppbarColor,
                                                      fontSize: ThemeSettings
                                                          .fontMedSize),
                                                ),
                                                Text(
                                                    widget
                                                        .kidDetails[
                                                            'kidResponse']
                                                        .religion,
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize,
                                                        color: Colors.black))
                                              ],
                                            )),
                                      ],
                                    ),
                                  ])),
                              Divider(color: ThemeSettings.breakLineColor),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/kidResponsible',
                                              arguments: {
                                                "kidResponse": widget
                                                    .kidDetails['kidResponse'],
                                                "index":
                                                    widget.kidDetails['index']
                                              });
                                        },
                                        child: Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: ThemeSettings.kidsColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              0, 20, 20, 20),
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      "المسؤلون عن استلامه",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ThemeSettings
                                                              .fontMedSize))),
                                              SvgPicture.asset(
                                                "lib/assets/kids/responsible.svg",
                                                semanticsLabel: "logo",
                                                height: 16,
                                                width: 16,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/kidFinancials',
                                              arguments: {
                                                "c_type": "kid",
                                                "kid_id": widget
                                                    .kidDetails['kidResponse']
                                                    .id,
                                                "level_name": "الطفل",
                                                "index":
                                                    widget.kidDetails['index']
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ThemeSettings.kidsColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          height: 70,
                                          margin: EdgeInsets.fromLTRB(
                                              20, 20, 20, 20),
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text("ماليات الطالب",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ThemeSettings
                                                              .fontMedSize))),
                                              SvgPicture.asset(
                                                "lib/assets/kids/financials.svg",
                                                semanticsLabel: "logo",
                                                height: 16,
                                                width: 16,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/academyNote',
                                        arguments: widget.kidDetails['index']);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: ThemeSettings
                                                .yourOpinionColor)),
                                    height: 70,
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    child: Center(
                                      child: Text("ما رايك في الاكاديميه ؟",
                                          style: TextStyle(
                                              color: ThemeSettings
                                                  .yourOpinionColor,
                                              fontSize:
                                                  ThemeSettings.fontMedSize)),
                                    ),
                                  )),
                              if (courseClasses.isNotEmpty ||
                                  nurseryClasses.isNotEmpty ||
                                  courseRoutes.isNotEmpty ||
                                  nurseryRoutes.isNotEmpty)
                                Divider(color: ThemeSettings.breakLineColor),
                              if (courseClasses.isNotEmpty)
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                                    child: Text(
                                      "الكورسات",
                                      style: TextStyle(
                                          color: ThemeSettings.textColor,
                                          fontSize:
                                              ThemeSettings.fontSubHeaderSize),
                                    )),
                              if (courseClasses.isNotEmpty)
                                ListViewBuilderWidget(
                                    list: courseClasses,
                                    dataType: 'level_name',
                                    bgColor: ThemeSettings.cClassColor,
                                    route: "/kidClassDetails",
                                    classType: "c",
                                    kidId: widget.kidDetails['kidResponse'].id,
                                    screenIndex: widget.kidDetails['index'],
                                    type: "c"),
                              if (nurseryClasses.isNotEmpty)
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                                    child: Text(
                                      "الحضانة",
                                      style: TextStyle(
                                          color: ThemeSettings.textColor,
                                          fontSize:
                                              ThemeSettings.fontSubHeaderSize),
                                    )),
                              if (nurseryClasses.isNotEmpty)
                                ListViewBuilderWidget(
                                    list: nurseryClasses,
                                    dataType: 'level_name',
                                    route: "/kidClassDetails",
                                    classType: "n",
                                    kidId: widget.kidDetails['kidResponse'].id,
                                    screenIndex: widget.kidDetails['index'],
                                    type: "c",
                                    bgColor: ThemeSettings.nClassColor),
                              if (courseRoutes.isNotEmpty)
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                                    child: Text(
                                      "خطوط الكورسات",
                                      style: TextStyle(
                                          color: ThemeSettings.textColor,
                                          fontSize:
                                              ThemeSettings.fontSubHeaderSize),
                                    )),
                              if (courseRoutes.isNotEmpty)
                                ListViewBuilderWidget(
                                    list: courseRoutes,
                                    dataType: 'route_id',
                                    route: "/kidRouteDetails",
                                    kidId: widget.kidDetails['kidResponse'].id,
                                    screenIndex: widget.kidDetails['index'],
                                    classType: "c",
                                    bgColor: ThemeSettings.cClassColor),
                              if (nurseryRoutes.isNotEmpty)
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                                    child: Text(
                                      "خطوط الحضانة",
                                      style: TextStyle(
                                          color: ThemeSettings.textColor,
                                          fontSize:
                                              ThemeSettings.fontSubHeaderSize),
                                    )),
                              if (nurseryRoutes.isNotEmpty)
                                ListViewBuilderWidget(
                                    route: "/kidRouteDetails",
                                    list: nurseryRoutes,
                                    dataType: 'route_id',
                                    kidId: widget.kidDetails['kidResponse'].id,
                                    screenIndex: widget.kidDetails['index'],
                                    classType: "n",
                                    bgColor: ThemeSettings.nClassColor),
                            ])),
                    onRefresh: () {
                      return Future.delayed(
                        Duration(milliseconds: 500),
                        () {
                          getKidsData();
                        },
                      );
                    },
                  );
                }),
                screenIndex: widget.kidDetails['index'],
                title: " الطالب " + widget.kidDetails['kidResponse'].name));
  }
}
