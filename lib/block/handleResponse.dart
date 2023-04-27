import 'package:rxdart/rxdart.dart';

class HandleResponse {
  final _handleResponseController = PublishSubject<bool>();

  Stream<bool> get handleResponseStream => _handleResponseController.stream;

  handleResponseSink(bool responseStatus) {
    return _handleResponseController.sink.add(responseStatus);
  }

  dispose() {
    _handleResponseController.close();
  }
}

final handleResponse = HandleResponse();
