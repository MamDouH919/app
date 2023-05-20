import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/job/job_response.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/widgets/standardTextFieldWidget/index.dart';

class Jobs extends StatefulWidget {
  final List jobPositions;
  Jobs(this.jobPositions);
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List tempJobs = [];
  List _searchResult = [];

  void initState() {
    tempJobs = widget.jobPositions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchResult.length != 0) {
      tempJobs = _searchResult;
    } else {
      tempJobs = widget.jobPositions;
    }
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            StandardScreen(
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
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
                              hintText: "ماذا تريد ان تعمل؟",
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
                            itemCount: tempJobs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/job',
                                        arguments: JobResponse.fromJson(
                                            tempJobs[index]));
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "مطلوب " +
                                                            tempJobs[index]
                                                                ['title'],
                                                        style: TextStyle(
                                                            color: ThemeSettings
                                                                .textColor,
                                                            fontSize: ThemeSettings
                                                                .fontMedCardSize)),
                                                    Text(
                                                        " الفرع: " +
                                                            tempJobs[index]
                                                                ['branch_name'],
                                                        style: TextStyle(
                                                            color: ThemeSettings
                                                                .homeAppbarColor,
                                                            fontSize: ThemeSettings
                                                                .fontNormalSize)),
                                                    Text(
                                                        " المرتب: " +
                                                            tempJobs[index]
                                                                ['salary'],
                                                        style: TextStyle(
                                                            color: ThemeSettings
                                                                .textColor,
                                                            fontSize: ThemeSettings
                                                                .fontNormalSize)),
                                                  ],
                                                ))),
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
                                                image: AssetImage(
                                                    "lib/assets/home/job_background.png"),
                                                fit: BoxFit.cover),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ));
                            })
                      ])),
              title: "الوظائف",
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.jobPositions.forEach((job) {
      if (job['title'].contains(text) || job['branch_name'].contains(text))
        _searchResult.add(job);
    });

    setState(() {});
  }
}
