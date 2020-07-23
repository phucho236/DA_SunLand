import 'package:flutter_core/api/api_http.dart';

class HistoryAttendanceController {
  getListModelAttendanceOfTheUser({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.getListModelAttendanceOfTheUser(
        document_id_custommer: document_id_custommer);
  }

  onFindDataSessionAttendanceInDay(
      {String document_id_custommer,
      String document_id_group_attendance,
      DateTime TimeSessionAttendanceInDay}) async {
    var api = HttpApi();
    return await api.FindDataSessionAttendanceInDay(
        document_id_custommer: document_id_custommer,
        document_id_group_attendance: document_id_group_attendance,
        TimeSessionAttendanceInDay: TimeSessionAttendanceInDay);
  }

  onFindDataSessionAttendanceInMon(
      {String document_id_custommer,
      String document_id_group_attendance,
      DateTime TimeSessionAttendanceInDay}) async {
    var api = HttpApi();
    return await api.FindDataSessionAttendanceInMon(
        document_id_custommer: document_id_custommer,
        document_id_group_attendance: document_id_group_attendance,
        TimeSessionAttendanceInDay: TimeSessionAttendanceInDay);
  }
}
