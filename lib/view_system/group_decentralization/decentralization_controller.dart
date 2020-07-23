import 'package:flutter_core/api/api_http.dart';

class DecentralizationController {
  onGetListGroupDecentralization(
      {String document_id_group_decentralizatio}) async {
    var api = HttpApi();
    return await api.GetListDetailGroupDecentralization();
  }
}
