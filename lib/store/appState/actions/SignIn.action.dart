import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:async_redux/async_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/user/actions/update.action.dart';
import 'package:starkids_app/store/user/user.dart';

class SignInAction extends ReduxAction<AppState> {
  final String email;
  final String password;
  final String userType;
  static String _baseUrl = AppData.serverURL;

  SignInAction(
      {required this.email, required this.password, required this.userType});

  @override
  Future<AppState?> reduce() async {
    final Response response = await post('${_baseUrl}api/signin' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'user_type': userType
        }));

    final Map<String, dynamic> responseObject = (response.body is Map)
        ? response.body as Map<String, dynamic>
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException((responseObject['errors'])
          .entries
          .map<ApiError>((error) => ApiError(
                code: error.value['name'],
                field: error.key,
                message: error.value['message'],
              ))
          .toList());
    }

    dispatch(UpdateUserModelAction(User(
      id: responseObject['id'].toString(),
      name: responseObject['name'].isNotEmpty
          ? responseObject['name'] as String
          : "Admin",
      email: email,
      token: responseObject['token'] as String,
      type: responseObject['type'] as String,
    )));
    return null;
  }
}
