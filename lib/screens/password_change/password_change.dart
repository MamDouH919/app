import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/user/userApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/gradiantBtn/GradiantButton.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';

class PasswordChange extends StatefulWidget {
  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;

  void initState() {
    super.initState();
  }

  void changePassword(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        //todo add user id
        await UserApi.changeUserPassword(controllers);
        showNavigationSnackBar(context, 'تم تغير كلمة المرور بنجاح');
        setState(() {
          isLoading = false;
          controllers['old_password']!.text = "";
          controllers['confirm_password']!.text = "";
          controllers['password']!.text = "";
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
                                  child: BorderedTextField(
                                      hintText: "ادخل كلمة المرور الحالية",
                                      labelText: "كلمة المرور الحالية",
                                      keyboardType: TextInputType.text,
                                      primaryColor: Colors.black,
                                      obscureText: true,
                                      maxLines: 1,
                                      // validator: notEmptyValidator,
                                      errorText: errors['old_password'],
                                      controller: controllers.putIfAbsent(
                                          'old_password',
                                          () => TextEditingController()))),
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
                                      controller: controllers.putIfAbsent(
                                          'password',
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
                                    errorText: errors['confirm_password'],
                                    // validator: (String? value) =>
                                    //     textMatchValidator(value,
                                    //         controllers['password'].text),
                                    controller: controllers.putIfAbsent(
                                        'confirm_password',
                                        () => TextEditingController()),
                                  )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: GradientButton(
                                  isLoading: isLoading,
                                  bgColor: ThemeSettings.kidsColor,
                                  onPressed: () => changePassword(context),
                                  labelText: 'تغير كلمة المرور',
                                ),
                              )),
                            ])));
              }),
              title: "الاعدادات",
              appBarBGColor: ThemeSettings.kidsColor,
            ));
  }
}
