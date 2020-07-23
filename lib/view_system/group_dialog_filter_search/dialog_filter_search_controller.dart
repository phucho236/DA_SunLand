import 'package:flutter_core/api/api_http.dart';

class DialogFilterSearchController {
  onLoadGetListRealEstate() async {
    var api = HttpApi();
    return await api.GetListRealEstate();
  }

  onSubmitOke({
    String district,
    num star_price,
    num end_price,
    String document_id_real_estate,
    String type_apartment,
    String type_floor,
    num start_acreage_apartment,
    num end_acreage_apartment,
  }) async {
    var api = HttpApi();
    return api.FilterFindProduct(
        type_apartment: type_apartment,
        document_id_real_estate: document_id_real_estate,
        district: district,
        end_acreage_apartment: end_acreage_apartment,
        end_price: end_price,
        star_price: star_price,
        start_acreage_apartment: start_acreage_apartment,
        type_floor: type_floor);
  }
}
