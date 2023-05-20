import 'dart:convert';
import 'package:http/http.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';
import 'package:starkids_app/utils/encrypt.dart';

class UserApi {
  static String _baseUrl = AppData.serverURL;

  static Future<Map<String, dynamic>> getUserMessages(userId) async {
    final Response response = await get(
        '${_baseUrl}api/user/messages?token=${GlobalRedux.store.state.user!.token}&userid=$userId' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getUserMessagesCount() async {
    final Response response = await get(
        '${_baseUrl}api/user/messages-count?token=${GlobalRedux.store.state.user!.token}&userid=${GlobalRedux.store.state.user!.id}' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final Response response = await get(
        '${_baseUrl}api/user?token=${GlobalRedux.store.state.user!.token}&userid=${GlobalRedux.store.state.user!.id}' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response> removeUserPicture() async {
    final Response response = await post(
        '${_baseUrl}api/user/remove-picture?token=${GlobalRedux.store.state.user!.token}&userid=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'remove': true,
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
    return response;
  }

  static Future<Response> updateUserFirebaseToken(token) async {
    final Response response = await post(
        '${_baseUrl}api/user/firebase-token?token=${GlobalRedux.store.state.user!.token}&userid=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'firebase_token': token,
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
    return response;
  }

  static Future<Response> changeUserPicture(picture) async {
    final Response response = await post(
        '${_baseUrl}api/user/change-picture?token=${GlobalRedux.store.state.user!.token}&userid=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'pic': picture,
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
    return response;
  }

  static Future<Response> changeUserPassword(cotrnollers) async {
    final Response response = await post(
        '${_baseUrl}api/user/change-password?token=${GlobalRedux.store.state.user!.token}&userid=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'oldpwd': generateSha1(cotrnollers['old_password'].text),
          'pwd1': generateSha1(cotrnollers['password'].text),
          'pwd2': generateSha1(cotrnollers['confirm_password'].text),
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
    return response;
  }

  static Future<Response?> updateUserData(
      controller, birthDate, gender, picture, governorate, city, area) async {
    final Response response = await post('${_baseUrl}api/user/update-data' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'name': controller['name'].text,
          'email': controller['email'].text,
          'birth': birthDate,
          'gender': gender,
          'phone1': controller['personal_phone'].text,
          'phone2': controller['mother_phone'].text,
          'phone3': controller['home_phone'].text,
          'job': controller['work'].text,
          'governorate': governorate,
          'city': city,
          'area': area
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
    return null;
  }

  static Future<Response?> sendUserMessage(message, branch) async {
    final Response response = await post(
        '${_baseUrl}api/user/message?token=${GlobalRedux.store.state.user!.token}&userid=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'message': message, 'branchid': branch}));

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
    return null;
  }
}
