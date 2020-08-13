import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/PushNotifications/PushNotificationsManager.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_dialog_filter_search/dialog_filter_search.dart';
import 'package:flutter_core/view_system/system_center_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/views/group_home_page/home_page_controller.dart';
import 'package:flutter_core/views/group_notication/notifycation_screen.dart';
import 'package:flutter_core/widgets/button_icon.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_core/widgets/button_item.dart';

class HomePageScreen extends StatefulWidget {
  static String id = "HomePageScreen";
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with AutomaticKeepAliveClientMixin {
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  bool isLoading = false;
  String document_id_custommer;
  List<dynamic> list_item_like = [];
  num type;
  int lenghList = 4;
  int lenghListNow = 0;
  bool listMAx = false;
  bool onfind = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProduct = [];
  List<ProductModel> listProductFind = [];
  HomePageController homePageController = HomePageController();
  bool checkItemLiked({String document_id_product}) {
    for (var item in list_item_like) {
      if (item == document_id_product) {
        return true;
      }
    }
    return false;
  }

  getTypeCustommer() async {
    num _type;
    _type = await getType();
    if (_type != null) {
      setState(() {
        type = _type;
      });
    }
  }

  getListProduct(lenghList) async {
    await getListItemLike();
    if (listMAx == false) {
      List<ProductModel> _listIDProductTmp = [];
      _listIDProductTmp =
          await homePageController.onGetListGetListProduct(lenghList);
      if (lenghListNow == _listIDProductTmp.length) {
        setState(() {
          listMAx = true;
        });
      }
      if (_listIDProductTmp.length > 0) {
        if (mounted) {
          setState(() {
            lenghListNow = _listIDProductTmp.length;
            listProduct = _listIDProductTmp;
            isLoading = false;
          });
        }
      }
    }
  }

  get_document_id_custommer() async {
    String document_id_custommerTmp = await getDocumentIdCustommer();
    if (document_id_custommerTmp != null) {
      document_id_custommer = document_id_custommerTmp;
    }
  }

  getListItemLike() async {
    await get_document_id_custommer();
    List<dynamic> list_item_likeTmp = [];

    list_item_likeTmp = await homePageController.onGetListGetListItemLike(
        document_id_custommer: document_id_custommer);

    if (list_item_likeTmp.length > 0) {
      setState(() {
        list_item_like = list_item_likeTmp;
      });
    } else {
      setState(() {
        list_item_like = [];
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await homePageController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  getDetailProduct({String document_id_product}) async {
    return await homePageController.onGetDetailProduct(
        document_id_product: document_id_product);
  }

  onUpdateSeenProduct({String document_id_product}) async {
    return await homePageController.onUpdateSeenProduct(
        document_id_product: document_id_product);
  }

  getListProductFilter({List<String> list_document_id_product}) async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp = await homePageController
        .onGetListProductFilter(list_document_id_product);
    setState(() {
      listProductFind = _listIDProductTmp;
      onfind = true;
    });
  }

  void onLoading() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      lenghList = lenghList + 4;
      getListProduct(lenghList);
    });

    if (mounted) _refreshController.loadComplete();
  }

  void onRefresh() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted)
      setState(() {
        listMAx = false;
        getListProduct(lenghList);
        onfind = false;
      });
    _refreshController.refreshCompleted();
  }

  getProductFind({String name_or_document_id_product}) async {
    List<ProductModel> _listProductTmp = [];
    ProductModel productModelTmp;
    productModelTmp = await homePageController.onGetProductFindByNameOrId(
        name_or_id: name_or_document_id_product);
    if (productModelTmp != null) {
      _listProductTmp.add(productModelTmp);
    }
    if (_listProductTmp.length > 0) {
      setState(() {
        listProductFind = _listProductTmp;
      });
    } else {
      setState(() {
        listProductFind = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTypeCustommer();
    if (listProduct.length < 1) {
      setState(() {
        isLoading = true;
      });
      getListProduct(lenghList);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: colorAppbar,
      leading: GestureDetector(
        onTap: type == 1
            ? () {
                Navigator.pushReplacementNamed(context, SystemCenterScreen.id);
              }
            : null,
        child: Padding(
          padding: EdgeInsets.only(left: setWidthSize(size: 15)),
          child: Container(
            child: Image.asset(
              "assets/images/icon_sunland.png",
            ),
          ),
        ),
      ),
      title: Text("SunLand"),
      actions: <Widget>[
        IconButton(
          alignment: Alignment.center,
          onPressed: () {
            Navigator.pushNamed(context, NotifycatonScreen.id);
          },
          icon: Icon(Icons.notifications),
        ),
      ],
    );
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBar.preferredSize.height),
        child: appBar,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(setWidthSize(size: 10)),
                  child: Search_TextField_Border(
                    borderRadius: 5,
                    hintText: "Nhập id hoặc tên sản phẩm",
                    sizeBorder: 2,
                    colorBorDer: Colors.white,
                    onChanged: (value) {
                      getProductFind(name_or_document_id_product: value);
                      if (value == "") {
                        onfind = false;
                      } else {
                        onfind = true;
                      }
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    child:
                        buildGridView(onfind ? listProductFind : listProduct),
                    header: WaterDropHeader(),
                    onRefresh: onRefresh,
                    onLoading: onLoading,
                  ),
                ),
              ],
            ),
      floatingActionButton: isLoading
          ? Container()
          : FloatingActionButton(
              backgroundColor: colorAppbar,
              onPressed: () async {
                showDialog(
                  //barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return DialogFilterSearch();
                  },
                ).then((value) {
                  if (value != null) {
                    if (value != null) {
                      getListProductFilter(list_document_id_product: value);
                    }
                  }
                });
              },
              child: Icon(Icons.search),
            ),
    );
  }

  Widget buildGridView(listProduct) {
    return listProduct.length > 0
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: setHeightSize(size: cardWidth / cardHeight),
            ),
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) => ButtonItem(
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
                    view_only: false,
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
                    setState(() {
                      listMAx = false;
                    });
                    getListProduct(lenghList);
                  }
                });
              },
            ),
            itemCount: lenghList >= listProduct.length
                ? listProduct.length
                : lenghList,
          )
        : Center(
            child: Text(
              "Không có dữ liệu",
              style: styleTextHintBlack,
            ),
          );
  }
}
