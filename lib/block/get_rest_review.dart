import 'package:nlytical/models/get_review.dart';
import 'package:nlytical/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class GetRestRreviewBloc {
  final _restReview = PublishSubject<GetRestReview>();

  Stream<GetRestReview> get favouriteStream => _restReview.stream;

  Future favouriteSink(String restID) async {
    GetRestReview getRestReview =
        await Repository().getReviewRepository(restID);
    _restReview.sink.add(getRestReview);
  }

  dispose() {
    _restReview.close();
  }
}

final getRestRreviewBloc = GetRestRreviewBloc();
