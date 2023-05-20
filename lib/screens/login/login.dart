import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/services/user/userApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/actions/SignIn.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/gradiantBtn/GradiantButton.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:starkids_app/utils/encrypt.dart';

class Login extends StatefulWidget {
  final String userType;
  Login(this.userType);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void onSignIn(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await GlobalRedux.dispatchFuture(SignInAction(
            email: controllers['email']!.text,
            password: generateSha1(controllers['password']!.text),
            userType: widget.userType));

        showNavigationSnackBar(context, 'You signed in successfully');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('jw_token') != null &&
            prefs.getString('jw_token')!.isNotEmpty) {
          try {
            await UserApi.updateUserFirebaseToken(prefs.getString('jw_token'));
          } on ApiException catch (exception) {
            for (final ApiError error in exception.errors) {
              print(error.message);
            }
          }
        }
        Future.delayed(Duration(milliseconds: 50), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        });
      } on ApiException catch (exception) {
        setState(() => isLoading = false);
        for (final ApiError error in exception.errors) {
          setState(() => errors[error.field] = error.message);
        }
      }
    }
  }

  void onForgetPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgetPassword');
  }

  void onSignUp(BuildContext context) {
    Navigator.pushNamed(context, "/register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return Form(
          key: _formKey,
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
                        ThemeSettings.picksAppBarGradientColor.withOpacity(0.5),
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
                                SvgPicture.asset("lib/assets/picks/logo.svg",
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
                            borderSide: new BorderSide(color: Colors.white30)),
                        hintColor: Colors.white30,
                        controller: controllers.putIfAbsent(
                            'email', () => TextEditingController()),
                        keyboardType: TextInputType.emailAddress,
                      )),
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: BorderedTextField(
                        labelText: 'كلمة المرور',
                        hintColor: Colors.white30,
                        // validator: notEmptyValidator,
                        errorText: errors['password'],
                        primaryColor: Colors.white,
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white30)),
                        maxLines: 1,
                        controller: controllers.putIfAbsent(
                            'password', () => TextEditingController()),
                        obscureText: true,
                      )),
                  if (widget.userType == 'parent')
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(
                          bottom: ThemeSettings.standardPadding, right: 20),
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                            style: const TextStyle(
                                letterSpacing: 0.5,
                                color: ThemeSettings.textColor),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: 'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                      color: ThemeSettings.homeAppbarColor,
                                      fontSize: ThemeSettings.fontMedSize),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => onForgetPassword(context))
                            ]),
                      ),
                    ),
                  GradientButton(
                    isLoading: isLoading,
                    onPressed: () => onSignIn(context),
                    labelText: 'دخول',
                  ),
                  const SizedBox(height: ThemeSettings.standardPadding),
                  if (widget.userType == 'parent')
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(color: Colors.white),
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: RichText(
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                  style: const TextStyle(
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                        text: 'سجل الان',
                                        style: TextStyle(
                                            color:
                                                ThemeSettings.homeAppbarColor,
                                            fontSize:
                                                ThemeSettings.fontMedSize),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => onSignUp(context))
                                  ])),
                        )
                      ],
                    )
                ]),
              ),
            )
          ]));
    }));
  }
}
