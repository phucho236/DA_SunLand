import 'dart:io';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';

class DetailAppointmentDoneController {
  onGetCustomerProifile(
      {String document_id_custommer,
      bool is_custommer_profile_out_the_system = false}) async {
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

  onCheckInAppointment(
      {String documment_id_custommer,
      CoordinatesDoubleModel coordinatesDoubleModel,
      String document_id_appointment,
      File file_images_check_in}) async {
    var api = HttpApi();
    String url_images_check_in = await api.uploadImages(
        images: file_images_check_in,
        PathDatabase: PathDatabase.Images_CheckIn);
    if (url_images_check_in != null) {
      return await api.CheckInAppointment(
          coordinatesDoubleModel: coordinatesDoubleModel,
          document_id_appointment: document_id_appointment,
          documment_id_custommer: documment_id_custommer,
          url_images_check_in: url_images_check_in);
    } else {
      return false;
    }
  }

  onGetProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetProductFindByID(
        document_id_product: document_id_product);
  }
}
