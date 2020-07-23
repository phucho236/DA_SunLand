import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_product_ads/group_detail_product_ads/detail_product_ads_screen.dart';
import 'package:flutter_core/view_system/group_product_ads/group_product_ads/product_ads_controller.dart';
import 'package:flutter_core/view_system/group_product_ads/post_product_ads/post_product_ads_screen.dart';

class ProductAdsScreen extends StatefulWidget {
  static String id = "ProductAdsScreen";
  @override
  _ProductAdsScreenState createState() => _ProductAdsScreenState();
}

class _ProductAdsScreenState extends State<ProductAdsScreen> {
  bool isLoading = false;
  ProductAdsController productAdsController = ProductAdsController();
  List<NotifiProductAdsModel> _result = [];
  CustomerProfileModel customerProfileModelPostAds = CustomerProfileModel();
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Getdata();
    // TODO: implement initState
    super.initState();
  }

  void Getdata() async {
    var _resulttmp = await productAdsController.onLoadScreenProductAds();
    if (_resulttmp.length > 0) {
      setState(() {
        isLoading = false;
        _result = _resulttmp;
      });
    } else {
      setState(() {
        isLoading = false;
        _result = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách thông báo"),
        centerTitle: true,
        backgroundColor: colorAppbar,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : ListView.builder(
              itemCount: _result.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemDetailProductAds(
                  result: _result[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DeatailProductAdsnScreen.id,
                      arguments: DeatailProductAdsnScreen(
                        notifiProductAdsModel: _result[index],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorAppbar,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, PostProductAdsScreen.id);
        },
      ),
    );
  }
}

class ItemDetailProductAds extends StatefulWidget {
  ItemDetailProductAds({this.result, this.onTap});
  final NotifiProductAdsModel result;
  final Function onTap;
  @override
  _ItemDetailProductAdsState createState() => _ItemDetailProductAdsState();
}

class _ItemDetailProductAdsState extends State<ItemDetailProductAds> {
  ProductAdsController productAdsController = ProductAdsController();
  CustomerProfileModel customerProfileModel = CustomerProfileModel();
  getCustommerProfileUserPost({String document_id_custommer}) async {
    CustomerProfileModel customerProfileModelPostAdsTmp =
        CustomerProfileModel();
    customerProfileModelPostAdsTmp =
        await productAdsController.getCustommerProfileUserPost(
            document_id_custommer: document_id_custommer);
    if (customerProfileModelPostAdsTmp != null) {
      setState(() {
        customerProfileModel = customerProfileModelPostAdsTmp;
      });
    }
  }

  @override
  void initState() {
    getCustommerProfileUserPost(document_id_custommer: widget.result.post_by);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: setHeightSize(size: 20)),
                        child: Icon(
                          Icons.notifications_active,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.result.title,
                            style: styleTextTitleInBodyBlack,
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
                  "Nội dung: ${widget.result.content}",
                  style: styleTextContentBlack,
                  textAlign: TextAlign.start,
                ),
                Text(
                  "Trạng thái: ${widget.result.removed ? "Không hoạt động." : "Hoạt động"}",
                  style: styleTextHintBlack,
                ),
                Text(
                  "Đăng vào :${getDateShow(widget.result.post_at)}",
                  style: styleTextHintBlack,
                ),
                Text(
                  "Đăng bởi:${customerProfileModel.user_name}",
                  style: styleTextHintBlack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
