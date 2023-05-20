import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class KidResponsible extends StatefulWidget {
  final Map<String, dynamic> kidDetails;
  KidResponsible(this.kidDetails);
  @override
  _KidResponsibleState createState() => _KidResponsibleState();
}

class _KidResponsibleState extends State<KidResponsible> {
  List people = [];
  String _baseUrl = AppData.serverURL;

  void initState() {
    getCoursesByCategorieId();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getCoursesByCategorieId() async {
    KidsAPi.getKidResponsible(int.parse(widget.kidDetails['kidResponse'].id))
        .then((value) {
      setState(() {
        people = List.castFrom(value['responsible'] ?? []);
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
                  color: ThemeSettings.messagesHeader,
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 25),
                              child: Text(
                                  "المسؤلين عن استلام  " +
                                      widget.kidDetails['kidResponse'].name,
                                  style: TextStyle(
                                      fontSize: ThemeSettings.fontMedCardSize,
                                      color: ThemeSettings.homeAppbarColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                            if (people.length > 0)
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: people.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ThemeSettings
                                                        .homeAppbarColor),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            constraints:
                                                BoxConstraints(maxHeight: 80),
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            child: Row(children: [
                                              Container(
                                                height: 47,
                                                width: 47,
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                      image: NetworkImage(people[
                                                                      index]
                                                                  ['photo'] ==
                                                              "default"
                                                          ? _baseUrl +
                                                              '/media/auth/default.png'
                                                          : _baseUrl +
                                                              people[index]
                                                                  ['photo']),
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
                                                      padding: EdgeInsets.only(
                                                          top: 11),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "الاسم: ",
                                                            style: TextStyle(
                                                                color: ThemeSettings
                                                                    .homeAppbarColor,
                                                                fontSize:
                                                                    ThemeSettings
                                                                        .fontMedSize),
                                                          ),
                                                          Text(
                                                              people[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      ThemeSettings
                                                                          .fontMedSize,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 11, bottom: 11),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "الرقم القومى: ",
                                                            style: TextStyle(
                                                                color: ThemeSettings
                                                                    .homeAppbarColor,
                                                                fontSize:
                                                                    ThemeSettings
                                                                        .fontMedSize),
                                                          ),
                                                          Text(
                                                              people[index]
                                                                  ['public_id'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      ThemeSettings
                                                                          .fontMedSize,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ])));
                                  }),
                            if (people.length == 0)
                              Center(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                2),
                                    child: Center(
                                        child: Text('لا يوجد بعد',
                                            style: TextStyle(
                                                color: ThemeSettings.textColor,
                                                fontSize: ThemeSettings
                                                    .fontNormalSize)))),
                              ),
                            Padding(
                                padding: EdgeInsets.only(
                                    right: 20, left: 20, top: 20),
                                child: Center(
                                    child: ButtonTheme(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                            backgroundColor: ThemeSettings.homeAppbarColor,
                                          ),
                                          // color: ThemeSettings.homeAppbarColor,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/responsibleRegister',
                                                arguments: widget
                                                    .kidDetails['kidResponse']);
                                          }, //
                                          child: Text("سجل شخص جديد",
                                              style: TextStyle(
                                                  fontSize: ThemeSettings
                                                      .fontNormalSize,
                                                  fontFamily: 'Tajawal',
                                                  color: Colors.white)),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5)),
                                        ))))
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
                screenIndex: widget.kidDetails['index'],
                title: "مسؤلين " + widget.kidDetails['kidResponse'].name,
                appBarBGColor: ThemeSettings.homeAppbarColor));
  }
}
