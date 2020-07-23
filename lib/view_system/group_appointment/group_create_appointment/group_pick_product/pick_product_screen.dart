import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_appointment/group_create_appointment/group_pick_product/pick_product_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/views/group_like_item/like_item_controller.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PickProductScreen extends StatefulWidget {
  static String id = "PickProductScreen";
  @override
  _PickProductScreenState createState() => _PickProductScreenState();
}

class _PickProductScreenState extends State<PickProductScreen>
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text("Danh sách sản phẩm"),
      ),
      body: BuildLikeScreen(),
    );
  }
}

class BuildLikeScreen extends StatefulWidget {
  @override
  _BuildLikeScreenState createState() => _BuildLikeScreenState();
}

class _BuildLikeScreenState extends State<BuildLikeScreen> {
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  List<String> list_item_like = [];
  List<String> list_product = [];
  List<ProductModel> listProductModel = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  PickProductController pickProductController = PickProductController();
  bool is_slected = false;

  bool checkItemLiked({String document_id_product}) {
    for (var item in list_item_like) {
      if (item == document_id_product) {
        return true;
      }
    }
    return false;
  }

  getListProduct() async {
    await getListIDProductcensored();
    List<ProductModel> _listProductModelTmp = [];
    _listProductModelTmp = await pickProductController.onGetListGetListProduct(
        list_product: list_product);
    if (_listProductModelTmp.length > 0) {
      if (mounted) {
        setState(() {
          listProductModel = _listProductModelTmp;
        });
      }
    }
  }

  getListIDProductcensored() async {
    List<String> list_document_id_product_tmp = [];
    list_document_id_product_tmp =
        await pickProductController.onLoadGetListProductCensored();
    if (list_document_id_product_tmp.length > 0) {
      setState(() {
        list_product = list_document_id_product_tmp;
      });
    }
  }

  getRealEstate({String document_id_real_estate}) async {
    return await pickProductController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  onUpdateSeenProduct({String document_id_product}) async {
    return await pickProductController.onUpdateSeenProduct(
        document_id_product: document_id_product);
  }

  void onLoading() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  getDetailProduct({String document_id_product}) async {
    return await pickProductController.onGetDetailProduct(
        document_id_product: document_id_product);
  }

  void onRefresh() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) {
      getListProduct();
    }

    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              "Nhấn giữ để xem chi tiết sản phẩm \nTap để chọn sản phẩm",
              style: styleTextHintBlack,
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullUp: false,
              child: buildGridView(listProductModel),
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

  Widget buildGridView(listProduct) {
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
        onTap: () {
          Navigator.pop(context, listProduct[index]);
        },
        onLongPress: () async {
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
              view_only: true,
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
