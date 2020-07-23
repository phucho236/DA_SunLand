import 'package:flutter_core/api/api_http.dart';

class RequestToBecome_A_Partner {
  Future<bool> onSubmitSendRequest(
      {String document_id_custommer, String content}) async {
    var api = HttpApi();
    bool _result = false;
    await api.CreateRequestToBecomeAPartner(
            document_id_custommer: document_id_custommer, content: content)
        .then((value) {
      if (value != null) {
        _result = true;
      }
    });
    return _result;
  }
}
