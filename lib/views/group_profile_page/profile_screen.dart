import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/providers/global_provider.dart';
import 'package:flutter_core/view_system/group_product/post_product_screen.dart';
import 'package:flutter_core/views/group_accuracy/group_login/login_screen.dart';
import 'package:flutter_core/views/group_introduce/introduce_screen.dart';
import 'package:flutter_core/views/group_profile_page/dialog_send_request.dart';
import 'package:flutter_core/views/group_profile_page/group_product_posted/product_posted_screen.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String id = "ProfileScreen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "";
  String created_at = "";
  bool is_partner = false;
  String content;
  String document_id_custommer = "";
  getdataLocal() async {
    String emailTmp;
    String created_atTmp;
    bool is_partnerTmp;
    is_partnerTmp = await getIsPartner();
    emailTmp = await getEmail();
    created_atTmp = await getCreatedAt();
    setState(() {
      email = emailTmp;
      is_partner = is_partnerTmp;
      created_at = created_atTmp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataLocal();
  }

  @override
  Widget build(BuildContext context) {
    final List<SpeedDialChild> listfloattingbuttonisparner = [
      SpeedDialChild(
        child: Icon(MdiIcons.logout),
        backgroundColor: colorAppbar,
        label: 'Đăng xuất'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () async {
          setDocumentIdCustommer(newValue: '');
          Navigator.pushReplacementNamed(
            context,
            LoginScreen.id,
          );
        },
      ),
      SpeedDialChild(
        child: Icon(MdiIcons.accountMultipleCheck),
        backgroundColor: colorAppbar,
        label: 'Đăng sản phẩm'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () {
          Navigator.pushNamed(context, PostProductScreen.id,
              arguments: PostProductScreen(
                permisstion_post_project: false,
              ));
        },
      ),
      SpeedDialChild(
        child: Icon(MdiIcons.accountMultipleCheck),
        backgroundColor: colorAppbar,
        label: 'Sản phẩm đã đăng'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () {
          Navigator.pushNamed(context, ProductPostedScreen.id);
        },
      ),
      SpeedDialChild(
        child: Icon(MdiIcons.accountMultipleCheck),
        backgroundColor: colorAppbar,
        label: 'Sản phẩm đã đăng'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () {
          Navigator.pushNamed(context, ProductPostedScreen.id);
        },
      ),
      SpeedDialChild(
        child: Icon(MdiIcons.domain),
        backgroundColor: colorAppbar,
        label: 'Giới thiệu'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () {
          Navigator.pushNamed(context, IntroduceScreen.id);
        },
      ),
    ];
    final List<SpeedDialChild> listfloattingbuttonnonparner = [
      SpeedDialChild(
        child: Icon(Icons.domain),
        backgroundColor: colorAppbar,
        label: 'Giới thiệu'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () {
          Navigator.pushNamed(context, IntroduceScreen.id);
        },
      ),
      SpeedDialChild(
        child: Icon(MdiIcons.logout),
        backgroundColor: colorAppbar,
        label: 'Đăng xuất'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () async {
          setDocumentIdCustommer(newValue: '');
          Navigator.pushReplacementNamed(
            context,
            LoginScreen.id,
          );
        },
      ),
      SpeedDialChild(
        child: Icon(MdiIcons.accountCheckOutline),
        backgroundColor: colorAppbar,
        label: 'Trở thành đối tác'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogSendRequest();
            },
          );
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.domain),
        backgroundColor: colorAppbar,
        label: 'Giới thiệu'.toUpperCase(),
        labelStyle: styleTextContentBlack,
        onTap: () {
          Navigator.pushNamed(context, IntroduceScreen.id);
        },
      ),
    ];
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () {},
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Provider.of<GlobalData>(context).avatarUser.runtimeType ==
                          null
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: setHeightSize(size: 40)),
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            elevation: 8,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  Provider.of<GlobalData>(context).avatarUser),
                            ),
                          ),
                        )
                      : Padding(
                          padding:
                              EdgeInsets.only(top: setHeightSize(size: 40)),
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            elevation: 8,
                            child: CircleAvatar(
                              radius: 80,
                              child: Image.asset(
                                "assets/images/library_image.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: setHeightSize(size: 10)),
                    child: Text(
                      Provider.of<GlobalData>(context).userName,
                      style: styleTextTitleInAppBarBlack,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          blurRadius:
                              3, // has the effect of softening the shadow
                          spreadRadius:
                              0.1, // has the effect of extending the shadow
                          offset: Offset(
                            1.5, // horizontal, move right 10
                            1.5, // vertical, move down 10
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: setHeightSize(size: 5),
                        horizontal: setWidthSize(size: 5)),
                    child: Container(
                      height: setHeightSize(size: 420),
                      width: setWidthSize(size: 300),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            BuildWidgetProfile(
                              titte: "Họ: ",
                              content:
                                  Provider.of<GlobalData>(context).lastName,
                            ),
                            BuildWidgetProfile(
                              titte: "Tên: ",
                              content:
                                  Provider.of<GlobalData>(context).fistName,
                            ),
                            BuildWidgetProfile(
                              titte: "Email: ",
                              content: email,
                            ),
                            BuildWidgetProfile(
                              titte: "Số điện thoại: ",
                              content:
                                  Provider.of<GlobalData>(context).phoneNumber,
                            ),
                            BuildWidgetProfile(
                              titte: "Ngày bắt đầu: ",
                              content: created_at == ""
                                  ? ""
                                  : getDateNoHour(created_at),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: setHeightSize(size: 150),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/background_dialog_1.png"),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: SpeedDial(
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
          heroTag: 'speed-dial-hero-tag-pro-file-screen',
          backgroundColor: colorAppbar,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: is_partner
              ? listfloattingbuttonisparner
              : listfloattingbuttonnonparner),
    );
  }

  Widget BuildWidgetProfile({String titte, String content}) {
    return Padding(
      padding: EdgeInsets.all(setWidthSize(size: 10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            titte,
            style: styleTextTitleInBodyBlack,
          ),
          Text(
            content,
            style: styleTextContentBlack,
          ),
        ],
      ),
    );
  }
}
