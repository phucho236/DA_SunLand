import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class ApointmentDoneController {
  onGetListApointment(
      {String document_id_custommer,
        bool get_list_appointment_user_handing,
        bool checked_in}) async {
    var api = HttpApi();
    return await api.GetListAppointmentModel(
        document_id_custommer: document_id_custommer,
        get_list_appointment_user_handing: get_list_appointment_user_handing,
        checked_in: checked_in);
  }

  onGetCustomerProifile(
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
