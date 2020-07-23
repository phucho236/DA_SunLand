import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_note_screen/note_screen.dart';
import 'package:flutter_core/view_system/group_user_need_contact/group_detai_user_need_contact/detail_user_need_contact_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/views/group_like_item/like_item_controller.dart';
import 'package:flutter_core/widgets/button_item_like.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetailUserNeedContact extends StatefulWidget {
  static String id = "DetailUserNeedContact";
  DetailUserNeedContact(
      {this.customerProfileModel,
      this.productNeedSuportModel,
      this.is_taked_screen = false,
      this.enable_button_edit = false});
  final ProductNeedSuportModel productNeedSuportModel;
  final CustomerProfileModel customerProfileModel;
  final bool is_taked_screen;
  final bool enable_button_edit;
  @override
  _DetailUserNeedContactState createState() => _DetailUserNeedContactState();
}

class _DetailUserNeedContactState extends State<DetailUserNeedContact> {
  double cardWidth = getScreenWidth() / 2;
  double cardHeight = getScreenHeight() / 2.6;
  bool itemLiked = false;
  String value_note;
  DetailUserNeedContact args;
  CustomerProfileModel customerProfileModelTaked = CustomerProfileModel();
  CustomerProfileModel customerProfileModelContacted = CustomerProfileModel();
  CustomerProfileModel customerProfileModelEdit = CustomerProfileModel();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductModel> listProduct = [];
  LikeItemController likeItemController = LikeItemController();
  DetailUserNeedContactController detailUserNeedContactController =
      DetailUserNeedContactController();
  String document_id_custommer;
  void get_document_id_custommer() async {
    String document_id_custommerTmp;
    document_id_custommerTmp = await getDocumentIdCustommer();

    if (document_id_custommerTmp != null) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  getCustommerProfileEdit(String document_id_custommer_edit) async {
    CustomerProfileModel customerProfileModelTakedTmp;
    customerProfileModelTakedTmp =
        await detailUserNeedContactController.getCustommerProfileUser(
            document_id_custommer: args.productNeedSuportModel.edit_by);
    if (customerProfileModelTakedTmp != null) {
      setState(() {
        customerProfileModelEdit = customerProfileModelTakedTmp;
      });
    }
  }

  getCustommerProfileTakeIt(args) async {
    CustomerProfileModel customerProfileModelTakedTmp;
    customerProfileModelTakedTmp =
        await detailUserNeedContactController.getCustommerProfileUser(
            document_id_custommer: args.productNeedSuportModel.taked_by);
    if (customerProfileModelTakedTmp != null) {
      setState(() {
        customerProfileModelTaked = customerProfileModelTakedTmp;
      });
    }
  }

  getCustommerProfileContactBy(args) async {
    CustomerProfileModel customerProfileModelTakedTmp = CustomerProfileModel();
    customerProfileModelTakedTmp =
        await detailUserNeedContactController.getCustommerProfileUser(
            document_id_custommer: args.productNeedSuportModel.contact_by);
    if (customerProfileModelTakedTmp != null) {
      setState(() {
        customerProfileModelContacted = customerProfileModelTakedTmp;
      });
    }
  }

  getListProduct(args) async {
    List<ProductModel> _listIDProductTmp = [];
    _listIDProductTmp =
        await detailUserNeedContactController.onGetListGetListProduct(
            list_item_like: List.from(
                args.productNeedSuportModel.list_document_id_product));
    if (_listIDProductTmp != null) {
      setState(() {
        listProduct = _listIDProductTmp;
      });
    }
  }

  getDetailProduct({String document_id_product}) async {
    return await detailUserNeedContactController.onGetDetailProduct(
        document_id_product: document_id_product);
  }

  getRealEstate({String document_id_real_estate}) async {
    return await detailUserNeedContactController.onGetRealEstate(
        document_id_real_estate: document_id_real_estate);
  }

  void onRefresh() async {
    //monitor fetch data from network
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) {
      getListProduct(args);
    }
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      get_document_id_custommer();
      getListProduct(args);
      if (args.productNeedSuportModel.edit_by != null) {
        getCustommerProfileEdit(args.productNeedSuportModel.edit_by);
      }
      getCustommerProfileTakeIt(args);
      getCustommerProfileContactBy(args);
      getCustommerProfileEdit(args.productNeedSuportModel.edit_by);
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
              title: Text("Thông tin liên lạc"),
              backgroundColor: colorAppbar,
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: args.customerProfileModel.linkImages == null
                            ? CircleAvatar(
                                radius: 60,
                                child: Container(
                                  margin:
                                      EdgeInsets.all(setWidthSize(size: 10)),
                                  child: Image.asset(
                                      "assets/images/library_image.png"),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(setWidthSize(size: 10)),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                      args.customerProfileModel.linkImages),
                                ),
                              ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              args.customerProfileModel.user_name,
                              style: styleTextTitleInBodyBlack,
                            ),
                            SizedBox(
                              height: setHeightSize(size: 5),
                            ),
                            Text(
                              args.customerProfileModel.email,
                              style: styleTextTitleInBodyBlack,
                            ),
                            SizedBox(
                              height: setHeightSize(size: 5),
                            ),
                            Text(
                              args.customerProfileModel.phone_number,
                              style: styleTextTitleInBodyBlack,
                            ),
                            SizedBox(
                              height: setHeightSize(size: 10),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "gửi yêu cầu lúc: ${getDateShow(args.productNeedSuportModel.post_at)}",
                                  style: styleTextContentBlack,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                args.is_taked_screen
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      width: setWidthSize(size: 5),
                                    ),
                                    Text(
                                      "Nhận xử lí bởi: ${customerProfileModelTaked.user_name}",
                                      style: styleTextContentBlack,
                                    ),
                                    Text(
                                      "Nhận xử lí lúc:${getDateShow(args.productNeedSuportModel.taked_at)}",
                                      style: styleTextContentBlack,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Trạng thái: ${args.productNeedSuportModel.contacted == false ? "Chưa xử lí" : "Đã xử lí"}",
                                      style: styleTextContentBlack,
                                    ),
                                    CupertinoButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          NoteScreen.id,
                                          arguments: NoteScreen(
                                            document_id_product_need_support: args
                                                .productNeedSuportModel
                                                .document_id_product_need_support,
                                          ),
                                        );
                                      },
                                      child: Text("Xem chú thích"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            args.productNeedSuportModel.edit_by != null
                                ? Column(
                                    children: <Widget>[
                                      Text(
                                        "Chỉnh sửa bởi: ${customerProfileModelContacted.user_name}",
                                        style: styleTextContentBlack,
                                      ),
                                      Text(
                                        "Chỉnh sửa vào:  ${getDateShow(args.productNeedSuportModel.last_edit)}",
                                        style: styleTextContentBlack,
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: setHeightSize(size: 5),
                            ),
                            args.productNeedSuportModel.contacted
                                ? Column(
                                    children: <Widget>[
                                      Text(
                                        "Xử lí xong bởi: ${customerProfileModelContacted.user_name}",
                                        style: styleTextContentBlack,
                                      ),
                                      Text(
                                        "Xử lí xong lúc:  ${getDateShow(args.productNeedSuportModel.contacted_at)}",
                                        style: styleTextContentBlack,
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container(),
                Text(
                  "Danh sách sản phẩm quan tâm",
                  style: styleTextTitleInBodyBlack,
                ),
                Expanded(
                  flex: 3,
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
                args.is_taked_screen == false
                    ? Container(
                        margin: EdgeInsets.all(setWidthSize(size: 10)),
                        width: setWidthSize(size: 200),
                        child: ButtonNormal(
                          onTap: () async {
                            await detailUserNeedContactController
                                .onSubmitUpdateProductNeedSuport(
                              document_id_product_need_sp: args
                                  .productNeedSuportModel
                                  .document_id_product_need_support,
                              taked: true,
                              document_id_custommer_taked:
                                  document_id_custommer,
                            );
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Nhận liên lạc thành công",
                                );
                              },
                            ).then((value) {
                              Navigator.pop(context, true);
                            });
                          },
                          text: "Nhận liên lạc",
                        ))
                    : args.productNeedSuportModel.contacted == false
                        ? Row(
                            children: <Widget>[
                              SizedBox(
                                width: setWidthSize(size: 10),
                              ),
                              Expanded(
                                child: args.enable_button_edit
                                    ? ButtonNormal(
                                        onTap: () async {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return buildAlertDialogPickUserSystem(
                                                document_id_product_need_sp: args
                                                    .productNeedSuportModel
                                                    .document_id_product_need_support,
                                                type: 1,
                                              );
                                            },
                                          ).then((value) {
                                            Navigator.pop(context, true);
                                          });
                                        },
                                        text: "Chỉnh sửa",
                                      )
                                    : ButtonNormal(
                                        onTap: () async {
                                          await detailUserNeedContactController
                                              .onSubmitUpdateProductNeedSuport(
                                                  document_id_product_need_sp: args
                                                      .productNeedSuportModel
                                                      .document_id_product_need_support,
                                                  contacted: true,
                                                  document_id_custommer_contact:
                                                      document_id_custommer);
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDiaLogScreen(
                                                title: "Thông báo",
                                                message: "Thành công",
                                              );
                                            },
                                          ).then((value) {
                                            Navigator.pop(context, true);
                                          });
                                        },
                                        text: "Xử lí xong",
                                      ),
                              ),
                              SizedBox(
                                width: setWidthSize(size: 10),
                              ),
                              Expanded(
                                child: ButtonNormal(
                                  onTap: () async {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          contentPadding: EdgeInsets.only(
                                              top: setHeightSize(size: 20)),
                                          title: Text("Nhập chú thích"),
                                          content: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      setWidthSize(size: 5)),
                                                  child: Material(
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          setWidthSize(
                                                              size: 10.0)),
                                                      child: Column(
                                                        children: <Widget>[
                                                          TextFieldBorder(
                                                            onChanged: (value) {
                                                              value_note =
                                                                  value;
                                                            },
                                                            hintText:
                                                                "chú thích",
                                                            colorTextWhite:
                                                                false,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height:
                                                      setHeightSize(size: 140),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: AssetImage(
                                                        "assets/images/background_dialog_1.png"),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Đóng")),
                                            FlatButton(
                                              onPressed: () async {
                                                await detailUserNeedContactController
                                                    .onSubmitPostNoteProductNeedSuport(
                                                        note: value_note,
                                                        document_id_product_need_sp: args
                                                            .productNeedSuportModel
                                                            .document_id_product_need_support)
                                                    .then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(
                                                        context, true);
                                                  } else {
                                                    Navigator.pop(
                                                        context, false);
                                                  }
                                                });
                                              },
                                              child: (Text("Đồng ý")),
                                            ),
                                          ],
                                        );
                                      },
                                    ).then((value) {
                                      if (value == true) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDiaLogScreen(
                                              title: "Thông báo",
                                              message:
                                                  "Thêm chú thích thành công",
                                            );
                                          },
                                        );
                                      }
                                    });
                                  },
                                  text: "Thêm chú thích",
                                ),
                              ),
                              SizedBox(
                                width: setWidthSize(size: 10),
                              ),
                            ],
                          )
                        : Container(
                            width: setWidthSize(size: 250),
                            child: ButtonNormal(
                              onTap: () async {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      contentPadding: EdgeInsets.only(
                                          top: setHeightSize(size: 20)),
                                      title: Text("Nhập chú thích"),
                                      content: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  setWidthSize(size: 5)),
                                              child: Material(
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      setWidthSize(size: 10.0)),
                                                  child: Column(
                                                    children: <Widget>[
                                                      TextFieldBorder(
                                                        onChanged: (value) {
                                                          value_note = value;
                                                        },
                                                        hintText: "chú thích",
                                                        colorTextWhite: false,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: setHeightSize(size: 140),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: AssetImage(
                                                    "assets/images/background_dialog_1.png"),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Đóng")),
                                        FlatButton(
                                          onPressed: () async {
                                            await detailUserNeedContactController
                                                .onSubmitPostNoteProductNeedSuport(
                                                    note: value_note,
                                                    document_id_product_need_sp: args
                                                        .productNeedSuportModel
                                                        .document_id_product_need_support)
                                                .then((value) {
                                              if (value == true) {
                                                Navigator.pop(context, true);
                                              } else {
                                                Navigator.pop(context, false);
                                              }
                                            });
                                          },
                                          child: (Text("Đồng ý")),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  if (value == true) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDiaLogScreen(
                                          title: "Thông báo",
                                          message: "Thêm chú thích thành công",
                                        );
                                      },
                                    );
                                  }
                                });
                              },
                              text: "Thêm chú thích",
                            ),
                          ),
                SizedBox(
                  height: setHeightSize(size: 10),
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
              is_preview_item_screen: false,
              itemLiked: false,
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

class buildAlertDialogPickUserSystem extends StatefulWidget {
  buildAlertDialogPickUserSystem({this.type, this.document_id_product_need_sp});
  final int type;
  final document_id_product_need_sp;
  @override
  _buildAlertDialogPickUserSystemState createState() =>
      _buildAlertDialogPickUserSystemState();
}

class _buildAlertDialogPickUserSystemState
    extends State<buildAlertDialogPickUserSystem> {
  DetailUserNeedContactController detailUserNeedContactController =
      new DetailUserNeedContactController();
  List<CustomerProfileModel> listCustommerProfile = [];

  FindCustommerProfileByEmailOrUserName({String email, int type}) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp = await detailUserNeedContactController
        .onFindCustommerProfileByEmail(email: email, type: type);
    if (customerProfileModelTmp != null) {
      setState(() {
        listCustommerProfile = [customerProfileModelTmp];
      });
    } else {
      setState(() {
        listCustommerProfile = [];
      });
    }
  }

  getListDataCustommerProfile({num type}) async {
    List<CustomerProfileModel> listCustommerProfileTmp = [];
    listCustommerProfileTmp = await detailUserNeedContactController
        .onGetListCustommerProfile(type: type);
    if (listCustommerProfileTmp.length > 0) {
      setState(() {
        listCustommerProfile = listCustommerProfileTmp;
      });
    } else
      setState(() {
        listCustommerProfile = [];
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListDataCustommerProfile(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text(
        "Chọn nhân viên xử lí",
        style: styleTextTitleInAppBarBlack,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(setWidthSize(size: 10)),
            child: Search_TextField_Border(
              borderRadius: 5,
              hintText: "Nhập email.",
              sizeBorder: 2,
              colorBorDer: Colors.white,
              onChanged: (value) async {
                await FindCustommerProfileByEmailOrUserName(
                    email: value, type: widget.type);
                if (value == "") {
                  getListDataCustommerProfile(type: widget.type);
                }
              },
            ),
          ),
          Container(
            height: setHeightSize(size: 350),
            width: setWidthSize(size: 300),
            child: ListView.builder(
              padding: EdgeInsets.all(setWidthSize(size: 15)),
              itemCount: listCustommerProfile.length,
              itemBuilder: (BuildContext context, int index) {
                return listCustommerProfile.length > 0
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          await detailUserNeedContactController
                              .onSubmitUpdateUserTakedNeedSuport(
                                  document_id_custommer_edit:
                                      await getDocumentIdCustommer(),
                                  document_id_product_need_sp:
                                      widget.document_id_product_need_sp,
                                  document_id_custommer_taked:
                                      listCustommerProfile[index]
                                          .document_id_custommer)
                              .then((value) {
                            if (value == true) {
                              Navigator.pop(context, true);
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDiaLogScreen(
                                    title: "Thông báo",
                                    message:
                                        "Chỉnh sửa người xử lí thành công.",
                                  );
                                },
                              );
                            }
                            if (value == false) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDiaLogScreen(
                                    title: "Thông báo",
                                    message: "Có lỗi vui lòng thử lại sau.",
                                  );
                                },
                              );
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: setWidthSize(size: 5),
                            horizontal: setWidthSize(size: 5),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                listCustommerProfile[index].linkImages != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            listCustommerProfile[index]
                                                .linkImages),
                                        radius: 30.0,
                                      )
                                    : CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/library_image.png"),
                                        radius: 30.0,
                                      ),
                                SizedBox(
                                  width: setWidthSize(size: 10),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      listCustommerProfile[index].email,
                                      style: styleTextContentBlack,
                                    ),
                                    Text(
                                      listCustommerProfile[index].user_name,
                                      style: styleTextContentBlack,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                        "Không có dữ liệu",
                        style: styleTextContentBlack,
                      ));
              },
            ),
          ),
          Container(
            height: setHeightSize(size: 140),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background_dialog_1.png"),
            )),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text("Đóng"))
      ],
    );
    ;
  }
}
