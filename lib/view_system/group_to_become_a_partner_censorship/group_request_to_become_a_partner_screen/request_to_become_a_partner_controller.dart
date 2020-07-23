import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class RequestToBecomeAPartnerController {
  onLoadGetListRequestToBecomeAPartner() async {
    var api = HttpApi();
    return await api.GetListRequestToBecomeAPartner(censored: false);
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

  onAcceptRequest(
      {String document_id_custommer,
      String document_id_request,
      String document_id_custommer_send_request,
      bool accepted}) async {
    var api = HttpApi();
    return await api.AcceptRequest(
        document_id_custommer_send_request: document_id_custommer_send_request,
        accepted: accepted,
        document_id_custommer: document_id_custommer,
        document_id_request: document_id_request);
  }

  onLoadGetDataProfileCustommerCensored({String document_id_custommer}) async {
    var api = HttpApi();
    return await CustomerProfileModel.fromJson(await api.GetDataCustommer(
        document_id_custommer: document_id_custommer));
  }

  Future<bool> onEditPartner(
      {String document_id_custommer,
      String document_id_request,
      bool accepted,
      String document_id_custommer_send_request}) async {
    var api = HttpApi();
    return await api.EditPartner(
        document_id_custommer: document_id_custommer,
        document_id_request: document_id_request,
        accepted: accepted,
        document_id_custommer_send_request: document_id_custommer_send_request);
  }
}
