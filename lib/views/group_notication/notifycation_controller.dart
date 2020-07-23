import 'package:flutter_core/api/api_http.dart';

class NotifycationController {
  onLoadScreenNotifycation() async {
    var api = HttpApi();
    return await api.getListNotifyProductAds(removed: false);
  }
}
