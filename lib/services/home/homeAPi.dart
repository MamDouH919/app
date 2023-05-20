import 'dart:convert';
import 'package:http/http.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class HomeApi {
  static String _baseUrl = AppData.serverURL;

  static Future<Map<String, dynamic>> getHomeData() async {
    final Response response = await get(
        '${_baseUrl}api/home?token=${GlobalRedux.store.state.user?.token}&userid=${GlobalRedux.store.state.user?.id}&type=${GlobalRedux.store.state.user?.type}' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response?> seePoster(userPosterId) async {
    final Response response = await post('${_baseUrl}api/poster' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'user_poster_id': userPosterId,
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

  static Future<Response?> posterAction(userPosterId, action) async {
    final Response response = await post('${_baseUrl}api/poster/action' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'user_poster_id': userPosterId,
          'action': action
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
