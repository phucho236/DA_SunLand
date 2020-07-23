import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class ProductCensorshipController {
  // lấy các sản phẩm cần duyệt bằng list id
  onGetListGetListProductNeedApproval() async {
    var api = HttpApi();
    List<String> listDocumentIDProduct = await onLoadPreviewProductScreen();
    return await api.GetListProduct(
        listDocumentIDProduct: listDocumentIDProduct);
  }

  // lấy list id các sản phẩm cần duyệt
  onLoadPreviewProductScreen() async {
    var api = HttpApi();
    return await api.GetListIDProduct();
  }

  onGetRealEstate({String document_id_real_estate}) async {
    var api = HttpApi();
    return await api.GetRealEstate(document_id_real_estate);
  }

  onBrowseProduct(
      {String document_id_custommer, String document_id_product}) async {
    var api = HttpApi();
    return await api.BrowseProduct(
        document_id_product: document_id_product,
        document_id_custommer: document_id_custommer);
  }

  onGetDetailProductNeedApproval({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetDetailProduct(document_id_product: document_id_product);
  }
}
