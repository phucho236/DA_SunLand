import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/helpers/validators.dart';

class ForgotPasswordController {
  StreamController _errController = new StreamController();
  StreamController _emailController = new StreamController();
  Stream get errStream => _errController.stream;
  Stream get emailStream => _emailController.stream;
  Validators validators = new Validators();
  Future<String> onSubmitSendOTP({String email}) async {
    int countError = 0;
    _errController.sink.add('Ok');
    _emailController.sink.add('Ok');
    if (!validators.isValidEmail(email)) {
      _errController.sink.addError('vui lòng kiểm tra Email.');
      countError++;
    }
    print(countError);
    if (countError == 0) {
      String data = null;
      var api = HttpApi();
      await api.CheckEmailExist(email: email).then((value) async {
        if (value) {
          await api.CreateOTP(email: email).then((value) {
            if (value == null) {
              _errController.sink.addError('Gửi OTP thất bại.');
            } else
              //setOTP(newValue: value);
              data = value;
          });
        } else {
          _errController.sink.addError('Email chưa được đăng kí.');
        }
      });
      return data;
    }
  }

  Future<bool> onSubmitCheckOTP({String otp}) async {
    bool CheckOTP = false;
    int countError = 0;
    InfoOTP infoOTP = InfoOTP();
    _errController.sink.add('Ok');
    if (!validators.isValidOTP(otp)) {
      _errController.sink.addError('Vui lòng kiểm tra lại OTP');
      countError++;
    }
    print(countError);
    if (countError == 0) {
      var api = HttpApi();
      await api.CheckOTPExist(otp: otp).then((value) {
        if (value == null) {
          _errController.sink.addError('OTP không hợp lệ');
        } else {
          infoOTP = InfoOTP.fromJson(value);
          DateTime timeCreatOTP = DateTime.parse(infoOTP.time_create_otp)
              .add(new Duration(minutes: 30));
          if (DateTime.now().isAfter(timeCreatOTP)) {
            _errController.sink.addError('OTP hết thời gian sử dụng');
          } else {
            CheckOTP = true;
          }
        }
      });
      return CheckOTP;
    }
  }

  Future<bool> onSubmitchangePassword(
      {String email, String password, String confirmPass}) async {
    bool checkChangePassword = false;
    int countError = 0;

    _errController.sink.add('Ok');

    if (!validators.isValidPass(password)) {
      _errController.sink.addError('Mật khẩu không được để trống.');
      countError++;
    } else {
      if (!validators.checkLengPass(password)) {
        _errController.sink.addError('Mật khẩu có độ dài từ 6 đến 15 kí tự.');
        countError++;
      } else {
        if (!validators.isValidConfirmPass(confirmPass)) {
          _errController.sink
              .addError('Nhập lại mật khẩu không được để trống.');
          countError++;
        } else {
          if (password != confirmPass) {
            _errController.sink.addError("Mật khẩu không trùng khớp.");
            countError++;
          }
        }
      }
    }

    print(countError);
    if (countError == 0) {
      var api = HttpApi();
      await api
          .changePassword(
              email: email,
              password: password,
              last_change_password: DateTime.now().toString())
          .then((value) {
        if (value == false) {
          _errController.sink.addError('Đổi mật khẩu thất bại');
        } else {
          checkChangePassword = true;
        }
      });
      return checkChangePassword;
    }
  }
}
