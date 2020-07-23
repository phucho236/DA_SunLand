import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_decentralization/decentralization_controller.dart';
import 'package:flutter_core/view_system/group_decentralization/group_detail_decentralization/detail_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_post_decentralization/post_decentralization_screen.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';

class DecentralizationScreen extends StatefulWidget {
  static String id = "DecentralizationScreen";
  @override
  _DecentralizationScreenState createState() => _DecentralizationScreenState();
}

class _DecentralizationScreenState extends State<DecentralizationScreen> {
  bool isLoading = false;
  List<GroupDecentralizationModel> list_group_permistion = [];
  DecentralizationController decentralizationController =
      DecentralizationController();
  getListIDGroupPermisstion() async {
    List<GroupDecentralizationModel> list_id_group_permistionTmp = [];
    list_id_group_permistionTmp =
        await decentralizationController.onGetListGroupDecentralization();
    if (list_id_group_permistionTmp.length > 0) {
      list_id_group_permistionTmp
          .removeWhere((element) => element.document_id_group == "admin");
      setState(() {
        isLoading = false;
        list_group_permistion = list_id_group_permistionTmp;
      });
    } else {
      isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getListIDGroupPermisstion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Phân quyền",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : list_group_permistion.length < 1
              ? Center(
                  child: Text(
                    "Không có dữ liệu",
                    style: styleTextContentBlack,
                  ),
                )
              : buildListCustommerNeedSupport(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, PostDecentralizationScreen.id)
              .then((value) {
            getListIDGroupPermisstion();
          });
        },
        backgroundColor: colorAppbar,
      ),
    );
  }

  Widget buildListCustommerNeedSupport() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 10)),
      itemBuilder: (context, index) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailDecentralizationScreen.id,
            arguments: DetailDecentralizationScreen(
              group_decentralization: list_group_permistion[index],
            ),
          ).then((value) {
            getListIDGroupPermisstion();
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 15)),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: setHeightSize(size: 50),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      list_group_permistion[index].document_id_group,
                      style: styleTextTitleInBodyBlack,
                    ),
                    SizedBox(
                      height: setHeightSize(size: 5),
                    ),
                    Text(
                      "Trạng thái: ${list_group_permistion[index].removed ? "Đã xóa" : "Đang hoạt động"}",
                      style: styleTextHintBlack,
                    ),
                  ],
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
      itemCount: list_group_permistion.length,
    );
  }
}
