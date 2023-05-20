import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/contactus/conactusApi.dart';
import 'package:starkids_app/services/courses/coursesApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/date_picker/date_picker.dart';
import 'package:starkids_app/widgets/gradiantBtn/GradiantButton.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';
import 'package:starkids_app/widgets/standardDropDownField/index.dart';
import 'package:intl/intl.dart';

class NurseryRegister extends StatefulWidget {
  @override
  _NurseryRegisterState createState() => _NurseryRegisterState();
}

class _NurseryRegisterState extends State<NurseryRegister> {
  List branches = [];
  String? branch;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;
  var myFormat = DateFormat('yyyy-MM-dd');
  String? applicationDate;
  String? availableDate;
  String? availableTime;

  void initState() {
    super.initState();
    getBranchesData();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getBranchesData() async {
    ContactUsAPi.getBranchesData().then((value) {
      setState(() {
        branches = List.castFrom(value['branches'] ?? []);
        branch = branches[0]['id'].toString();
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  void registerChild(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        //todo add user id
        await CoursesApi.registerNurseryKid(
            controllers,
            branch,
            applicationDate,
            availableTime,
            availableDate,
            GlobalRedux.store.state.user!.id);
        showNavigationSnackBar(context, 'تم استلام طلبك بنجاح');
        setState(() {
          isLoading = false;
          controllers['name']!.text = "";
          controllers['age']!.text = "";
          controllers['time']!.text = "";
        });
      } on ApiException catch (exception) {
        setState(() => isLoading = false);
        for (final ApiError error in exception.errors) {
          setState(() => errors[error.field] = error.message);
        }
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
                return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 30, left: 30),
                                child: StandardDropdownField(
                                  labelText: "الفرع",
                                  initialValue: branch,
                                  values: branches.asMap().map((key, value) =>
                                      MapEntry<String, String>(
                                          value['id'].toString(),
                                          value['name'])),
                                  onChanged: (String? key) {
                                    setState(() {
                                      branch = key;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    enabled: false,
                                    initialValue: "الحضانة",
                                    labelText: "الكورس",
                                    primaryColor: Colors.black,
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "اسم الطفل",
                                    hintText: "ادخل اسم الطفل...",
                                    primaryColor: Colors.black,
                                    // validator: notEmptyValidator,
                                    errorText: errors['name'],
                                    controller: controllers.putIfAbsent(
                                        'name', () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "سن الطفل",
                                    hintText: "ادخل سن الطفل...",
                                    primaryColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    // validator: notEmptyValidator,
                                    errorText: errors['age'],
                                    controller: controllers.putIfAbsent(
                                        'age', () => TextEditingController()),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30, left: 30, bottom: 20),
                                child: MyTextFieldDatePicker(
                                  labelText: "ميعاد التقديم",
                                  lastDate:
                                      DateTime.now().add(Duration(days: 366)),
                                  dateFormat: DateFormat.yMd(),
                                  firstDate: DateTime(1900),
                                  initialDate: "",
                                  primaryColor: ThemeSettings.coursesAppBar,
                                  onPrimary: Colors.white,
                                  suffixIcon: Icon(Icons.calendar_today),
                                  // validator: notEmptyValidator,
                                  errorText: errors['application_date'],
                                  onDateChanged: (selectedDate) {
                                    applicationDate = myFormat
                                        .format(selectedDate)
                                        .toString();
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 18, right: 20),
                                  child: Text(
                                    "انسب ميعاد للاكاديمية للاتصال بك",
                                    style: TextStyle(
                                        color: ThemeSettings.homeAppbarColor,
                                        fontSize:
                                            ThemeSettings.fontSubHeaderSize,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Theme(
                                  data: Theme.of(context).copyWith(
                                    timePickerTheme:
                                        TimePickerTheme.of(context).copyWith(),

                                    primaryColor: Colors.cyan,
                                    colorScheme: ColorScheme.light(
                                        primary: ThemeSettings
                                            .coursesAppBar, // header background color
                                        onPrimary:
                                            Colors.white, // header text color
                                        onSurface: ThemeSettings
                                            .coursesAppBar // body text color
                                        ), //color you want at header
                                    buttonTheme:
                                        ButtonTheme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        secondary: Colors
                                            .cyan, // Color you want for action buttons (CANCEL and OK)
                                      ),
                                    ),
                                  ),
                                  child: Builder(
                                      builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                              right: 30, left: 30),
                                          child: BorderedTextField(
                                            labelText: "الوقت",
                                            primaryColor: Colors.black,
                                            // validator: notEmptyValidator,
                                            suffixIcon: Icon(Icons.timer),
                                            errorText: errors['time'],
                                            onTap: () async {
                                              showTimePickerDisplay(context);
                                            },
                                            controller: controllers.putIfAbsent(
                                                'time',
                                                () => TextEditingController()),
                                          )))),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30, left: 30, bottom: 20),
                                child: MyTextFieldDatePicker(
                                  labelText: "التاريخ",
                                  lastDate:
                                      DateTime.now().add(Duration(days: 366)),
                                  dateFormat: DateFormat.yMd(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 366)),
                                  initialDate: "",
                                  primaryColor: ThemeSettings.coursesAppBar,
                                  onPrimary: Colors.white,
                                  suffixIcon: Icon(Icons.calendar_today),
                                  // validator: notEmptyValidator,
                                  errorText: errors['available_date'],
                                  onDateChanged: (selectedDate) {
                                    availableDate = myFormat
                                        .format(selectedDate)
                                        .toString();
                                  },
                                ),
                              ),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: GradientButton(
                                  isLoading: isLoading,
                                  onPressed: () => registerChild(context),
                                  labelText: 'سجل لطفلك',
                                ),
                              )),
                            ])));
              }),
              title: "الحضانة",
              screenIndex: 2,
              appBarBGColor: ThemeSettings.nurseryAppBar,
            ));
  }

  void showTimePickerDisplay(context) async {
    TimeOfDay time = TimeOfDay.now();
    FocusScope.of(context).requestFocus(new FocusNode());

    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      final localizations = MaterialLocalizations.of(context);
      final formattedTimeOfDay = localizations.formatTimeOfDay(picked);
      controllers['time']!.text = formattedTimeOfDay;
      setState(() {
        availableTime = picked.toString().substring(10, 15);
      });
    }
  }
}
