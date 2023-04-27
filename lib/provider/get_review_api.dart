import 'dart:convert';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/models/get_review.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RestReviewApi {
  Future<GetRestReview> restReviewApi(String restID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var responseJson;
    await http.post(Uri.parse('${baseUrl()}/get_res_details'), body: {
      'res_id': restID,
    }).then((response) {
      responseJson = _returnResponse(response);

//Store data into local db
      if (response.statusCode == 200) {
        preferences.remove('review');
        Map data = json.decode(response.body.toString());
        String user = jsonEncode(GetRestReview.fromJson(data));
        preferences.setString('review', user);
      }
//Store data into local db
    }).catchError((onError) {
      print(onError);
    });
    return GetRestReview.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);

        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
