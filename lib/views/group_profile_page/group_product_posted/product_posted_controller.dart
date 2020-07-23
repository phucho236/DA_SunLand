import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class ProductPostedController {
  onLoadGetListDetailProductPostByUser({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetListDetailProductPostByUser(
        document_id_custommer: document_id_custommer);
  }

  onGetRealEstate({String document_id_real_estate}) async {
    var api = HttpApi();
    return await api.GetRealEstate(document_id_real_estate);
  }

  onLoadGetProduct({List<DetailProductModel> listDetailProductModel}) async {
    List<ProductModel> listProductModel = [];
    ProductModel productModel = ProductModel();
    var api = HttpApi();
    for (var item in listDetailProductModel) {
      productModel = await api.GetProductFindByID(
          document_id_product: item.document_id_product);
      if (productModel != null) {
        listProductModel.add(productModel);
      }
      productModel = null;
    }
    return listProductModel;
  }
}
