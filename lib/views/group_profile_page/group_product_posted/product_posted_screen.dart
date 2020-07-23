import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_edit_product/edit_detail_product_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/views/group_profile_page/group_product_posted/product_posted_controller.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductPostedScreen extends StatefulWidget {
  static String id = "ProductPostedScreen";
  @override
  _ProductPostedScreenState createState() => _ProductPostedScreenState();
}

class _ProductPostedScreenState extends State<ProductPostedScreen> {
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ProductModel> listProduct = [];
  List<DetailProductModel> listDetailProduct = [];
  String document_id_custommer;
  ProductPostedController productPostedController = ProductPostedController();
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;

  getDocumentIdCustommer_() async {
    document_id_custommer = await getDocumentIdCustommer();
  }

  getlistProduct({List<DetailProductModel> listDetailProduct_}) async {
    List<ProductModel> _listProduct = [];
    _listProduct = await productPostedController.onLoadGetProduct(
        listDetailProductModel: listDetailProduct_);
    if (_listProduct.length > 0) {
      setState(() {
        isLoading = false;
        listProduct = _listProduct;
      });
    }
  }

  getDetailProduct() async {
    List<DetailProductModel> listDetailProductTmp;
    listDetailProductTmp =
        await productPostedController.onLoadGetListDetailProductPostByUser(
            document_id_custommer: document_id_custommer);
    if (listDetailProductTmp.length > 0) {
      setState(() {
        listDetailProduct = listDetailProductTmp;
      });
      getlistProduct(listDetailProduct_: listDetailProductTmp);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await productPostedController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  void onRefresh() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    getDetailProduct();

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
    getDocumentIdCustommer_();
    getDetailProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Sản phẩm đã đăng",
          style: styleTextTitleInAppWhite,
        ),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Column(
              children: <Widget>[
                SizedBox(
                  height: setHeightSize(size: 10),
                ),
                Text(
                  "Nhấn để xem chi tiết, Nhân giữ để sửa sản phẩm",
                  style: styleTextHintBlack,
                ),
                SizedBox(
                  height: setHeightSize(size: 10),
                ),
                Expanded(
                  child: SmartRefresher(
                    //reverse: true,
                    //enablePullDown: tr,
                    controller: _refreshController,
                    enablePullUp: false,
                    child: listProduct.length < 1
                        ? Center(
                            child: Text(
                              "Không có dữ liệu",
                              style: styleTextContentBlack,
                            ),
                          )
                        : buildGridView(),
                    header: WaterDropHeader(),
                    onRefresh: onRefresh,
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
        show_censored: true,
        censored: listDetailProduct[index].censored,
        urlImagesAvataProduct: listProduct[index].url_images_avatar_product,
        acreageApartment: listProduct[index].acreage_apartment.toString(),
        amountBedroom: listProduct[index].amount_bedroom.toString(),
        district: listProduct[index].district,
        price: listProduct[index].price,
        nameApartment: listProduct[index].name_apartment,
        like: listProduct[index].like,
        seen: listProduct[index].seen,
        onLongPress: () async {
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  listDetailProduct[index].document_id_real_estate);
          Navigator.pushNamed(context, EditDetailProductScreen.id,
              arguments: EditDetailProductScreen(
                permisstion_add_project: false,
                productModel: listProduct[index],
                detailProductModel: listDetailProduct[index],
                realEstateModel: realEstateModel,
              )).then((value) {
            if (value == true) {
              getDetailProduct();
            }
          });
        },
        onTap: () async {
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  listDetailProduct[index].document_id_real_estate);
          Navigator.pushNamed(
            context,
            DetailItemScreen.id,
            arguments: DetailItemScreen(
              detailProductModel: listDetailProduct[index],
              is_detai_item_screen: false,
              view_only: true,
              isImagesURL: true,
              document_id_product: listDetailProduct[index].document_id_product,
              cost: listDetailProduct[index].cost,
              listImages: listDetailProduct[index].list_images,
              nameApartment: listProduct[index].name_apartment,
              acreageApartment: listProduct[index].acreage_apartment.toString(),
              amountBathrooms:
                  listDetailProduct[index].amount_bathrooms.toString(),
              amountBedroom: listProduct[index].amount_bedroom.toString(),
              district: listProduct[index].district,
              price: listProduct[index].price,
              realEstate: realEstateModel.name_real_estate,
              typeApartment: listDetailProduct[index].type_apartment,
              typeFloor: listDetailProduct[index].type_floor,
              listItemInfrastructure:
                  listDetailProduct[index].list_item_infrastructure,
            ),
          );
        },
      ),
      itemCount: listProduct.length,
    );
  }
}
