import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:async_redux/async_redux.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/user/actions/update.action.dart';
import 'package:starkids_app/store/user/user.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class UpdateUserAction extends ReduxAction<AppState> {
  final String name;
  final String email;
  final String password;
  static String _baseUrl = AppData.serverURL;

  UpdateUserAction(
      {required this.name, required this.email, required this.password});

  @override
  Future<AppState?> reduce() async {
    final http.Response response = await http.put(
      Uri.parse('${_baseUrl}api/signin'),
      headers: <String, String>{
        'Authorization': 'bearer ${GlobalRedux.state.user!.token}'
      },
      body: <String, String>{
        'name': name,
        'email': email,
        'password': password
      },
    );

    final Map<String, dynamic> responseObject = (response.body is Map)
        ? response.body as Map<String, dynamic>
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
          (responseObject['errors'] as Map<String, Map<String, String>>)
              .entries
              .map<ApiError>(
                  (MapEntry<String, Map<String, String>> error) => ApiError(
                        code: error.value['name'] ?? "",
                        field: error.key,
                        message: error.value['message'] ?? "",
                      ))
              .toList());
    }

    dispatch(UpdateUserModelAction(User(
        id: GlobalRedux.state.user!.id,
        name: name,
        email: email,
        token: GlobalRedux.state.user!.token,
        type: GlobalRedux.state.user!.type)));
    return null;
  }
}
