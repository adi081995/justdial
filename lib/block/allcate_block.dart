import 'package:nlytical/screens/model/categories_model.dart';
import 'package:nlytical/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class AllCateBloc {
  final allcate = PublishSubject<CateModel>();

  Stream<CateModel> get allcateStream => allcate.stream;

  Future allcateSink() async {
    CateModel nearbyModal = await Repository().allcateRepository();
    allcate.sink.add(nearbyModal);
  }

  dispose() {
    allcate.close();
  }
}

final allcate = AllCateBloc();
