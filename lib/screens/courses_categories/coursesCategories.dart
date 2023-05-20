import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/courses/courses_response.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/courses/coursesApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class CoursesCategories extends StatefulWidget {
  final Map<String, dynamic> courseCategoireData;
  CoursesCategories(this.courseCategoireData);
  @override
  _CoursesCategoriesState createState() => _CoursesCategoriesState();
}

class _CoursesCategoriesState extends State<CoursesCategories> {
  List courses = [];
  String _baseUrl = AppData.serverURL;

  void initState() {
    getCoursesByCategorieId();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getCoursesByCategorieId() async {
    CoursesApi.getCourseCategorie(widget.courseCategoireData['courseId'])
        .then((value) {
      setState(() {
        courses = List.castFrom(value['courses'] ?? []);
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
                color: ThemeSettings.coursesAppBar,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.courseCategoireData[
                                                    'courseImage'] ==
                                                "default"
                                            ? _baseUrl +
                                                '/media/courses/default.png'
                                            : _baseUrl +
                                                widget.courseCategoireData[
                                                    'courseImage']),
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
                                            widget.courseCategoireData[
                                                'courseTitle'],
                                        style: TextStyle(
                                            fontSize:
                                                ThemeSettings.fontMedCardSize,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                          ]),
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 25),
                            child: Text(
                                "كورسات " +
                                    widget.courseCategoireData['courseTitle'],
                                style: TextStyle(
                                    fontSize: ThemeSettings.fontMedCardSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/courseDetails',
                                          arguments: {
                                            "index": widget
                                                .courseCategoireData['index'],
                                            "courseData":
                                                CoursesResponse.fromJson(
                                                    courses[index])
                                          });
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Text(
                                                      courses[index]['title'],
                                                      style: TextStyle(
                                                          color: ThemeSettings
                                                              .textColor,
                                                          fontSize: ThemeSettings
                                                              .fontMedSize)))),
                                          Expanded(
                                              child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10, left: 20),
                                            height: 121,
                                            width: 128,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: DecorationImage(
                                                  image: NetworkImage(courses[
                                                              index]['photo'] ==
                                                          "default"
                                                      ? _baseUrl +
                                                          '/media/courses/default.png'
                                                      : _baseUrl +
                                                          courses[index]
                                                              ['photo']),
                                                  fit: BoxFit.cover),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ));
                              })
                        ])),
                onRefresh: () {
                  return Future.delayed(
                    Duration(milliseconds: 500),
                    () {
                      getCoursesByCategorieId();
                    },
                  );
                },
              ),
              title: "الكورسات",
              screenIndex: widget.courseCategoireData['index'],
              appBarBGColor: ThemeSettings.coursesAppBar,
            ));
  }
}
