import 'dart:async';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/validators.dart';

class PostDecentralizationController {
  onGetListNameGroupDecentralization() async {
    var api = HttpApi();
    return api.GetListNameGroupDecentralization();
  }

  onGetListCustommerProfile() async {
    var api = HttpApi();
    return await api.GetListCustommerProfile();
  }

  onGetDocumetIdCustommerAdmin() async {
    var api = HttpApi();
    return await api.GetDocumetIdCustommerAdmin();
  }

  onFindCustommerProfileByEmailOrUserName({String email}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileByEmail(email: email);
  }

  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  Validators validators = new Validators();
  Future<bool> onCreateDecentralization(
      {List<CustomerProfileModel> list_custommer_profile_model,
      String id_group_permission}) async {
    int countError = 0;
    _errController.sink.add('Ok');
    if (!validators.checkName(id_group_permission)) {
      _errController.sink.addError('Bạn phải chọn nhóm.');
      countError++;
    } else {
      if (list_custommer_profile_model.length < 1) {
        _errController.sink.addError("Bạn phải chọn ít nhất 1 người dùng");
        countError++;
      }
    }
    if (countError == 0) {
      var api = HttpApi();
      await api.UpdateTypeCustommerProfile(
          list_custommer_profile_model: list_custommer_profile_model);
      await api.UpdateDataCustommerSystem(
          list_custommer_profile_model: list_custommer_profile_model,
          id_group_permission: id_group_permission);
      return true;
    }
  }
}
