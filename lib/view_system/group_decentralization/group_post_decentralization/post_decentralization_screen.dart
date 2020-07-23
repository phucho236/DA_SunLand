import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_decentralization/group_create_group_decentralization/dialog_create_group_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_post_decentralization/post_decentralization_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostDecentralizationScreen extends StatefulWidget {
  static String id = "PostDecentralizationScreen";
  @override
  _PostDecentralizationScreenState createState() =>
      _PostDecentralizationScreenState();
}

class _PostDecentralizationScreenState
    extends State<PostDecentralizationScreen> {
  PostDecentralizationController postDecentralizationController =
      PostDecentralizationController();
  String nameGroup;
  List<String> listNameGroup = [];
  List<CustomerProfileModel> listCustomerProfileModelPost = [];
  List<CustomerProfileModel> listCustomerProfileModel = [];
  String document_id_custommer_admin;

  getListNameGroupDecentralization() async {
    List<String> listNameGroupTmp = [];
    listNameGroupTmp = await postDecentralizationController
        .onGetListNameGroupDecentralization();
    if (listNameGroupTmp != null) {
      setState(() {
        listNameGroup = listNameGroupTmp;
      });
    }
  }

  FindCustommerProfileByEmailOrUserName({String email}) async {
    List<CustomerProfileModel> listcustomerProfileModelTmp = [];
    CustomerProfileModel customerProfileModelTmp = CustomerProfileModel();
    customerProfileModelTmp = await postDecentralizationController
        .onFindCustommerProfileByEmailOrUserName(email: email);
    if (customerProfileModelTmp != null) {
      listcustomerProfileModelTmp.add(customerProfileModelTmp);
      listcustomerProfileModelTmp.removeWhere((element) =>
          element.document_id_custommer == document_id_custommer_admin);

      for (var item in listCustomerProfileModelPost) {
        setState(() {
          listcustomerProfileModelTmp.removeWhere((element) =>
              element.document_id_custommer == item.document_id_custommer);
        });
      }
    }
    setState(() {
      listCustomerProfileModel = listcustomerProfileModelTmp;
    });
  }

  makeListCustommerProfileReal() {
    for (var item in listCustomerProfileModelPost) {
      setState(() {
        listCustomerProfileModel.remove(item);
      });
    }
  }

  getDocuemntIDCustommerAdmin() async {
    String document_id_custommer_adminTmp;
    document_id_custommer_adminTmp =
        await postDecentralizationController.onGetDocumetIdCustommerAdmin();
    if (document_id_custommer_adminTmp != null) {
      setState(() {
        document_id_custommer_admin = document_id_custommer_adminTmp;
      });
    }
  }

  getCustommerProfile() async {
    if (document_id_custommer_admin == null) {
      await getDocuemntIDCustommerAdmin();
    }
    List<CustomerProfileModel> listCustomerProfileModelTmp = [];
    listCustomerProfileModelTmp =
        await postDecentralizationController.onGetListCustommerProfile();
    if (listCustomerProfileModelTmp != null) {
      listCustomerProfileModelTmp.removeWhere((element) =>
          element.document_id_custommer == document_id_custommer_admin);
      for (var item in listCustomerProfileModelPost) {
        listCustomerProfileModelTmp.removeWhere((element) =>
            element.document_id_custommer == item.document_id_custommer);
      }
      setState(() {
        listCustomerProfileModel = listCustomerProfileModelTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocuemntIDCustommerAdmin();
    getListNameGroupDecentralization();
    getCustommerProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Thêm người dùng vào nhóm",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(setWidthSize(size: 10.0)),
                          child: CustomPaint(
                            painter: MyPainter(
                                radius: 60,
                                borderWidth: 2,
                                colorBoder: Colors.white),
                            child: Container(
                              height: setHeightSize(size: 45),
                              child: DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: setWidthSize(size: 15)),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: nameGroup,
                                          onChanged: (String value) {
                                            setState(() {
                                              nameGroup = value;
                                            });
                                          },
                                          style: styleTextContentBlack,
                                          hint: Text(
                                            'Nhóm quyền',
                                            style: styleTextHintBlack,
                                          ),
                                          icon: Icon(Icons.arrow_drop_down),
                                          items: listNameGroup
                                              .map((String nameGroup) {
                                            return DropdownMenuItem<String>(
                                              value: nameGroup,
                                              child: Text(
                                                nameGroup,
                                                style: styleTextContentBlack,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogCreateGroupDecentralization();
                                              },
                                            ).then((value) {
                                              if (value == true) {
                                                getListNameGroupDecentralization();
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add_circle))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: setHeightSize(size: 10),
                      ),
                      Text(
                        "Danh sách người dùng",
                        style: styleTextTitleInBodyBlack,
                      ),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(setWidthSize(size: 10.0)),
                          child: Column(
                            children: <Widget>[
                              Search_TextField_Border(
                                borderRadius: 5,
                                hintText: "Nhập email.",
                                sizeBorder: 2,
                                colorBorDer: Colors.white,
                                onChanged: (value) async {
                                  await FindCustommerProfileByEmailOrUserName(
                                      email: value);
                                  if (value == "") {
                                    getCustommerProfile();
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              listCustomerProfileModel.length < 1
                                  ? Container(
                                      height: setHeightSize(size: 350),
                                      child: Text(
                                        "Không có dữ liệu",
                                        style: styleTextHintBlack,
                                      ),
                                    )
                                  : Container(
                                      height: setHeightSize(size: 350),
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(
                                            setWidthSize(size: 15)),
                                        itemCount:
                                            listCustomerProfileModel.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              listCustomerProfileModelPost.add(
                                                  listCustomerProfileModel[
                                                      index]);
                                              makeListCustommerProfileReal();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical: setWidthSize(size: 5),
                                                horizontal:
                                                    setWidthSize(size: 5),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    listCustomerProfileModel[
                                                                    index]
                                                                .linkImages !=
                                                            null
                                                        ? CircleAvatar(
                                                            backgroundImage: NetworkImage(
                                                                listCustomerProfileModel[
                                                                        index]
                                                                    .linkImages),
                                                            radius: 30.0,
                                                          )
                                                        : CircleAvatar(
                                                            backgroundImage:
                                                                AssetImage(
                                                                    "assets/images/library_image.png"),
                                                            radius: 30.0,
                                                          ),
                                                    SizedBox(
                                                      width: setWidthSize(
                                                          size: 10),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          listCustomerProfileModel[
                                                                  index]
                                                              .email,
                                                          style:
                                                              styleTextContentBlack,
                                                        ),
                                                        Text(
                                                          listCustomerProfileModel[
                                                                  index]
                                                              .user_name,
                                                          style:
                                                              styleTextContentBlack,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      listCustomerProfileModelPost == null
                          ? Container()
                          : Container(
                              height: setHeightSize(size: 70),
                              child: buildListViewScrollDerectionVertiocal(),
                            ),
                      Center(
                        child: Container(
                          child: StreamBuilder(
                            stream: postDecentralizationController.errStream,
                            builder: (context, snapshot) => Text(
                              snapshot.hasError ? snapshot.error : '',
                              style: styleTextErrorBlack,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: setWidthSize(size: 200),
                        child: ButtonNormal(
                          onTap: () async {
                            await postDecentralizationController
                                .onCreateDecentralization(
                                    id_group_permission: nameGroup,
                                    list_custommer_profile_model:
                                        listCustomerProfileModelPost)
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
                                          "Thêm người dùng vào nhóm thành công",
                                    );
                                  },
                                );
                              }
                            });
                          },
                          text: "Thêm",
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListViewScrollDerectionVertiocal() {
    return ListView.builder(
      itemCount: listCustomerProfileModelPost.length,
      itemBuilder: (context, index) {
        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                listCustomerProfileModel
                    .add(listCustomerProfileModelPost[index]);
                listCustomerProfileModelPost.removeAt(index);
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
                              listCustomerProfileModelPost[index].linkImages !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          listCustomerProfileModelPost[index]
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
                                    listCustomerProfileModelPost[index]
                                        .user_name,
                                    style: styleTextContentBlack,
                                  ),
                                  Text(
                                    listCustomerProfileModelPost[index].email,
                                    style: styleTextContentBlack,
                                  ),
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
                          listCustomerProfileModel
                              .add(listCustomerProfileModelPost[index]);
                          listCustomerProfileModelPost.removeAt(index);
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
