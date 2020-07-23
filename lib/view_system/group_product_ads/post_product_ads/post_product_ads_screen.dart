import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_dialog_filter_search/dialog_filter_search.dart';
import 'package:flutter_core/view_system/group_dialog_filter_search/dialog_filter_search_controller.dart';
import 'package:flutter_core/view_system/group_product_ads/post_product_ads/post_product_ads_controller.dart';

import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostProductAdsScreen extends StatefulWidget {
  static String id = "PostProductAdsScreen";
  @override
  _PostProductAdsScreenState createState() => _PostProductAdsScreenState();
}

class _PostProductAdsScreenState extends State<PostProductAdsScreen> {
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  List<String> list_product = [];
  String title;
  String content;
  List<ProductModel> list_product_model_post = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProductModel = [];
  PostProductAdsController postProductAdsController =
      PostProductAdsController();

  String document_id_custommer;

  get_document_id_custommer() async {
    String document_id_custommerTmp;
    document_id_custommerTmp = await getDocumentIdCustommer();

    if (document_id_custommerTmp.length > 0) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  getListProduct() async {
    await getListIDProductcensored();
    List<ProductModel> _listProductModelTmp = [];
    _listProductModelTmp = await postProductAdsController
        .onGetListGetListProduct(list_product: list_product);
    if (_listProductModelTmp.length > 0) {
      setState(() {
        listProductModel = _listProductModelTmp;
      });
    }
  }

  getListProductFilter({List<String> list_document_id_product}) async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp = await postProductAdsController
        .onGetListProductFilter(list_document_id_product);
    if (_listIDProductTmp.length > 0) {
      setState(() {
        listProductModel = _listIDProductTmp;
      });
    }
  }

  getListIDProductcensored() async {
    List<String> list_document_id_product_tmp = [];
    list_document_id_product_tmp =
        await postProductAdsController.onLoadGetListProductCensored();
    if (list_document_id_product_tmp.length > 0) {
      setState(() {
        list_product = list_document_id_product_tmp;
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await postProductAdsController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  void onLoading() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  getDetailProduct({String document_id_product}) async {
    return await postProductAdsController.onGetDetailProduct(
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
    getListProduct();
    get_document_id_custommer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Gửi gợi ý sản phẩm",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: setHeightSize(size: 15),
          ),
          Text(
            "Nội dung gợi ý",
            style: styleTextHintBlack,
          ),
          SizedBox(
            height: setHeightSize(size: 10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 10)),
            child: TextFieldBorder(
              onChanged: (value) {
                title = value;
              },
              hintText: "Tên gợi ý",
              colorTextWhite: false,
            ),
          ),
          SizedBox(
            height: setHeightSize(size: 10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 10)),
            child: TextFieldBorder(
              onChanged: (value) {
                content = value;
              },
              colorTextWhite: false,
              hintText: "Nội dung gợi ý",
            ),
          ),
          SizedBox(
            height: setHeightSize(size: 5),
          ),
          list_product_model_post.length > 0
              ? SizedBox(
                  height: setWidthSize(size: 70),
                  child: buildListViewScrollDerectionVertiocal())
              : Container(),
          SizedBox(
            height: setHeightSize(size: 10),
          ),
          Text(
            "Chọn sản phẩm(Nhấn giữ để xem chi tiết)",
            style: styleTextHintBlack,
          ),
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
          Center(
            child: Container(
              child: StreamBuilder(
                stream: postProductAdsController.errStream,
                builder: (context, snapshot) => Text(
                  snapshot.hasError ? snapshot.error : '',
                  style: styleTextErrorBlack,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(setWidthSize(size: 10)),
            width: setWidthSize(size: 200),
            child: ButtonNormal(
              onTap: () async {
                List<String> list_document_id_post_ads = [];
                for (var item in list_product_model_post) {
                  list_document_id_post_ads.add(item.ducument_id_product);
                }
                await postProductAdsController
                    .onPostNotifyProductAds(
                        list_document_id_product: list_document_id_post_ads,
                        title: title,
                        content: content,
                        document_id_custommer: document_id_custommer)
                    .then((value) {
                  if (value == true) {
                    Navigator.pop(context);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDiaLogScreen(
                          title: "Thông báo",
                          message: "Gửi gợi ý sản phẩm thành công.",
                        );
                      },
                    );
                  }
                  if (value == false) {
                    {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDiaLogScreen(
                            title: "Thông báo",
                            message: "Thất bại vui lòng thử lại sau.",
                          );
                        },
                      );
                    }
                  }
                });
              },
              text: "Gửi thông báo",
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
              print(value);
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

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: setHeightSize(size: cardWidth / cardHeight),
      ),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => ButtonItemLike(
        like: listProductModel[index].like,
        seen: listProductModel[index].seen,
        itemLiked: false,
        urlImagesAvataProduct:
            listProductModel[index].url_images_avatar_product,
        acreageApartment: listProductModel[index].acreage_apartment.toString(),
        amountBedroom: listProductModel[index].amount_bedroom.toString(),
        district: listProductModel[index].district,
        price: listProductModel[index].price,
        nameApartment: listProductModel[index].name_apartment,
        is_selected: listProductModel[index].is_selected,
        onTap: () {
          if (list_product_model_post.contains(listProductModel[index]) ==
              false) {
            list_product_model_post.add(listProductModel[index]);
            setState(() {});
          }
        },
        onLongPress: () async {
          DetailProductModel detailProductModel = await getDetailProduct(
              document_id_product: listProductModel[index].ducument_id_product);
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  detailProductModel.document_id_real_estate);
          Navigator.pushNamed(
            context,
            DetailItemScreen.id,
            arguments: DetailItemScreen(
              itemLiked: false,
              is_detai_item_screen: true,
              isImagesURL: true,
              document_id_product: detailProductModel.document_id_product,
              cost: detailProductModel.cost,
              listImages: detailProductModel.list_images,
              nameApartment: listProductModel[index].name_apartment,
              acreageApartment:
                  listProductModel[index].acreage_apartment.toString(),
              amountBathrooms: detailProductModel.amount_bathrooms.toString(),
              amountBedroom: listProductModel[index].amount_bedroom.toString(),
              district: listProductModel[index].district,
              price: listProductModel[index].price,
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
      itemCount: listProductModel.length,
    );
  }

  Widget buildListViewScrollDerectionVertiocal() {
    return ListView.builder(
      itemCount: list_product_model_post.length,
      itemBuilder: (context, index) {
        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                list_product_model_post.removeAt(index);
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
                          horizontal: setWidthSize(size: 5),
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    list_product_model_post[index]
                                        .url_images_avatar_product),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    list_product_model_post[index]
                                        .name_apartment,
                                    style: styleTextContentBlack,
                                  ),
                                  Text(
                                    PriceFortmatMoney(
                                        value: double.parse(
                                            list_product_model_post[index]
                                                .price
                                                .toString()),
                                        symbol: true),
                                    style: styleTextContentBlack,
                                  )
                                ],
                              ),
                            ],
                          ),
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
                          list_product_model_post.removeAt(index);
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
