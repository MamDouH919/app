import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/register/registerApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/index.dart';
import 'package:starkids_app/widgets/date_picker/date_picker.dart';
import 'package:starkids_app/widgets/gradiantBtn/index.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';
import 'package:starkids_app/widgets/standardDropDownField/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  final int currentIndex;
  Register(this.currentIndex);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List governorates = [];
  Map<String, dynamic> cities = {};
  Map<String, dynamic> areas = {};
  Map<String, dynamic> tempCities = {};
  Map<String, dynamic> tempAreas = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;

  var gender = {'m': 'ذكر', 'f': 'انثى'};
  var foundUs = {
    'friend': 'صديق',
    'net': 'انترنت',
    'paper': 'جرئد',
    'poster': 'ورق دعاية',
    'school': 'مدرسة',
    'banner': 'يفط',
    'other': 'اخرى',
  };

  late String governorate;
  late String city;
  late String area;
  late String birthDate;
  String source = "صديق";
  late String picture;
  String genderValue = 'm';
  var myFormat = DateFormat('yyyy-MM-dd');

  void initState() {
    getGovernorates();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getGovernorates() async {
    RegisterApi.getGovernorates().then((value) {
      setState(() {
        governorates = List.castFrom(value['governorates'] ?? []);
        cities = tempCities = value['cities'] ?? [];
        areas = tempAreas = value['areas'] ?? [];
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  void filterCities(governorate) {
    setState(() {
      tempCities = Map.from(cities)
        ..removeWhere((k, v) => !k.startsWith(governorate));
    });
  }

  void filterAreas(city) {
    int idx = city.indexOf("-");
    List parts = [
      city.substring(0, idx).trim(),
      city.substring(idx + 1).trim()
    ];
    setState(() {
      tempAreas = Map.from(areas)
        ..removeWhere((k, v) => !k.startsWith(parts[1]));
    });
  }

  Future chooseImage() async {
    final picker = ImagePicker();
    await picker.getImage(source: ImageSource.gallery).then((value) {
      value!.readAsBytes().then((value) {
        setState(() {
          picture = base64Encode(value);
        });
      });
    });
  }

  void registerNewUser(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        int idx = city.indexOf("-");
        List cityParts = [
          city.substring(0, idx).trim(),
          city.substring(idx + 1).trim()
        ];

        int areaIdx = area.indexOf("-");
        List areaParts = [
          area.substring(0, areaIdx).trim(),
          area.substring(areaIdx + 1).trim()
        ];

        await RegisterApi.registerNewUser(controllers, birthDate, genderValue,
            picture, source, governorate, cityParts[1], areaParts[1]);
        showNavigationSnackBar(context, 'تم انشاء حساب بنجاح');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userType", "parent");

        Future.delayed(Duration(milliseconds: 250), () {
          Navigator.pushNamed(context, '/login', arguments: "parent");
        });
      } on ApiException catch (exception) {
        setState(() => isLoading = false);
        for (final ApiError error in exception.errors) {
          setState(() => errors[error.field] = error.message);
        }
      }
    }
  }

  Widget showImage(image) {
    return Container(
        padding: EdgeInsets.only(bottom: 15),
        child: image == null
            ? Text(
                '',
                textAlign: TextAlign.center,
              )
            : Text(
                'تم تحميل الصورة',
                style: TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ));
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
                        //courses part
                        child: Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2.7,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("lib/assets/picks/appbar.png"),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Center(
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.7,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            "lib/assets/picks/logo.svg",
                                            semanticsLabel: "logo"),
                                      ]))),
                          Container(
                            height: MediaQuery.of(context).size.height / 2.7,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      ThemeSettings.picksAppBarGradientColor
                                          .withOpacity(0.3),
                                    ],
                                    stops: [
                                      0.0,
                                    ])),
                          ),
                        ]),
                        Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 20),
                            child: Text(
                              "التسجيل",
                              style: TextStyle(
                                  color: ThemeSettings.homeAppbarColor,
                                  fontSize: ThemeSettings.fontCardSize,
                                  fontWeight: FontWeight.bold),
                            )),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                              hintText: "ادخل الاسم هنا...",
                              labelText: "الاسم",
                              keyboardType: TextInputType.text,
                              primaryColor: Colors.black,
                              // validator: notEmptyValidator,
                              errorText: errors['name'],
                              controller: controllers.putIfAbsent(
                                  'name', () => TextEditingController()),
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: StandardDropdownField(
                            labelText: "الجنس",
                            initialValue: 'm',
                            values: gender
                                .map((key, value) => MapEntry(key, value)),
                            onChanged: (String? key) {
                              genderValue = key!;
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                              hintText: "ادخل رقم الهاتف هنا...",
                              labelText: "الهاتف الشخصى",
                              keyboardType: TextInputType.number,
                              primaryColor: Colors.black,
                              // validator: integerValidator,
                              errorText: errors['personal_phone'],
                              controller: controllers.putIfAbsent(
                                  'personal_phone',
                                  () => TextEditingController()),
                            )),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                              hintText: "ادخل رقم الهاتف هنا...",
                              labelText: "هاتف الام",
                              keyboardType: TextInputType.number,
                              primaryColor: Colors.black,
                              errorText: errors['mother_phone'],
                              controller: controllers.putIfAbsent(
                                  'mother_phone',
                                  () => TextEditingController()),
                            )),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                              hintText: "ادخل رقم الهاتف هنا...",
                              labelText: "هاتف المنزل",
                              keyboardType: TextInputType.number,
                              errorText: errors['home_phone'],
                              primaryColor: Colors.black,
                              controller: controllers.putIfAbsent(
                                  'home_phone', () => TextEditingController()),
                            )),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                              hintText: "ماذا تعمل",
                              labelText: "العمل",
                              keyboardType: TextInputType.text,
                              primaryColor: Colors.black,
                              errorText: errors['work'],
                              // validator: notEmptyValidator,
                              controller: controllers.putIfAbsent(
                                  'work', () => TextEditingController()),
                            )),
                        Padding(
                          padding:
                              EdgeInsets.only(right: 30, left: 30, bottom: 20),
                          child: MyTextFieldDatePicker(
                            labelText: "تاريخ الميلاد",
                            lastDate: DateTime.now().add(Duration(days: 366)),
                            dateFormat: DateFormat.yMd(),
                            firstDate: DateTime(1900),
                            initialDate: "",
                            primaryColor: Colors.black,
                            onPrimary: Colors.white,
                            suffixIcon: Icon(Icons.calendar_today),
                            // validator: notEmptyValidator,
                            errorText: errors['birth_date'],
                            onDateChanged: (selectedDate) {
                              birthDate =
                                  myFormat.format(selectedDate).toString();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: StandardDropdownField(
                            labelText: "المحافظة",
                            hintText: "اختر المحافظة",
                            initialValue: governorate,
                            errorText: errors['governorate'],
                            // validator: notEmptySelector,
                            values: governorates.asMap().map((key, value) =>
                                MapEntry<String, String>(value, value)),
                            onChanged: (String? key) {
                              if (key!.isEmpty) {
                                setState(() {
                                  tempCities = cities;
                                });
                              } else {
                                filterCities(key);
                                setState(() {
                                  city = '';
                                  governorate = key;
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: StandardDropdownField(
                            labelText: "المدينة",
                            hintText: "اختر المدينة",
                            initialValue: city,
                            errorText: errors['city'],
                            // validator: notEmptySelector,
                            values: tempCities.map((key, value) =>
                                MapEntry<String, String>(
                                    key.toString(), value)),
                            onChanged: (String? key) {
                              if (key!.isEmpty) {
                                setState(() {
                                  tempAreas = areas;
                                });
                              } else {
                                filterAreas(key);
                                setState(() {
                                  area = '';
                                  city = key;
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: StandardDropdownField(
                            labelText: "القرية",
                            hintText: "اختر القرية",
                            errorText: errors['area'],
                            // validator: notEmptySelector,
                            initialValue: area,
                            values: tempAreas.map((key, value) =>
                                MapEntry<String, String>(
                                    key.toString(), value)),
                            onChanged: (String? key) {
                              setState(() {
                                area = key!;
                              });
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                              hintText: "البريد الالكترونى",
                              labelText: "البريد الالكترونى",
                              keyboardType: TextInputType.text,
                              primaryColor: Colors.black,
                              // validator: emailValidator,
                              errorText: errors['email'],
                              controller: controllers.putIfAbsent(
                                  'email', () => TextEditingController()),
                            )),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                                hintText: "ادخل كلمة المرور",
                                labelText: "كلمة المرور",
                                keyboardType: TextInputType.text,
                                primaryColor: Colors.black,
                                obscureText: true,
                                maxLines: 1,
                                // validator: notEmptyValidator,
                                errorText: errors['password'],
                                controller: controllers.putIfAbsent('password',
                                    () => TextEditingController()))),
                        Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: BorderedTextField(
                              hintText: "تاكيد كلمة المرور",
                              labelText: "تاكيد كلمة المرور",
                              keyboardType: TextInputType.text,
                              primaryColor: Colors.black,
                              obscureText: true,
                              maxLines: 1,
                              // validator: (String value) => textMatchValidator(
                              //     value, controllers['password'].text),
                              controller: controllers.putIfAbsent(
                                  'confirm_password',
                                  () => TextEditingController()),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 30, bottom: 20),
                                  child: Text("الصورة الشخصية")),
                            ),
                            Expanded(child: showImage(picture)),
                            Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 30, bottom: 20),
                                    child: ButtonTheme(
                                        minWidth: 200,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    color: ThemeSettings
                                                        .homeAppbarColor)),
                                            backgroundColor: Colors.white,
                                          ),
                                          // color: Colors.white,
                                          onPressed: chooseImage, //
                                          child: Text("تحميل",
                                              style: TextStyle(
                                                  fontSize: ThemeSettings
                                                      .fontNormalSize,
                                                  fontFamily: 'Tajawal',
                                                  fontWeight: FontWeight.bold,
                                                  color: ThemeSettings
                                                      .homeAppbarColor)),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5),
                                          //     side: BorderSide(
                                          //         color: ThemeSettings
                                          //             .homeAppbarColor)),
                                        ))))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: StandardDropdownField(
                            labelText: "كيف وصلت الى الاكاديمية",
                            initialValue: "friend",
                            values: foundUs
                                .map((key, value) => MapEntry(key, value)),
                            onChanged: (String? key) {
                              source = foundUs[key]!;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: GradientButton(
                            isLoading: isLoading,
                            onPressed: () => registerNewUser(context),
                            labelText: 'تسجيل',
                          ),
                        )
                      ],
                    )));
              }),
              title: 'انشاء حساب',
              screenIndex: widget.currentIndex,
              appBarBGColor: ThemeSettings.registerAppBar,
            ));
  }
}
