import 'dart:async';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/helpers/validators.dart';

class DialogCreateGroupDecentralizationController {
  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  Validators validators = new Validators();
  Future<bool> onCreateGroupDecentralization({
    String nameGroup,
    List<String> list_permission,
    String document_id_custommer,
  }) async {
    int countError = 0;
    _errController.sink.add('Ok');
    if (!validators.checkName(nameGroup)) {
      _errController.sink.addError('Bạn phải nhập tên nhóm.');
      countError++;
    } else {
      if (list_permission.length < 1) {
        _errController.sink.addError("Bạn phải chọn ít nhất 1 quyền");
        countError++;
      }
    }
    if (countError == 0) {
      var api = HttpApi();
      return await api.CreateGroupDecentralization(
          document_id_custommer: document_id_custommer,
          list_permission: list_permission,
          nameGroup: nameGroup);
    }
  }
}
