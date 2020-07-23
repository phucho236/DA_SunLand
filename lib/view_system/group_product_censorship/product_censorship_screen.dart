import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_edit_product/edit_detail_product_screen.dart';
import 'package:flutter_core/view_system/group_product_censorship/product_censorship_controller.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/widgets/button_item.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductCensorshipScreen extends StatefulWidget {
  static String id = "ProductCensorshipScreen";
  @override
  _ProductCensorshipScreenState createState() =>
      _ProductCensorshipScreenState();
}

class _ProductCensorshipScreenState extends State<ProductCensorshipScreen> {
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ProductModel> listIDProductNeedApproval = [];
  ProductCensorshipController productCensorshipController =
      ProductCensorshipController();
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;

  getlistIDProductNeedApproval() async {
    List<ProductModel> _listIDProductNeedApprovalTmp = [];
    _listIDProductNeedApprovalTmp =
        await productCensorshipController.onGetListGetListProductNeedApproval();
    if (_listIDProductNeedApprovalTmp.length > 0) {
      isLoading = false;
      listIDProductNeedApproval = _listIDProductNeedApprovalTmp;
      setState(() {});
    } else {
      setState(() {
        isLoading = false;
        listIDProductNeedApproval = [];
      });
    }
  }

  getDetailProduct({String document_id_product}) async {
    return await productCensorshipController.onGetDetailProductNeedApproval(
        document_id_product: document_id_product);
  }

  getRealEstate({String document_id_real_estate}) async {
    return await productCensorshipController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  void onRefresh() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    getlistIDProductNeedApproval();

    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getlistIDProductNeedApproval();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Duyệt sản phẩm",
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
          : SingleChildScrollView(
              //padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 10)),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Sản phẩm chờ duyệt",
                        style: styleTextTitleInBodyBlack,
                      ),
                      Text(
                        "(Nhấn giữ để chỉnh sửa sản phẩm)",
                        style: styleTextHintBlack,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  SizedBox(
                    height: setHeightSize(
                        size: getScreenHeight() - getBottomBarHeight() * 6),
                    child: SmartRefresher(
                      //reverse: true,
                      //enablePullDown: tr,
                      controller: _refreshController,
                      enablePullUp: false,
                      child: listIDProductNeedApproval.length < 1
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
        like: listIDProductNeedApproval[index].like,
        seen: listIDProductNeedApproval[index].seen,
        onLongPress: () async {
          DetailProductModel detailProductModel = await getDetailProduct(
              document_id_product:
                  listIDProductNeedApproval[index].ducument_id_product);
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  detailProductModel.document_id_real_estate);
          Navigator.pushNamed(
            context,
            EditDetailProductScreen.id,
            arguments: EditDetailProductScreen(
              productModel: listIDProductNeedApproval[index],
              detailProductModel: detailProductModel,
              realEstateModel: realEstateModel,
            ),
          ).then((value) {
            if (value == true) {
              getDetailProduct();
            }
          });
        },
        urlImagesAvataProduct:
            listIDProductNeedApproval[index].url_images_avatar_product,
        acreageApartment:
            listIDProductNeedApproval[index].acreage_apartment.toString(),
        amountBedroom:
            listIDProductNeedApproval[index].amount_bedroom.toString(),
        district: listIDProductNeedApproval[index].district,
        price: listIDProductNeedApproval[index].price,
        nameApartment: listIDProductNeedApproval[index].name_apartment,
        onTap: () async {
          DetailProductModel detailProductModel = await getDetailProduct(
              document_id_product:
                  listIDProductNeedApproval[index].ducument_id_product);
          RealEstateModel realEstateModel = await getRealEstate(
              document_id_real_estate:
                  detailProductModel.document_id_real_estate);
          Navigator.pushNamed(
            context,
            DetailItemScreen.id,
            arguments: DetailItemScreen(
              detailProductModel: detailProductModel,
              isImagesURL: true,
              document_id_product: detailProductModel.document_id_product,
              cost: detailProductModel.cost,
              listImages: detailProductModel.list_images,
              nameApartment: listIDProductNeedApproval[index].name_apartment,
              acreageApartment:
                  listIDProductNeedApproval[index].acreage_apartment.toString(),
              amountBathrooms: detailProductModel.amount_bathrooms.toString(),
              amountBedroom:
                  listIDProductNeedApproval[index].amount_bedroom.toString(),
              district: listIDProductNeedApproval[index].district,
              price: listIDProductNeedApproval[index].price,
              realEstate: realEstateModel.name_real_estate,
              typeApartment: detailProductModel.type_apartment,
              typeFloor: detailProductModel.type_floor,
              listItemInfrastructure:
                  detailProductModel.list_item_infrastructure,
            ),
          ).then((value) {
            if (value == true) {
              getlistIDProductNeedApproval();
            }
          });
        },
      ),
      itemCount: listIDProductNeedApproval.length,
    );
  }
}
