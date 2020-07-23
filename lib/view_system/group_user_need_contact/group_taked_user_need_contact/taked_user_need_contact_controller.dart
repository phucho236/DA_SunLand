import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';

class TakedUserNeedContactController {
  onLoadGetListProductNeedSuportModelContactBy(
      {bool contacted, String document_id_custommer, bool taked}) async {
    var api = HttpApi();
    String document_id_custommer = await getDocumentIdCustommer();
    return await api.GetListProductNeedSuportModel(
        contacted: contacted, taked: taked, contact_by: document_id_custommer);
  }

  onLoadGetDataProifile({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
  }

  onGetListCustommerProfile({num type}) async {
    var api = HttpApi();
    return await api.GetListCustommerProfile(type: type);
  }
}
