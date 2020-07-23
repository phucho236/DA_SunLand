import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class ProductAdsController {
  onLoadScreenProductAds() async {
    var api = HttpApi();
    return await api.getListNotifyProductAds();
  }

  getCustommerProfileUserPost({String document_id_custommer}) async {
    var api = HttpApi();
    return CustomerProfileModel.fromJson(await api.GetDataCustommer(
        document_id_custommer: document_id_custommer));
  }
}
