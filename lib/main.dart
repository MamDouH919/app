import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/data/job/job_response.dart';
import 'package:starkids_app/data/kid/kid_response.dart';
import 'package:starkids_app/data/poster/poster_response.dart';
import 'package:starkids_app/screens/academy_msg/index.dart';
import 'package:starkids_app/screens/contactus/index.dart';
import 'package:starkids_app/screens/course_details/index.dart';
import 'package:starkids_app/screens/course_register/index.dart';
import 'package:starkids_app/screens/courses/courses.dart';
import 'package:starkids_app/screens/courses_categories/index.dart';
import 'package:starkids_app/screens/financials_details/index.dart';
import 'package:starkids_app/screens/forgetpassword/index.dart';
import 'package:starkids_app/screens/home/home.dart';
import 'package:starkids_app/screens/job/index.dart';
import 'package:starkids_app/screens/jobApplication/index.dart';
import 'package:starkids_app/screens/jobs/index.dart';
import 'package:starkids_app/screens/kid_attendance/index.dart';
import 'package:starkids_app/screens/kid_attendance_month/index.dart';
import 'package:starkids_app/screens/kid_cclass_details/kid_cclass_details.dart';
import 'package:starkids_app/screens/kid_details/kid_details.dart';
import 'package:starkids_app/screens/kid_financials/index.dart';
import 'package:starkids_app/screens/kid_grade/index.dart';
import 'package:starkids_app/screens/kid_notes/index.dart';
import 'package:starkids_app/screens/kid_responsible/index.dart';
import 'package:starkids_app/screens/kid_route_attendance/index.dart';
import 'package:starkids_app/screens/kid_route_attendance_month/index.dart';
import 'package:starkids_app/screens/kid_route_details/index.dart';
import 'package:starkids_app/screens/kid_route_financials/index.dart';
import 'package:starkids_app/screens/login/login.dart';
import 'package:starkids_app/screens/messages/index.dart';
import 'package:starkids_app/screens/nursery_details/index.dart';
import 'package:starkids_app/screens/offer_details/index.dart';
import 'package:starkids_app/screens/offer_register/index.dart';
import 'package:starkids_app/screens/password_change/index.dart';
import 'package:starkids_app/screens/nursery_register/index.dart';
import 'package:starkids_app/screens/picks/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:starkids_app/screens/poster/index.dart';
import 'package:starkids_app/screens/registeration/index.dart';
import 'package:starkids_app/screens/responsible_register/index.dart';
import 'package:starkids_app/screens/teacher_note/index.dart';
import 'package:starkids_app/screens/user_settings/index.dart';
import 'package:starkids_app/services/push_notifications.dart';
import 'package:starkids_app/services/user/userApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/actions/SignOut.action.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:async_redux/async_redux.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/store/ui/actions/route.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/**
 * run code generation each time you are making changes to `lib/main.dart`
 * flutter pub run build_runner build --delete-conflicting-outputs
 * pub run build_runner watch --delete-conflicting-outputs
 */
import 'main.mapper.g.dart' show initializeJsonMapper;

bool loginStatus = false;
//
// late Store<AppState> store;

void main() async {
  // initializeJsonMapper();
  //
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent, // transparent status bar
  // ));
  // await GlobalRedux.init();
  // if (GlobalRedux.store.state.user != null) {
  //   if (GlobalRedux.store.state.user?.token != null) {
  //     bool hasExpired =
  //         JwtDecoder.isExpired(GlobalRedux.store.state.user!.token!);
  //     if (hasExpired) {
  //       loginStatus = false;
  //       try {
  //         await UserApi.updateUserFirebaseToken("none");
  //       } on ApiException catch (exception) {
  //         for (final ApiError error in exception.errors) {
  //           print(error.message);
  //         }
  //       }
  //       GlobalRedux.dispatch(SignOutAction());
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString("userType", "guest");
  //     } else {
  //       loginStatus = true;
  //     }
  //   }
  // }
  // NotificationService().init();
  runApp(MyApp(
    store: await GlobalRedux.init(),
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState>? store;

  const MyApp({Key? key, this.store}) : super(key: key);

  MaterialPageRoute<Widget> selectPage(
      String routeName, Widget Function(BuildContext) routeBuilder) {
    store!.dispatch(SetCurrentRouteAction(routeName));
    return MaterialPageRoute<Widget>(builder: routeBuilder);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AsyncReduxProvider<AppState>.value(
        value: store!,
        child: MaterialApp(
            title: 'Starkids',
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              Locale("ar", "EG"),
            ],
            locale: Locale("ar", "EG"),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              // useTextSelectionTheme: true,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: ThemeSettings.homeAppbarColor, //thereby
              ),

              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: store!.state.user != null &&
                    store!.state.user!.token != null &&
                    loginStatus
                ? "/home"
                : "/",
            onGenerateRoute: (RouteSettings settings) {
              final Object args = settings.arguments!;
              print("sdklfj ${args}");
              // final bool isAuthed =
              //     _store.state.user != null && _store.state.user.token != null;
              final Map<String, Widget Function(BuildContext)>
                  authedScreensBuilders =
                  <String, Widget Function(BuildContext)>{
                // "/": (_) => Picks(),
                // "/home": (_) => MainPage(args),
                // "/job": (_) => Job(args as JobResponse),
                // "/jobs": (_) => Jobs(args),
                // "/jobApplication": (_) => JobApplication(args as JobResponse),
                // "/poster": (_) => Poster(args as PosterResponse),
                // "/register": (_) => Register(args),
                // "/courses": (_) => Courses(args),
                // "/coursesCategories": (_) =>
                //     CoursesCategories(args as Map<String, dynamic>),
                // "/courseDetails": (_) =>
                //     CourseDetails(args as Map<String, dynamic>),
                // "/contactUs": (_) => ContactUs(),
                // "/courseRegister": (_) =>
                //     CourseRegister(args as Map<String, dynamic>),
                // "/login": (_) => Login(args as String),
                // "/forgetPassword": (_) => ForgetPassword(),
                // "/kidDetails": (_) => KidDetails(args as Map<String, dynamic>),
                // "/kidResponsible": (_) =>
                //     KidResponsible(args as Map<String, dynamic>),
                // "/responsibleRegister": (_) =>
                //     ResponsibleRegister(args as KidResponse),
                // "/kidClassDetails": (_) =>
                //     KidCclassDetails(args as Map<String, dynamic>),
                // "/kidAttendance": (_) =>
                //     KidAttendance(args as Map<String, dynamic>),
                // "/kidAttendanceMonth": (_) =>
                //     KidAttendanceMonth(args as Map<String, dynamic>),
                // "/kidNotes": (_) => KidNotes(args as Map<String, dynamic>),
                // "/kidGrade": (_) => KidGrade(args as Map<String, dynamic>),
                // "/kidFinancials": (_) =>
                //     KidFinancials(args as Map<String, dynamic>),
                // "/kidTeacherNotes": (_) =>
                //     TeacherNote(args as Map<String, dynamic>),
                // "/academyNote": (_) => AcademyMsg(args as int),
                // "/Messages": (_) => Messages(args),
                // "/kidRouteDetails": (_) =>
                //     KidRouteDetails(args as Map<String, dynamic>),
                // "/kidRouteAttendance": (_) =>
                //     KidRouteAttendance(args as Map<String, dynamic>),
                // "/kidRouteAttendanceMonth": (_) =>
                //     KidRouteAttendanceMonth(args as Map<String, dynamic>),
                // "/kidRouteFinancials": (_) =>
                //     KidRouteFinancials(args as Map<String, dynamic>),
                // "/nurseryDetails": (_) =>
                //     NurseryDetails(args as Map<String, dynamic>),
                // "/nurseryRegister": (_) => NurseryRegister(),
                // "/financialsDetails": (_) =>
                //     FinancialsDetails(args as Map<String, dynamic>),
                // "/settings": (_) => UserSettings(),
                // "/changePassword": (_) => PasswordChange(),
                // "/offerDetails": (_) =>
                //     OfferDetails(args as Map<String, dynamic>),
                // "/offerRegister": (_) =>
                //     OfferRegister(args as Map<String, dynamic>),
              };

              const String authedFallbackName = "/";
              Widget authedFallbackBuilder(_) => Picks();

              // final Map<String, Widget Function(BuildContext)>
              //     unauthedScreensBuilders =
              //     <String, Widget Function(BuildContext)>{
              //   SignInScreen.routeName: (_) => SignInScreen(),
              //   SignUpScreen.routeName: (_) => SignUpScreen(),
              //   ForgetPasswordScreen.routeName: (_) => ForgetPasswordScreen(),
              // };

              // const String unauthedFallbackName = SignInScreen.routeName;
              // Widget unauthedFallbackBuilder(_) => SignInScreen();

              // Make sure loading is disabled
              store!.dispatch(DisableLoadingAction());
              // Authed routes
              for (final MapEntry<String, Widget Function(BuildContext)> screen
                  in authedScreensBuilders.entries) {
                if (settings.name == screen.key) {
                  // return isAuthed
                  //     ?
                  return selectPage(screen.key, screen.value);
                  // : selectPage(unauthedFallbackName, unauthedFallbackBuilder);
                }
              }

              // for (final MapEntry<String, Widget Function(BuildContext)> screen
              //     in unauthedScreensBuilders.entries) {
              //   if (settings.name == screen.key) {
              //     return !isAuthed
              //         ? selectPage(screen.key, screen.value)
              //         : selectPage(authedFallbackName, authedFallbackBuilder);
              //   }
              // }

              // Fallback routes
              // return isAuthed
              //     ?
              return selectPage(authedFallbackName, authedFallbackBuilder);
              // : selectPage(unauthedFallbackName, unauthedFallbackBuilder);
            }));
  }
}
