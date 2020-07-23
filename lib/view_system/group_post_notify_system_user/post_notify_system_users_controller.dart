import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class PostNotifySystemUsersController {
  onPostNotifySystemUsers(
      {String document_id_custommer, String content, String title}) async {
    var api = HttpApi();
    return await api.PostNotifySystemUsers(
        document_id_custommer: document_id_custommer,
        content: content,
        title: title);
  }

  getlistNotifySystemUsers() async {
    var api = HttpApi();
    return await api.getListNotifySystemUsers();
  }

  Future<bool> removeNotifySystemUsers(
      {String document_id_custommer,
      String document_id_notify_system_users}) async {
    var api = HttpApi();
    return await api.RemoveNotifySystemUsers(
        document_id_custommer: document_id_custommer,
        document_id_notify_system_users: document_id_notify_system_users);
  }

  getListCustommerProifile(
      {List<NotifySystemUsersModel> listNotifySystemUsersModel}) async {
    List<CustomerProfileModel> listCustommerProifileTmp = [];
    CustomerProfileModel customerProfileModel = CustomerProfileModel();
    var api = HttpApi();
    for (var item in listNotifySystemUsersModel) {
      customerProfileModel = CustomerProfileModel.fromJson(
          await api.GetDataCustommer(document_id_custommer: item.post_by));
      listCustommerProifileTmp.add(customerProfileModel);
      customerProfileModel = null;
    }
    return listCustommerProifileTmp;
  }
}
