import 'dart:async';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/validators.dart';

class DetailAndEditAppoinmentController {
  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  Validators validators = new Validators();
  onGetCustomerProfile({String document_id_custommer}) async {
    var api = HttpApi();
    var result_;
    CustomerProfileModel customerProfileModel;
    result_ = await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
    if (result_ != null) {
      customerProfileModel = CustomerProfileModel.fromJson(result_);
      customerProfileModel.document_id_custommer = document_id_custommer;
    }
    return customerProfileModel;
  }

  onGetProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetProductFindByID(
        document_id_product: document_id_product);
  }

  onGetCustomerProfileOutTheSysten({String document_id_custommer}) async {
    var api = HttpApi();
    var result_;
    CustomerProfileModel customerProfileModel;
    result_ = await api.GetDataCustommerOutTheSystem(
        document_id_custommer: document_id_custommer);
    if (result_ != null) {
      customerProfileModel = CustomerProfileModel.fromJson(result_);
      customerProfileModel.document_id_custommer = document_id_custommer;
    }
    return customerProfileModel;
  }

  onGetListCustommerProfileOutTheSystem() async {
    var api = HttpApi();
    return await api.GetListCustommerProfileOutTheSystem();
  }

  onGetListCustommerProfile({num type}) async {
    var api = HttpApi();
    return await api.GetListCustommerProfile(type: type);
  }

  onFindCustommerProfileByEmail({String email, int type}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileByEmail(email: email, type: type);
  }

  onFindCustommerProfileOutTheSystemByEmail({String email, int type}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileOutTheSystemByEmail(
        email: email, type: type);
  }

  bool checkDataCustommerProfileUserOutTheSystem(
      {CustomerProfileModel customerProfileModel}) {
    int countError = 0;
    _errController.sink.add('Ok');

    if (!validators.isValidEmail(customerProfileModel.email)) {
      _errController.sink.addError('Vui lòng kiểm tra Email.');
      countError++;
    }

    if (customerProfileModel.phone_number == null) {
      _errController.sink.addError('Vui lòng kiểm tra Số điện thoại.');
      countError++;
    } else {
      if (!validators.isPhoneNumber(customerProfileModel.phone_number)) {
        _errController.sink.addError('Vui lòng kiểm tra Số điện thoại.');
        countError++;
      }
      if (!validators.checkLengPhongNumber(customerProfileModel.phone_number)) {
        _errController.sink.addError('Số điện thoại phải có 10 kí tự');
        countError++;
      }
    }

    if (!validators.checkName(customerProfileModel.first_name)) {
      _errController.sink.addError('Vui lòng kiểm tra Tên.');
      countError++;
    }
    if (!validators.checkName(customerProfileModel.last_name)) {
      _errController.sink.addError('vui lòng kiểm tra Họ.');
      countError++;
    }

    print(countError);
    if (countError == 0) {
      return true;
    }
    return false;
  }

  Future<bool> onUpdateAppointment(
      {String document_id_user_handing,
      CustomerProfileModel custommer_out_the_system,
      String document_id_product,
      String document_id_custommer,
      bool is_custommer_profile_out_the_system,
      String address_appointment,
      DateTime time_metting,
      String document_id_appointment}) async {
    int countError = 0;
    _errController.sink.add('Ok');
    if (address_appointment != null) {
      if (address_appointment.trim() == '') {
        _errController.sink.add("Vui lòng kiểm địa chỉ.");
        countError++;
      }
    }

    if (countError == 0) {
      var api = HttpApi();
      String document_id_custommer_out_the_system;
      if (custommer_out_the_system != null) {
        if (is_custommer_profile_out_the_system == true) {
          document_id_custommer_out_the_system =
              await api.CreateCustommerProfileOutTheSystem(
                  customerProfileModel: custommer_out_the_system);
        } else {
          document_id_custommer_out_the_system =
              custommer_out_the_system.document_id_custommer;
        }
      }

      return await api.UpdateAppointment(
        address_appointment: address_appointment,
        document_id_custommer: document_id_custommer,
        document_id_product: document_id_product,
        document_id_custommer_out_the_system:
            document_id_custommer_out_the_system,
        document_id_user_handing: document_id_user_handing,
        is_custommer_profile_out_the_system:
            is_custommer_profile_out_the_system,
        time_metting: time_metting,
        document_id_appointment: document_id_appointment,
      );
    } else {
      _errController.sink.add("Vui lòng thử lại sau !");
      countError++;
    }
  }
}
