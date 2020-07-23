import 'dart:async';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/validators.dart';

class CreateNameGroupAttendanceMangamentController {
  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  Validators validators = new Validators();
  bool onSubmitOke(
      {TimeModel time_start, TimeModel time_end, String name_group}) {
    int countError = 0;
    _errController.sink.add('Ok');
    if (!validators.checkName(name_group)) {
      _errController.sink.addError('Vui lòng kiểm tra Tên.');
      countError++;
    } else {
      if (time_start.hours == time_end.hours) {
        if (time_start.minute <= time_end.minute) {
          _errController.sink
              .addError('Thời gian bắt đầu phải bé hơn thời gian kết thúc.');
          countError++;
        }
      } else {
        if (time_start.hours > time_end.hours) {
          _errController.sink
              .addError('Thời gian bắt đầu phải bé hơn thời gian kết thúc.');
          countError++;
        }
      }
    }
    if (countError == 0) {
      return true;
    }
    return false;
  }
}
