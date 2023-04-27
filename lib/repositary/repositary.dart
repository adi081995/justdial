import 'package:nlytical/models/get_review.dart';
import 'package:nlytical/screens/model/categories_model.dart';

import 'package:nlytical/provider/allcate_api.dart';
import 'package:nlytical/provider/get_review_api.dart';

class Repository {
  Future<GetRestReview> getReviewRepository(String restID) async {
    return await RestReviewApi().restReviewApi(restID);
  }


  Future<CateModel> allcateRepository() async {
    return await AllCateApi().cateApi();
  }
}
