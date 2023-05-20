import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/data/job/job_response.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/jobs/jobsAPi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/date_picker/date_picker.dart';
import 'package:intl/intl.dart';
import 'package:starkids_app/widgets/gradiantBtn/index.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';
import 'package:starkids_app/widgets/standardDropDownField/index.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class JobApplication extends StatefulWidget {
  final JobResponse jobDetails;
  JobApplication(this.jobDetails);

  @override
  _JobApplicationState createState() => _JobApplicationState();
}

class _JobApplicationState extends State<JobApplication> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;
  String? birthDate;
  var myFormat = DateFormat('yyyy-MM-dd');
  var gender = {'m': 'ذكر', 'f': 'انثى'};
  String genderValue = 'm';
  var martial = {
    'married': 'متزوج',
    'single': 'اعزب',
    'divorced': 'مطلق',
    'widow': 'ارمل'
  };
  String martialValue = 'single';

  var diploma = {'yes': 'نعم', 'no': 'لا'};
  String diplomaValue = "yes";

  var outside = {'yes': 'نعم', 'no': 'لا'};
  String outsideValue = "yes";

  var computer = {
    'weak': 'ضعيف',
    'average': 'متوسط',
    'good': 'جيد',
    'exc': 'ممتاز'
  };
  String computerValue = "weak";

  var english = {
    'weak': 'ضعيف',
    'average': 'متوسط',
    'good': 'جيد',
    'exc': 'ممتاز'
  };
  String englishValue = "weak";

  String? personalPicture;
  String? frontIdPicture;
  String? backIdPicture;
  String? collegePicture;

  @override
  void initState() {
    super.initState();
  }

  Future chooseImage(type) async {
    final picker = ImagePicker();
    await picker.getImage(source: ImageSource.gallery).then((value) {
      value!.readAsBytes().then((value) {
        setState(() {
          if (type == "personal") {
            personalPicture = base64Encode(value);
          } else if (type == "front") {
            frontIdPicture = base64Encode(value);
          } else if (type == "back") {
            backIdPicture = base64Encode(value);
          } else {
            collegePicture = base64Encode(value);
          }
        });
      });
    });
  }

  void registerAJobApplication(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (personalPicture == null) {
      showNavigationSnackBar(context, 'اختر صورة شخصية');
    } else if (frontIdPicture == null) {
      showNavigationSnackBar(context, 'اختر صورة البطاقة الامامية');
    } else if (backIdPicture == null) {
      showNavigationSnackBar(context, 'اختر صورة البطاقة الخلفية');
    } else if (collegePicture == null) {
      showNavigationSnackBar(context, 'اختر صورة الشهادة الجامعية');
    } else {
      if (_formKey.currentState!.validate()) {
        setState(() => isLoading = true);
        try {
          await JobsApi.registerNewJobApplication(
              controllers,
              genderValue,
              birthDate,
              martialValue,
              personalPicture,
              frontIdPicture,
              backIdPicture,
              collegePicture,
              diplomaValue,
              computerValue,
              englishValue,
              widget.jobDetails.jobId,
              outsideValue,
              widget.jobDetails.branchId,
              widget.jobDetails.id);

          showNavigationSnackBar(context, 'تم  تسجيل طلبك بنجاح');
          Future.delayed(Duration(milliseconds: 250), () {
            Navigator.pushNamed(context, '/home');
          });
        } on ApiException catch (exception) {
          setState(() => isLoading = false);
          for (final ApiError error in exception.errors) {
            setState(() => errors[error.field] = error.message);
          }
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
                        child: Column(children: [
                          Stack(children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "lib/assets/job/job_details_background.png"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 3.2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        ThemeSettings.picksAppBarGradientColor
                                            .withOpacity(0.5),
                                      ],
                                      stops: [
                                        0.0,
                                      ])),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.2,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3.2) *
                                            0.55,
                                        right: 20),
                                    child: Text(widget.jobDetails.title,
                                        style: TextStyle(
                                            fontSize:
                                                ThemeSettings.fontMedCardSize,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))),
                          ]),
                          Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 20),
                              child: Text(
                                "المعلومات الشخصية",
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
                            padding: EdgeInsets.only(
                                right: 30, left: 30, bottom: 20),
                            child: MyTextFieldDatePicker(
                              labelText: "تاريخ الميلاد",
                              lastDate: DateTime.now().add(Duration(days: 366)),
                              dateFormat: DateFormat.yMd(),
                              firstDate: DateTime(1900),
                              initialDate: "",
                              primaryColor: ThemeSettings.homeAppbarColor,
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
                              child: BorderedTextField(
                                hintText: "ادخل رقم الهاتف هنا...",
                                labelText: "1 الهاتف الشخصى",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                // validator: integerValidator,
                                errorText: errors['personal_phone_1'],
                                controller: controllers.putIfAbsent(
                                    'personal_phone_1',
                                    () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "ادخل رقم الهاتف هنا...",
                                labelText: "2 الهاتف الشخصى",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                errorText: errors['personal_phone_2'],
                                controller: controllers.putIfAbsent(
                                    'personal_phone_2',
                                    () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "ادخل عنوانك",
                                labelText: "العنوان",
                                keyboardType: TextInputType.text,
                                primaryColor: Colors.black,
                                errorText: errors['address'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'address', () => TextEditingController()),
                              )),
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
                            child: StandardDropdownField(
                              labelText: "الحالة الاجتماعية",
                              initialValue: 'single',
                              values: martial
                                  .map((key, value) => MapEntry(key, value)),
                              onChanged: (String? key) {
                                martialValue = key!;
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "ادخل عنوانك",
                                labelText: "عدد الاطفال (ان وجد)",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                errorText: errors['childs'],
                                controller: controllers.putIfAbsent(
                                    'childs', () => TextEditingController()),
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 30, bottom: 20),
                                    child: Text("الصورة الشخصية")),
                              ),
                              Expanded(child: showImage(personalPicture)),
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
                                            onPressed: () async {
                                              chooseImage("personal");
                                            }, //
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
                              child: BorderedTextField(
                                hintText: " ادخل الرقم القومى",
                                labelText: "الرقم القومى",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                errorText: errors['national_id'],
                                // validator: nationalIdValidator,
                                controller: controllers.putIfAbsent(
                                    'national_id',
                                    () => TextEditingController()),
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 30, bottom: 20),
                                    child: Text("صورة البطاقة الامامية")),
                              ),
                              Expanded(child: showImage(frontIdPicture)),
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
                                            onPressed: () async {
                                              chooseImage("front");
                                            }, //
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
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 30, bottom: 20),
                                    child: Text("صورة البطاقة الخلفية")),
                              ),
                              Expanded(child: showImage(backIdPicture)),
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
                                            onPressed: () async {
                                              chooseImage("back");
                                            }, //
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
                              padding: EdgeInsets.only(top: 30, bottom: 20),
                              child: Text(
                                "المهارات",
                                style: TextStyle(
                                    color: ThemeSettings.homeAppbarColor,
                                    fontSize: ThemeSettings.fontCardSize,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "كلية التخرج",
                                labelText: "كلية التخرج",
                                keyboardType: TextInputType.text,
                                primaryColor: Colors.black,
                                errorText: errors['college'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'college', () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "سنة التخرج",
                                labelText: "سنة التخرج",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                errorText: errors['college_year'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'college_year',
                                    () => TextEditingController()),
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 30, bottom: 20),
                                    child: Text("صورة الشهادة الجامعية")),
                              ),
                              Expanded(child: showImage(collegePicture)),
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
                                            onPressed: () async {
                                              chooseImage("college");
                                            }, //
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
                              labelText: "هل حصلت على دبلوم تربوى؟",
                              initialValue: diplomaValue,
                              values: diploma
                                  .map((key, value) => MapEntry(key, value)),
                              onChanged: (String? key) {
                                diplomaValue = key!;
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "اكتب هنا",
                                labelText: "الكورسات الحاصل عليها",
                                keyboardType: TextInputType.text,
                                primaryColor: Colors.black,
                                errorText: errors['courses'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'courses', () => TextEditingController()),
                              )),
                          Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: StandardDropdownField(
                              labelText: "مهارات الكمبيوتر",
                              initialValue: computerValue,
                              values: computer
                                  .map((key, value) => MapEntry(key, value)),
                              onChanged: (String? key) {
                                computerValue = key!;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: StandardDropdownField(
                              labelText: "درجة اجادة اللغة الانجليزية",
                              initialValue: englishValue,
                              values: english
                                  .map((key, value) => MapEntry(key, value)),
                              onChanged: (String? key) {
                                englishValue = key!;
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "لغات اخرى",
                                labelText: "لغات اخرى",
                                keyboardType: TextInputType.text,
                                primaryColor: Colors.black,
                                errorText: errors['other_languages'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'other_languages',
                                    () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 20),
                              child: Text(
                                "الخبرة",
                                style: TextStyle(
                                    color: ThemeSettings.homeAppbarColor,
                                    fontSize: ThemeSettings.fontCardSize,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "الخبرات السابقة",
                                labelText: "اكتب هنا",
                                keyboardType: TextInputType.text,
                                primaryColor: Colors.black,
                                errorText: errors['previous_experience'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'previous_experience',
                                    () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "عدد ساعات عمل اخر وظيفة",
                                labelText: "عدد ساعات عمل اخر وظيفة",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                errorText: errors['work_hours'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'work_hours',
                                    () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "سبب ترك الوظيفة",
                                labelText: "اكتب هنا",
                                keyboardType: TextInputType.text,
                                primaryColor: Colors.black,
                                errorText: errors['leave_reason'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'leave_reason',
                                    () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "راتب اخر وظيفة",
                                labelText: "راتب اخر وظيفة",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                errorText: errors['salary'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'salary', () => TextEditingController()),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 30, left: 30),
                              child: BorderedTextField(
                                hintText: "المرتب المتوقع",
                                labelText: "المرتب المتوقع",
                                keyboardType: TextInputType.number,
                                primaryColor: Colors.black,
                                errorText: errors['expected_salary'],
                                // validator: notEmptyValidator,
                                controller: controllers.putIfAbsent(
                                    'expected_salary',
                                    () => TextEditingController()),
                              )),
                          Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: StandardDropdownField(
                              labelText:
                                  "هل لديك القدرة على العمل خارج نطاق محافظتك؟",
                              initialValue: outsideValue,
                              values: outside
                                  .map((key, value) => MapEntry(key, value)),
                              onChanged: (String? key) {
                                outsideValue = key!;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: GradientButton(
                              isLoading: isLoading,
                              onPressed: () => registerAJobApplication(context),
                              labelText: 'تسجيل',
                            ),
                          )
                        ]),
                      ));
                }),
                title: " وظيفة " + widget.jobDetails.title));
  }
}
