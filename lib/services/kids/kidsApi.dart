import 'dart:convert';
import 'package:http/http.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

class KidsAPi {
  static String _baseUrl = AppData.serverURL;

  static Future<Map<String, dynamic>> getClassesData(kidId) async {
    final Response response = await get(
        '${_baseUrl}api/kid?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response> changeKidPicture(kidPicture, kidid) async {
    final Response response = await post(
        '${_baseUrl}api/kid/change-picture?token=${GlobalRedux.store.state.user!.token}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'pic': kidPicture,
          'kid_id': kidid,
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

  static Future<Map<String, dynamic>> getKidResponsible(int kidId) async {
    final Response response = await get(
        '${_baseUrl}api/kid/responsible?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId&userid=${GlobalRedux.store.state.user!.id}' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response?> registerNewResponsible(
      controllers, kidId, picture) async {
    final Response response = await post(
        '${_baseUrl}api/kid/register-responsible?token=${GlobalRedux.store.state.user!.token}&userId=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'name': controllers['name'].text,
          'phone': controllers['phone'].text,
          'publicId': controllers['public_id'].text,
          'kid_id': kidId,
          'avatar': picture
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

  static Future<Map<String, dynamic>> getKidClassAttendance(
      kidId, classType) async {
    final Response response = await get(
        '${_baseUrl}api/kid/attendance?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId&c_type=$classType' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getKidRouteAttendance(
      kidId, classType) async {
    final Response response = await get(
        '${_baseUrl}api/kid/route-attendance?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId&c_type=$classType' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getKidNotes(kidId, classType) async {
    final Response response = await get(
        '${_baseUrl}api/kid/notes?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId&c_type=$classType' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getKidPercentage(kidId, classType) async {
    final Response response = await get(
        '${_baseUrl}api/kid/percentage?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId&c_type=$classType' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getKidFinancials(
      kidId, classType, ftype, month, year, page, total) async {
    final Response response = await get(
        '${_baseUrl}api/kid/financials?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId&c_type=$classType&type=$ftype&month=$month&year=$year&page=$page&total=$total' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getKidRouteFinancials(
      kidId, classType, ftype, month, year, page, total) async {
    final Response response = await get(
        '${_baseUrl}api/kid/route-financials?token=${GlobalRedux.store.state.user!.token}&kid_id=$kidId&c_type=$classType&type=$ftype&month=$month&year=$year&page=$page&total=$total' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Map<String, dynamic>> getKidFinancialsDetails(transId) async {
    final Response response = await get(
        '${_baseUrl}api/kid/financials-details?token=${GlobalRedux.store.state.user!.token}&trans_id=$transId' as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } else {
      return Future.error("Someting went wrong!");
    }
  }

  static Future<Response?> sendTeacherNote(controllers, kidId, cType) async {
    final Response response = await post(
        '${_baseUrl}api/kid/teacher-note?token=${GlobalRedux.store.state.user!.token}&userId=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'feedback': controllers['message'].text,
          'kcID': kidId,
          'cType': cType
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

  static Future<Response?> sendYourOpinion(controllers) async {
    final Response response = await post(
        '${_baseUrl}api/kid/academy-feedback?token=${GlobalRedux.store.state.user!.token}&userId=${GlobalRedux.store.state.user!.id}' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'feedback': controllers['message'].text,
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
