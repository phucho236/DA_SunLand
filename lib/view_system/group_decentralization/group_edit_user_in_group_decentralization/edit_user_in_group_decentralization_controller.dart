import 'dart:async';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class EditUserInGroupDecentralization {
  onGetDataCustommerProfile({String document_id_custommer}) async {
    var api = HttpApi();

    CustomerProfileModel customerProfileModel;
    customerProfileModel = CustomerProfileModel.fromJson(
        await api.GetDataCustommer(
            document_id_custommer: document_id_custommer));
    customerProfileModel.document_id_custommer = document_id_custommer;
    return customerProfileModel;
  }

  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;

  onRemoveUserInGroupDecentralization({
    String id_group_permission,
    List<String> list_document_id_custommer,
  }) async {
    int countError = 0;
    _errController.sink.add('Ok');
    if (list_document_id_custommer.length < 1) {
      _errController.sink.addError("Bạn phải chọn ít nhất 1 người dùng");
      countError++;
    }
    if (countError == 0) {
      var api = HttpApi();
      for (var item in list_document_id_custommer) {
        await api.RemoveUserInGroupDecentralization(
            document_id_custommer: item,
            id_group_permission: id_group_permission);
      }
    }
  }

  onGetListDataCustommerProfileInGroup(
      {String document_id_group_permission}) async {
    var api = HttpApi();
    List<String> list_ducument_id_custommer = [];
    List<CustomerProfileModel> listCustomerProfileModel = [];
    list_ducument_id_custommer =
        await api.GetListIdCustommerProfileInGroupPermission(
            document_id_permission: document_id_group_permission);
    for (var item in list_ducument_id_custommer) {
      listCustomerProfileModel
          .add(await onGetDataCustommerProfile(document_id_custommer: item));
    }
    return listCustomerProfileModel;
  }
}
