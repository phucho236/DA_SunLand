import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';
import 'package:flutter_core/helpers/validators.dart';

class EditProductController {
  Validators validators = new Validators();
  StreamController _errController = new StreamController();
  Stream get errStream => _errController.stream;
  onGetListGetListProduct() async {
    var api = HttpApi();

    return await api.GetListAllProduct();
  }

  onLoadPostProductScreenGetListRealEstate() async {
    var api = HttpApi();
    return await api.GetListRealEstate();
  }

  onGetListProductFilter(List<String> list_document_id_product) async {
    var api = HttpApi();
    return await api.GetListProduct(
        listDocumentIDProduct: list_document_id_product);
  }

  onGetProductFindByNameOrId({String name_or_id}) async {
    ProductModel Product = ProductModel();
    var api = HttpApi();
    Product = await api.GetProductFindByID(document_id_product: name_or_id);
    if (Product != null) {
      Product = await api.GetProductFindByName(name_apartment: name_or_id);
    }
    return Product;
  }

  onGetDetailProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetDetailProduct(document_id_product: document_id_product);
  }

  onGetRealEstate({String document_id_real_estate}) async {
    var api = HttpApi();
    return await api.GetRealEstate(document_id_real_estate);
  }

  onSubmitCropPostImages({File images}) async {
    var api = HttpApi();
    return await api.uploadImages(
        images: images, PathDatabase: PathDatabase.Images_Product);
  }

  onSubmitEditProduct({
    @required String document_id_detail_product,
    @required String document_id_product,
    @required String document_id_custommer,
    @required String nameApartment,
    @required num price,
    @required RealEstateModel realEstate,
    @required TypeFloorModel typeFloor,
    @required DistrictModel district,
    @required TypeApartmentModel typeApartment,
    @required num acreageApartment,
    @required int amountBathrooms,
    @required int amountBedroom,
    @required List<String> listImages,
    @required List<ItemsIcon> listItemInfrastructure,
    @required CostModel cost,
  }) async {
    int countError = 0;
    _errController.sink.add('Ok');

    if (listImages.length < 5) {
      _errController.sink.addError('bạn phải chọn thiểu 5 hình ảnh');
      countError++;
    }

    print(countError);
    if (countError == 0) {
      bool _result = false;
      var api = HttpApi();
      await api.UpdateProduct(
        document_id_product: document_id_product,
        name_apartment: nameApartment,
        district: district == null ? null : district.name,
        price: price,
        acreage_apartment: acreageApartment,
        amount_bedroom: amountBedroom,
        url_images_avatar_product: listImages[0],
      ).then((value) async {
        print(value);
        if (value == true) {
          _result = await api.UpdateDetailProduct(
              censored: false,
              document_id_real_estate:
                  realEstate == null ? null : realEstate.document_id_estate,
              cost: cost == null ? null : cost,
              amount_bathrooms: amountBedroom,
              document_id_detail_product: document_id_detail_product,
              last_edit_by: document_id_custommer,
              list_images: listImages,
              list_item_infrastructure: listItemInfrastructure,
              type_apartment: typeApartment == null ? null : typeApartment.name,
              type_floor: typeFloor == null ? null : typeFloor.name);
        }
      });

      return _result;
    }
  }
}
