import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';

class TakedUserNeedContactAllController {
  onLoadGetListProductNeedSuportModelContactBy(
      {bool contacted, bool taked}) async {
    var api = HttpApi();
    return await api.GetListProductNeedSuportModel(
        contacted: contacted, taked: taked);
  }

  onGetListCustommerProfile({num type}) async {
    var api = HttpApi();
    return await api.GetListCustommerProfile(type: type);
  }

  onLoadGetDataProifile({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
  }

  onFindCustommerProfileByEmail({String email, int type}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileByEmail(email: email, type: type);
  }
}
