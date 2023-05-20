import 'dart:convert';
import 'package:http/http.dart';
import 'package:starkids_app/data/exception/ApiException.dart';
import 'package:starkids_app/settings/appData.dart';

class JobsApi {
  static String _baseUrl = AppData.serverURL;

  static Future<Response?> registerNewJobApplication(
      controllers,
      gender,
      birthDate,
      martial,
      personalPicture,
      frontPic,
      backPic,
      gradPic,
      diploma,
      computer,
      english,
      selectedJob,
      outside,
      branch,
      positionId) async {
    final Response response = await post('${_baseUrl}api/jobs' as Uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'name': controllers['name'].text,
          'gender': gender,
          'birth': birthDate,
          'address': controllers['address'].text,
          'phone1': controllers['personal_phone_1'].text,
          'phone2': controllers['personal_phone_2'].text,
          'email': controllers['email'].text,
          'marital': martial,
          'kids': controllers['childs'].text,
          'avatar': personalPicture,
          'public_id': controllers['national_id'].text,
          'pid_pic_front': frontPic,
          'pid_pic_back': backPic,
          'grad_cert_pic': gradPic,
          'faculty': controllers['college'].text,
          'graduation': controllers['college_year'].text,
          'diplome': diploma,
          'courses': controllers['courses'].text,
          'computer': computer,
          'english': english,
          'languages': controllers['other_languages'].text,
          'experience': controllers['previous_experience'].text,
          'oldHours': controllers['work_hours'].text,
          'dismissReason': controllers['leave_reason'].text,
          'oldSalary': controllers['salary'].text,
          'job': selectedJob,
          'salary': controllers['expected_salary'].text,
          'outside': outside,
          'branch': branch,
          'position_id': positionId
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
