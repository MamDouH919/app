import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/home/homeAPi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/widgets/standardTextFieldWidget/index.dart';

class Courses extends StatefulWidget {
  final int currentIndex;
  Courses(this.currentIndex);
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  List courses = [];
  String _baseUrl = AppData.serverURL;
  List _searchResult = [];
  List coursesTemp = [];

  void initState() {
    getCoursesCategories();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getCoursesCategories() async {
    HomeApi.getHomeData().then((value) {
      setState(() {
        courses = coursesTemp = List.castFrom(value['courses'] ?? []);
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_searchResult.length != 0) {
      courses = _searchResult;
    } else {
      courses = coursesTemp;
    }
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
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 25),
                            child: Text("ابحث",
                                style: TextStyle(
                                    fontSize: ThemeSettings.fontMedCardSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 20, left: 20),
                              child: StandardTextField(
                                hintText: "ماذا تريد ان تتعلم؟",
                                icon: Icon(
                                  Icons.search,
                                  color: ThemeSettings.textColor,
                                ),
                                keyboardType: TextInputType.text,
                                filled: true,
                                filledColor: ThemeSettings.textFiledColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                onChanged: onSearchTextChanged,
                                primaryColor: ThemeSettings.homeAppbarColor,
                              )),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/coursesCategories',
                                          arguments: {
                                            "courseId": courses[index]['id'],
                                            "courseTitle": courses[index]
                                                ['title'],
                                            "index": widget.currentIndex,
                                            "courseImage": courses[index]
                                                ['photo']
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
                      getCoursesCategories();
                    },
                  );
                },
              ),
              title: "الكورسات",
              screenIndex: widget.currentIndex,
              appBarBGColor: ThemeSettings.coursesAppBar,
            ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    coursesTemp.forEach((course) {
      if (course['title'].contains(text)) _searchResult.add(course);
    });

    setState(() {});
  }
}
