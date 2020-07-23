import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/hash/hast_value.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/helpers/validators.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginController {
  Validators validators = new Validators();
  StreamController _errController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController _passwordController = new StreamController();

  Stream get emailStream => _emailController.stream;
  Stream get passwordStream => _passwordController.stream;
  Stream get errStream => _errController.stream;

  Future<bool> onSubmitLogin(
      {@required String email, @required String password}) async {
    int countError = 0;
    _errController.sink.add('Ok');
    _emailController.sink.add('Ok');
    _passwordController.sink.add('Ok');
    if (!validators.isValidEmail(email)) {
      _errController.sink.addError('Email không hợp lệ.');
      countError++;
    } else {
      if (!validators.isValidPass(password)) {
        _errController.sink.addError('Mật khẩu không hợp lệ.');
        countError++;
      }
    }

    if (countError == 0) {
      var api = HttpApi();
      dynamic _result = await api.login(email: email);

      if (_result == null) {
        _errController.sink.addError('Tài khoản hoặc mật khẩu không hợp lệ.');
      } else {
        Authenticator authenticator = Authenticator.fromJson(_result);
        if (authenticator.pass ==
            generateSignature(dataIn: password, signature: "SunLandGroup")) {
          setDocumentIdCustommer(newValue: authenticator.document_id_custommer);
          return true;
        } else {
          _errController.sink.addError('Mật khẩu không hợp lệ.');
        }
      }
    }
    return false;
  }
}
