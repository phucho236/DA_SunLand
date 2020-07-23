import 'dart:async';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/helpers/validators.dart';

class PostProductAdsController {
  onGetListGetListProduct({List<String> list_product}) async {
    var api = HttpApi();
    return await api.GetListProduct(listDocumentIDProduct: list_product);
  }

  onGetListGetListItemLike({String document_id_custommer}) async {
    var api = HttpApi();
    return await api.GetListItemLike(
        document_id_custommer: document_id_custommer);
  }

  onLoadGetListProductCensored() async {
    var api = HttpApi();
    return await api.GetListIDProduct(censored: true);
  }

  onGetDetailProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetDetailProduct(document_id_product: document_id_product);
  }

  onGetRealEstate({String document_id_real_estate}) async {
    var api = HttpApi();
    return await api.GetRealEstate(document_id_real_estate);
  }

  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  Validators validators = new Validators();
  Future<bool> onPostNotifyProductAds(
      {String document_id_custommer,
      String content,
      String title,
      List<String> list_document_id_product}) async {
    int countError = 0;
    _errController.sink.add('Ok');
    if (!validators.checkName(title)) {
      _errController.sink.addError('Vui lòng kiểm tra tên gợi ý.');
      countError++;
    } else {
      if (!validators.checkName(content)) {
        _errController.sink.addError('Vui lòng kiểm tra nội dung gợi ý.');
        countError++;
      } else {
        if (list_document_id_product.length < 1) {
          _errController.sink.addError('Phải chọn một số sản phẩm.');
          countError++;
        }
      }
    }
    if (countError == 0) {
      var api = HttpApi();
      return await api.PostNotifyProductAds(
          document_id_custommer: document_id_custommer,
          content: content,
          title: title,
          list_document_id_product: list_document_id_product);
    }
  }

  onGetListProductFilter(List<String> list_document_id_product) async {
    var api = HttpApi();
    return await api.GetListProduct(
        listDocumentIDProduct: list_document_id_product);
  }
}
