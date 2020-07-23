import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class RequestToBecomeAPartnerUserController {
  onLoadGetListRequestToBecomeAPartnerUser(
      {String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetListRequestToBecomeAPartner(
        censored: true, document_id_custommer: document_id_custommer);
  }

  onLoadGetListProFileCustommer(
      List<RequestToBecomeAPartnerModel>
          listRequestToBecomeAPartnerModel) async {
    List<CustomerProfileModel> listCustomerProfileModel = [];
    CustomerProfileModel customerProfileModel = CustomerProfileModel();

    var api = HttpApi();
    for (var item in listRequestToBecomeAPartnerModel) {
      customerProfileModel = CustomerProfileModel.fromJson(
          await api.GetDataCustommer(
              document_id_custommer: item.document_id_custommer));
      if (customerProfileModel != null) {
        listCustomerProfileModel.add(customerProfileModel);
      }
      customerProfileModel = null;
    }
    return listCustomerProfileModel;
  }
}
