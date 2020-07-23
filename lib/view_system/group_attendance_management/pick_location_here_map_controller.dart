import 'dart:async';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:here_sdk/core.dart';

class PickLocationHereMapController {
  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  String document_id_custommer;
  getDocumentIdCustommer__() async {
    String document_id_custommerTmp;

    document_id_custommerTmp = await getDocumentIdCustommer();
    if (document_id_custommerTmp != null) {
      document_id_custommer = document_id_custommerTmp;
    }
  }

  Future<bool> onSubmitOkePickLocation(
      {TimeModel time_start,
      TimeModel time_end,
      String name_group,
      GeoCoordinates geoCoordinates}) async {
    getDocumentIdCustommer__();
    int countError = 0;
    _errController.sink.add('Ok');

    if (geoCoordinates == null) {
      _errController.sink.addError('Chưa có địa điểm được chọn.');
      countError++;
    }
    if (countError == 0) {
      bool _result = false;
      var api = HttpApi();
      await api.CreateGroupAttendance(
              coordinatesDoubleModel: CoordinatesDoubleModel(
                  latitude: geoCoordinates.latitude,
                  longitude: geoCoordinates.longitude),
              name_group: name_group,
              time_end: time_end,
              time_start: time_start,
              document_id_custommer: document_id_custommer)
          .then((value) {
        print(value);
        if (value != null) {
          _result = true;
        }
      });
      return _result;
    }
  }
}
