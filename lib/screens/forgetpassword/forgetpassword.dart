import 'package:flutter/material.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/services/register/registerApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/gradiantBtn/GradiantButton.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

enum _ForgetPasswordScreenStates { provideEmail, provideCode, providePassword }

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;
  _ForgetPasswordScreenStates? screenState;

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _codeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  String? email;
  String? code;

  @override
  void initState() {
    super.initState();
    setState(() {
      screenState = _ForgetPasswordScreenStates.provideEmail;
    });
  }

  void onEmailSubmit(BuildContext context) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_emailFormKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        var response = await RegisterApi.forgetPassword(
            controllers['email']!.text, "email", "email", "code");
        final Map<String, dynamic> responseObject = (response.body is Map)
            ? response.body as Map<String, dynamic>
            : jsonDecode(response.body) as Map<String, dynamic>;

        showNavigationSnackBar(context, responseObject['message']);
        setState(() {
          email = responseObject['email'];
          screenState = _ForgetPasswordScreenStates.provideCode;
          isLoading = false;
        });
      } on ApiException catch (exception) {
        setState(() => isLoading = false);
        for (final ApiError error in exception.errors) {
          setState(() => errors[error.field] = error.message);
        }
      }
    }
  }

  void onCodeSubmit(BuildContext context) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_codeFormKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        var response = await RegisterApi.forgetPassword(
            controllers['code']!.text, "code", email, "code");
        final Map<String, dynamic> responseObject = (response.body is Map)
            ? response.body as Map<String, dynamic>
            : jsonDecode(response.body) as Map<String, dynamic>;

        showNavigationSnackBar(context, responseObject['message']);
        setState(() {
          email = responseObject['email'];
          code = responseObject['code'];
          screenState = _ForgetPasswordScreenStates.providePassword;
          isLoading = false;
        });
      } on ApiException catch (exception) {
        setState(() => isLoading = false);
        for (final ApiError error in exception.errors) {
          setState(() => errors[error.field] = error.message);
        }
      }
    }
  }

  void onPasswordChange(BuildContext context) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_passwordFormKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        var response = await RegisterApi.forgetPassword(
            controllers['password']!.text, "password", email, code);
        final Map<String, dynamic> responseObject = (response.body is Map)
            ? response.body as Map<String, dynamic>
            : jsonDecode(response.body) as Map<String, dynamic>;

        showNavigationSnackBar(context, responseObject['message']);
        Navigator.pushReplacementNamed(context, '/login', arguments: "parent");
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
    return Scaffold(body: Builder(builder: (BuildContext context) {
      switch (screenState) {
        case _ForgetPasswordScreenStates.provideEmail:
          return Form(
              key: _emailFormKey,
              child: Stack(children: [
                new AppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/home/login_background.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
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
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Center(
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.7,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "lib/assets/picks/logo.svg",
                                        semanticsLabel: "logo"),
                                    Text("http://www.starkids-academy.com/",
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: ThemeSettings.linkColor,
                                          decoration: TextDecoration.underline,
                                        ))
                                  ]))),
                      Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: BorderedTextField(
                            labelText: 'البريد الالكترونى',
                            // validator: emailValidator,
                            errorText: errors['email'],
                            primaryColor: Colors.white,
                            enabledBorder: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white30)),
                            hintColor: Colors.white38,
                            controller: controllers.putIfAbsent(
                                'email', () => TextEditingController()),
                            keyboardType: TextInputType.emailAddress,
                          )),
                      GradientButton(
                        isLoading: isLoading,
                        onPressed: () => onEmailSubmit(context),
                        labelText: 'ارسال',
                      ),
                      const SizedBox(height: ThemeSettings.standardPadding),
                    ]),
                  ),
                )
              ]));
          break;
        case _ForgetPasswordScreenStates.provideCode:
          return Form(
              key: _codeFormKey,
              child: Stack(children: [
                new AppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/home/login_background.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
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
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Center(
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.7,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "lib/assets/picks/logo.svg",
                                        semanticsLabel: "logo"),
                                    Text("http://www.starkids-academy.com/",
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: ThemeSettings.linkColor,
                                          decoration: TextDecoration.underline,
                                        ))
                                  ]))),
                      Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: BorderedTextField(
                            labelText: 'الكود',
                            // validator: notEmptyValidator,
                            errorText: errors['code'],
                            primaryColor: Colors.white,
                            enabledBorder: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white30)),
                            hintColor: Colors.white38,
                            controller: controllers.putIfAbsent(
                                'code', () => TextEditingController()),
                            keyboardType: TextInputType.text,
                          )),
                      GradientButton(
                        isLoading: isLoading,
                        onPressed: () => onCodeSubmit(context),
                        labelText: 'ارسال',
                      ),
                      const SizedBox(height: ThemeSettings.standardPadding),
                    ]),
                  ),
                )
              ]));
          break;
        case _ForgetPasswordScreenStates.providePassword:
          return Form(
              key: _passwordFormKey,
              child: Stack(children: [
                new AppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/home/login_background.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
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
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Center(
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.7,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "lib/assets/picks/logo.svg",
                                        semanticsLabel: "logo"),
                                    Text("http://www.starkids-academy.com/",
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: ThemeSettings.fontMedSize,
                                          color: ThemeSettings.linkColor,
                                          decoration: TextDecoration.underline,
                                        ))
                                  ]))),
                      Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: BorderedTextField(
                            labelText: 'كلمة المرور الجديدة',
                            // validator: notEmptyValidator,
                            errorText: errors['password'],
                            primaryColor: Colors.white,
                            obscureText: true,
                            maxLines: 1,
                            enabledBorder: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white30)),
                            hintColor: Colors.white38,
                            controller: controllers.putIfAbsent(
                                'password', () => TextEditingController()),
                            keyboardType: TextInputType.text,
                          )),
                      GradientButton(
                        isLoading: isLoading,
                        onPressed: () => onPasswordChange(context),
                        labelText: 'تغيير',
                      ),
                      const SizedBox(height: ThemeSettings.standardPadding),
                    ]),
                  ),
                )
              ]));
          break;
        default:
          throw 'invalid screenState $screenState';
          return const Text(
              'This text should never be shown. If you see this, please report it as a bug');
      }
    }));
  }
}
