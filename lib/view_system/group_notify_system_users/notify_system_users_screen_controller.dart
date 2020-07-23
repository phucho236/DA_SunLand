import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class NotifySystemUsersController {
  getlistNotifySystemUsers() async {
    var api = HttpApi();
    return await api.getListNotifySystemUsers(removed: false);
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
