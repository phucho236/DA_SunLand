import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class UserNeedContactController {
  onLoadGetListProductNeedSuportModelNotYetContactBy() async {
    var api = HttpApi();
    return await api.GetListProductNeedSuportModel(taked: false);
  }

  onLoadGetDataProifile({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
  }
}
