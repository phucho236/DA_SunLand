import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_add_new_real_estate/dialog_add_real_estate.dart';
import 'package:flutter_core/view_system/group_preview_product/preview_product_screen.dart';
import 'package:flutter_core/view_system/group_product/post_product_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/views/group_images_brain/images_brain.dart';
import 'package:flutter_core/widgets/build_icon-infrastructure.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:numberpicker/numberpicker.dart';

class PostProductScreen extends StatefulWidget {
  static String id = "PostProductScreen";
  PostProductScreen({this.permisstion_post_project});
  final bool permisstion_post_project;
  @override
  _PostProductScreenState createState() => _PostProductScreenState();
}

class _PostProductScreenState extends State<PostProductScreen> {
  //phần để gửi đi
  bool isLoading = false;
  List<File> listImages = [];
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
  List<ItemsIcon> listItemInfrastructure = [];
  List<ItemsIcon> dataItemsIconsUse = dataItemsIcons;

  // phần sử dụng
  TextEditingController textEditingControllerPrice = TextEditingController();
  ImagesBrain imagesBrain = ImagesBrain();
  List<RealEstateModel> listRealEstate = [];
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 20.0;
  PostProductController postProductController = PostProductController();

  void getDataLocar() async {
    cost.swimming_pool_cost = null;
    cost.gym_cost = null;
    cost.car_parking_cost = null;
    cost.motorbike_parking_cost = null;
    cost.management_cost = null;
    document_id_custommer = await getDocumentIdCustommer();
    setState(() {});
  }

  getListRealEstate() async {
    List<RealEstateModel> listRealEstateTmp = [];
    listRealEstateTmp =
        await postProductController.onLoadPostProductScreenGetListRealEstate();
    if (listRealEstateTmp.length > 0) {
      setState(() {
        listRealEstate = listRealEstateTmp;
      });
    }
  }

  // gọi thằng này để get cái link cần post thôi
  List<ItemsIcon> getListItemInfrastructure() {
    List<ItemsIcon> _listItemInfrastructure = [];
    for (var item in dataItemsIconsUse) {
      if (item.is_choos == true) {
        _listItemInfrastructure.add(item);
      }
    }
    if (_listItemInfrastructure.length > 0) {
      return _listItemInfrastructure;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var item in dataItemsIconsUse) {
      item.is_choos = false;
    }
    getDataLocar();
    getListRealEstate();
  }

  @override
  Widget build(BuildContext context) {
    PostProductScreen args = ModalRoute.of(context).settings.arguments;
    return isLoading
        ? Scaffold(
            body: Column(
              children: <Widget>[
                Text("Đang xử lí. \n Vui lòng đợi..."),
                Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
                )
              ],
            ),
          )
        : Scaffold(
            backgroundColor: colorBackgroundPostProduct,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: colorAppbar,
              title: Text(
                "Thêm sản phẩm",
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
                    padding: EdgeInsets.symmetric(
                        horizontal: setWidthSize(size: 10)),
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
                          child: listImages.length > 0
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
                                  hintText: "Tên căn hộ",
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
                                  hintText: "Giá tiền",
                                  onChanged: (value) {
                                    price = num.parse(value);
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
                                                          (RealEstateModel
                                                              value) {
                                                        setState(() {
                                                          realEstate = value;
                                                        });
                                                      },
                                                      style:
                                                          styleTextContentBlack,
                                                      hint: Text(
                                                        'Dự án',
                                                        style:
                                                            styleTextHintBlack,
                                                      ),
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
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
                                                  args.permisstion_post_project ==
                                                          true
                                                      ? IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return DialogAddRealEstateScreen(
                                                                    document_id_custommer:
                                                                        document_id_custommer);
                                                              },
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                getListRealEstate();
                                                                showDialog(
                                                                  context:
                                                                      context,
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
                                                              if (value ==
                                                                  false) {
                                                                showDialog(
                                                                  context:
                                                                      context,
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
                                                          icon: Icon(
                                                              Icons.add_circle))
                                                      : SizedBox(
                                                          width: setWidthSize(
                                                              size: 15),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: setWidthSize(size: 5),
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
                                                          typeFloor =
                                                              _typeFloor;
                                                        });
                                                      },
                                                      style:
                                                          styleTextContentBlack,
                                                      hint: Text(
                                                        'Loại tần',
                                                        style:
                                                            styleTextHintBlack,
                                                      ),
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      items: listTypeloorModel
                                                          .map((TypeFloorModel
                                                              typeFloor) {
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
                                                  horizontal:
                                                      setWidthSize(size: 10)),
                                              child:
                                                  DropdownButton<DistrictModel>(
                                                value: district,
                                                onChanged:
                                                    (DistrictModel _distict) {
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
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                items: listDistrictModel.map(
                                                    (DistrictModel distict) {
                                                  return DropdownMenuItem<
                                                      DistrictModel>(
                                                    value: distict,
                                                    child: Text(
                                                      distict.name,
                                                      style:
                                                          styleTextContentBlack,
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
                                                  horizontal:
                                                      setWidthSize(size: 10)),
                                              child: DropdownButton<
                                                  TypeApartmentModel>(
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
                                                  'Loại căn hộ',
                                                  style: styleTextHintBlack,
                                                ),
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                items: listTypeApartmentModel
                                                    .map((TypeApartmentModel
                                                        typepartmentModel) {
                                                  return DropdownMenuItem<
                                                      TypeApartmentModel>(
                                                    value: typepartmentModel,
                                                    child: Text(
                                                      typepartmentModel.name,
                                                      style:
                                                          styleTextContentBlack,
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
                                                  acreageApartmentOutOf:
                                                      acreageApartment,
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
                                                      "Diện tích",
                                                      style: styleTextHintBlack,
                                                    )
                                                  : Text(
                                                      "${acreageApartment.toString()}m\u00B2",
                                                      style:
                                                          styleTextContentBlack,
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
                                                  valueOutOf: amountBedroom,
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
                                                      "Số phòng ngủ",
                                                      style: styleTextHintBlack,
                                                    )
                                                  : Text(
                                                      amountBedroom.toString(),
                                                      style:
                                                          styleTextContentBlack,
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
                                                  valueOutOf: amountBathrooms,
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
                                                      "Số phòng tắm",
                                                      style: styleTextHintBlack,
                                                    )
                                                  : Text(
                                                      amountBathrooms
                                                          .toString(),
                                                      style:
                                                          styleTextContentBlack,
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
                              " (để trống nếu miễn phí )",
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
                                  hintText: "Phí quản lí",
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
                                  hintText: "Phí đỗ xe máy",
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
                                  hintText: "Phí đỗ xe ô tô",
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
                                  hintText: "Phí phòng gym",
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
                                  hintText: "Phí hồ bơi",
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
                                        childAspectRatio:
                                            cardWidth / cardHeight),
                                itemCount: dataItemsIconsUse.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildIconInfrastructure(
                                    onTap: () {
                                      setState(() {
                                        dataItemsIconsUse[index].is_choos =
                                            !dataItemsIconsUse[index].is_choos;
                                      });
                                    },
                                    icon: itemsIcon[
                                        dataItemsIconsUse[index].id_icon],
                                    title: dataItemsIconsUse[index].name_icon,
                                    isChoos: dataItemsIconsUse[index].is_choos,
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
                      stream: postProductController.errStream,
                      builder: (context, snapshot) => Text(
                        snapshot.hasError ? snapshot.error : '',
                        style: styleTextErrorBlack,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: setWidthSize(size: 20),
                    ),
                    Container(
                      width: setWidthSize(size: 130),
                      child: ButtonNormal(
                        text: 'Xem trước',
                        onTap: () {
                          showModalBottomSheetPreviewProduct();
                        },
                      ),
                    ),
                    SizedBox(
                      width: setWidthSize(size: 20),
                    ),
                    Container(
                      width: setWidthSize(size: 120),
                      child: ButtonNormal(
                        text: 'XÉT DUYỆT',
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          listItemInfrastructure = getListItemInfrastructure();
                          await postProductController
                              .onSubmitPostProduct(
                                  document_id_custommer: document_id_custommer,
                                  nameApartment: name_apartment,
                                  price: price,
                                  realEstate: realEstate,
                                  typeFloor: typeFloor,
                                  district: district,
                                  typeApartment: typeApartment,
                                  acreageApartment: acreageApartment,
                                  amountBathrooms: amountBathrooms,
                                  amountBedroom: amountBedroom,
                                  listImages: listImages,
                                  listItemInfrastructure:
                                      listItemInfrastructure,
                                  cost: cost)
                              .then((value) {
                            if (value == 0) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            if (value == true) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDiaLogScreen(
                                    title: "Thông báo",
                                    message:
                                        "Gửi xét duyệt sản phẩm thành công !",
                                  );
                                },
                              );
                            }
                            if (value == false) {
                              Navigator.pop(context);
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDiaLogScreen(
                                    title: "Thông báo",
                                    message: "Có lỗi vui lòng thử lại sau !",
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
                  height: setWidthSize(size: 20),
                ),
              ],
            ),
            floatingActionButton: listImages.length > 0
                ? FloatingActionButton(
                    backgroundColor: colorAppbar,
                    onPressed: () async {
                      List<File> _listImages = [];
                      _listImages = await imagesBrain.pickerMultilImages();
                      int lengthList = listImages.length + _listImages.length;
                      if (lengthList > 0) {
                        if (lengthList >= 10) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDiaLogScreen(
                                title: "Thông báo",
                                message: "Chỉ chọn tối đa 10 hình",
                              );
                            },
                          );
                        } else {
                          if (lengthList < 5) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Chọn tối thiểu 5 hình",
                                );
                              },
                            );
                          } else {
                            for (var item in _listImages) {
                              listImages.add(item);
                            }
                            setState(() {});
                          }
                        }
                      }
                    },
                    child: Icon(Icons.add_circle),
                  )
                : FloatingActionButton(
                    onPressed: () async {
                      List<File> _listImages = [];
                      _listImages = await imagesBrain.pickerMultilImages();
                      if (_listImages.length > 0) {
                        if (_listImages.length > 10) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDiaLogScreen(
                                title: "Thông báo",
                                message: "Chỉ chọn tối đa 10 hình",
                              );
                            },
                          );
                        } else {
                          if (_listImages.length < 5) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Chọn tối thiểu 5 hình",
                                );
                              },
                            );
                          } else {
                            setState(() {
                              listImages = _listImages;
                            });
                          }
                        }
                      }
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
                              image: FileImage(listImages[index])),
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
                              child: Image.file(listImages[index])),
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
                    IconButton(
                      icon: Icon(
                        Icons.crop,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        File _images;
                        _images = await imagesBrain
                            .cropImageUseProDuct(listImages[index]);
                        if (_images != null) {
                          setState(() {
                            listImages[index] = _images;
                          });
                        }
                      },
                    )
                  ],
                ),
              ],
            ));
      },
      scrollDirection: Axis.horizontal,
    );
  }

  void showModalBottomSheetPreviewProduct() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(
                      Icons.remove_red_eye,
                      // color: kColorBorDer,
                    ),
                    title: new Text('Xem sản phẩm'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        PreviewProductScreen.id,
                        arguments: PreviewProductScreen(
                          urlImagesAvataProduct:
                              listImages.length < 1 ? null : listImages[0],
                          acreageApartment: acreageApartment != null
                              ? acreageApartment.toString()
                              : acreageApartment,
                          amountBedroom: amountBedroom != null
                              ? amountBedroom.toString()
                              : null,
                          district: district != null ? district.name : null,
                          nameApartment: name_apartment,
                          price: price != null ? price : null,
                        ),
                      );
                    }),
                new ListTile(
                    leading: new Icon(
                      Icons.remove_red_eye,
                      // color: kColorBorDer,
                    ),
                    title: new Text('Xem chi tiết sản phẩm'),
                    onTap: () {
                      Navigator.pop(context);
                      listItemInfrastructure = getListItemInfrastructure();
                      Navigator.pushNamed(
                        context,
                        DetailItemScreen.id,
                        arguments: DetailItemScreen(
                          view_only: true,
                          cost: cost,
                          listImages: listImages,
                          nameApartment: name_apartment,
                          is_preview_item_screen: true,
                          acreageApartment: acreageApartment != null
                              ? acreageApartment.toString()
                              : acreageApartment,
                          amountBathrooms: amountBathrooms != null
                              ? amountBathrooms.toString()
                              : null,
                          amountBedroom: amountBedroom != null
                              ? amountBedroom.toString()
                              : null,
                          district: district != null ? district.name : null,
                          price: price != null ? price : null,
                          realEstate: realEstate != null
                              ? realEstate.name_real_estate
                              : null,
                          typeApartment:
                              typeApartment != null ? typeApartment.name : null,
                          typeFloor: typeFloor != null ? typeFloor.name : null,
                          listItemInfrastructure: listItemInfrastructure,
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }
}
