import 'dart:convert';
import 'package:http/http.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';

class ContactUsAPi {
  static String _baseUrl = AppData.serverURL;

  static Future<Map<String, dynamic>> getBranchesData() async {
    final Response response = await get('${_baseUrl}api/contact-us' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response?> submitNewMessage(controllers, branch, userId) async {
    final Response response = await post('${_baseUrl}api/contact-us' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'name': controllers['name'].text,
          'email': controllers['email'].text,
          'phone': controllers['phone'].text,
          'message': controllers['message'].text,
          'branch': branch,
          'user_id': userId.toString()
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
}
