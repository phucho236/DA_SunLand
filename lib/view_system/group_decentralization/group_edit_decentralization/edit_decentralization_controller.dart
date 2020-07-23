import 'dart:async';

import 'package:flutter_core/api/api_http.dart';

class EditDecentralizationController {
  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;

  Future<bool> onEditListPermission({
    String document_id_decentralization,
    List<String> list_permission,
    String document_id_custommer,
  }) async {
    int countError = 0;
    _errController.sink.add('Ok');
    if (list_permission.length < 1) {
      _errController.sink.addError("Bạn phải chọn ít nhất 1 quyền");
      countError++;
    }
    if (countError == 0) {
      var api = HttpApi();
      return await api.UpdateListPermissionInGroupDecentralization(
          document_id_custommer: document_id_custommer,
          list_permission: list_permission,
          document_id_decentralization: document_id_decentralization);
    }
  }
}
