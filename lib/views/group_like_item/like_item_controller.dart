import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class LikeItemController {
  onGetListGetListProduct({List<String> list_item_like}) async {
    var api = HttpApi();
    return await api.GetListProduct(listDocumentIDProduct: list_item_like);
  }

  onGetListGetListItemLike({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetListItemLike(
        document_id_custommer: document_id_custommer);
  }

  onGetRealEstate({String document_id_real_estate}) async {
    var api = HttpApi();
    return await api.GetRealEstate(document_id_real_estate);
  }

  onGetDetailProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetDetailProduct(document_id_product: document_id_product);
  }

  onUpdateSeenProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.UpdateSeenProduct(
      document_id_product: document_id_product,
    );
  }

  Future<bool> onSubmitNeedContact(
      {String document_id_custommer_need_contact,
      List<String> list_document_id_product}) async {
    var api = HttpApi();
    return await api.PostProductNeedSuport(
        document_id_custommer_need_contact: document_id_custommer_need_contact,
        list_document_id_product: list_document_id_product);
  }

  onLoadGetListProductSentRequested({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetListProductSentRequested(
        document_id_custommer: document_id_custommer);
  }
}
