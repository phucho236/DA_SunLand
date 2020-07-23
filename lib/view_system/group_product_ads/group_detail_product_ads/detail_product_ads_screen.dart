import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_product_ads/group_detail_product_ads/detail_product_ads_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeatailProductAdsnScreen extends StatefulWidget {
  static String id = "DeatailProductAdsnScreen";
  DeatailProductAdsnScreen({this.notifiProductAdsModel});
  final NotifiProductAdsModel notifiProductAdsModel;
  @override
  _DeatailProductAdsnScreenState createState() =>
      _DeatailProductAdsnScreenState();
}

class _DeatailProductAdsnScreenState extends State<DeatailProductAdsnScreen> {
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  bool isLoading = false;
  DeatailProductAdsnScreen args;
  List<String> list_item_like = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProduct = [];
  DeatailProductAdsController detailProductAdsController =
      DeatailProductAdsController();
  List<String> listProductNeedContact = [];
  bool is_slected = false;
  String document_id_custommer;

//  bool checkItemLiked({String document_id_product}) {
//    for (var item in list_item_like) {
//      if (item == document_id_product) {
//        return true;
//      }
//    }
//    return false;
//  }

  void get_document_id_custommer() async {
    String document_id_custommerTmp;
    document_id_custommerTmp = await getDocumentIdCustommer();

    if (document_id_custommerTmp != null) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  CustomerProfileModel customerProfileModel = CustomerProfileModel();
  CustomerProfileModel customerProfileModelRemove = CustomerProfileModel();
  getCustommerProfileUserPost({String document_id_custommer}) async {
    CustomerProfileModel customerProfileModelPostAdsTmp;
    customerProfileModelPostAdsTmp =
        await detailProductAdsController.getCustommerProfileUserPost(
            document_id_custommer: document_id_custommer);
    if (customerProfileModelPostAdsTmp != null) {
      setState(() {
        customerProfileModel = customerProfileModelPostAdsTmp;
      });
    }
  }

  getCustommerProfileUserRemove({String document_id_custommer}) async {
    CustomerProfileModel customerProfileModelPostAdsTmp =
        CustomerProfileModel();
    customerProfileModelPostAdsTmp =
        await detailProductAdsController.getCustommerProfileUserPost(
            document_id_custommer: document_id_custommer);
    if (customerProfileModelPostAdsTmp != null) {
      setState(() {
        customerProfileModelRemove = customerProfileModelPostAdsTmp;
      });
    }
  }

  getListProduct() async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp =
        await detailProductAdsController.onGetListGetListProduct(
            list_document_id_product:
                List.from(args.notifiProductAdsModel.list_document_id_product));
    if (_listIDProductTmp.length > 0) {
      setState(() {
        isLoading = false;
        listProduct = _listIDProductTmp;
      });
    } else {
      listProduct = [];
      isLoading = false;
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await detailProductAdsController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  void onLoading() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  getDetailProduct({String document_id_product}) async {
    return await detailProductAdsController.onGetDetailProduct(
        document_id_product: document_id_product);
  }

  void onRefresh() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    getListProduct();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_document_id_custommer();
    Future.delayed(Duration.zero, () {
      setState(() {
        isLoading = true;
        args = ModalRoute.of(context).settings.arguments;
      });
      getListProduct();
      getCustommerProfileUserPost(
          document_id_custommer: args.notifiProductAdsModel.post_by);
      if (args.notifiProductAdsModel.remove_by != null) {
        getCustommerProfileUserRemove(
            document_id_custommer: args.notifiProductAdsModel.remove_by);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return args == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(" Chi tiết thông báo"),
              backgroundColor: colorAppbar,
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange)),
                  )
                : Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: listProduct.length < 1
                                ? Text(
                                    "Không có dữ liệu",
                                    style: styleTextContentBlack,
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      setHeightSize(size: 20)),
                                              child: Icon(
                                                Icons.notifications_active,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Tên: ${args.notifiProductAdsModel.title}",
                                                  style:
                                                      styleTextTitleInBodyBlack,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Nội dung: ${args.notifiProductAdsModel.content}",
                                        style: styleTextContentBlack,
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        "Trạng thái: ${args.notifiProductAdsModel.removed ? "Không hoạt động." : "Hoạt động"}",
                                        style: styleTextHintBlack,
                                      ),
                                      Text(
                                        "Đăng vào :${getDateShow(args.notifiProductAdsModel.post_at)}",
                                        style: styleTextHintBlack,
                                      ),
                                      Text(
                                        "Đăng bởi:${customerProfileModel.user_name}",
                                        style: styleTextHintBlack,
                                      ),
                                      Text(
                                        "Xóa bởi:${args.notifiProductAdsModel.remove_by == null ? "Không có dữ liệu" : customerProfileModelRemove.user_name}",
                                        style: styleTextHintBlack,
                                      ),
                                      Text(
                                        "Xóa vào:${args.notifiProductAdsModel.remove_at == null ? "Không có dữ liệu" : getDateShow(args.notifiProductAdsModel.remove_at)}",
                                        style: styleTextHintBlack,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullUp: false,
                          child: buildGridView(),
                          enablePullDown: false,
                          header: WaterDropHeader(),
                          onRefresh: onRefresh,
                          //onLoading: onLoading,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(setWidthSize(size: 10)),
                        width: setWidthSize(size: 200),
                        child: args.notifiProductAdsModel.removed
                            ? Container()
                            : ButtonNormal(
                                onTap: () async {
                                  await detailProductAdsController
                                      .onRemoveNotifyProductAds(
                                          document_id_custommer:
                                              document_id_custommer,
                                          document_id_notify_product_ads: args
                                              .notifiProductAdsModel
                                              .document_id_notify_product_ads)
                                      .then((result) {
                                    if (result == true) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDiaLogScreen(
                                            title: "Thông báo",
                                            message:
                                                "Xóa thông báo thành công.",
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext) {
                                          return AlertDiaLogScreen(
                                            title: "Thông báo",
                                            message:
                                                "Lỗi! /n.sử dụng tính năng này sau",
                                          );
                                        },
                                      );
                                    }
                                  });
                                },
                                text: "Xóa thông báo",
                              ),
                      ),
                    ],
                  ),
          );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: setHeightSize(size: cardWidth / cardHeight),
      ),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => ButtonItemLike(
        like: listProduct[index].like,
        seen: listProduct[index].seen,
        itemLiked: false,
        urlImagesAvataProduct: listProduct[index].url_images_avatar_product,
        acreageApartment: listProduct[index].acreage_apartment.toString(),
        amountBedroom: listProduct[index].amount_bedroom.toString(),
        district: listProduct[index].district,
        price: listProduct[index].price,
        nameApartment: listProduct[index].name_apartment,
        is_selected: listProduct[index].is_selected,
        onTap: () async {
          DetailProductModel detailProductModel = await getDetailProduct(
              document_id_product: listProduct[index].ducument_id_product);
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  detailProductModel.document_id_real_estate);
          Navigator.pushNamed(
            context,
            DetailItemScreen.id,
            arguments: DetailItemScreen(
              view_only: true,
              itemLiked: false,
              is_detai_item_screen: true,
              isImagesURL: true,
              document_id_product: detailProductModel.document_id_product,
              cost: detailProductModel.cost,
              listImages: detailProductModel.list_images,
              nameApartment: listProduct[index].name_apartment,
              acreageApartment: listProduct[index].acreage_apartment.toString(),
              amountBathrooms: detailProductModel.amount_bathrooms.toString(),
              amountBedroom: listProduct[index].amount_bedroom.toString(),
              district: listProduct[index].district,
              price: listProduct[index].price,
              realEstate: realEstateModel.name_real_estate,
              typeApartment: detailProductModel.type_apartment,
              typeFloor: detailProductModel.type_floor,
              listItemInfrastructure:
                  detailProductModel.list_item_infrastructure,
              coordinatesModel: realEstateModel.coordinates,
            ),
          );
        },
      ),
      itemCount: listProduct.length,
    );
  }
}
