import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/views/group_notication/notifycation_screen.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'like_item_controller.dart';

class LikeItemScreen extends StatefulWidget {
  static String id = "LikeItemScreen";
  @override
  _LikeItemScreenState createState() => _LikeItemScreenState();
}

class _LikeItemScreenState extends State<LikeItemScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorAppbar,
        title: Text("Sản phẩm yêu thích"),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "Yêu thích",
            ),
            Tab(
              text: "Đã gửi yêu cầu",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BuildLikeScreen(),
          BuildSentRequestedScreen(),
        ],
      ),
    );
  }
}

class BuildLikeScreen extends StatefulWidget {
  @override
  _BuildLikeScreenState createState() => _BuildLikeScreenState();
}

class _BuildLikeScreenState extends State<BuildLikeScreen> {
  bool isLoading = false;
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  List<String> list_item_like = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProduct = [];
  LikeItemController likeItemController = LikeItemController();
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

  getListProduct() async {
    await getListItemLike();
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp = await likeItemController.onGetListGetListProduct(
        list_item_like: list_item_like);
    if (_listIDProductTmp.length > 0) {
      if (mounted) {
        setState(() {
          listProduct = _listIDProductTmp;
          isLoading = false;
        });
      }
    } else {
      listProduct = [];
      isLoading = false;
    }
  }

  getListItemLike() async {
    await get_document_id_custommer();
    List<dynamic> list_item_likeTmp = [];
    if (document_id_custommer != null) {
      list_item_likeTmp = await likeItemController.onGetListGetListItemLike(
          document_id_custommer: document_id_custommer);
    }

    if (list_item_likeTmp.length > 0) {
      if (mounted) {
        setState(() {
          list_item_like = List.from(list_item_likeTmp);
        });
      }
    } else {
      setState(() {
        list_item_like = [];
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await likeItemController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  onUpdateSeenProduct({String document_id_product}) async {
    return await likeItemController.onUpdateSeenProduct(
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
    return await likeItemController.onGetDetailProduct(
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
    setState(() {
      isLoading = true;
    });
    getListProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: false,
                    child: buildGridView(),
                    enablePullDown: true,
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
                      if (listProductNeedContact.length < 1) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext) {
                            return AlertDiaLogScreen(
                              title: "Thông báo",
                              message: "Bạn chưa chọn sản phẩm !",
                            );
                          },
                        );
                      } else {
                        await likeItemController
                            .onSubmitNeedContact(
                                document_id_custommer_need_contact:
                                    document_id_custommer,
                                list_document_id_product:
                                    listProductNeedContact)
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
                      }
                    },
                    text: "Liên lạc ngay",
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildGridView() {
    return listProduct.length < 1
        ? Center(
            child: Text(
              "Không có dữ liệu",
              style: styleTextContentBlack,
            ),
          )
        : GridView.builder(
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
              urlImagesAvataProduct:
                  listProduct[index].url_images_avatar_product,
              acreageApartment: listProduct[index].acreage_apartment.toString(),
              amountBedroom: listProduct[index].amount_bedroom.toString(),
              district: listProduct[index].district,
              price: listProduct[index].price,
              nameApartment: listProduct[index].name_apartment,
              is_selected: listProduct[index].is_selected,
              onLongPress: () {
                setState(() {
                  listProduct[index].is_selected =
                      !listProduct[index].is_selected;
                });
              },
              onTap: () async {
                onUpdateSeenProduct(
                    document_id_product:
                        listProduct[index].ducument_id_product);
                DetailProductModel detailProductModel = await getDetailProduct(
                    document_id_product:
                        listProduct[index].ducument_id_product);
                RealEstateModel realEstateModel = await getRealEstate(
                    document_id_real_estate:
                        detailProductModel.document_id_real_estate);
                Navigator.pushNamed(
                  context,
                  DetailItemScreen.id,
                  arguments: DetailItemScreen(
                    itemLiked: checkItemLiked(
                        document_id_product:
                            listProduct[index].ducument_id_product),
                    is_detai_item_screen: true,
                    isImagesURL: true,
                    document_id_product: detailProductModel.document_id_product,
                    cost: detailProductModel.cost,
                    listImages: detailProductModel.list_images,
                    nameApartment: listProduct[index].name_apartment,
                    acreageApartment:
                        listProduct[index].acreage_apartment.toString(),
                    amountBathrooms:
                        detailProductModel.amount_bathrooms.toString(),
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
                ).then((value) {
                  if (value == true) {
                    getListProduct();
                  }
                });
              },
            ),
            itemCount: listProduct.length,
          );
  }
}

class BuildSentRequestedScreen extends StatefulWidget {
  @override
  _BuildSentRequestedScreenState createState() =>
      _BuildSentRequestedScreenState();
}

class _BuildSentRequestedScreenState extends State<BuildSentRequestedScreen> {
  bool isLoading = false;
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  List<dynamic> list_item_like = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProduct = [];
  LikeItemController likeItemController = LikeItemController();
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

  getListProduct() async {
    await getListItemLike();
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp =
        await likeItemController.onLoadGetListProductSentRequested(
            document_id_custommer: document_id_custommer);
    if (_listIDProductTmp.length > 0) {
      if (mounted) {
        setState(() {
          isLoading = false;
          listProduct = _listIDProductTmp;
        });
      }
    } else {
      setState(() {
        isLoading = false;
        listProduct = [];
      });
    }
  }

  getListItemLike() async {
    await get_document_id_custommer();
    List<dynamic> list_item_likeTmp = [];
    if (document_id_custommer != null) {
      list_item_likeTmp = await likeItemController.onGetListGetListItemLike(
          document_id_custommer: document_id_custommer);
    }
    print(list_item_likeTmp);
    if (list_item_likeTmp != null) {
      setState(() {
        list_item_like = list_item_likeTmp;
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await likeItemController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  onUpdateSeenProduct({String document_id_product}) async {
    return await likeItemController.onUpdateSeenProduct(
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

  void onRefresh() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    getListProduct();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  getDetailProduct({String document_id_product}) async {
    return await likeItemController.onGetDetailProduct(
        document_id_product: document_id_product);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (listProductNeedContact.length < 1) {
      setState(() {
        isLoading = true;
      });
    }
    getListProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: false,
                    child: buildGridView(),
                    enablePullDown: true,
                    header: WaterDropHeader(),
                    onRefresh: onRefresh,
                    //onLoading: onLoading,
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildGridView() {
    return listProduct.length < 1
        ? Center(
            child: Text(
              "Không có dữ liệu",
              style: styleTextContentBlack,
            ),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: setHeightSize(size: cardWidth / cardHeight),
            ),
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) => ButtonItemLike(
              like: listProduct[index].like,
              onTap: () async {
                onUpdateSeenProduct(
                    document_id_product:
                        listProduct[index].ducument_id_product);
                DetailProductModel detailProductModel = await getDetailProduct(
                    document_id_product:
                        listProduct[index].ducument_id_product);
                RealEstateModel realEstateModel = await getRealEstate(
                    document_id_real_estate:
                        detailProductModel.document_id_real_estate);
                Navigator.pushNamed(
                  context,
                  DetailItemScreen.id,
                  arguments: DetailItemScreen(
                    itemLiked: checkItemLiked(
                        document_id_product:
                            listProduct[index].ducument_id_product),
                    is_detai_item_screen: true,
                    isImagesURL: true,
                    document_id_product: detailProductModel.document_id_product,
                    cost: detailProductModel.cost,
                    listImages: detailProductModel.list_images,
                    nameApartment: listProduct[index].name_apartment,
                    acreageApartment:
                        listProduct[index].acreage_apartment.toString(),
                    amountBathrooms:
                        detailProductModel.amount_bathrooms.toString(),
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
                ).then((value) {
                  if (value == true) {
                    getListProduct();
                  }
                });
              },
              seen: listProduct[index].seen,
              itemLiked: checkItemLiked(
                  document_id_product: listProduct[index].ducument_id_product),
              urlImagesAvataProduct:
                  listProduct[index].url_images_avatar_product,
              acreageApartment: listProduct[index].acreage_apartment.toString(),
              amountBedroom: listProduct[index].amount_bedroom.toString(),
              district: listProduct[index].district,
              price: listProduct[index].price,
              nameApartment: listProduct[index].name_apartment,
              is_selected: listProduct[index].is_selected,
            ),
            itemCount: listProduct.length,
          );
  }
}
