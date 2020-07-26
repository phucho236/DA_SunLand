import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_decentralization/group_detail_decentralization/detail_decentralization_controller.dart';
import 'package:flutter_core/view_system/group_decentralization/group_edit_decentralization/dialog_edit_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_edit_user_in_group_decentralization/remove_user_in_group_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_post_decentralization/post_decentralization_screen.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetailDecentralizationScreen extends StatefulWidget {
  static String id = "DetailDecentralizationScreen";
  DetailDecentralizationScreen({this.group_decentralization});
  final GroupDecentralizationModel group_decentralization;
  @override
  _DetailDecentralizationScreenState createState() =>
      _DetailDecentralizationScreenState();
}

class _DetailDecentralizationScreenState
    extends State<DetailDecentralizationScreen>
    with SingleTickerProviderStateMixin {
  DetailDecentralizationScreen args;
  bool isLoading = false;
  DetailDecentralizationController decentralizationController =
      DetailDecentralizationController();
  CustomerProfileModel custommerProfilePost = CustomerProfileModel();
  CustomerProfileModel custommerProfileLastEdit = CustomerProfileModel();
  List<CustomerProfileModel> listCustommerProfile = [];
  GroupDecentralizationModel groupDecentralizationModel;
  TabController _tabController;
  String document_id_custommer;
  List<PermistionModel> listPermisstionModelInSystemUse =
      listPermisstionModelInSystem;
  onGetDocumentIdCustommer() async {
    String document_id_custommertmp;
    document_id_custommertmp = await getDocumentIdCustommer();
    if (document_id_custommertmp != null) {
      setState(() {
        document_id_custommer = document_id_custommertmp;
      });
    }
  }

  onGetListlistPermisstionModelInSystemUse(groupDecentralizationModel) {
    if (groupDecentralizationModel.list_permission.length > 0) {
      for (var item in groupDecentralizationModel.list_permission) {
        for (var item1 in listPermisstionModelInSystemUse) {
          if (item == item1.id) {
            item1.isSelected = true;
            break;
          }
        }
      }
    } else {
      for (var item1 in listPermisstionModelInSystemUse) {
        item1.isSelected = false;
      }
    }
    setState(() {});
  }

  onGetListDataCustommerProfileInGroup(groupDecentralizationModel) async {
    List<CustomerProfileModel> listCustommerProfileTmp = [];
    listCustommerProfileTmp =
        await decentralizationController.onGetListDataCustommerProfileInGroup(
            document_id_group_permission:
                groupDecentralizationModel.document_id_group);
    if (listCustommerProfileTmp != null) {
      setState(() {
        listCustommerProfile = listCustommerProfileTmp;
      });
    }
  }

  getDetailGroupPermisstion(
      GroupDecentralizationModel groupDecentralizationModel_) async {
    GroupDecentralizationModel group_permistionTmp =
        GroupDecentralizationModel();
    group_permistionTmp =
        await decentralizationController.onGetGroupDecentralization(
            document_id_group_decentralizatio:
                groupDecentralizationModel_.document_id_group);
    if (group_permistionTmp != null) {
      setState(() {
        groupDecentralizationModel = group_permistionTmp;
      });
      await onGetDataCustommerProfilePostGroup(group_permistionTmp);
      await onGetDataCustommerProfileLastEdit(group_permistionTmp);
      await onGetListlistPermisstionModelInSystemUse(group_permistionTmp);
      await onGetListDataCustommerProfileInGroup(group_permistionTmp);
      setState(() {
        isLoading = false;
      });
    }
  }

  onGetDataCustommerProfilePostGroup(groupDecentralizationModel) async {
    CustomerProfileModel custommerProfilePostTmp = CustomerProfileModel();
    custommerProfilePostTmp =
        await decentralizationController.onGetDataCustommerProfile(
            document_id_custommer: groupDecentralizationModel.post_by);
    if (custommerProfilePostTmp != null) {
      setState(() {
        custommerProfilePost = custommerProfilePostTmp;
      });
    }
  }

  onGetDataCustommerProfileLastEdit(groupDecentralizationModel) async {
    if (groupDecentralizationModel.last_edit_by != null) {
      CustomerProfileModel custommerProfileLastEditTmp;
      custommerProfileLastEdit =
          await decentralizationController.onGetDataCustommerProfile(
              document_id_custommer: groupDecentralizationModel.last_edit_by);
      if (custommerProfileLastEditTmp != null) {
        setState(() {
          custommerProfileLastEdit = custommerProfileLastEditTmp;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    onGetDocumentIdCustommer();
    Future.delayed(Duration.zero, () {
      setState(() {
        isLoading = true;
        args = ModalRoute.of(context).settings.arguments;
      });
      getDetailGroupPermisstion(args.group_decentralization);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết nhóm quyền"),
        backgroundColor: colorAppbar,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Padding(
              padding: EdgeInsets.all(setWidthSize(size: 15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tên nhóm quyền: ${groupDecentralizationModel == null ? "" : groupDecentralizationModel.document_id_group}",
                    style: styleTextTitleInBodyBlack,
                  ),
                  SizedBox(
                    height: setHeightSize(size: 5),
                  ),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: EdgeInsets.all(setWidthSize(size: 15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Trạng thái: ${groupDecentralizationModel == null ? "" : groupDecentralizationModel.removed ? "Đã xóa" : "Đang hoạt động"}",
                            style: styleTextHintBlack,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 5),
                          ),
                          Text(
                            "Tạo bởi: ${custommerProfilePost.user_name}",
                            style: styleTextHintBlack,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 5),
                          ),
                          Text(
                            "Tạo vào: ${groupDecentralizationModel == null ? "" : getDateShow(groupDecentralizationModel.post_at)}",
                            style: styleTextHintBlack,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 5),
                          ),
                          Text(
                            "Chỉnh sửa lần cuối bởi: ${custommerProfileLastEdit.user_name == null ? "Không có dữ liệu" : custommerProfileLastEdit.user_name}",
                            style: styleTextHintBlack,
                          ),
                          SizedBox(
                            height: setHeightSize(size: 5),
                          ),
                          Text(
                            "Chỉnh sửa lần cuối vào: ${groupDecentralizationModel == null ? "" : groupDecentralizationModel.last_edit_at == null ? "Không có dữ liệu" : getDateShow(groupDecentralizationModel.last_edit_at)}",
                            style: styleTextHintBlack,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  Container(
                    height: setHeightSize(size: 450),
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize:
                            Size.fromHeight(50), // here the desired height
                        child: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          leading: Container(),
                          bottom: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            indicatorColor: Colors.greenAccent,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black54,
                            labelStyle: styleTextTitleInBodyBlack,
                            tabs: <Widget>[
                              Tab(
                                text: "Danh sách quyền",
                              ),
                              Tab(
                                text: "Danh sách người dùng",
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          buildListPermission(),
                          listCustommerProfile.length > 0
                              ? buildListCustommerModel()
                              : Center(
                                  child: Text(
                                      "Nhóm chưa có người được phân quyền"),
                                ),
                        ],
                      ),
                    ),
                  ),
                  groupDecentralizationModel == null
                      ? Container()
                      : groupDecentralizationModel.removed
                          ? Container()
                          : Expanded(
                              child: Center(
                                child: Container(
                                  width: setWidthSize(size: 200),
                                  child: ButtonNormal(
                                    text: "Chỉnh sửa",
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogEditDecentralization(
                                            group_decentralization:
                                                groupDecentralizationModel,
                                          );
                                        },
                                      ).then((value) {
                                        getDetailGroupPermisstion(
                                            groupDecentralizationModel);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                ],
              ),
            ),
      floatingActionButton: isLoading
          ? Container()
          : groupDecentralizationModel == null
              ? Container()
              : SpeedDial(
                  // both default to 16
                  marginRight: 18,
                  marginBottom: 20,
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: true,
                  // If true user is forced to close dial manually
                  // by tapping main button and overlay is not rendered.
                  closeManually: false,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  tooltip: 'Speed Dial',
                  heroTag: 'speed-dial-hero-tag',
                  backgroundColor: colorAppbar,
                  foregroundColor: Colors.white,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: [
                    groupDecentralizationModel.removed
                        ? SpeedDialChild(
                            child: Icon(Icons.call_made),
                            backgroundColor: colorAppbar,
                            label: 'Cấp lại nhóm quyền'.toUpperCase(),
                            labelStyle: styleTextContentBlack,
                            onTap: () async {
                              await decentralizationController
                                  .onRemoveGroupDecentralization(
                                      document_id_custommer:
                                          document_id_custommer,
                                      document_id_decentralization:
                                          groupDecentralizationModel
                                              .document_id_group,
                                      removed: false)
                                  .then((value) {
                                if (value == true) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDiaLogScreen(
                                        title: "Thông báo",
                                        message:
                                            "Bật lại thành công.\n Hãy thêm quyền.",
                                      );
                                    },
                                  ).then((value) {
                                    if (value) {
                                      getDetailGroupPermisstion(
                                          args.group_decentralization);
                                    }
                                  });
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDiaLogScreen(
                                        title: "Thông báo",
                                        message: "Có lỗi. vui lòng thử lại sau",
                                      );
                                    },
                                  );
                                }
                              });
                            },
                          )
                        : SpeedDialChild(
                            child: Icon(Icons.delete),
                            backgroundColor: colorAppbar,
                            label: 'Thu hồi nhóm quyền'.toUpperCase(),
                            labelStyle: styleTextContentBlack,
                            onTap: () async {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDiaLogScreen(
                                    buttonCance: true,
                                    title: "Thông báo",
                                    message:
                                        "Xóa hết các quyền.\n Nếu bật lại bạn phải thêm lại quyền.",
                                  );
                                },
                              ).then((value) async {
                                if (value == true) {
                                  await decentralizationController
                                      .onRemoveGroupDecentralization(
                                          document_id_custommer:
                                              document_id_custommer,
                                          document_id_decentralization: args
                                              .group_decentralization
                                              .document_id_group,
                                          removed: true)
                                      .then((value) {
                                    if (value == true) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDiaLogScreen(
                                            title: "Thông báo",
                                            message:
                                                "Thu hồi nhóm quyền thành công",
                                          );
                                        },
                                      ).then((value) {
                                        if (value) {
                                          getDetailGroupPermisstion(
                                              args.group_decentralization);
                                        }
                                      });
                                    } else {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDiaLogScreen(
                                            title: "Thông báo",
                                            message:
                                                "Có lỗi. vui lòng thử lại sau",
                                          );
                                        },
                                      );
                                    }
                                  });
                                }
                              });
                            }),
                    SpeedDialChild(
                      child: Icon(MdiIcons.accountMultipleRemove),
                      backgroundColor: colorAppbar,
                      label: 'Thu hồi người dùng khỏi nhóm'.toUpperCase(),
                      labelStyle: styleTextContentBlack,
                      onTap: () {
                        Navigator.pushNamed(
                            context, RemoveUserInGroupDecentralizationScreen.id,
                            arguments: RemoveUserInGroupDecentralizationScreen(
                              document_id_group_decentralization:
                                  groupDecentralizationModel.document_id_group,
                            )).then((value) {
                          getDetailGroupPermisstion(groupDecentralizationModel);
                        });
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(MdiIcons.accountMultipleCheck),
                      backgroundColor: colorAppbar,
                      label: 'Thêm người dùng vào nhóm'.toUpperCase(),
                      labelStyle: styleTextContentBlack,
                      onTap: () {
                        Navigator.pushNamed(
                                context, PostDecentralizationScreen.id)
                            .then((value) {
                          getDetailGroupPermisstion(groupDecentralizationModel);
                        });
                      },
                    ),
                  ],
                ),
    );
  }

  Widget buildListPermission() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 10)),
      itemBuilder: (context, index) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(setWidthSize(size: 2)),
          child: Material(
            elevation: 2,
            color: listPermisstionModelInSystemUse[index].isSelected == true
                ? Colors.white
                : Colors.white24,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: setHeightSize(size: 50),
              child: Center(
                child: Text(
                  listPermisstionModelInSystemUse[index].title,
                  style: styleTextTitleInBodyBlack,
                ),
              ),
            ),
          ),
        ),
      ),
      separatorBuilder: (context, index) {
        return Container(
          height: 10,
        );
      },
      itemCount: listPermisstionModelInSystemUse.length,
    );
  }

  Widget buildListCustommerModel() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 10)),
      itemBuilder: (context, index) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(setWidthSize(size: 2)),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(setWidthSize(size: 10.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  listCustommerProfile[index].linkImages != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              listCustommerProfile[index].linkImages),
                          radius: 30.0,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/library_image.png"),
                          radius: 30.0,
                        ),
                  SizedBox(
                    width: setWidthSize(size: 10.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${listCustommerProfile[index].user_name}',
                          style: styleTextContentBlack),
                      Text('${listCustommerProfile[index].email}',
                          style: styleTextContentBlack),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      separatorBuilder: (context, index) {
        return Container(
          height: 10,
        );
      },
      itemCount: listCustommerProfile.length,
    );
  }
}
