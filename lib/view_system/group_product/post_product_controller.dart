import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';
import 'package:flutter_core/helpers/validators.dart';

class PostProductController {
  StreamController _errController = new StreamController();
  StreamController _nameApartmentController = new StreamController();
  StreamController _districtController = new StreamController();
  StreamController _typeFloorController = new StreamController();
  StreamController _priceController = new StreamController();
  StreamController _acreageApartmentController = new StreamController();
  StreamController _amountBathroomsController = new StreamController();
  StreamController _amountBedroomController = new StreamController();
  StreamController _realEstateController = new StreamController();
  StreamController _typeApartmentController = new StreamController();

  Stream get errStream => _errController.stream;
  Stream get nameApartment => _nameApartmentController.stream;
  Stream get districtStream => _districtController.stream;
  Stream get typeFloorStream => _typeFloorController.stream;
  Stream get priceStream => _priceController.stream;
  Stream get acreageApartmentStream => _acreageApartmentController.stream;
  Stream get amountBathroomsStream => _amountBathroomsController.stream;
  Stream get amountBedroomStream => _amountBedroomController.stream;
  Stream get realEstateStream => _realEstateController.stream;
  Stream get typeApartmentStream => _typeApartmentController.stream;

  Validators validators = new Validators();

  Future<dynamic> onSubmitPostProduct({
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
    @required List<File> listImages,
    @required List<ItemsIcon> listItemInfrastructure,
    @required CostModel cost,
  }) async {
    int countError = 0;
    _errController.sink.add('Ok');
    _nameApartmentController.sink.add('Ok');
    _districtController.sink.add('Ok');
    _typeFloorController.sink.add('Ok');
    _priceController.sink.add('Ok');
    _acreageApartmentController.sink.add('Ok');
    _amountBathroomsController.sink.add('Ok');
    _amountBedroomController.sink.add('Ok');
    _realEstateController.sink.add('Ok');
    _typeApartmentController.sink.add('Ok');

    if (!validators.checkName(nameApartment)) {
      _errController.sink.addError('Bạn phải nhập tên căn hộ.');
      countError++;
    } else {
      if (!validators.isNumber(price)) {
        _errController.sink.addError('Vui lòng kiểm tra giá tiền.');
        countError++;
      }
    }

    if (realEstate == null) {
      _errController.sink.addError('Bạn phải chọn dự án');
      countError++;
    } else {
      if (!validators.checkName(realEstate.name_real_estate)) {
        _errController.sink.addError('Bạn phải chọn dự án');
        countError++;
      }
    }
    if (typeFloor == null) {
      _errController.sink.addError('Bạn phải chọn loại tần');
      countError++;
    } else {
      if (!validators.checkName(typeFloor.name)) {
        _errController.sink.addError('Bạn phải chọn loại tần');
        countError++;
      }
    }
    if (district == null) {
      _errController.sink.addError('Bạn phải chọn quận');
      countError++;
    } else {
      if (!validators.checkLengPass(district.name)) {
        _errController.sink.addError('Bạn phải chọn quận');
        countError++;
      }
    }
    if (typeApartment == null) {
      _errController.sink.addError('Bạn phải chọn loại căn hộ');
      countError++;
    } else {
      if (!validators.checkName(typeApartment.name)) {
        _errController.sink.addError('Bạn phải chọn loại căn hộ');
        countError++;
      }
    }
    if (acreageApartment == null) {
      _errController.sink.addError('Bạn phải chọn diện tích.');
      countError++;
    } else {
      if (!validators.isNumber(acreageApartment)) {
        _errController.sink.addError('Bạn phải chọn diện tích.');
        countError++;
      }
    }
    if (listImages.length < 1) {
      _errController.sink.addError('bạn phải chọn tối đa 5 hình ảnh');
      countError++;
    }
    if (amountBedroom == null) {
      _errController.sink.addError('Bạn phải chọn số lượng phòng ngủ.');
      countError++;
    } else {
      if (!validators.isNumber(amountBedroom)) {
        _errController.sink.addError('Bạn phải chọn số lượng phòng ngủ.');
        countError++;
      }
    }
    if (amountBathrooms == null) {
      _errController.sink.addError('Bạn phải chọn số lượng phòng tắm.');
      countError++;
    } else {
      if (!validators.isNumber(amountBathrooms)) {
        _errController.sink.addError('Bạn phải chọn số lượng phòng tắm.');
        countError++;
      }
    }

    if (listItemInfrastructure == null) {
      _errController.sink.addError('Bạn phải chọn một số tiện ích.');
    } else {
      if (listItemInfrastructure.length < 5) {
        _errController.sink.addError('Số lượng tiện ích phải lớn hơn 5.');
      }
    }

    print(countError);
    if (countError == 0) {
      List<String> _listUrlImages = [];
      _listUrlImages = await PostListImages(listImages);
      if (_listUrlImages != null) {
        String _document_id_product;
        bool _result = false;
        var api = HttpApi();
        _document_id_product = await api.CreatProduct(
          urlImagesAvataProduct: _listUrlImages[0],
          nameApartment: nameApartment,
          price: price,
          district: district,
          acreageApartment: acreageApartment,
          amountBedroom: amountBedroom,
        );
        if (_document_id_product != null) {
          _result = await api.CreatDetailProduct(
              document_id_product: _document_id_product,
              document_id_custommer: document_id_custommer,
              realEstate: realEstate,
              typeFloor: typeFloor,
              typeApartment: typeApartment,
              amountBathrooms: amountBathrooms,
              listUrlImages: _listUrlImages,
              listItemInfrastructure: listItemInfrastructure,
              cost: cost);
        }

        return _result;
      }
    } else {
      return 0;
    }
  }

  onLoadPostProductScreenGetListRealEstate() async {
    var api = HttpApi();
    return await api.GetListRealEstate();
  }

  PostListImages(List<File> _listImages) async {
    var api = HttpApi();
    String linkImages;
    List<String> listUrlImages = [];
    if (_listImages.length > 0) {
      for (var item in _listImages) {
        linkImages = await api.uploadImages(
            PathDatabase: PathDatabase.Images_Product, images: item);
        if (linkImages != null) {
          listUrlImages.add(linkImages);
        }
      }
    }
    return listUrlImages;
  }
}
