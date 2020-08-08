import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_edit_product/edit_product_controller.dart';
import 'package:flutter_core/widgets/button_item.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_core/view_system/group_dialog_filter_search/dialog_filter_search.dart';
import 'edit_detail_product_screen.dart';

class GridViewShowProductEditScreen extends StatefulWidget {
  static String id = "GridViewShowProductEditScreen";
  GridViewShowProductEditScreen({this.permisstion_post_project});
  final bool permisstion_post_project;
  @override
  _GridViewShowProductEditScreenState createState() =>
      _GridViewShowProductEditScreenState();
}

class _GridViewShowProductEditScreenState
    extends State<GridViewShowProductEditScreen> {
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  String document_id_custommer;
  bool isLoading = false;
  bool onfind = false;

  List<dynamic> list_item_like = [];
  num type;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProduct = [];
  List<ProductModel> listProductFind = [];
  EditProductController editProductController = EditProductController();
  bool checkItemLiked({String document_id_product}) {
    for (var item in list_item_like) {
      if (item == document_id_product) {
        return true;
      }
    }
    return false;
  }

  getListProductFilter({List<String> list_document_id_product}) async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp = await editProductController
        .onGetListProductFilter(list_document_id_product);
    if (_listIDProductTmp.length > 0) {
      setState(() {
        listProduct = _listIDProductTmp;

        onfind = false;
      });
    }
  }

  getListProduct() async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp = await editProductController.onGetListGetListProduct();
    if (_listIDProductTmp.length > 0) {
      setState(() {
        listProduct = _listIDProductTmp;
        onfind = false;
        isLoading = false;
      });
    } else {
      setState(() {
        listProduct = [];
        isLoading = false;
        onfind = false;
      });
    }
  }

  getProductFind({String name_or_document_id_product}) async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp = await editProductController.onGetProductFindByNameOrId(
        name_or_id: name_or_document_id_product);
    if (_listIDProductTmp.length >= 0) {
      setState(() {
        listProductFind = _listIDProductTmp;
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await editProductController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  getDetailProduct({String document_id_product}) async {
    return await editProductController.onGetDetailProduct(
        document_id_product: document_id_product);
  }

  void onLoading() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
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
    setState(() {
      isLoading = true;
    });
    getListProduct();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GridViewShowProductEditScreen args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text("Chọn sản phẩm cần chỉnh sửa"),
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
                      if (value != "") {
                        onfind = true;
                      } else {
                        onfind = false;
                      }
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                    child: SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  child: onfind
                      ? listProductFind.length > 0
                          ? buildGridViewFind()
                          : Center(
                              child: Text(
                              "Không có dữ liệu",
                              style: styleTextContentBlack,
                            ))
                      : listProduct.length > 0
                          ? buildGridView(args)
                          : Center(
                              child: Text(
                              "Không tìm thấy sản phẩm",
                              style: styleTextContentBlack,
                            )),
                  header: WaterDropHeader(),
                  onRefresh: onRefresh,
                  onLoading: onLoading,
                )),
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
                onfind = false;
              }
            }
          });
        },
        child: Icon(Icons.search),
      ),
    );
  }

  Widget buildGridView(args) {
    return GridView.builder(
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
        urlImagesAvataProduct: listProduct[index].url_images_avatar_product,
        acreageApartment: listProduct[index].acreage_apartment.toString(),
        amountBedroom: listProduct[index].amount_bedroom.toString(),
        district: listProduct[index].district,
        price: listProduct[index].price,
        nameApartment: listProduct[index].name_apartment,
        onTap: () async {
          DetailProductModel detailProductModel = await getDetailProduct(
              document_id_product: listProduct[index].ducument_id_product);
          print(detailProductModel.document_id_detail_product);
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  detailProductModel.document_id_real_estate);
          print(realEstateModel.document_id_estate);
          Navigator.pushNamed(context, EditDetailProductScreen.id,
              arguments: EditDetailProductScreen(
                permisstion_add_project: args.permisstion_post_project,
                productModel: listProduct[index],
                detailProductModel: detailProductModel,
                realEstateModel: realEstateModel,
              )).then((value) {
            if (value != null) {
              getListProduct();
              onfind = false;
            }
          });
        },
      ),
      itemCount: listProduct.length,
    );
  }

  Widget buildGridViewFind() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: setHeightSize(size: cardWidth / cardHeight),
      ),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => ButtonItem(
        seen: listProductFind[index].seen,
        itemLiked: checkItemLiked(
            document_id_product: listProductFind[index].ducument_id_product),
        urlImagesAvataProduct: listProductFind[index].url_images_avatar_product,
        acreageApartment: listProductFind[index].acreage_apartment.toString(),
        amountBedroom: listProductFind[index].amount_bedroom.toString(),
        district: listProductFind[index].district,
        price: listProductFind[index].price,
        nameApartment: listProductFind[index].name_apartment,
        onTap: () async {
          DetailProductModel detailProductModel = await getDetailProduct(
              document_id_product: listProductFind[index].ducument_id_product);
          print(detailProductModel.document_id_detail_product);
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  detailProductModel.document_id_real_estate);
          print(realEstateModel.document_id_estate);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return EditDetailProductScreen(
                productModel: listProductFind[index],
                detailProductModel: detailProductModel,
                realEstateModel: realEstateModel,
              );
            },
          ).then((value) {
            if (value == true) {
              getListProduct();
              onfind = false;
            }
          });
        },
      ),
      itemCount: listProductFind.length,
    );
  }
}
