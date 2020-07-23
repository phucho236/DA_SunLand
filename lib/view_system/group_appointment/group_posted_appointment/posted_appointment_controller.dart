import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class ApointmentPostedController {
  onGetListPostedApointment({
    String document_id_custommer,
  }) async {
    List<AppointmentModel> listAppointmentModel = [];
    var api = HttpApi();
    listAppointmentModel = await api.GetListAppointmentModelUserPosted(
      document_id_custommer: document_id_custommer,
    );
    return listAppointmentModel;
  }

  onGetCustomerProfile(
      {String document_id_custommer,
      bool is_custommer_profile_out_the_system}) async {
    var api = HttpApi();
    var result_;
    CustomerProfileModel customerProfileModel;
    result_ = is_custommer_profile_out_the_system
        ? await api.GetDataCustommerOutTheSystem(
            document_id_custommer: document_id_custommer)
        : await api.GetDataCustommer(
            document_id_custommer: document_id_custommer);
    if (result_ != null) {
      customerProfileModel = CustomerProfileModel.fromJson(result_);
      customerProfileModel.document_id_custommer = document_id_custommer;
    }
    return customerProfileModel;
  }
}
