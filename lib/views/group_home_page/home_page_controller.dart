import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class HomePageController {
  onGetListGetListProduct(int limit) async {
    var api = HttpApi();
    List<String> listDocumentIDProduct =
        await onLoadPreviewProductScreen(limit);
    return await api.GetListProduct(
        listDocumentIDProduct: listDocumentIDProduct);
  }

  onGetProductFindByNameOrId({String name_or_id}) async {
    ProductModel Product1;
    var api = HttpApi();

    Product1 = await api.GetProductFindByName(name_apartment: name_or_id);

    return Product1;
  }

  // lấy list id các sản phẩm
  onLoadPreviewProductScreen(int limit) async {
    var api = HttpApi();
    return await api.GetListIDProductLimit(censored: true, limit: limit);
  }

  onGetListProductFilter(List<String> list_document_id_product) async {
    var api = HttpApi();
    return await api.GetListProduct(
        listDocumentIDProduct: list_document_id_product);
  }

  onGetDetailProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetDetailProduct(document_id_product: document_id_product);
  }

  onGetRealEstate({String document_id_real_estate}) async {
    var api = HttpApi();
    return await api.GetRealEstate(document_id_real_estate);
  }

  onUpdateSeenProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.UpdateSeenProduct(
      document_id_product: document_id_product,
    );
  }

  onGetListGetListItemLike({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetListItemLike(
        document_id_custommer: document_id_custommer);
  }
}
