import 'dart:convert';
import 'package:http/http.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';

class CoursesApi {
  static String _baseUrl = AppData.serverURL;

  static Future<Map<String, dynamic>> getCourseCategorie(
      courseCategorieId) async {
    final Response response =
        await get('${_baseUrl}api/courses/$courseCategorieId' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response?> registerNewKid(controllers, branch, applicationDate,
      availableTime, availableDate, levelId, userId) async {
    final Response response = await post('${_baseUrl}api/courses' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'branch': branch,
          'levelId': levelId,
          'kidName': controllers['name'].text,
          'age': controllers['age'].text,
          'applyDate': applicationDate,
          'contactTime': availableTime + ":00",
          'contactDate': availableDate,
          'userid': userId.toString()
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

  static Future<Response?> registerNurseryKid(controllers, branch,
      applicationDate, availableTime, availableDate, userId) async {
    final Response response = await post('${_baseUrl}api/nursery' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'branch': branch,
          'kidName': controllers['name'].text,
          'age': controllers['age'].text,
          'applyDate': applicationDate,
          'contactTime': availableTime + ":00",
          'contactDate': availableDate,
          'levelId': "0",
          'userid': userId.toString()
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
