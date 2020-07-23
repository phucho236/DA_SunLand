import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class NoteController {
  onLoadGetListNote({String document_id_product_need_support}) async {
    var api = HttpApi();
    return await api.GetListNotedProductNeedSuport(
        document_id_product_need_support: document_id_product_need_support);
  }

  onLoadGetDataProifile({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
  }
}
