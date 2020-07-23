import 'package:flutter_core/api/api_http.dart';

class CheckAttendanceController {
  getListModelAttendanceOfTheUser({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.getListModelAttendanceOfTheUser(
        document_id_custommer: document_id_custommer);
  }

  onGetDataSessionAttendanceInToDay(
      {String document_id_custommer,
      String document_id_group_attendance}) async {
    var api = HttpApi();
    return await api.GetDataSessionAttendanceInToDay(
        document_id_custommer: document_id_custommer,
        document_id_group_attendance: document_id_group_attendance);
  }

  onUpdateSessionAttendance(
      {String document_session_attendance,
      String time_minute_check_out_soon,
      String document_id_custommer,
      bool check_out_soon,
      String time_check_out}) async {
    var api = HttpApi();
    return await api.UpdateSessionAttendance(
        document_id_custommer: document_id_custommer,
        time_minute_check_out_soon: time_minute_check_out_soon,
        document_session_attendance: document_session_attendance,
        check_out_soon: check_out_soon,
        time_check_out: time_check_out);
  }

  onCreateSessionAttendance(
      {String document_id_attendance,
      bool check_in_late,
      String time_minute_check_in_late,
      String document_id_custommer,
      String time_check_in}) async {
    var api = HttpApi();
    return await api.CreateSessionAttendance(
      time_check_in: time_check_in,
      document_id_custommer: document_id_custommer,
      check_in_late: check_in_late,
      document_id_attendance: document_id_attendance,
      time_minute_check_in_late: time_minute_check_in_late,
    );
  }
}
