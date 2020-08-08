import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_add_new_real_estate/dialog_add_real_estate.dart';
import 'package:flutter_core/view_system/group_edit_product/edit_product_controller.dart';
import 'package:flutter_core/view_system/group_product/post_product_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_images_brain/images_brain.dart';
import 'package:flutter_core/widgets/build_icon-infrastructure.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';

class EditDetailProductScreen extends StatefulWidget {
  static String id = "EditDetailProductScreen";
  EditDetailProductScreen(
      {this.detailProductModel,
      this.productModel,
      this.realEstateModel,
      this.permisstion_add_project = false});
  final DetailProductModel detailProductModel;
  final ProductModel productModel;
  final RealEstateModel realEstateModel;
  final bool permisstion_add_project;
  @override
  _EditDetailProductScreenState createState() =>
      _EditDetailProductScreenState();
}

class _EditDetailProductScreenState extends State<EditDetailProductScreen> {
  //phần để gửi đi
  List<String> listImages = [];
  String name_apartment;
  DistrictModel district;
  TypeFloorModel typeFloor;
  String document_id_custommer;
  num price;
  num acreageApartment;
  int amountBathrooms;
  int amountBedroom;
  RealEstateModel realEstate;
  TypeApartmentModel typeApartment;
  CostModel cost = CostModel();
  EditDetailProductScreen args;
  // phần sử dụng
  TextEditingController textEditingControllerPrice = TextEditingController();

  ImagesBrain imagesBrain = ImagesBrain();
  List<RealEstateModel> listRealEstate = [];
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 20.0;
  PostProductController postProductController = PostProductController();
  EditProductController editProductController = EditProductController();
  List<ItemsIcon> listItemInfrastructure = dataItemsIcons;
  List<ItemsIcon> getListItemInfrastructure() {
    List<ItemsIcon> _listItemInfrastructure = [];
    for (var item in listItemInfrastructure) {
      if (item.is_choos == true) {
        _listItemInfrastructure.add(item);
      }
    }
    if (_listItemInfrastructure.length > 0) {
      return _listItemInfrastructure;
    }
  }

  getListDataItemsIcons(args) {
    List<ItemsIcon> listDataItemIconTmp = [];
    bool isEqual = false;
    for (var item in listItemInfrastructure) {
      for (var item1 in args.detailProductModel.list_item_infrastructure) {
        if (item.id_icon == item1.id_icon) {
          item.is_choos = true;
          listDataItemIconTmp.add(item);
          isEqual = true;
          break;
        }
      }
      if (isEqual == false) {
        item.is_choos = false;
        listDataItemIconTmp.add(item);
      }
      isEqual = false;
    }
    setState(() {});
  }

  getDataLocar(args) async {
    document_id_custommer = await getDocumentIdCustommer();
    listImages = args.detailProductModel.list_images;
    setState(() {});
  }

  upLoadImages({File images}) async {
    return await editProductController.onSubmitCropPostImages(images: images);
  }

  getListRealEstate() async {
    List<RealEstateModel> listRealEstateTmp = [];
    listRealEstateTmp =
        await postProductController.onLoadPostProductScreenGetListRealEstate();

    if (listRealEstateTmp != null) {
      setState(() {
        listRealEstate = listRealEstateTmp;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });

      getDataLocar(args);
      getListDataItemsIcons(args);
      getListRealEstate();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditDetailProductScreen args1 = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: colorBackgroundPostProduct,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Sửa sản phẩm",
          style: styleTextTitleInAppWhite,
        ),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Hình ảnh",
                    style: styleTextTitleInBodyBlack,
                  ),
                  SizedBox(
                    height: setHeightSize(size: 170),
                    child: args1.detailProductModel.list_images.length > 0
                        ? buildListViewScrollDerectionVertiocal()
                        : buildListViewScrollDerectionVertiocalSample(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Thông tin căn hộ",
                    style: styleTextTitleInBodyBlack,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(setWidthSize(size: 10.0)),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: setHeightSize(size: 5),
                          ),
                          TextFieldBorder(
                            hintText: args1.productModel.name_apartment,
                            colorTextWhite: false,
                            onChanged: (value) {
                              name_apartment = value;
                            },
                          ),
                          SizedBox(
                            height: setHeightSize(size: 15),
                          ),
                          TextFieldBorder(
                            controller: textEditingControllerPrice,
                            isTextInputMoney: true,
                            hintText: args1.productModel.price.toString(),
                            onChanged: (value) {
                              price = value;
                            },
                            typeInputIsNumber: true,
                            colorTextWhite: false,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 15),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
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
                                            left: setWidthSize(size: 10)),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: DropdownButton<
                                                  RealEstateModel>(
                                                value: realEstate,
                                                onChanged:
                                                    (RealEstateModel value) {
                                                  setState(() {
                                                    realEstate = value;
                                                  });
                                                },
                                                style: styleTextContentBlack,
                                                hint: Text(
                                                  args1.realEstateModel
                                                      .name_real_estate,
                                                  style: styleTextHintBlack,
                                                ),
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                items: listRealEstate.map(
                                                    (RealEstateModel
                                                        realEstate) {
                                                  return DropdownMenuItem<
                                                      RealEstateModel>(
                                                    value: realEstate,
                                                    child: Text(
                                                      realEstate
                                                          .name_real_estate,
                                                      style:
                                                          styleTextContentBlack,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            args1.permisstion_add_project
                                                ? IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DialogAddRealEstateScreen(
                                                              document_id_custommer:
                                                                  document_id_custommer);
                                                        },
                                                      ).then((value) {
                                                        if (value == true) {
                                                          getListRealEstate();
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDiaLogScreen(
                                                                title:
                                                                    "Thông báo",
                                                                message:
                                                                    "Thêm thành công",
                                                              );
                                                            },
                                                          );
                                                        }
                                                        if (value == false) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDiaLogScreen(
                                                                title:
                                                                    "Thông báo",
                                                                message:
                                                                    "Thêm thất bại",
                                                              );
                                                            },
                                                          );
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        Icon(Icons.add_circle))
                                                : Container(
                                                    width:
                                                        setWidthSize(size: 10),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: setWidthSize(size: 10),
                              ),
                              Expanded(
                                flex: 1,
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
                                            right: setWidthSize(size: 5),
                                            left: setWidthSize(size: 10)),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: DropdownButton<
                                                  TypeFloorModel>(
                                                value: typeFloor,
                                                onChanged: (TypeFloorModel
                                                    _typeFloor) {
                                                  setState(() {
                                                    typeFloor = _typeFloor;
                                                  });
                                                },
                                                style: styleTextContentBlack,
                                                hint: Text(
                                                  args1.detailProductModel
                                                      .type_floor,
                                                  style: styleTextHintBlack,
                                                ),
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
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
                            ],
                          ),
                          SizedBox(
                            height: setHeightSize(size: 15),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
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
                                            args1.productModel.district,
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
                                width: setWidthSize(size: 10),
                              ),
                              Expanded(
                                flex: 1,
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
                                        child:
                                            DropdownButton<TypeApartmentModel>(
                                          value: typeApartment,
                                          onChanged: (TypeApartmentModel
                                              _typeApartmentModel) {
                                            setState(() {
                                              typeApartment =
                                                  _typeApartmentModel;
                                            });
                                          },
                                          isExpanded: true,
                                          style: styleTextContentBlack,
                                          hint: Text(
                                            args1.detailProductModel
                                                .type_apartment,
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
                            ],
                          ),
                          SizedBox(
                            height: setHeightSize(size: 15),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    num _returnvalue;
                                    _returnvalue =
                                        await showIntDialogPickNumberDouble(
                                            acreageApartmentOutOf: args1
                                                .productModel.acreage_apartment,
                                            title: "Chọn diện tích");
                                    if (_returnvalue != null) {
                                      setState(() {
                                        acreageApartment = _returnvalue;
                                      });
                                    }
                                  },
                                  child: CustomPaint(
                                    painter: MyPainter(
                                        radius: 60,
                                        borderWidth: 2,
                                        colorBoder: Colors.white),
                                    child: Container(
                                      height: setHeightSize(size: 45),
                                      child: Center(
                                        child: acreageApartment == null ||
                                                acreageApartment == 0.0
                                            ? Text(
                                                "${args1.productModel.acreage_apartment.toString()}m\u00B2",
                                                style: styleTextHintBlack,
                                              )
                                            : Text(
                                                "${acreageApartment.toString()}m\u00B2",
                                                style: styleTextContentBlack,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: setWidthSize(size: 10),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    int _returnvalue;
                                    _returnvalue =
                                        await showIntDialogPickNumberInt(
                                            valueOutOf: args1
                                                .productModel.amount_bedroom,
                                            title: "Số phòng ngủ");
                                    if (_returnvalue != null) {
                                      setState(() {
                                        amountBedroom = _returnvalue;
                                      });
                                    }
                                  },
                                  child: CustomPaint(
                                    painter: MyPainter(
                                        radius: 60,
                                        borderWidth: 2,
                                        colorBoder: Colors.white),
                                    child: Container(
                                      height: setHeightSize(size: 45),
                                      child: Center(
                                        child: amountBedroom == null
                                            ? Text(
                                                args1
                                                    .productModel.amount_bedroom
                                                    .toString(),
                                                style: styleTextHintBlack,
                                              )
                                            : Text(
                                                amountBedroom.toString(),
                                                style: styleTextContentBlack,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: setWidthSize(size: 10),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    int _returnvalue;
                                    _returnvalue =
                                        await showIntDialogPickNumberInt(
                                            valueOutOf: args1.detailProductModel
                                                .amount_bathrooms,
                                            title: "Số phòng tắm");
                                    if (_returnvalue != null) {
                                      setState(() {
                                        amountBathrooms = _returnvalue;
                                      });
                                    }
                                  },
                                  child: CustomPaint(
                                    painter: MyPainter(
                                        radius: 60,
                                        borderWidth: 2,
                                        colorBoder: Colors.white),
                                    child: Container(
                                      height: setHeightSize(size: 45),
                                      child: Center(
                                        child: amountBathrooms == null
                                            ? Text(
                                                args1.detailProductModel
                                                    .amount_bathrooms
                                                    .toString(),
                                                style: styleTextHintBlack,
                                              )
                                            : Text(
                                                amountBathrooms.toString(),
                                                style: styleTextContentBlack,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: setHeightSize(size: 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Các khoảng phí",
                        style: styleTextTitleInBodyBlack,
                      ),
                      Text(
                        "(để trống nếu miễn phí )",
                        style: styleTextHintBlack,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(setWidthSize(size: 10.0)),
                      child: Column(
                        children: <Widget>[
                          TextFieldBorder(
                            onChanged: (value) {
                              cost.management_cost = value;
                            },
                            hintText: args1.detailProductModel.cost
                                        .management_cost ==
                                    null
                                ? "Miễn phí"
                                : args1.detailProductModel.cost.management_cost,
                            typeInputIsNumber: true,
                            colorTextWhite: false,
                            isTextInputMoney: true,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 10),
                          ),
                          TextFieldBorder(
                            onChanged: (value) {
                              cost.motorbike_parking_cost = value;
                            },
                            hintText: args1.detailProductModel.cost
                                        .motorbike_parking_cost ==
                                    null
                                ? "Miễn phí"
                                : args1.detailProductModel.cost
                                    .motorbike_parking_cost,
                            typeInputIsNumber: true,
                            isTextInputMoney: true,
                            colorTextWhite: false,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 10),
                          ),
                          TextFieldBorder(
                            onChanged: (value) {
                              cost.car_parking_cost = value;
                            },
                            hintText: args1.detailProductModel.cost
                                        .car_parking_cost ==
                                    null
                                ? "Miễn phí"
                                : args1
                                    .detailProductModel.cost.car_parking_cost,
                            isTextInputMoney: true,
                            typeInputIsNumber: true,
                            colorTextWhite: false,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 10),
                          ),
                          TextFieldBorder(
                            onChanged: (value) {
                              cost.gym_cost = value;
                            },
                            hintText:
                                args1.detailProductModel.cost.gym_cost == null
                                    ? "Miễn phí"
                                    : args1.detailProductModel.cost.gym_cost,
                            isTextInputMoney: true,
                            typeInputIsNumber: true,
                            colorTextWhite: false,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 10),
                          ),
                          TextFieldBorder(
                            onChanged: (value) {
                              cost.swimming_pool_cost = value;
                            },
                            hintText: args1.detailProductModel.cost
                                        .swimming_pool_cost ==
                                    null
                                ? "Miễn phí"
                                : args1
                                    .detailProductModel.cost.swimming_pool_cost,
                            typeInputIsNumber: true,
                            isTextInputMoney: true,
                            colorTextWhite: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  Text(
                    "Tiện ích",
                    style: styleTextTitleInBodyBlack,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.5),
                          blurRadius:
                              3, // has the effect of softening the shadow
                          spreadRadius:
                              0.1, // has the effect of extending the shadow
                          offset: Offset(
                            1.5, // horizontal, move right 10
                            1.5, // vertical, move down 10
                          ),
                        )
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: SizedBox(
                        height: setHeightSize(size: 300),
                        child: GridView.builder(
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this produces 2 rows.

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: cardWidth / cardHeight),
                          itemCount: listItemInfrastructure.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(listItemInfrastructure[index].is_choos);
                            return buildIconInfrastructure(
                              onTap: () {
                                setState(() {
                                  listItemInfrastructure[index].is_choos =
                                      !listItemInfrastructure[index].is_choos;
                                });
                              },
                              icon: itemsIcon[
                                  listItemInfrastructure[index].id_icon],
                              title: listItemInfrastructure[index].name_icon,
                              isChoos: listItemInfrastructure[index].is_choos,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              child: StreamBuilder(
                stream: editProductController.errStream,
                builder: (context, snapshot) => Text(
                  snapshot.hasError ? snapshot.error : '',
                  style: styleTextErrorBlack,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: setWidthSize(size: 20),
              ),
              Container(
                width: setWidthSize(size: 200),
                child: ButtonNormal(
                  text: 'XÉT DUYỆT',
                  onTap: () async {
                    List<ItemsIcon> ItemIconTmp =
                        await getListItemInfrastructure();
                    await editProductController
                        .onSubmitEditProduct(
                            document_id_detail_product: args1
                                .detailProductModel.document_id_detail_product,
                            document_id_product:
                                args1.productModel.ducument_id_product,
                            document_id_custommer: document_id_custommer,
                            nameApartment: name_apartment == null
                                ? null
                                : name_apartment.trim() == ""
                                    ? null
                                    : name_apartment.trim(),
                            price: price,
                            realEstate: realEstate,
                            typeFloor: typeFloor,
                            district: district,
                            typeApartment: typeApartment,
                            acreageApartment: acreageApartment,
                            amountBathrooms: amountBathrooms,
                            amountBedroom: amountBedroom,
                            listImages: listImages,
                            listItemInfrastructure: ItemIconTmp,
                            cost: cost == null ? null : cost)
                        .then((value) {
                      if (value == true) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDiaLogScreen(
                              title: "Thông báo",
                              message: "Sửa sản phẩm thành công.",
                            );
                          },
                        ).then((value) {
                          Navigator.pop(context, true);
                        });
                      } else {
                        Navigator.pop(context, false);
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDiaLogScreen(
                              title: "Thông báo",
                              message: "Lỗi !. Sửa sản phẩm không thành công.",
                            );
                          },
                        );
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: setWidthSize(size: 5),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          File _images;
          _images = await imagesBrain.cropImageUseProDuct(await imagesBrain
              .getImageCameraNoCrop(source_picker: ImageSource.gallery));
          listImages.add(await upLoadImages(images: _images));
          setState(() {});
        },
        child: Icon(Icons.image),
      ),
    );
  }

  Future<double> showIntDialogPickNumberDouble(
      {String title, num acreageApartmentOutOf}) async {
    num _value = null;
    await showDialog<num>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.decimal(
          confirmWidget: Text(
            "XÁC NHẬN",
            style: styleTextContentBlack,
          ),
          cancelWidget: Text(
            "ĐÓNG",
            style: styleTextContentBlack,
          ),
          title: Text(
            title,
            style: styleTextTitleInAppBarBlack,
          ),
          minValue: 1,
          maxValue: 500,
          initialDoubleValue:
              acreageApartmentOutOf == null ? 1.0 : acreageApartmentOutOf,
        );
      },
    ).then((num value) {
      if (value != null) {
        _value = value;
      }
    });
    return _value;
  }

  Future<int> showIntDialogPickNumberInt({String title, int valueOutOf}) async {
    int _value = null;
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          confirmWidget: Text(
            "XÁC NHẬN",
            style: styleTextContentBlack,
          ),
          cancelWidget: Text(
            "ĐÓNG",
            style: styleTextContentBlack,
          ),
          title: Text(
            title,
            style: styleTextTitleInAppBarBlack,
          ),
          minValue: 1,
          maxValue: 50,
          infiniteLoop: true,
          highlightSelectedValue: true,
          initialIntegerValue: valueOutOf == null ? 1 : valueOutOf,
        );
      },
    ).then((int value) {
      if (value != null) {
        _value = value;
      }
    });
    return _value;
  }

  Widget buildListViewScrollDerectionVertiocalSample() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 5)),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: setWidthSize(size: 200),
          margin: EdgeInsets.symmetric(
            horizontal: setWidthSize(size: 5),
          ),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/images/library_image.png",
              color: Colors.black,
              //height: 10,
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
    );
  }

  Widget buildListViewScrollDerectionVertiocal() {
    return ListView.builder(
      itemCount: listImages.length,
      itemBuilder: (context, index) {
        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                listImages.removeAt(index);
              });
            },
            direction: DismissDirection.vertical,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: setWidthSize(size: 5),
                            horizontal: setWidthSize(size: 5)),
                        decoration: new BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(listImages[index])),
                          color: Colors.white,
                          // border color
                          border: Border.all(color: Colors.orange, width: 1.5),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius:
                                  3, // has the effect of softening the shadow
                              spreadRadius:
                                  0.1, // has the effect of extending the shadow
                              offset: Offset(
                                1.5, // horizontal, move right 10
                                1.5, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Opacity(
                          // này hơi cùi nhưng dùng để lấy được kích thước của widget để vẽ lại có bo góc
                          opacity: 0.0,
                          //maintainInteractivity: true,
                          child: Container(
                              //margin: EdgeInsets.all(20),
                              child: Image.network(listImages[index])),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          listImages.removeAt(index);
                        });
                      },
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
      scrollDirection: Axis.horizontal,
    );
  }
}
