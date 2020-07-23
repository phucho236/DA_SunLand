import 'dart:async';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/validators.dart';

class AddUserSystemToGroupAttendanceController {
  getListGroupAttendance() async {
    var api = HttpApi();
    return await api.getListGroupAttendance();
  }

  onGetListCustommerProfile() async {
    var api = HttpApi();
    return await api.GetListCustommerProfile(type: 1);
  }

  onGetDocumetIdCustommerAdmin() async {
    var api = HttpApi();
    return await api.GetDocumetIdCustommerAdmin();
  }

  onGetListUserInAllGroupAttendace(
      {String documemt_id_group_attendance}) async {
    var api = HttpApi();
    return await api.getListDocumentIdCustomerInGroupAttendance(
        documemt_id_group_attendance: documemt_id_group_attendance);
  }

  onFindCustommerProfileByEmailOrUserName({String email}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileByEmail(email: email, type: 1);
  }

  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  Validators validators = new Validators();
  Future<bool> onAddUserSystemToGroupAttendance(
      {List<CustomerProfileModel> list_custommer_profile_model,
      String documemt_id_group_attendance}) async {
    int countError = 0;
    _errController.sink.add('Ok');
    if (!validators.checkName(documemt_id_group_attendance)) {
      _errController.sink.addError('Bạn phải chọn nhóm điểm danh.');
      countError++;
    } else {
      if (list_custommer_profile_model.length < 1) {
        _errController.sink.addError("Bạn phải chọn ít nhất 1 người dùng");
        countError++;
      }
    }
    if (countError == 0) {
      var api = HttpApi();
      await api.UpdateUserInGroupAttendance(
          list_custommer_profile_model: list_custommer_profile_model,
          documemt_id_group_attendance: documemt_id_group_attendance);
      return true;
    }
  }
}
