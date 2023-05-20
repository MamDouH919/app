import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/widgets/standardDropDownField/index.dart';

class KidRouteFinancials extends StatefulWidget {
  final Map<String, dynamic> kidDetails;
  KidRouteFinancials(this.kidDetails);
  @override
  _KidRouteFinancialsState createState() => _KidRouteFinancialsState();
}

class _KidRouteFinancialsState extends State<KidRouteFinancials> {
  List financialsList = [];
  ScrollController? _scrollController;
  String ftype = 'in';
  var months = {
    '0': 'كل الشهور',
    '1': 'يناير',
    '2': 'فبراير',
    '3': 'مارس',
    '4': 'ابريل',
    '5': 'مايو',
    '6': 'يونيو',
    '7': 'يوليو',
    '8': 'اغسطس',
    '9': 'سبتمبر',
    '10': 'اكتوبر',
    '11': 'نوفمبر',
    '12': 'ديسمبر'
  };
  String monthValue = "0";

  Map<String, String> years = {};

  String yearValue = "0";
  bool loading = false;
  bool allLoaded = false;
  var page = 1;
  var total = 2;
  var totalFinancialsCount = 0;

  @override
  void initState() {
    _scrollController = new ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels >=
                _scrollController!.position.maxScrollExtent &&
            !loading &&
            financialsList.length < totalFinancialsCount) {
          setState(() {
            page += 1;
          });
          getKidRouteFinancials();
        }
      });
    getKidRouteFinancials();
    super.initState();
    years = getYears();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController!.dispose();
  }

  mockFetch() async {}

  Map<String, String> getYears() {
    var temp = {
      '0': 'كل السنين',
    };
    for (var year = 2016; year <= DateTime.now().year; year++) {
      temp[year.toString()] = year.toString();
    }
    return temp;
  }

  void getKidRouteFinancials() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });

    await KidsAPi.getKidRouteFinancials(
            widget.kidDetails['kid_id'],
            widget.kidDetails['c_type'],
            ftype,
            monthValue,
            yearValue,
            page,
            total)
        .then((value) {
      setState(() {
        value['rows']?.forEach((element) => financialsList.add(element));
        totalFinancialsCount = int.parse(value['count']) ?? 0;
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
    setState(() {
      loading = false;
      allLoaded = financialsList.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            StandardScreen(
              child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: Text(
                          "الماليات",
                          style: TextStyle(
                              color: ThemeSettings.kidsColor,
                              fontSize: ThemeSettings.fontCardSize,
                              fontWeight: FontWeight.bold),
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  ftype = 'in';
                                  financialsList = [];
                                  allLoaded = false;
                                  page = 1;
                                });
                                getKidRouteFinancials();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: ftype == 'in'
                                      ? ThemeSettings.kidsColor
                                      : ThemeSettings.financialsColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text("دفع",
                                    style: TextStyle(
                                        color: ftype == 'in'
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: ThemeSettings.fontMedSize)),
                              )),
                        ),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  ftype = 'out';
                                  financialsList = [];
                                  allLoaded = false;
                                  page = 1;
                                });
                                getKidRouteFinancials();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: ftype == 'out'
                                      ? ThemeSettings.kidsColor
                                      : ThemeSettings.financialsColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 20),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text("سحب",
                                    style: TextStyle(
                                        color: ftype == 'out'
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: ThemeSettings.fontMedSize)),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30, left: 30),
                      child: StandardDropdownField(
                        labelText: "ابحث بالسنة: ",
                        initialValue: yearValue,
                        values: years.map((key, value) => MapEntry(key, value)),
                        onChanged: (String? key) {
                          setState(() {
                            yearValue = key!;
                            financialsList = [];
                            page = 1;
                            allLoaded = false;
                          });
                          getKidRouteFinancials();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30, left: 30),
                      child: StandardDropdownField(
                        labelText: "ابحث بالشهر: ",
                        initialValue: monthValue,
                        values:
                            months.map((key, value) => MapEntry(key, value)),
                        onChanged: (String? key) {
                          setState(() {
                            monthValue = key!;
                            financialsList = [];
                            allLoaded = false;
                            page = 1;
                          });
                          getKidRouteFinancials();
                        },
                      ),
                    ),
                    financialsList.length == 0
                        ? Center(
                            child: Text("لا توجد تعاملات حتى الآن",
                                style: TextStyle(
                                    fontSize: ThemeSettings.fontHeaderSize)))
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: financialsList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 145,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ThemeSettings.kidsColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: EdgeInsets.all(16),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                "رقم المسلسل: ",
                                                                style: TextStyle(
                                                                    color: ThemeSettings
                                                                        .kidsColor,
                                                                    fontSize:
                                                                        ThemeSettings
                                                                            .fontMedSize)),
                                                            Text(
                                                                financialsList[
                                                                            index]
                                                                        [
                                                                        'transaction_id']
                                                                    .toString()
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ThemeSettings
                                                                            .fontMedSize,
                                                                    color: Colors
                                                                        .black))
                                                          ],
                                                        )),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                "نوع التعامل: ",
                                                                style: TextStyle(
                                                                    color: ThemeSettings
                                                                        .kidsColor,
                                                                    fontSize:
                                                                        ThemeSettings
                                                                            .fontMedSize)),
                                                            Text(
                                                                ftype == 'in'
                                                                    ? "دفع"
                                                                    : "سحب",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        ThemeSettings
                                                                            .fontMedSize,
                                                                    color: Colors
                                                                        .black))
                                                          ],
                                                        )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("اصل المبلغ: ",
                                                            style: TextStyle(
                                                                color: ThemeSettings
                                                                    .kidsColor,
                                                                fontSize:
                                                                    ThemeSettings
                                                                        .fontMedSize)),
                                                        Text(
                                                            financialsList[
                                                                        index]
                                                                    ['required']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ThemeSettings
                                                                        .fontMedSize,
                                                                color: Colors
                                                                    .black))
                                                      ],
                                                    ),
                                                  ],
                                                ))),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                                                        financialsList[index]
                                                            ['datetime'],
                                                        style: TextStyle(
                                                            fontSize:
                                                                ThemeSettings
                                                                    .fontMedSize,
                                                            color:
                                                                Colors.black))
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
                                                    Text("سبب التعامل: ",
                                                        style: TextStyle(
                                                            color: ThemeSettings
                                                                .kidsColor,
                                                            fontSize: ThemeSettings
                                                                .fontMedSize)),
                                                    Text(
                                                        financialsList[index]
                                                            ['ftype_name'],
                                                        style: TextStyle(
                                                            fontSize:
                                                                ThemeSettings
                                                                    .fontMedSize,
                                                            color:
                                                                Colors.black))
                                                  ],
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("المدفوع: ",
                                                    style: TextStyle(
                                                        color: ThemeSettings
                                                            .kidsColor,
                                                        fontSize: ThemeSettings
                                                            .fontMedSize)),
                                                Text(
                                                    financialsList[index]
                                                            ['paid']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontMedSize,
                                                        color: Colors.black))
                                              ],
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                    if (financialsList[index]['completion'] ==
                                        0)
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/financialsDetails',
                                                arguments: {
                                                  "index": widget
                                                      .kidDetails['index'],
                                                  "trans_id":
                                                      financialsList[index]
                                                          ['transaction_id']
                                                });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: Center(
                                                child: Text(
                                              "عرض المزيد",
                                              style: TextStyle(
                                                  color:
                                                      ThemeSettings.kidsColor,
                                                  fontSize: ThemeSettings
                                                      .fontMedSize),
                                            )),
                                          ))
                                  ]));
                            })
                  ])),
              screenIndex: widget.kidDetails['index'],
              title: " ماليات الخط ",
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
