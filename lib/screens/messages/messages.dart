import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/screens/standard/index.dart';
import 'package:starkids_app/services/contactus/conactusApi.dart';
import 'package:starkids_app/services/user/userApi.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/actions/loading.action.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:intl/intl.dart';
import 'package:starkids_app/utils/validators/formValidators.dart';
import 'package:starkids_app/widgets/borderedTextField/BorderedTextField.dart';
import 'package:starkids_app/widgets/navigationSnackBar/NavigationSnackBar.dart';
import 'package:starkids_app/widgets/standardDropDownField/index.dart';

class Messages extends StatefulWidget {
  final int currentIndex;
  Messages(this.currentIndex);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List messages = [];
  List branches = [];
  String? branch;
  final TextEditingController textcontroller = new TextEditingController();

  void initState() {
    getUserMessages();
    getBranchesData();
    super.initState();
    GlobalRedux.dispatch(EnableLoadingAction());
  }

  void getUserMessages() async {
    UserApi.getUserMessages(GlobalRedux.store.state.user!.id).then((value) {
      setState(() {
        messages = List.castFrom(value['messages'] ?? []);
      });
      // GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  void getBranchesData() async {
    ContactUsAPi.getBranchesData().then((value) {
      setState(() {
        branches = List.castFrom(value['branches'] ?? []);
        branch = branches[0]['id'].toString();
      });
      GlobalRedux.dispatch(DisableLoadingAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) => <dynamic>[state.ui],
        builder: (BuildContext context, _, AppState state, __, ___,
                Widget? child) =>
            StandardScreen(
              child: Builder(builder: (BuildContext context) {
                return Stack(fit: StackFit.expand, children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 170),
                      child: RefreshIndicator(
                        color: ThemeSettings.messagesHeader,
                        child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(children: [
                              messages?.length == 0
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Text("لا يوجد رسائل بعد"))
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 20, left: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (messages[index]
                                                              ['message'] !=
                                                          null &&
                                                      messages[index]['message']
                                                          .isNotEmpty)
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ChatBubble(
                                                          clipper: ChatBubbleClipper2(
                                                              type: BubbleType
                                                                  .sendBubble),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 10,
                                                                  top: 10),
                                                          backGroundColor:
                                                              ThemeSettings
                                                                  .homeAppbarColor,
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child:
                                                                SelectableText(
                                                              messages[index]
                                                                  ['message'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      ThemeSettings
                                                                          .fontMedSize),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 10),
                                                            child: Text(
                                                              DateFormat.jm()
                                                                  .format(DateTime
                                                                      .parse(messages[
                                                                              index]
                                                                          [
                                                                          'message_date']))
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      ThemeSettings
                                                                          .fontMedSize),
                                                            ))
                                                      ],
                                                    ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      ChatBubble(
                                                        clipper: ChatBubbleClipper2(
                                                            type: BubbleType
                                                                .receiverBubble),
                                                        margin: EdgeInsets.only(
                                                            right: 10,
                                                            left: 10,
                                                            top: 10),
                                                        backGroundColor:
                                                            ThemeSettings
                                                                .greyBubble,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: SelectableText(
                                                            messages[index]
                                                                ['answer'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    ThemeSettings
                                                                        .fontMedSize),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  left: 10),
                                                          child: Text(
                                                            DateFormat.jm()
                                                                .format(DateTime
                                                                    .parse(messages[
                                                                            index]
                                                                        [
                                                                        'answer_date']))
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    ThemeSettings
                                                                        .fontMedSize),
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              )),
                                        );
                                      }),
                            ])),
                        onRefresh: () {
                          return Future.delayed(
                            Duration(milliseconds: 500),
                            () {
                              getUserMessages();
                            },
                          );
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BorderedTextField(
                                  hintText: "اكتب هنا...",
                                  labelText: "الرسالة",
                                  keyboardType: TextInputType.text,
                                  primaryColor: Colors.black,
                                  // validator: notEmptyValidator,
                                  controller: textcontroller,
                                  iconBtn: true,
                                  sendIcon: IconButton(
                                      onPressed: () async {
                                        // Validate returns true if the form is valid, otherwise false.
                                        try {
                                          await UserApi.sendUserMessage(
                                              textcontroller.text, branch);
                                          textcontroller.clear();

                                          showNavigationSnackBar(context,
                                              'تم ارسال الرساله بنجاح');
                                        } on ApiException catch (exception) {
                                          for (final ApiError error
                                              in exception.errors) {
                                            showNavigationSnackBar(
                                                context, error.message);
                                          }
                                        }
                                      },
                                      icon: Icon(Icons.send)),
                                ),
                                StandardDropdownField(
                                  labelText: "الفرع",
                                  initialValue: branch,
                                  values: branches.asMap().map((key, value) =>
                                      MapEntry<String, String>(
                                          value['id'].toString(),
                                          value['name'])),
                                  onChanged: (String? key) {
                                    setState(() {
                                      branch = key;
                                    });
                                  },
                                ),
                              ]))),
                ]);
              }),
              title: " الرسائل ",
              appBarBGColor: ThemeSettings.messagesHeader,
              screenIndex: widget.currentIndex,
            ));
  }
}
