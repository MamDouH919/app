import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/kids/kidsApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/gradiantBtn/GradiantButton.dart';
import 'package:starkids_app/widgets/navigationSnackBar/index.dart';

class TeacherNote extends StatefulWidget {
  final Map<String, dynamic> kidDetails;
  TeacherNote(this.kidDetails);
  @override
  _TeacherNoteState createState() => _TeacherNoteState();
}

class _TeacherNoteState extends State<TeacherNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers =
      <String, TextEditingController>{};
  final Map<String, String> errors = <String, String>{};
  bool isLoading = false;
  String? authPicture;

  void initState() {
    super.initState();
  }

  void sendTeacherNote(BuildContext context) async {
    // clear custom errors;
    errors.clear();
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        //todo add user id
        await KidsAPi.sendTeacherNote(controllers,
            widget.kidDetails['kid_class_id'], widget.kidDetails['c_type']);
        showNavigationSnackBar(context, 'تم ارسال رسالة بنجاح');
        setState(() {
          isLoading = false;
          controllers['message']!.text = '';
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 20, top: 25, bottom: 25),
                                child: Text(
                                    " المستوى " +
                                        widget.kidDetails['level_name'],
                                    style: TextStyle(
                                        fontSize: ThemeSettings.fontMedCardSize,
                                        color: ThemeSettings.homeAppbarColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: BorderedTextField(
                                    labelText: "الرسالة",
                                    hintText: "اكتب الملاحظة هنا",
                                    primaryColor: Colors.black,
                                    // validator: notEmptyValidator,
                                    minLines: 6,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
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
                                    errorText: errors['message'],
                                    controller: controllers.putIfAbsent(
                                        'message',
                                        () => TextEditingController()),
                                  )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: GradientButton(
                                  isLoading: isLoading,
                                  onPressed: () => sendTeacherNote(context),
                                  labelText: 'ارسال',
                                ),
                              )),
                            ])));
              }),
              title: "ارسال ملاحظة للمدرس",
              appBarBGColor: ThemeSettings.homeAppbarColor,
            ));
  }
}
