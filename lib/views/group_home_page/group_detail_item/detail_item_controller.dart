import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class DetailItemController {
  onSubmitUpdateLikeProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.UpdateLikeProduct(
      document_id_product: document_id_product,
    );
  }

  onSubmitLike(
      {String document_id_product, String document_id_custommer}) async {
    var api = HttpApi();
    return await api.AddLikeProductInCustommer(
        document_id_product: document_id_product,
        document_id_custommer: document_id_custommer);
  }

  onSubmitUnlike(
      {String document_id_product, String document_id_custommer}) async {
    var api = HttpApi();
    return await api.RemoveLikeProductInCustommer(
        document_id_product: document_id_product,
        document_id_custommer: document_id_custommer);
  }

  getCustommerProfileUserPost({String document_id_custommer}) async {
    var api = HttpApi();
    return CustomerProfileModel.fromJson(await api.GetDataCustommer(
        document_id_custommer: document_id_custommer));
  }
}
