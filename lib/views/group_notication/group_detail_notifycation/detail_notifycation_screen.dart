import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/views/group_like_item/like_item_controller.dart';
import 'package:flutter_core/views/group_notication/group_detail_notifycation/detail_notifycation_controller.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeatailNotifycationScreen extends StatefulWidget {
  static String id = "DeatailNotifycationScreen";
  DeatailNotifycationScreen({this.notifiProductAdsModel});
  final NotifiProductAdsModel notifiProductAdsModel;
  @override
  _DeatailNotifycationScreenState createState() =>
      _DeatailNotifycationScreenState();
}

class _DeatailNotifycationScreenState extends State<DeatailNotifycationScreen> {
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  DeatailNotifycationScreen args;
  List<String> list_item_like = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProduct = [];
  DetailNotifycationController detailNotifycationController =
      DetailNotifycationController();
  List<String> listProductNeedContact = [];
  bool is_slected = false;
  String document_id_custommer;

  bool checkItemLiked({String document_id_product}) {
    for (var item in list_item_like) {
      if (item == document_id_product) {
        return true;
      }
    }
    return false;
  }

  void get_document_id_custommer() async {
    String document_id_custommerTmp;
    document_id_custommerTmp = await getDocumentIdCustommer();

    if (document_id_custommerTmp != null) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  getListItemLike() async {
    await get_document_id_custommer();
    List<dynamic> list_item_likeTmp = [];
    if (document_id_custommer != null) {
      list_item_likeTmp =
          await detailNotifycationController.onGetListGetListItemLike(
              document_id_custommer: document_id_custommer);
    }
    print(list_item_likeTmp);
    if (list_item_likeTmp != null) {
      setState(() {
        list_item_like = List.from(list_item_likeTmp);
      });
    }
  }

  getListProduct() async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp =
        await detailNotifycationController.onGetListGetListProduct(
            list_document_id_product:
                List.from(args.notifiProductAdsModel.list_document_id_product));
    if (_listIDProductTmp != null) {
      setState(() {
        listProduct = _listIDProductTmp;
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await detailNotifycationController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  onUpdateSeenProduct({String document_id_product}) async {
    return await detailNotifycationController.onUpdateSeenProduct(
        document_id_product: document_id_product);
  }

  void onLoading() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  getListProductNeedContact() {
    List<String> listProductNeedContactTmp = [];
    for (var item in listProduct) {
      if (item.is_selected == true) {
        listProductNeedContactTmp.add(item.ducument_id_product);
      }
    }
    setState(() {
      listProductNeedContact = listProductNeedContactTmp;
    });
  }

  getDetailProduct({String document_id_product}) async {
    return await detailNotifycationController.onGetDetailProduct(
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
    getListItemLike();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
        getListProduct();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Chi tiết"),
        backgroundColor: colorAppbar,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: setHeightSize(size: 20)),
                            child: Icon(
                              Icons.notifications_active,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                args.notifiProductAdsModel.title,
                                style: styleTextTitleInBodyBlack,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: setWidthSize(size: 10),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      args.notifiProductAdsModel.content,
                      style: styleTextContentBlack,
                      textAlign: TextAlign.start,
                    )
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
            child: ButtonNormal(
              onTap: () async {
                getListProductNeedContact();
                await detailNotifycationController
                    .onSubmitNeedContact(
                        document_id_custommer_need_contact:
                            document_id_custommer,
                        list_document_id_product: listProductNeedContact)
                    .then((result) {
                  if (result == true) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDiaLogScreen(
                          title: "Thông báo",
                          message:
                              "Gửi thông tin thành công\nSunLand sẽ liên lạc bạn ngay !",
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
                              "Lỗi! /n. xin quý khách sử dụng tính năng này sau",
                        );
                      },
                    );
                  }
                });
              },
              text: "Liên lạc ngay",
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
        itemLiked: checkItemLiked(
            document_id_product: listProduct[index].ducument_id_product),
        urlImagesAvataProduct: listProduct[index].url_images_avatar_product,
        acreageApartment: listProduct[index].acreage_apartment.toString(),
        amountBedroom: listProduct[index].amount_bedroom.toString(),
        district: listProduct[index].district,
        price: listProduct[index].price,
        nameApartment: listProduct[index].name_apartment,
        is_selected: listProduct[index].is_selected,
        onLongPress: () {
          setState(() {
            listProduct[index].is_selected = !listProduct[index].is_selected;
          });
        },
        onTap: () async {
          onUpdateSeenProduct(
              document_id_product: listProduct[index].ducument_id_product);
          DetailProductModel detailProductModel = await getDetailProduct(
              document_id_product: listProduct[index].ducument_id_product);
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  detailProductModel.document_id_real_estate);
          Navigator.pushNamed(
            context,
            DetailItemScreen.id,
            arguments: DetailItemScreen(
              itemLiked: checkItemLiked(
                  document_id_product: listProduct[index].ducument_id_product),
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
