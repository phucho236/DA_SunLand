import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class DetailDecentralizationController {
  onGetDataCustommerProfile({String document_id_custommer}) async {
    var api = HttpApi();
    return CustomerProfileModel.fromJson(await api.GetDataCustommer(
        document_id_custommer: document_id_custommer));
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

  Future<bool> onRemoveGroupDecentralization(
      {String document_id_decentralization,
      String document_id_custommer,
      bool removed}) async {
    var api = HttpApi();
    return api.RemoveGroupDecentralization(
        document_id_decentralization: document_id_decentralization,
        document_id_custommer: document_id_custommer,
        removed: removed);
  }

  onGetGroupDecentralization({String document_id_group_decentralizatio}) async {
    var api = HttpApi();
    return await api.GetGroupDecentralization(
        document_id_group_decentralizatio: document_id_group_decentralizatio);
  }
}
