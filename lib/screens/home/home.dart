import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/job/job_response.dart';
import 'package:starkids_app/data/kid/kid_response.dart';
import 'package:starkids_app/data/poster/poster_response.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/home/homeAPi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class MainPage extends StatefulWidget {
  final int currentIndex;
  MainPage(this.currentIndex);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _baseUrl = AppData.serverURL;
  String? userType;
  List courses = [];
  List testmonials = [];
  List jobs = [];
  List posters = [];
  List kids = [];
  String nursery = '';
  Map<String, dynamic> data = {};
  List coursesOffers = [];
  List nurseryOffers = [];

  void initState() {
    getUserType();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getUserType() async {
    HomeApi.getHomeData().then((value) {
      setState(() {
        courses = List.castFrom(value['courses'] ?? []);
        testmonials = List.castFrom(value['testmonials'] ?? []);
        jobs = List.castFrom(value['jobs']);
        posters = List.castFrom(value['posters'] ?? []);
        kids = List.castFrom(value['kids'] ?? []);
        nursery = value['nursery'] ?? '';
        coursesOffers = List.castFrom(value['courses_offers'] ?? []);
        nurseryOffers = List.castFrom(value['nursery_offers'] ?? []);
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget;
    childWidget = RefreshIndicator(
      color: ThemeSettings.homeAppbarColor,
      child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),

          //courses part
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (posters.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                      child: Text(
                        "إعلانات خاصةً بالأكاديمية",
                        style: TextStyle(
                            color: ThemeSettings.textColor,
                            fontSize: ThemeSettings.fontSubHeaderSize),
                      )),
                if (posters.isNotEmpty)
                  SizedBox(
                      height: 80,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: posters.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/poster',
                                      arguments: PosterResponse.fromJson(
                                          posters[index]));
                                },
                                child: Container(
                                  margin: index == posters.length - 1
                                      ? EdgeInsets.fromLTRB(20, 0, 20, 0)
                                      : EdgeInsets.only(right: 20),
                                  height: 78,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        image: NetworkImage(_baseUrl +
                                            posters[index]['poster_pic']),
                                        fit: BoxFit.cover),
                                  ),
                                ));
                          })),
                if (posters.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.5, 17.5, 24.5, 0),
                      child: Divider(color: ThemeSettings.breakLineColor)),
                if (kids.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                      child: Text(
                        "طلابك",
                        style: TextStyle(
                            color: ThemeSettings.textColor,
                            fontSize: ThemeSettings.fontSubHeaderSize),
                      )),
                if (kids.isNotEmpty)
                  SizedBox(
                      height: 186.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: kids.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/kidDetails',
                                      arguments: {
                                        "kidResponse":
                                            KidResponse.fromJson(kids[index]),
                                        "index": widget.currentIndex,
                                      });
                                },
                                child: Container(
                                  margin: index == kids.length - 1
                                      ? EdgeInsets.fromLTRB(20, 0, 20, 0)
                                      : EdgeInsets.only(right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 121,
                                        width: 128,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(kids[index]
                                                          ['photo'] ==
                                                      "default"
                                                  ? _baseUrl +
                                                      '/media/courses/default.png'
                                                  : _baseUrl +
                                                      kids[index]['photo']),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 11),
                                          child: Text(kids[index]['name'],
                                              style: TextStyle(
                                                  color:
                                                      ThemeSettings.textColor,
                                                  fontSize: ThemeSettings
                                                      .fontMedSize)))
                                    ],
                                  ),
                                ));
                          })),
                if (kids.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.5, 17.5, 24.5, 0),
                      child: Divider(color: ThemeSettings.breakLineColor)),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                    child: Text(
                      "الكورسات",
                      style: TextStyle(
                          color: ThemeSettings.textColor,
                          fontSize: ThemeSettings.fontSubHeaderSize),
                    )),
                SizedBox(
                    height: 186.5,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/coursesCategories',
                                    arguments: {
                                      "courseId": courses[index]['id'],
                                      "courseTitle": courses[index]['title'],
                                      "index": widget.currentIndex,
                                      "courseImage": courses[index]['photo']
                                    });
                              },
                              child: Container(
                                margin: index == courses.length - 1
                                    ? EdgeInsets.fromLTRB(20, 0, 20, 0)
                                    : EdgeInsets.only(right: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 121,
                                      width: 128,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: NetworkImage(courses[index]
                                                        ['photo'] ==
                                                    "default"
                                                ? _baseUrl +
                                                    '/media/courses/default.png'
                                                : _baseUrl +
                                                    courses[index]['photo']),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 11),
                                        child: Text(courses[index]['title'],
                                            style: TextStyle(
                                                color: ThemeSettings.textColor,
                                                fontSize:
                                                    ThemeSettings.fontMedSize)))
                                  ],
                                ),
                              ));
                        })),
                if (coursesOffers.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.5, 17.5, 24.5, 0),
                      child: Divider(color: ThemeSettings.breakLineColor)),
                if (coursesOffers.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                      child: Text(
                        "عروض الكورسات",
                        style: TextStyle(
                            color: ThemeSettings.textColor,
                            fontSize: ThemeSettings.fontSubHeaderSize),
                      )),
                if (coursesOffers.isNotEmpty)
                  SizedBox(
                      height: 186.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: coursesOffers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/offerDetails',
                                      arguments: {
                                        "courseId": coursesOffers[index]['id'],
                                        "offerData": coursesOffers[index],
                                        "index": widget.currentIndex
                                      });
                                },
                                child: Container(
                                  margin: index == courses.length - 1
                                      ? EdgeInsets.fromLTRB(20, 0, 20, 0)
                                      : EdgeInsets.only(right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 121,
                                        width: 128,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(coursesOffers[
                                                          index]['photo'] ==
                                                      "default"
                                                  ? _baseUrl +
                                                      '/media/offers/default.png'
                                                  : _baseUrl +
                                                      coursesOffers[index]
                                                          ['photo']),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 11),
                                          child: Text(
                                              coursesOffers[index]
                                                  ['offer_title'],
                                              style: TextStyle(
                                                  color:
                                                      ThemeSettings.textColor,
                                                  fontSize: ThemeSettings
                                                      .fontMedSize)))
                                    ],
                                  ),
                                ));
                          })),
                if (coursesOffers.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.5, 17.5, 24.5, 0),
                      child: Divider(color: ThemeSettings.breakLineColor)),
                if (nurseryOffers.isNotEmpty && nurseryOffers[0].isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                      child: Text(
                        "عروض الحضانة",
                        style: TextStyle(
                            color: ThemeSettings.textColor,
                            fontSize: ThemeSettings.fontSubHeaderSize),
                      )),
                if (nurseryOffers.isNotEmpty && nurseryOffers[0].isNotEmpty)
                  SizedBox(
                      height: 186.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: nurseryOffers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/nurseryDetails', arguments: {
                                    "nursery_text": nursery,
                                    "offerData": nurseryOffers[index]
                                  });
                                },
                                child: Container(
                                  margin: index == courses.length - 1
                                      ? EdgeInsets.fromLTRB(20, 0, 20, 0)
                                      : EdgeInsets.only(right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 121,
                                        width: 128,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(nurseryOffers[
                                                          index]['offer_pic'] ==
                                                      "default"
                                                  ? _baseUrl +
                                                      '/media/offers/default.png'
                                                  : _baseUrl +
                                                      nurseryOffers[index]
                                                          ['offer_pic']),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 11),
                                          child: Text(
                                              nurseryOffers[index]['title'],
                                              style: TextStyle(
                                                  color:
                                                      ThemeSettings.textColor,
                                                  fontSize: ThemeSettings
                                                      .fontMedSize)))
                                    ],
                                  ),
                                ));
                          })),
                if (nurseryOffers.isNotEmpty && nurseryOffers[0].isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.5, 17.5, 24.5, 0),
                      child: Divider(color: ThemeSettings.breakLineColor)),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                    child: Text(
                      "الحضانة",
                      style: TextStyle(
                          color: ThemeSettings.textColor,
                          fontSize: ThemeSettings.fontSubHeaderSize),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Center(
                        child: Text(
                      nursery.trim() ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ))),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.blue,
                          ),
                          // color: ThemeSettings.homeAppbarColor,
                          onPressed: () {
                            Navigator.pushNamed(context, '/nurseryDetails',
                                arguments: {
                                  "nursery_text": nursery,
                                  "offerData": nurseryOffers[0]
                                });
                          }, //
                          child: Text("تفاصيل",
                              style: TextStyle(
                                  fontSize: ThemeSettings.fontNormalSize,
                                  fontFamily: 'Tajawal',
                                  color: Colors.white)),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(5)),
                        ))),
                if (testmonials.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.5, 0, 24.5, 0),
                      child: Divider(color: ThemeSettings.breakLineColor)),
                if (testmonials.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                      child: Text(
                        "اراء أولياء الامور",
                        style: TextStyle(
                            color: ThemeSettings.textColor,
                            fontSize: ThemeSettings.fontSubHeaderSize),
                      )),
                if (testmonials.isNotEmpty)
                  SizedBox(
                      height: 130,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: testmonials.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: index == testmonials.length - 1
                                      ? EdgeInsets.fromLTRB(20, 0, 20, 0)
                                      : EdgeInsets.only(right: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 83,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          _baseUrl +
                                                              testmonials[index]
                                                                  ['avatar']),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 11),
                                                  child: Text(
                                                      testmonials[index][
                                                          'name'],
                                                      style: TextStyle(
                                                          color: ThemeSettings
                                                              .textColor,
                                                          fontSize: ThemeSettings
                                                              .fontNormalSize)))
                                            ],
                                          ),
                                          ChatBubble(
                                            clipper: ChatBubbleClipper2(
                                                type: BubbleType.sendBubble),
                                            margin: EdgeInsets.only(right: 6),
                                            backGroundColor:
                                                ThemeSettings.homeAppbarColor,
                                            child: Container(
                                              width: 230,
                                              constraints: BoxConstraints(
                                                maxHeight: 83,
                                              ),
                                              child: Text(
                                                testmonials[index]
                                                    ['testimonial'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: ThemeSettings
                                                        .fontMedSize),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          })),
                if (jobs.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.5, 0, 24.5, 0),
                      child: Divider(color: ThemeSettings.breakLineColor)),
                if (jobs.isNotEmpty)
                  GestureDetector(
                      onTap: () => {
                            Navigator.pushNamed(context, '/jobs',
                                arguments: jobs)
                          },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 24, 13.5),
                          child: Text(
                            "الوظائف",
                            style: TextStyle(
                                color: ThemeSettings.textColor,
                                fontSize: ThemeSettings.fontSubHeaderSize),
                          ))),
                if (jobs.isNotEmpty)
                  SizedBox(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/job',
                                      arguments:
                                          JobResponse.fromJson(jobs[index]));
                                },
                                child: Container(
                                    constraints: BoxConstraints(maxHeight: 83),
                                    margin: index == jobs.length - 1
                                        ? EdgeInsets.fromLTRB(20, 0, 20, 0)
                                        : EdgeInsets.only(right: 20),
                                    child: Row(children: [
                                      Container(
                                        height: 83,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "lib/assets/home/job_background.png"),
                                              fit: BoxFit.cover),
                                        ),
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
                                              child: Text(
                                                  "مطلوب " +
                                                      jobs[index]['title'],
                                                  style: TextStyle(
                                                      color: ThemeSettings
                                                          .textColor,
                                                      fontSize: ThemeSettings
                                                          .fontNormalSize))),
                                          Padding(
                                              padding: EdgeInsets.only(top: 11),
                                              child: Text(
                                                  " الفرع: " +
                                                      jobs[index]
                                                          ['branch_name'],
                                                  style: TextStyle(
                                                      color: ThemeSettings
                                                          .homeAppbarColor,
                                                      fontSize: ThemeSettings
                                                          .fontNormalSize))),
                                        ],
                                      ),
                                    ])));
                          }))
              ])),
      onRefresh: () {
        return Future.delayed(
          Duration(milliseconds: 500),
          () {
            getUserType();
          },
        );
      },
    );

    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder:
            (BuildContext context, _, AppState state, __, ___, Widget? child) =>
                StandardScreen(
                  child: childWidget,
                  title: "الرئيسية",
                  screenIndex: widget.currentIndex,
                ));
  }
}
