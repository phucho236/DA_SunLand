import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/group_google_map/open_app_google_map.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_product_censorship/product_censorship_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_controller.dart';
import 'package:flutter_core/views/group_save_data/save_data_controller.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class DetailItemScreen extends StatefulWidget {
  static String id = "DetailItemScreen";
  DetailItemScreen({
    this.listImages,
    this.nameApartment,
    this.price,
    this.realEstate,
    this.typeFloor,
    this.district,
    this.typeApartment,
    this.acreageApartment,
    this.amountBathrooms,
    this.amountBedroom,
    this.cost,
    this.listItemInfrastructure,
    this.document_id_product,
    this.isImagesURL = false,
    this.itemLiked = false,
    this.is_detai_item_screen = false,
    this.is_preview_item_screen = false,
    this.coordinatesModel,
    this.view_only = false,
    this.detailProductModel,
  });
  List<dynamic> listImages = [];
  final bool is_preview_item_screen;
  final bool is_detai_item_screen;
  final String nameApartment;
  final num price;
  final String realEstate;
  final String typeFloor;
  final String district;
  final String typeApartment;
  final String acreageApartment;
  final String amountBathrooms;
  final String amountBedroom;
  final CostModel cost;
  final String document_id_product;
  final bool isImagesURL;
  final DetailProductModel detailProductModel;
  bool itemLiked;
  final CoordinatesModel coordinatesModel;
  final bool view_only;
  List<ItemsIcon> listItemInfrastructure = [];

  @override
  _DetailItemScreenState createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  String document_id_custommer;
  bool isLoading = false;
  bool resData = false;
  SaveDataController saveDataController = SaveDataController();
  DetailItemController detailItemController = DetailItemController();
  DetailItemScreen args1;
  CustomerProfileModel customerProfileModel_post_product =
      CustomerProfileModel();
  CustomerProfileModel customerProfileModel_edit_product =
      CustomerProfileModel();
  CustomerProfileModel customerProfileModel_censorship_product =
      CustomerProfileModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args1 = ModalRoute.of(context).settings.arguments;
      });
      if (args1.is_preview_item_screen == false) {
        if (args1.is_detai_item_screen == false) {
          getCustommerProfilePostProduct(args1);
          getCustommerProfileEditProduct(args1);
          getCustommerProfileCensorshipProduct(args1);
        }
      }
    });
    getDocumentIDCustommer();
  }

  getCustommerProfileCensorshipProduct(args) async {
    CustomerProfileModel customerProfileModelPostProductTmp =
        CustomerProfileModel();
    customerProfileModelPostProductTmp =
        await detailItemController.getCustommerProfileUserPost(
            document_id_custommer: args.detailProductModel.censored_by);
    if (customerProfileModelPostProductTmp != null) {
      setState(() {
        customerProfileModel_censorship_product =
            customerProfileModelPostProductTmp;
      });
    }
  }

  getCustommerProfilePostProduct(args) async {
    CustomerProfileModel customerProfileModelPostProductTmp =
        CustomerProfileModel();
    customerProfileModelPostProductTmp =
        await detailItemController.getCustommerProfileUserPost(
            document_id_custommer: args.detailProductModel.post_by);
    if (customerProfileModelPostProductTmp != null) {
      setState(() {
        customerProfileModel_post_product = customerProfileModelPostProductTmp;
      });
    }
  }

  getCustommerProfileEditProduct(args) async {
    CustomerProfileModel customerProfileModelPostProductTmp =
        CustomerProfileModel();
    customerProfileModelPostProductTmp =
        await detailItemController.getCustommerProfileUserPost(
            document_id_custommer: args.detailProductModel.last_edit_by);
    if (customerProfileModelPostProductTmp != null) {
      setState(() {
        customerProfileModel_edit_product = customerProfileModelPostProductTmp;
      });
    }
  }

  void getDocumentIDCustommer() async {
    String document_id_custommerTmp;
    document_id_custommerTmp = await getDocumentIdCustommer();
    if (document_id_custommerTmp != null) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  ProductCensorshipController productCensorshipController =
      ProductCensorshipController();

  @override
  Widget build(BuildContext context) {
    DetailItemScreen args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: colorAppbar,
                  pinned: true,
                  expandedHeight: setHeightSize(size: 250.0),
                  leading: BackButton(onPressed: () {
                    Navigator.pop(context, resData);
                  }),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Center(
                      child: Stack(
                        children: <Widget>[
                          _buildPageView(args),
                          _buildCircleIndicator(args),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        args.is_preview_item_screen == false
                            ? args.is_detai_item_screen
                                ? Container()
                                : Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: setHeightSize(size: 10),
                                      ),
                                      Text(
                                        "Đăng bởi: ${customerProfileModel_post_product.user_name} ",
                                      ),
                                      Text(
                                          "Đăng vào: ${getDateShow(args.detailProductModel.post_at)} "),
                                      customerProfileModel_edit_product
                                                  .user_name !=
                                              null
                                          ? Text(
                                              "Chỉnh sửa lẩn cuối bởi: ${customerProfileModel_edit_product.user_name} ")
                                          : Container(),
                                      args.detailProductModel.last_edit != null
                                          ? Text(
                                              "Chỉnh sửa lần cuối vào: ${getDateShow(args.detailProductModel.last_edit)} ")
                                          : Container(),
                                      Text(
                                          "Đăng bởi: ${customerProfileModel_post_product.type == 0 ? "Đối tác" : "Nhân viên"} "),
                                      customerProfileModel_censorship_product
                                                  .user_name !=
                                              null
                                          ? Text(
                                              "Kiểm duyệt lần cuối bởi: ${customerProfileModel_censorship_product.user_name} ")
                                          : Container(),
                                    ],
                                  )
                            : Container(),
                        SizedBox(
                          height: setHeightSize(size: 10),
                        ),
                        detail_item_widget(
                          is_preview_item_screen: args.is_preview_item_screen,
                          view_only: args.view_only,
                          is_detai_item_screen: args.is_detai_item_screen,
                          nameApartment: args.nameApartment,
                          typeFloor: args.typeFloor,
                          typeApartment: args.typeApartment,
                          realEstate: args.realEstate,
                          price: args.price,
                          district: args.district,
                          amountBedroom: args.amountBedroom,
                          amountBathrooms: args.amountBathrooms,
                          acreageApartment: args.acreageApartment,
                          document_id_product: args.document_id_product,
                        ),
                        detail_charges_item_widget(
                          cost: args.cost,
                        ),
                        infrastructure_widget(
                          listItemInfrastructure:
                              args.listItemInfrastructure == null
                                  ? null
                                  : args.listItemInfrastructure,
                        ),
                        SizedBox(
                          height: setHeightSize(size: 10),
                        ),
                        args.is_preview_item_screen == false
                            ? args.is_detai_item_screen
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      print(args.coordinatesModel.latitude);
                                      await MapUtils.openMap(
                                          lat: args.coordinatesModel.latitude,
                                          long: args.coordinatesModel.longitude,
                                          title: args.realEstate);
                                    },
                                    child: Container(
                                      child: Text(
                                        "Xem vị trí dự án",
                                        style: styleTextContentBlack,
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          args.is_detai_item_screen
              ? Container()
              : args.view_only
                  ? Container()
                  : args.is_preview_item_screen
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: setHeightSize(size: 10)),
                          child: Container(
                            width: setWidthSize(size: 200),
                            child: ButtonNormal(
                              onTap: () async {
                                bool _result = false;
                                _result = await productCensorshipController
                                    .onBrowseProduct(
                                        document_id_custommer:
                                            document_id_custommer,
                                        document_id_product:
                                            args.document_id_product);
                                if (_result == true) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDiaLogScreen(
                                        title: "Thông báo",
                                        message: "Duyệt sản phẩm thành công",
                                      );
                                    },
                                  ).then((value) {
                                    if (value) {
                                      Navigator.pop(context, true);
                                    }
                                  });
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDiaLogScreen(
                                        title: "Thông báo",
                                        message: "Duyệt sản phẩm thất bại",
                                      );
                                    },
                                  ).then((value) {
                                    if (value) {
                                      Navigator.pop(context, false);
                                    }
                                  });
                                }
                              },
                              text: "Duyệt",
                            ),
                          ),
                        ),
          args.view_only
              ? Container()
              : args.is_detai_item_screen
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: setHeightSize(size: 10)),
                      child: Container(
                        width: setWidthSize(size: 200),
                        child: args.itemLiked
                            ? ButtonNormal(
                                TextColorsRed: true,
                                onTap: () async {
                                  setState(() {
                                    args.itemLiked = false;
                                    resData = true;
                                  });
                                  await detailItemController.onSubmitUnlike(
                                      document_id_product:
                                          args.document_id_product,
                                      document_id_custommer:
                                          document_id_custommer);
                                  // await saveDataController.onLoadSaveData();
                                },
                                text: "Đã thích",
                              )
                            : ButtonNormal(
                                onTap: () async {
                                  setState(() {
                                    args.itemLiked = true;
                                    resData = true;
                                  });

                                  await detailItemController
                                      .onSubmitUpdateLikeProduct(
                                          document_id_product:
                                              args.document_id_product);
                                  await detailItemController.onSubmitLike(
                                      document_id_product:
                                          args.document_id_product,
                                      document_id_custommer:
                                          document_id_custommer);
                                  //await saveDataController.onLoadSaveData();
                                },
                                text: "Yêu thích",
                              ),
                      ),
                    )
                  : Container(),
        ],
      ),
    );
  }

  final _items = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.amber,
    Colors.brown,
    Colors.yellow,
    Colors.blue,
  ];
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight =
      setHeightSize(size: 250.0) + setHeightSize(size: getTopBarHeight());
  _buildPageView(DetailItemScreen args) {
    return Container(
      //color: col,
      height: _boxHeight,
      child: PageView.builder(
          itemCount: args.listImages.length > 0
              ? args.listImages.length
              : _items.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return args.isImagesURL
                ? CachedNetworkImage(
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    imageUrl: args.listImages[index],
                    fit: BoxFit.cover,
                  )
//            Image.network(
//                    widget.listImages[index],
//                    fit: BoxFit.cover,
//                  )
                : args.listImages.length > 0
                    ? Image.asset(
                        args.listImages[index].path,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Image.asset(
                          "assets/images/library_image.png",
                          color: _items[index],
                          //height: setHeightSize(size: 70),
                        ),
                      );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildCircleIndicator(DetailItemScreen args) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: args.listImages.length > 0
              ? args.listImages.length
              : _items.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}

class infrastructure_widget extends StatelessWidget {
  infrastructure_widget({this.listItemInfrastructure});

  List<ItemsIcon> listItemInfrastructure = [];
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 22.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(
          //height: setHeightSize(size: 210),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.5),
                blurRadius: 3, // has the effect of softening the shadow
                spreadRadius: 0.1, // has the effect of extending the shadow
                offset: Offset(
                  1.5, // horizontal, move right 10
                  1.5, // vertical, move down 10
                ),
              )
            ],
          ),
          margin: EdgeInsets.only(
              top: setHeightSize(size: 15),
              bottom: setWidthSize(size: 5),
              left: setWidthSize(size: 15),
              right: setWidthSize(size: 15)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: SizedBox(
              height: setHeightSize(size: 200),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                childAspectRatio: cardWidth / cardHeight,
                crossAxisCount: 2,
                children: listItemInfrastructure == null
                    ? List.generate(dataItemsIcons.length, (index) {
                        return buildIconWidgetSample(
                            title: dataItemsIcons[index].name_icon,
                            icon: itemsIcon[index]);
                      })
                    : List.generate(listItemInfrastructure.length, (index) {
                        return buildIconWidget(
                            icon: itemsIcon[
                                listItemInfrastructure[index].id_icon],
                            title: listItemInfrastructure[index].name_icon);
                      }),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: setWidthSize(size: 15)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 5)),
            child: Text(
              "Cơ sở vật chất",
              style: TextStyle(
                color: Colors.black,
                fontSize: setFontSize(size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIconWidget({IconData icon, String title}) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: setWidthSize(size: 10),
          ),
          Icon(
            icon,
            size: setHeightSize(size: 20),
          ),
          SizedBox(
            width: setWidthSize(size: 5),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: setFontSize(size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconWidgetSample({IconData icon, String title}) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: setWidthSize(size: 10),
          ),
          Icon(
            icon,
            size: setHeightSize(size: 20),
            color: Colors.red,
          ),
          SizedBox(
            width: setWidthSize(size: 5),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.red,
              fontSize: setFontSize(size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class detail_charges_item_widget extends StatelessWidget {
  detail_charges_item_widget({this.cost});
  CostModel cost;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(
          //height: setHeightSize(size: 210),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.5),
                blurRadius: 3, // has the effect of softening the shadow
                spreadRadius: 0.1, // has the effect of extending the shadow
                offset: Offset(
                  1.5, // horizontal, move right 10
                  1.5, // vertical, move down 10
                ),
              )
            ],
          ),
          margin: EdgeInsets.only(
              top: setHeightSize(size: 15),
              bottom: setWidthSize(size: 5),
              left: setWidthSize(size: 15),
              right: setWidthSize(size: 15)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(
                setWidthSize(size: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  charges_item_widget(
                      title: "Phí quản lí",
                      cost: cost.management_cost == null
                          ? "Miễn phí"
                          : PriceFortmatMoney(
                                  value: double.parse(cost.management_cost),
                                  symbol: false)
                              .toString()),
                  charges_item_widget(
                      title: "Miễn phí",
                      cost: cost.motorbike_parking_cost == null
                          ? "Miễn phí"
                          : PriceFortmatMoney(
                                  value:
                                      double.parse(cost.motorbike_parking_cost),
                                  symbol: false)
                              .toString()),
                  charges_item_widget(
                      title: "Phí đỗ xe ô tô",
                      cost: cost.car_parking_cost == null
                          ? "Miễn phí"
                          : PriceFortmatMoney(
                                  value: double.parse(cost.car_parking_cost),
                                  symbol: false)
                              .toString()),
                  charges_item_widget(
                      title: "Phí phòng gym",
                      cost: cost.gym_cost == null
                          ? "Miễn phí"
                          : PriceFortmatMoney(
                                  value: double.parse(cost.gym_cost),
                                  symbol: false)
                              .toString()),
                  charges_item_widget(
                      title: "Phí hồ bơi",
                      cost: cost.swimming_pool_cost == null
                          ? "Miễn phí"
                          : PriceFortmatMoney(
                                  value: double.parse(cost.swimming_pool_cost),
                                  symbol: false)
                              .toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Đơn vị tính: VND/ tháng ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: setFontSize(size: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: setWidthSize(size: 15)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 5)),
            child: Text(
              "Các khoảng phí",
              style: TextStyle(
                color: Colors.black,
                fontSize: setFontSize(size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget charges_item_widget({String title, String cost}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: setFontSize(size: 14),
          ),
        ),
        Text(
          cost,
          style: TextStyle(
            color: Colors.black,
            fontSize: setFontSize(size: 14),
          ),
        ),
      ],
    );
  }
}

class detail_item_widget extends StatelessWidget {
  detail_item_widget(
      {this.nameApartment,
      this.price,
      this.realEstate,
      this.typeFloor,
      this.district,
      this.typeApartment,
      this.acreageApartment,
      this.amountBathrooms,
      this.amountBedroom,
      this.document_id_product,
      this.is_detai_item_screen,
      this.view_only,
      this.is_preview_item_screen});

  String nameApartment;
  num price;
  String realEstate;
  String typeFloor;
  String district;
  String typeApartment;
  String acreageApartment;
  String amountBathrooms;
  String amountBedroom;
  String document_id_product;
  bool is_detai_item_screen;
  bool view_only;
  bool is_preview_item_screen;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(
          // height: setHeightSize(size: 210),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.5),
                blurRadius: 3, // has the effect of softening the shadow
                spreadRadius: 0.1, // has the effect of extending the shadow
                offset: Offset(
                  1.5, // horizontal, move right 10
                  1.5, // vertical, move down 10
                ),
              )
            ],
          ),
          margin: EdgeInsets.only(
              top: setHeightSize(size: 15),
              bottom: setWidthSize(size: 5),
              left: setWidthSize(size: 15),
              right: setWidthSize(size: 15)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(
                setWidthSize(size: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  Row(
                    children: <Widget>[
                      Text("Dự án: ", style: styleTextTitleInBodyBlack),
                      Text(
                        realEstate == null ? "ABCD" : realEstate,
                        style: realEstate == null
                            ? styleTextTitleInBodyNoInput
                            : styleTextTitleInBodyBlack,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Giá: ", style: styleTextTitleInBodyBlack),
                      Text(
                        price == null
                            ? "999.999.999 VNĐ"
                            : PriceFortmatMoney(
                                value: double.parse(price.toString())),
                        style: price == null
                            ? styleTextTitleInBodyNoInput
                            : styleTextTitleInBodyBlack,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Loại căn hộ: ", style: styleTextTitleInBodyBlack),
                      Text(
                        typeApartment == null ? "ABCD" : typeApartment,
                        style: typeApartment == null
                            ? styleTextTitleInBodyNoInput
                            : styleTextTitleInBodyBlack,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Địa chỉ: ", style: styleTextTitleInBodyBlack),
                      Text(
                        district == null ? "ABCD" : district,
                        style: district == null
                            ? styleTextTitleInBodyNoInput
                            : styleTextTitleInBodyBlack,
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: setHeightSize(size: 10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Icon(MdiIcons.bedQueen),
                            Text(
                              amountBedroom == null ? "999" : amountBedroom,
                              style: amountBedroom == null
                                  ? styleTextContenIconNoInput
                                  : styleTextContentIconBlack,
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(MdiIcons.toilet),
                            Text(
                              amountBathrooms == null ? "999" : amountBathrooms,
                              style: amountBathrooms == null
                                  ? styleTextContenIconNoInput
                                  : styleTextContentIconBlack,
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.flip_to_front),
                            Text(
                              acreageApartment == null
                                  ? "999m2"
                                  : "${acreageApartment}m\u00B2",
                              style: acreageApartment == null
                                  ? styleTextContenIconNoInput
                                  : styleTextContentIconBlack,
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(MdiIcons.officeBuilding),
                            Text(
                              typeFloor == null ? "Loại tần" : typeFloor,
                              style: typeFloor == null
                                  ? styleTextContenIconNoInput
                                  : styleTextContentIconBlack,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  is_preview_item_screen == false
                      ? is_detai_item_screen
                          ? GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDiaLogScreen(
                                      allow_copy_text: true,
                                      title: "Mã sản phẩm",
                                      message: document_id_product,
                                    );
                                  },
                                );
                              },
                              child: Text("Xem mã SP"),
                            )
                          : Container()
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          margin: EdgeInsets.only(left: setWidthSize(size: 15)),
          //color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 5.0)),
            child: Text(
              nameApartment == null ? "Căn hộ ABCD" : nameApartment,
              style: TextStyle(
                color: nameApartment == null ? Colors.red : Colors.black,
                fontSize: setFontSize(size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
