import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_core/view_system/group_dialog_filter_search/dialog_filter_search_controller.dart';

class DialogFilterSearch extends StatefulWidget {
  @override
  _DialogFilterSearchState createState() => _DialogFilterSearchState();
}

class _DialogFilterSearchState extends State<DialogFilterSearch> {
  num lowerSliderAcreageValue = 10;
  num upperSliderAcreageValue = 1000;
  num lowerSliderPriceValue = 1000000;
  num upperSliderPriceValue = 5000000000;
  List<RealEstateModel> listRealEstate = [];
  RealEstateModel realEstate;
  DistrictModel district;
  TypeApartmentModel typeApartment;
  TypeFloorModel typeFloor;
  DialogFilterSearchController dialogFilterSearchController =
      DialogFilterSearchController();

  getListRealEstate() async {
    List<RealEstateModel> listRealEstateTmp = [];
    listRealEstateTmp =
        await dialogFilterSearchController.onLoadGetListRealEstate();
    if (listRealEstateTmp.length > 0) {
      setState(() {
        listRealEstate = listRealEstateTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListRealEstate();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text("Bộ lọc tìm kiếm"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(setWidthSize(size: 10.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: setWidthSize(size: double.infinity),
                              child: CustomPaint(
                                painter: MyPainter(
                                    radius: 60,
                                    borderWidth: 2,
                                    colorBoder: Colors.white),
                                child: Container(
                                  height: setHeightSize(size: 45),
                                  child: DropdownButtonHideUnderline(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: setWidthSize(size: 10)),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child:
                                                DropdownButton<RealEstateModel>(
                                              value: realEstate,
                                              onChanged:
                                                  (RealEstateModel value) {
                                                setState(() {
                                                  realEstate = value;
                                                });
                                              },
                                              style: styleTextContentBlack,
                                              hint: Text(
                                                'Dự án',
                                                style: styleTextHintBlack,
                                              ),
                                              icon: Icon(Icons.arrow_drop_down),
                                              items: listRealEstate.map(
                                                  (RealEstateModel realEstate) {
                                                return DropdownMenuItem<
                                                    RealEstateModel>(
                                                  value: realEstate,
                                                  child: Text(
                                                    realEstate.name_real_estate,
                                                    style:
                                                        styleTextContentBlack,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: setHeightSize(size: 10),
                            ),
                            Container(
                              width: setWidthSize(size: double.infinity),
                              child: CustomPaint(
                                painter: MyPainter(
                                    radius: 60,
                                    borderWidth: 2,
                                    colorBoder: Colors.white),
                                child: Container(
                                  height: setHeightSize(size: 45),
                                  child: DropdownButtonHideUnderline(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: setWidthSize(size: 10)),
                                      child: DropdownButton<DistrictModel>(
                                        value: district,
                                        onChanged: (DistrictModel _distict) {
                                          setState(() {
                                            district = _distict;
                                          });
                                        },
                                        //isExpanded: true,
                                        style: styleTextContentBlack,
                                        hint: Text(
                                          'Quận',
                                          style: styleTextHintBlack,
                                        ),
                                        icon: Icon(Icons.arrow_drop_down),
                                        items: listDistrictModel
                                            .map((DistrictModel distict) {
                                          return DropdownMenuItem<
                                              DistrictModel>(
                                            value: distict,
                                            child: Text(
                                              distict.name,
                                              style: styleTextContentBlack,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: setHeightSize(size: 10),
                            ),
                            Container(
                              height: setHeightSize(size: 45),
                              child: CustomPaint(
                                painter: MyPainter(
                                    radius: 60,
                                    borderWidth: 2,
                                    colorBoder: Colors.white),
                                child: Container(
                                  height: setHeightSize(size: 45),
                                  child: DropdownButtonHideUnderline(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: setWidthSize(size: 10),
                                          left: setWidthSize(size: 10)),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child:
                                                DropdownButton<TypeFloorModel>(
                                              value: typeFloor,
                                              onChanged:
                                                  (TypeFloorModel _typeFloor) {
                                                setState(() {
                                                  typeFloor = _typeFloor;
                                                });
                                              },
                                              style: styleTextContentBlack,
                                              hint: Text(
                                                'Loại tần',
                                                style: styleTextHintBlack,
                                              ),
                                              icon: Icon(Icons.arrow_drop_down),
                                              items: listTypeloorModel.map(
                                                  (TypeFloorModel typeFloor) {
                                                return DropdownMenuItem<
                                                    TypeFloorModel>(
                                                  value: typeFloor,
                                                  child: Text(
                                                    typeFloor.name,
                                                    style:
                                                        styleTextContentBlack,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: setHeightSize(size: 10),
                            ),
                            Container(
                              height: setHeightSize(size: 45),
                              child: CustomPaint(
                                painter: MyPainter(
                                    radius: 60,
                                    borderWidth: 2,
                                    colorBoder: Colors.white),
                                child: Container(
                                  height: setHeightSize(size: 45),
                                  child: DropdownButtonHideUnderline(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: setWidthSize(size: 10)),
                                      child: DropdownButton<TypeApartmentModel>(
                                        value: typeApartment,
                                        onChanged: (TypeApartmentModel
                                            _typeApartmentModel) {
                                          setState(() {
                                            typeApartment = _typeApartmentModel;
                                          });
                                        },
                                        isExpanded: true,
                                        style: styleTextContentBlack,
                                        hint: Text(
                                          'Loại căn hộ',
                                          style: styleTextHintBlack,
                                        ),
                                        icon: Icon(Icons.arrow_drop_down),
                                        items: listTypeApartmentModel.map(
                                            (TypeApartmentModel
                                                typepartmentModel) {
                                          return DropdownMenuItem<
                                              TypeApartmentModel>(
                                            value: typepartmentModel,
                                            child: Text(
                                              typepartmentModel.name,
                                              style: styleTextContentBlack,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: setHeightSize(size: 10),
                            ),
                            Text(
                              "Diện tích: ",
                              style: styleTextHintBlack,
                            ),
                            SizedBox(
                              height: setHeightSize(size: 5),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Từ: $lowerSliderAcreageValue m\u00B2",
                                    style: styleTextHintBlack,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Đến: $upperSliderAcreageValue m\u00B2",
                                    style: styleTextHintBlack,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: setHeightSize(size: 5),
                            ),
                            Container(
                              width: setWidthSize(size: 300),
                              height: setHeightSize(size: 30),
                              child: FlutterSlider(
                                tooltip: FlutterSliderTooltip(disabled: true),
                                values: [
                                  lowerSliderAcreageValue.toDouble(),
                                  upperSliderAcreageValue.toDouble()
                                ],
                                rangeSlider: true,
                                min: 10,
                                max: 1000,
                                onDragging:
                                    (handlerIndex, lowerValue, upperValue) {
                                  lowerSliderAcreageValue = lowerValue;
                                  upperSliderAcreageValue = upperValue;
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              height: setHeightSize(size: 10),
                            ),
                            Text(
                              "Giá tiền",
                              style: styleTextHintBlack,
                            ),
                            SizedBox(
                              height: setHeightSize(size: 5),
                            ),
                            Text(
                              "Từ: ${PriceFortmatMoney(value: lowerSliderPriceValue.toDouble(), symbol: true)}",
                              style: styleTextHintBlack,
                            ),
                            SizedBox(
                              height: setHeightSize(size: 5),
                            ),
                            Text(
                              "Đến: ${PriceFortmatMoney(value: upperSliderPriceValue.toDouble(), symbol: true)}",
                              style: styleTextHintBlack,
                            ),
                            Container(
                              width: setWidthSize(size: 300),
                              height: setHeightSize(size: 30),
                              child: FlutterSlider(
                                tooltip: FlutterSliderTooltip(disabled: true),
                                values: [
                                  lowerSliderPriceValue.toDouble(),
                                  upperSliderPriceValue.toDouble()
                                ],
                                rangeSlider: true,
                                min: 1000000,
                                max: 5000000000,
                                step: FlutterSliderStep(
                                    step: 1, // default
                                    isPercentRange:
                                        true, // ranges are percents, 0% to 20% and so on... . default is true
                                    rangeList: [
                                      FlutterSliderRangeStep(
                                          from: 0, to: 70, step: 1000000),
                                      FlutterSliderRangeStep(
                                          from: 70, to: 100, step: 100000000),
                                    ]),
                                onDragging:
                                    (handlerIndex, lowerValue, upperValue) {
                                  lowerSliderPriceValue = lowerValue;
                                  upperSliderPriceValue = upperValue;
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 10),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                )),
            Container(
              height: setHeightSize(size: 140),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/background_dialog_1.png"),
              )),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text("Đóng")),
        FlatButton(
          onPressed: () async {
            List<String> document_id_productTmp =
                await dialogFilterSearchController.onSubmitOke(
              type_floor: typeFloor == null ? null : typeFloor.name,
              start_acreage_apartment: lowerSliderAcreageValue,
              star_price: lowerSliderPriceValue,
              end_price: upperSliderPriceValue,
              end_acreage_apartment: upperSliderAcreageValue,
              district: district == null ? null : district.name,
              document_id_real_estate:
                  realEstate == null ? null : realEstate.document_id_estate,
              type_apartment: typeApartment == null ? null : typeApartment.name,
            );
            if (document_id_productTmp != null) {
              Navigator.pop(context, document_id_productTmp);
            }
          },
          child: (Text("Đồng ý")),
        ),
      ],
    );
  }
}
