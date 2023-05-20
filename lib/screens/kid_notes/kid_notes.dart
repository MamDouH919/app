import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class KidNotes extends StatefulWidget {
  final Map<String, dynamic> kidDetails;
  KidNotes(this.kidDetails);
  @override
  _KidNotesState createState() => _KidNotesState();
}

class _KidNotesState extends State<KidNotes> {
  List kidNotes = [];

  void initState() {
    getKidNotes();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getKidNotes() async {
    KidsAPi.getKidNotes(
            widget.kidDetails['kid_id'], widget.kidDetails['c_type'])
        .then((value) {
      setState(() {
        kidNotes = List.castFrom(value['notes'] ?? []);
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
                color: ThemeSettings.homeAppbarColor,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(children: [
                      kidNotes?.length == 0
                          ? Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Text("لا يوجد ملاحظات بعد"))
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: kidNotes.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ThemeSettings.kidsColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: EdgeInsets.all(16),
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 20, top: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text("المدرس: ",
                                                      style: TextStyle(
                                                          color: ThemeSettings
                                                              .kidsColor,
                                                          fontSize: ThemeSettings
                                                              .fontMedSize)),
                                                  Text(
                                                      kidNotes[index]
                                                          ['teacher_name'],
                                                      style: TextStyle(
                                                          fontSize:
                                                              ThemeSettings
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
                                                  Text("التاريخ: ",
                                                      style: TextStyle(
                                                          color: ThemeSettings
                                                              .kidsColor,
                                                          fontSize: ThemeSettings
                                                              .fontMedSize)),
                                                  Text(
                                                      kidNotes[index]
                                                          ['session_date'],
                                                      style: TextStyle(
                                                          fontSize:
                                                              ThemeSettings
                                                                  .fontMedSize,
                                                          color: Colors.black))
                                                ],
                                              )),
                                          Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ThemeSettings.kidsColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: SelectableText(
                                                  kidNotes[index]['note'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ThemeSettings
                                                          .fontMedSize)))
                                        ],
                                      )),
                                );
                              })
                    ])),
                onRefresh: () {
                  return Future.delayed(
                    Duration(milliseconds: 500),
                    () {
                      getKidNotes();
                    },
                  );
                },
              ),
              title: " ملاحظات " + widget.kidDetails['level_name'],
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
