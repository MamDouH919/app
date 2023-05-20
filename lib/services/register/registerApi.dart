import 'dart:convert';
import 'package:http/http.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/utils/encrypt.dart';

class RegisterApi {
  static String _baseUrl = AppData.serverURL;

  static Future<Map<String, dynamic>> getGovernorates() async {
    final Response response = await get('${_baseUrl}api/register' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response?> registerNewUser(controller, birthDate, gender,
      picture, source, governorate, city, area) async {
    final Response response = await post('${_baseUrl}api/register' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'name': controller['name'].text,
          'email': controller['email'].text,
          'pwd1': generateSha1(controller['password'].text),
          'pwd2': generateSha1(controller['confirm_password'].text),
          'birth': birthDate,
          'gender': gender,
          'phone1': controller['personal_phone'].text,
          'phone2': controller['mother_phone'].text,
          'phone3': controller['home_phone'].text,
          'job': controller['work'].text,
          'avatar': picture,
          'source': source,
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

  static Future<Response> forgetPassword(
      String forgetPassData, String type, email, code) async {
    final Response response = await post('${_baseUrl}api/signin/forget-pass' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'data': generateSha1(forgetPassData),
          'type': type,
          'email': email,
          'code': code,
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
}
