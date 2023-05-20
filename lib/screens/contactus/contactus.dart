// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/contactus/conactusApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/gradiantBtn/GradiantButton.dart';
import 'package:starkids_app/widgets/navigationSnackBar/NavigationSnackBar.dart';
import 'package:starkids_app/widgets/standardDropDownField/index.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List branches = [];
  late String branch;
  late String msgBranch;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;

  // Completer<GoogleMapController> _controller = Completer();
  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  void initState() {
    super.initState();
    getBranchesData();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getBranchesData() async {
    ContactUsAPi.getBranchesData().then((value) {
      setState(() {
        branches = List.castFrom(value['branches'] ?? []);
        branch = msgBranch = branches[0]['id'].toString();
        controllers['address']?.text = branches[0]['address'];
        controllers['starkids_phone']?.text = branches[0]['phone1'];
        controllers['starkids_email']?.text = branches[0]['email'];
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  void addNewMessage(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await ContactUsAPi.submitNewMessage(controllers, msgBranch, 0);
        showNavigationSnackBar(
            context, 'تم استلام الرسالة سيتم الرد عليك من خلال الايميل');
        setState(() {
          isLoading = false;
          controllers['name']?.text = "";
          controllers['phone']?.text = "";
          controllers['email']?.text = "";
          controllers['message']?.text = "";
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
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 18, right: 20),
                                  child: Text(
                                    "تواصل معنا",
                                    style: TextStyle(
                                        color: ThemeSettings.homeAppbarColor,
                                        fontSize:
                                            ThemeSettings.fontSubHeaderSize,
                                        fontWeight: FontWeight.bold),
                                  )),
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
                                    for (var i = 0; i < branches.length; i++) {
                                      if (branches[i]['id'].toString() ==
                                          key.toString()) {
                                        setState(() {
                                          controllers['address']!.text =
                                              branches[i]['address'];
                                          controllers['starkids_phone']!.text =
                                              branches[i]['phone1'];
                                          controllers['starkids_email']!.text =
                                              branches[i]['email'];
                                          branch = key!;
                                        });
                                        break;
                                      }
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    enabled: false,
                                    labelText: "العنوان",
                                    primaryColor: Colors.black,
                                    controller: controllers.putIfAbsent(
                                        'address',
                                        () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    enabled: false,
                                    labelText: "التليفون",
                                    primaryColor: Colors.black,
                                    controller: controllers.putIfAbsent(
                                        'starkids_phone',
                                        () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    enabled: false,
                                    labelText: "الايميل",
                                    primaryColor: Colors.black,
                                    controller: controllers.putIfAbsent(
                                        'starkids_email',
                                        () => TextEditingController()),
                                  )),
                              // Padding(
                              //     padding: EdgeInsets.only(right: 30, left: 30),
                              //     child: SizedBox(
                              //         height: 250,
                              //         child: GoogleMap(
                              //           mapType: MapType.hybrid,
                              //           initialCameraPosition: _kGooglePlex,
                              //           onMapCreated:
                              //               (GoogleMapController controller) {
                              //             _controller.complete(controller);
                              //           },
                              //         ))),
                              Padding(
                                  padding: EdgeInsets.only(top: 18, right: 20),
                                  child: Text(
                                    "ارسل رساله الي اداره الاكاديميه",
                                    style: TextStyle(
                                        color: ThemeSettings.homeAppbarColor,
                                        fontSize:
                                            ThemeSettings.fontSubHeaderSize,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(right: 30, left: 30),
                                child: StandardDropdownField(
                                  labelText: "الفرع",
                                  initialValue: msgBranch,
                                  values: branches.asMap().map((key, value) =>
                                      MapEntry<String, String>(
                                          value['id'].toString(),
                                          value['name'])),
                                  onChanged: (String? key) {
                                    msgBranch = key!;
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "الاسم",
                                    primaryColor: Colors.black,
                                    // validator: notEmptyValidator,
                                    errorText: errors['name'],
                                    controller: controllers.putIfAbsent(
                                        'name', () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "الايميل",
                                    errorText: errors['email'],
                                    // validator: emailValidator,
                                    primaryColor: Colors.black,
                                    controller: controllers.putIfAbsent(
                                        'email', () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "التليفون",
                                    primaryColor: Colors.black,
                                    // validator: notEmptyValidator,
                                    keyboardType: TextInputType.number,
                                    errorText: errors['phone'],
                                    controller: controllers.putIfAbsent(
                                        'phone', () => TextEditingController()),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "الرسالة",
                                    hintText: "اكتب رايك هنا...",
                                    // validator: notEmptyValidator,
                                    errorText: errors['message'],
                                    keyboardType: TextInputType.multiline,
                                    primaryColor: Colors.black,
                                    minLines: 6,
                                    maxLines: null,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          ThemeSettings.smallBorderRadius),
                                      borderSide: const BorderSide(
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          ThemeSettings.smallBorderRadius),
                                      borderSide: const BorderSide(
                                        width: 1.0,
                                        color: ThemeSettings.textColor,
                                      ),
                                    ),
                                    controller: controllers.putIfAbsent(
                                        'message',
                                        () => TextEditingController()),
                                  )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: GradientButton(
                                  isLoading: isLoading,
                                  onPressed: () => addNewMessage(context),
                                  labelText: 'ارسال',
                                ),
                              )),
                            ]),
                      ));
                }),
                title: "تواصل معنا"));
  }
}
