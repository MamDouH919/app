import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/data/kid/kid_response.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/gradiantBtn/GradiantButton.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';
import 'package:image_picker/image_picker.dart';

class ResponsibleRegister extends StatefulWidget {
  final KidResponse kidDetails;
  ResponsibleRegister(this.kidDetails);
  @override
  _ResponsibleRegisterState createState() => _ResponsibleRegisterState();
}

class _ResponsibleRegisterState extends State<ResponsibleRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;
  String? authPicture;

  void initState() {
    super.initState();
  }

  void registerNewResponsible(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        //todo add user id
        await KidsAPi.registerNewResponsible(
            controllers, widget.kidDetails.id, authPicture);
        showNavigationSnackBar(context, 'تم تسجيل مسؤل جديد بنجاح');
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.pushNamed(context, '/kidResponsible',
              arguments: {"kidResponse": widget.kidDetails, "index": 2});
        });
      } on ApiException catch (exception) {
        setState(() => isLoading = false);
        for (final ApiError error in exception.errors) {
          if (error.field == 'avatar') {
            showNavigationSnackBar(context, error.message);
          } else {
            setState(() => errors[error.field] = error.message);
          }
        }
      }
    }
  }

  Future chooseImage() async {
    final picker = ImagePicker();
    await picker.getImage(source: ImageSource.gallery).then((value) {
      value!.readAsBytes().then((value) {
        setState(() {
          authPicture = base64Encode(value);
        });
      });
    });
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
                        physics: ClampingScrollPhysics(),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 20, top: 25, bottom: 25),
                                child: Text(
                                    "مسؤل للطالب " + widget.kidDetails.name,
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedCardSize,
                                        color: ThemeSettings.homeAppbarColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 30, bottom: 20),
                                        child: Text("الصورة الشخصية")),
                                  ),
                                  Expanded(child: showImage(authPicture)),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 30, bottom: 20),
                                          child: ButtonTheme(
                                              minWidth: 200,
                                              height: 50,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ThemeSettings
                                                            .homeAppbarColor)),
                                                // shape: RoundedRectangleBorder(
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             5),
                                                //     side: BorderSide(
                                                //         color: ThemeSettings
                                                //             .homeAppbarColor)),
                                              ))))
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "الاسم",
                                    hintText: "ادخل الاسم هنا...",
                                    primaryColor: Colors.black,
                                    // validator: notEmptyValidator,
                                    errorText: errors['name'],
                                    controller: controllers.putIfAbsent(
                                        'name', () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "الهاتف",
                                    hintText: "ادخل  الهاتف...",
                                    primaryColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    // validator: notEmptyValidator,
                                    errorText: errors['phone'],
                                    controller: controllers.putIfAbsent(
                                        'phone', () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "الرقم القومى",
                                    hintText: "ادخل  الرقم القومى...",
                                    primaryColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    // validator: notEmptyValidator,
                                    errorText: errors['public_id'],
                                    controller: controllers.putIfAbsent(
                                        'public_id',
                                        () => TextEditingController()),
                                  )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: GradientButton(
                                  isLoading: isLoading,
                                  onPressed: () =>
                                      registerNewResponsible(context),
                                  labelText: 'تسجيل',
                                ),
                              )),
                            ])));
              }),
              title: "سجل مسؤل جديد",
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
