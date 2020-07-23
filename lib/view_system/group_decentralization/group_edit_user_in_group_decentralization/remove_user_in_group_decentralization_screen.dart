import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_decentralization/group_create_group_decentralization/dialog_create_group_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_edit_user_in_group_decentralization/edit_user_in_group_decentralization_controller.dart';
import 'package:flutter_core/view_system/group_decentralization/group_post_decentralization/post_decentralization_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RemoveUserInGroupDecentralizationScreen extends StatefulWidget {
  static String id = "RemoveUserInGroupDecentralizationScreen";
  RemoveUserInGroupDecentralizationScreen(
      {this.document_id_group_decentralization});
  final String document_id_group_decentralization;
  @override
  _RemoveUserInGroupDecentralizationScreenState createState() =>
      _RemoveUserInGroupDecentralizationScreenState();
}

class _RemoveUserInGroupDecentralizationScreenState
    extends State<RemoveUserInGroupDecentralizationScreen> {
  EditUserInGroupDecentralization editUserInGroupDecentralization =
      EditUserInGroupDecentralization();
  RemoveUserInGroupDecentralizationScreen args;
  List<CustomerProfileModel> listCustommerProfile = [];
  List<String> listCustommerProfileRemove = [];

  Future<bool> onRemoveRemoveUserInGroupDecentralization(args) async {
    List<String> ListIdCustommerRemoveGroupDecentralizationTmp = [];
    for (var item in listCustommerProfile) {
      if (item.is_seleced == true) {
        ListIdCustommerRemoveGroupDecentralizationTmp.add(
            item.document_id_custommer);
      }
    }

    await editUserInGroupDecentralization.onRemoveUserInGroupDecentralization(
        list_document_id_custommer:
            ListIdCustommerRemoveGroupDecentralizationTmp,
        id_group_permission: args.document_id_group_decentralization);
  }

  onGetListDataCustommerProfileInGroup(args) async {
    List<CustomerProfileModel> listCustommerProfileTmp = [];
    listCustommerProfileTmp = await editUserInGroupDecentralization
        .onGetListDataCustommerProfileInGroup(
            document_id_group_permission:
                args.document_id_group_decentralization);
    if (listCustommerProfileTmp.length > 0) {
      setState(() {
        listCustommerProfile = listCustommerProfileTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      onGetListDataCustommerProfileInGroup(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    RemoveUserInGroupDecentralizationScreen args1 =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Nhóm: ${args1.document_id_group_decentralization}",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: setHeightSize(size: 15),
          ),
          listCustommerProfile.length > 0
              ? Text(
                  "Chọn người dùng muốn thu hồi quyền",
                  style: styleTextHintBlack,
                )
              : Container(),
          Expanded(
            child: listCustommerProfile.length > 0
                ? buildListCustommerModel()
                : Center(
                    child: Text("Group không có người dùng"),
                  ),
          ),
          Center(
            child: Container(
              child: StreamBuilder(
                stream: editUserInGroupDecentralization.errStream,
                builder: (context, snapshot) => Text(
                  snapshot.hasError ? snapshot.error : '',
                  style: styleTextContentBlack,
                ),
              ),
            ),
          ),
          listCustommerProfile.length > 0
              ? Container(
                  width: setWidthSize(size: 200),
                  child: ButtonNormal(
                    onTap: () async {
                      await onRemoveRemoveUserInGroupDecentralization(args1)
                          .then((value) {
                        onGetListDataCustommerProfileInGroup(args1);
                      });
                    },
                    text: "Thu hồi",
                  ),
                )
              : Container(),
          SizedBox(
            height: setHeightSize(size: 15),
          ),
        ],
      ),
    );
  }

  Widget buildListCustommerModel() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
          vertical: setHeightSize(size: 10),
          horizontal: setWidthSize(size: 10)),
      itemBuilder: (context, index) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            listCustommerProfile[index].is_seleced =
                !listCustommerProfile[index].is_seleced;
          });
        },
        child: Material(
          elevation: 2,
          color: listCustommerProfile[index].is_seleced
              ? Colors.amber[50]
              : Colors.white,
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
      separatorBuilder: (context, index) {
        return Container(
          height: 10,
        );
      },
      itemCount: listCustommerProfile.length,
    );
  }
}
