import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class FinancialsDetails extends StatefulWidget {
  final Map<String, dynamic> financialsDetails;
  FinancialsDetails(this.financialsDetails);
  @override
  _FinancialsDetailsState createState() => _FinancialsDetailsState();
}

class _FinancialsDetailsState extends State<FinancialsDetails> {
  Map details = {};
  Map classSub = {
    'day': 'يومي',
    'half': 'نصف شهري',
    'month': 'شهري',
    'semester': 'ترم',
  };

  void initState() {
    getCoursesByCategorieId();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getCoursesByCategorieId() async {
    KidsAPi.getKidFinancialsDetails(widget.financialsDetails['trans_id'])
        .then((value) {
      setState(() {
        details = Map.castFrom(value['details'] ?? {});
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
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: ThemeSettings.kidsColor),
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(20),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("الرقم المسلسل : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['transaction_id'].toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("الفرع : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['branch_name'].toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("التاريخ : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['date'].toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("الوقت : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['time'].toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("نوع التعامل  : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['type'] == 'in' ? 'دفع' : 'سحب',
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("سبب التعامل : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['ftype_name'].toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Divider(
                                    color: ThemeSettings.breakLineColor)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("أصل المبلغ : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['required'].toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("المدفوع : ",
                                    style: TextStyle(
                                        color: ThemeSettings.kidsColor,
                                        fontSize: ThemeSettings.fontMedSize)),
                                Text(details['paid'].toString(),
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedSize,
                                        color: Colors.black))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Divider(
                                    color: ThemeSettings.breakLineColor)),
                            if (details['kr_id'] != null)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "معلومات الخط",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize: ThemeSettings
                                                .fontSubHeaderSize),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("رقم الخط : ",
                                          style: TextStyle(
                                              color: ThemeSettings.kidsColor,
                                              fontSize:
                                                  ThemeSettings.fontMedSize)),
                                      Text(
                                          details['route_type'] == 'n'
                                              ? details['route_number_n']
                                                  .toString()
                                              : details['route_number_c']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize:
                                                  ThemeSettings.fontMedSize,
                                              color: Colors.black))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("اسم الخط : ",
                                          style: TextStyle(
                                              color: ThemeSettings.kidsColor,
                                              fontSize:
                                                  ThemeSettings.fontMedSize)),
                                      Text(
                                          details['route_type'] == 'n'
                                              ? details['route_title_n']
                                                  .toString()
                                              : details['route_title_c']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize:
                                                  ThemeSettings.fontMedSize,
                                              color: Colors.black))
                                    ],
                                  ),
                                ],
                              ),
                            if (details['class_id'] != null)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "معلومات الفصل",
                                        style: TextStyle(
                                            color: ThemeSettings.kidsColor,
                                            fontSize: ThemeSettings
                                                .fontSubHeaderSize),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("نوع الفصل  : ",
                                          style: TextStyle(
                                              color: ThemeSettings.kidsColor,
                                              fontSize:
                                                  ThemeSettings.fontMedSize)),
                                      Text(
                                          details['class_type'] == 'norm'
                                              ? ' نظامي '
                                              : ' تعويضي ',
                                          style: TextStyle(
                                              fontSize:
                                                  ThemeSettings.fontMedSize,
                                              color: Colors.black))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("رقم الفصل : ",
                                          style: TextStyle(
                                              color: ThemeSettings.kidsColor,
                                              fontSize:
                                                  ThemeSettings.fontMedSize)),
                                      Text(
                                          details['class_id'].toString() +
                                                      details['c_type'] ==
                                                  'n'
                                              ? ' حضانة '
                                              : ' كورسات ',
                                          style: TextStyle(
                                              fontSize:
                                                  ThemeSettings.fontMedSize,
                                              color: Colors.black))
                                    ],
                                  ),
                                  if (details['class_type'] == 'comp')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("تعويضي لفصل رقم  : ",
                                            style: TextStyle(
                                                color: ThemeSettings.kidsColor,
                                                fontSize:
                                                    ThemeSettings.fontMedSize)),
                                        Text(
                                            details['comp_class_id']
                                                            .toString() +
                                                        details['c_type'] ==
                                                    'n'
                                                ? ' حضانة '
                                                : ' كورسات ',
                                            style: TextStyle(
                                                fontSize:
                                                    ThemeSettings.fontMedSize,
                                                color: Colors.black))
                                      ],
                                    ),
                                  if (details['class_type'] == 'comp')
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("تعويضي لحصة رقم  : ",
                                            style: TextStyle(
                                                color: ThemeSettings.kidsColor,
                                                fontSize:
                                                    ThemeSettings.fontMedSize)),
                                        Text(
                                            details['comp_class_session']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize:
                                                    ThemeSettings.fontMedSize,
                                                color: Colors.black))
                                      ],
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("المستوى : ",
                                          style: TextStyle(
                                              color: ThemeSettings.kidsColor,
                                              fontSize:
                                                  ThemeSettings.fontMedSize)),
                                      Text(details['level_title'].toString(),
                                          style: TextStyle(
                                              fontSize:
                                                  ThemeSettings.fontMedSize,
                                              color: Colors.black))
                                    ],
                                  ),
                                ],
                              ),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Divider(
                                    color: ThemeSettings.breakLineColor)),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "معلومات اضافية",
                                  style: TextStyle(
                                      color: ThemeSettings.kidsColor,
                                      fontSize:
                                          ThemeSettings.fontSubHeaderSize),
                                )),
                            if (details['class_month'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("رقم شهر الفصل المدفوع : ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(details['class_month'].toString(),
                                      style: TextStyle(
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: Colors.black))
                                ],
                              ),
                            if (details['route_month'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("رقم دورة الخط المدفوع : ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(details['route_month'].toString(),
                                      style: TextStyle(
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: Colors.black))
                                ],
                              ),
                            if (details['class_plan'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("نوع الإشتراك : ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(
                                      classSub[
                                          details['class_plan'].toString()],
                                      style: TextStyle(
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: Colors.black))
                                ],
                              ),
                            if (details['next_payment'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("تاريخ الدفع القادم : ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(details['next_payment'].toString(),
                                      style: TextStyle(
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: Colors.black))
                                ],
                              ),
                            if (details['who_paid'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("الدافع: ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(details['who_paid'].toString(),
                                      style: TextStyle(
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: Colors.black))
                                ],
                              ),
                            if (details['relativity'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("صفة الدافع: ",
                                      style: TextStyle(
                                          color: ThemeSettings.kidsColor,
                                          fontSize: ThemeSettings.fontMedSize)),
                                  Text(details['relativity'].toString(),
                                      style: TextStyle(
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: Colors.black))
                                ],
                              ),
                          ]))),
              title: "التفاصيل",
              screenIndex: widget.financialsDetails['index'],
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
