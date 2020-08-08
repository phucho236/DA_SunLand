import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';
import 'package:flutter_core/helpers/validators.dart';

class RegisterController {
  StreamController _errController = new StreamController();

  Stream get errStream => _errController.stream;

  Validators validators = new Validators();

  onSubmitRegisterAddCustommerProfile({
    @required String email,
    @required String firstName,
    @required String lastName,
    @required String phoneNumber,
    @required String password,
    @required String confirmPass,
    String fb_id,
    String gg_id,
    File images,
    String created_at,
    String deleted_at,
    String last_login,
    int total_days,
    List<String> list_item_like,
    int type = 0,
  }) async {
    int countError = 0;
    _errController.sink.add('Ok');

    if (!validators.isValidEmail(email)) {
      _errController.sink.addError('vui lòng kiểm tra Email.');
      countError++;
    }

    if (!validators.checkName(firstName)) {
      _errController.sink.addError('Vui lòng kiểm tra Tên.');
      countError++;
    } else {
      if (!validators.checkName(lastName)) {
        _errController.sink.addError('vui lòng kiểm tra Họ.');
        countError++;
      } else {
        if (phoneNumber == null || phoneNumber == '') {
          _errController.sink.addError('Vui lòng kiểm tra Số điện thoại.');
          countError++;
        } else {
          if (!validators.isPhoneNumber(phoneNumber)) {
            _errController.sink.addError('Vui lòng kiểm tra Số điện thoại.');
            countError++;
          } else {
            if (!validators.checkLengPhongNumber(phoneNumber)) {
              _errController.sink.addError('Số điện thoại phải có 10 kí tự');
              countError++;
            } else {
              if (!validators.isValidPass(password)) {
                _errController.sink.addError('Mật khẩu không được để trống.');
                countError++;
              } else {
                if (!validators.checkLengPass(password)) {
                  _errController.sink
                      .addError('Mật khẩu có độ dài từ 6 đến 15 kí tự.');
                  countError++;
                } else {
                  if (password != confirmPass) {
                    _errController.sink.addError("Mật khẩu không trùng khớp.");
                    countError++;
                  }
                }
              }
            }
          }
        }
      }
    }

    print(countError);
    if (countError == 0) {
      var api = HttpApi();
      String id_document;
      String linkImages;
      if (images != null) {
        linkImages = await api.uploadImages(
            PathDatabase: PathDatabase.Images_Customer, images: images);
        print(linkImages);
      }
      id_document = await api.CustomerProfile(
          email: email,
          first_name: firstName,
          last_name: lastName,
          phone_number: phoneNumber,
          fb_id: fb_id,
          gg_id: gg_id,
          created_at: created_at,
          deleted_at: deleted_at,
          linkImages: linkImages,
          last_login: last_login,
          total_days: total_days);
      return id_document;
    }
  }

  Future<String> onSubmitRegisterAuthenticator({
    @required String document_id_custommer,
    @required String email,
    @required String pass,
  }) async {
    var api = HttpApi();
    return await api.Authenticator(
      email: email,
      document_id_custommer: document_id_custommer,
      pass: pass,
    );
  }
}
