import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';
import 'package:flutter_core/helpers/validators.dart';

class AddRealEstareController {
  StreamController _errController = new StreamController();
  StreamController _nameRealEstateController = new StreamController();
  StreamController _longitudeController = new StreamController();
  StreamController _latitudeController = new StreamController();
  Stream get errStream => _errController.stream;
  Stream get nameRealEStream => _nameRealEstateController.stream;
  Stream get longitudeStream => _longitudeController.stream;
  Stream get latitudeStream => _latitudeController.stream;

  Validators validators = new Validators();

  onSubmitAddRealEstare({
    @required String document_id_custommer,
    @required String name_real_estate,
    @required String longitude,
    @required String latitude,
  }) async {
    CoordinatesModel coordinates = CoordinatesModel();
    int countError = 0;
    _errController.sink.add('Ok');
    _nameRealEstateController.sink.add('Ok');
    _longitudeController.sink.add('Ok');
    _latitudeController.sink.add('Ok');

    if (!validators.checkName(name_real_estate)) {
      _errController.sink.addError('Bạn phải nhập tên dự án');
      countError++;
    } else {
      if (!validators.checkName(longitude)) {
        _errController.sink.addError('Bạn phải nhập kinh độ');
        countError++;
      } else {
        if (!validators.checkName(latitude)) {
          _errController.sink.addError('bạn phải nhập vĩ độ');
          countError++;
        }
      }
    }

    print(countError);
    if (countError == 0) {
      coordinates.longitude = longitude;
      coordinates.latitude = latitude;
      var api = HttpApi();
      return await api.CreatRealEstate(
          document_id_custommer: document_id_custommer,
          coordinates: coordinates,
          name_real_estate: name_real_estate);
    }
  }
}
