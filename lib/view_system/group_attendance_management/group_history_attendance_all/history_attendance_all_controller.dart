import 'package:flutter_core/api/api_http.dart';

class HistoryAttendanceAllController {
  onGetListCustommerProfile() async {
    var api = HttpApi();
    return await api.GetListCustommerProfile(type: 1);
  }

  onFindCustommerProfileByEmailOrUserName({String email}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileByEmail(email: email, type: 1);
  }
}
