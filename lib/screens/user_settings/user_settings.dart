import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/register/registerApi.dart';
import 'package:starkids_app/services/user/userApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/settings/appData.dart';
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
import 'dart:io';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  List governorates = [];
  Map<String, dynamic> cities = {};
  Map<String, dynamic> areas = {};
  Map<String, dynamic> tempCities = {};
  Map<String, dynamic> tempAreas = {};
  Map<String, dynamic> userData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;

  var gender = {'m': 'ذكر', 'f': 'انثى'};

  late String governorate;
  late String city;
  late String area;
  late String birthDate;
  String source = "صديق";
  late String pictureData;
  var picture;
  String genderValue = 'm';
  var myFormat = DateFormat('yyyy-MM-dd');
  String _baseUrl = AppData.serverURL;
  late String userAvatar;
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
    });

    UserApi.getUserData().then((value) {
      setState(() {
        userData = value['user'] ?? {};
        controllers['name']?.text = userData['name'] ?? '';
        controllers['email']?.text = userData['email'] ?? '';
        controllers['personal_phone']?.text = userData['phone1'] ?? '';
        controllers['mother_phone']?.text = userData['phone2'] ?? '';
        controllers['home_phone']?.text = userData['phone3'] ?? '';
        controllers['work']?.text = userData['job'] ?? '';

        genderValue = userData['gender'] ?? 'm';
        birthDate = userData['birthdate'].toString() ?? '';
        governorate = userData['governorate'] != null
            ? userData['governorate'] != 'none'
                ? userData['governorate']
                : null
            : null;
        city = userData['city'] != null
            ? userData['city'] != 'none'
                ? userData['governorate'] + '-' + userData['city']
                : null
            : null;
        area = userData['area'] != null
            ? userData['area'] != 'none'
                ? userData['city'] + '-' + userData['area']
                : null
            : null;

        userAvatar = userData['avatar'] ?? '';
      });
      if (governorate != null && governorate.isNotEmpty) {
        filterCities(governorate);
      }
      if (city != null && city.isNotEmpty) {
        filterAreas(city);
      }
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

  Future chooseImage(context) async {
    final picker = ImagePicker();
    PickedFile? image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      picture = File(image!.path);
    });
    image?.readAsBytes().then((value) async {
      setState(() {
        pictureData = base64Encode(value);
      });
      try {
        var response = await UserApi.changeUserPicture(base64Encode(value));
        final Map<String, dynamic> responseObject = (response.body is Map)
            ? response.body as Map<String, dynamic>
            : jsonDecode(response.body) as Map<String, dynamic>;
        showNavigationSnackBar(context, responseObject['message']);
      } on ApiException catch (exception) {
        for (final ApiError error in exception.errors) {
          showNavigationSnackBar(context, error.message);
        }
      }
    });
  }

  void updateUserData(BuildContext context) async {
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

        await UserApi.updateUserData(controllers, birthDate, genderValue,
            pictureData, governorate, cityParts[1], areaParts[1]);
        showNavigationSnackBar(context, 'تم تعديل البيانات بنجاح');
        setState(() => isLoading = false);
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
                    child: RefreshIndicator(
                      color: ThemeSettings.kidsColor,
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          //courses part
                          child: Column(
                            children: [
                              Container(
                                  constraints: BoxConstraints(maxHeight: 100),
                                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Row(children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // image: DecorationImage(
                                            //     image: picture != null
                                            //         ? FileImage(
                                            //             picture,
                                            //           )
                                            //         : NetworkImage(userAvatar ==
                                            //                 "default"
                                            //             ? _baseUrl +
                                            //                 '/media/avatars/default.png'
                                            //             : _baseUrl +
                                            //                 userAvatar
                                            //                     .toString()),
                                            //     fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 90,
                                          margin: EdgeInsets.only(top: 65),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5)),
                                              color: ThemeSettings.picChange
                                                  .withOpacity(0.5)),
                                        ),
                                        GestureDetector(
                                            onTap: () => chooseImage(context),
                                            child: Container(
                                              margin: EdgeInsets.only(top: 65),
                                              height: 30,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text("تغير الصورة",
                                                    style: TextStyle(
                                                        fontSize: ThemeSettings
                                                            .fontSmallSize,
                                                        color: Colors.white)),
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 11,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ButtonTheme(
                                            minWidth: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                backgroundColor:
                                                    ThemeSettings.kidsColor,
                                              ),
                                              // color: ThemeSettings.kidsColor,
                                              onPressed: () async {
                                                try {
                                                  var response = await UserApi
                                                      .removeUserPicture();
                                                  final Map<String, dynamic>
                                                      responseObject =
                                                      (response.body is Map)
                                                          ? response.body
                                                              as Map<String,
                                                                  dynamic>
                                                          : jsonDecode(
                                                                  response.body)
                                                              as Map<String,
                                                                  dynamic>;
                                                  showNavigationSnackBar(
                                                      context,
                                                      responseObject[
                                                          'message']);
                                                  setState(() {
                                                    picture = null;
                                                    userAvatar = "default";
                                                  });
                                                } on ApiException catch (exception) {
                                                  for (final ApiError error
                                                      in exception.errors) {
                                                    showNavigationSnackBar(
                                                        context, error.message);
                                                  }
                                                }
                                              }, //
                                              child: Text("ازالة الصورة",
                                                  style: TextStyle(
                                                      fontSize: ThemeSettings
                                                          .fontSmallSize,
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.white)),
                                              // shape: RoundedRectangleBorder(
                                              //   borderRadius:
                                              //       BorderRadius.circular(5),
                                              // ),
                                            )),
                                        ButtonTheme(
                                            minWidth: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                backgroundColor:
                                                    ThemeSettings.kidsColor,
                                              ),
                                              // color: ThemeSettings.kidsColor,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/changePassword');
                                              }, //
                                              child: Text("تغيير كلمة المرور",
                                                  style: TextStyle(
                                                      fontSize: ThemeSettings
                                                          .fontSmallSize,
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.white)),
                                              // shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //         BorderRadius.circular(5)),
                                            )),
                                      ],
                                    )),
                                  ])),
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
                                        'name',
                                        () => TextEditingController(
                                            text: userData['name'] ?? '')),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(right: 30, left: 30),
                                child: StandardDropdownField(
                                  labelText: "الجنس",
                                  initialValue: genderValue,
                                  values: gender.map(
                                      (key, value) => MapEntry(key, value)),
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
                                        () => TextEditingController(
                                            text: userData['phone1'] ?? '')),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    hintText: "ادخل رقم الهاتف هنا...",
                                    labelText: "هاتف الام",
                                    keyboardType: TextInputType.number,
                                    primaryColor: Colors.black,
                                    errorText: errors['mother_phone'],
                                    // validator: integerValidator,
                                    controller: controllers.putIfAbsent(
                                        'mother_phone',
                                        () => TextEditingController(
                                            text: userData['phone2'] ?? '')),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    hintText: "ادخل رقم الهاتف هنا...",
                                    labelText: "هاتف المنزل",
                                    keyboardType: TextInputType.number,
                                    errorText: errors['home_phone'],
                                    // validator: integerValidator,
                                    primaryColor: Colors.black,
                                    controller: controllers.putIfAbsent(
                                        'home_phone',
                                        () => TextEditingController(
                                            text: userData['phone3'] ?? '')),
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
                                        'work',
                                        () => TextEditingController(
                                            text: userData['job'] ?? '')),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30, left: 30, bottom: 20),
                                child: MyTextFieldDatePicker(
                                  labelText: "تاريخ الميلاد",
                                  lastDate:
                                      DateTime.now().add(Duration(days: 366)),
                                  dateFormat: DateFormat.yMd(),
                                  firstDate: DateTime(1900),
                                  initialDate: birthDate,
                                  primaryColor: Colors.black,
                                  onPrimary: Colors.white,
                                  suffixIcon: Icon(Icons.calendar_today),
                                  // validator: notEmptyValidator,
                                  errorText: errors['birth_date'],
                                  onDateChanged: (selectedDate) {
                                    birthDate = myFormat
                                        .format(selectedDate)
                                        .toString();
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
                                  values: governorates.asMap().map((key,
                                          value) =>
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
                                        'email',
                                        () => TextEditingController(
                                            text: userData['email'] ?? '')),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: GradientButton(
                                  bgColor: ThemeSettings.kidsColor,
                                  isLoading: isLoading,
                                  onPressed: () => updateUserData(context),
                                  labelText: 'حفظ البيانات الشخصيه',
                                ),
                              )
                            ],
                          )),
                      onRefresh: () {
                        return Future.delayed(
                          Duration(milliseconds: 500),
                          () {
                            getGovernorates();
                          },
                        );
                      },
                    ));
              }),
              title: 'الاعدادات',
              appBarBGColor: ThemeSettings.kidsColor,
            ));
  }
}
