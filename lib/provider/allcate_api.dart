import 'dart:convert';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/screens/model/categories_model.dart';

import 'package:http/http.dart' as http;

class AllCateApi {
  Future<CateModel> cateApi() async {
    var responseJson;
    await http.post(Uri.parse('${baseUrl()}/get_all_cat')).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return CateModel.fromJson(responseJson);
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

final allcateApi = AllCateApi();
