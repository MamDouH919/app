import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/poster/poster_response.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/home/homeAPi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';

class Poster extends StatefulWidget {
  final PosterResponse poster;
  Poster(this.poster);

  @override
  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  String _baseUrl = AppData.serverURL;
  late SharedPreferences sharedPreferences;
  late String userType;

  @override
  void initState() {
    super.initState();
    seePoster();
  }

  void seePoster() async {
    HomeApi.seePoster(widget.poster.userPosterId);
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 3.2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    _baseUrl + widget.poster.posterPic),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Center(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, right: 10, left: 10),
                                child: Text(
                                  widget.poster.title,
                                  style: TextStyle(
                                      color: ThemeSettings.textColor,
                                      fontSize:
                                          ThemeSettings.fontSubHeaderSize),
                                ))),
                        Center(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, right: 10, left: 10),
                                child: Text(
                                  widget.poster.details,
                                  style: TextStyle(
                                      color: ThemeSettings.textColor,
                                      fontSize: ThemeSettings.fontMedSize),
                                ))),
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: Colors.green,
                                    ),
                                  // color: Colors.green,
                                  onPressed: () {
                                    HomeApi.posterAction(
                                            widget.poster.userPosterId, "1")
                                        .then((value) => showNavigationSnackBar(
                                            context, 'تم تسجيل ردك'));
                                  }, //
                                  child: Text(widget.poster.acceptBtn,
                                      style: TextStyle(
                                          fontSize:
                                              ThemeSettings.fontNormalSize,
                                          fontFamily: 'Tajawal',
                                          color: Colors.white)),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(5)),
                                ))),
                        if (widget.poster.rejectBtnState == "0")
                          Padding(
                              padding: EdgeInsets.only(
                                  right: 20, left: 20, bottom: 20),
                              child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: Colors.red,
                                    ),
                                    // color: Colors.red,
                                    onPressed: () async {
                                      HomeApi.posterAction(
                                              widget.poster.userPosterId, "0")
                                          .then((value) =>
                                              showNavigationSnackBar(
                                                  context, 'تم تسجيل ردك'));
                                    }, //
                                    child: Text(widget.poster.rejectBtn,
                                        style: TextStyle(
                                            fontSize:
                                                ThemeSettings.fontNormalSize,
                                            fontFamily: 'Tajawal',
                                            color: Colors.white)),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(5)),
                                  ))),
                      ]),
                );
              }),
              title: "تنويه",
              screenIndex: 2,
            ));
  }
}
