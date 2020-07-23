import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_support_chat_with_user/group_chat/chat_screen.dart';
import 'package:flutter_core/view_system/group_support_chat_with_user/support_chat_with_user_controller.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_core/api/api_model.dart';

class SupportChatWithUserScreen extends StatefulWidget {
  static String id = "SupportChatWithUserScreen";
  @override
  _SupportChatWithUserScreenState createState() =>
      _SupportChatWithUserScreenState();
}

class _SupportChatWithUserScreenState extends State<SupportChatWithUserScreen> {
  SupportChatWithUserController supportChatWithUserController =
      SupportChatWithUserController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<CustomerProfileModel> listCustommerProfile = [];
  List<CustomerProfileModel> listCustommerProfileTmp = [];
  bool onFind = false;
  getListProfileCustommer() async {
    List<CustomerProfileModel> listCustommerProfiletmp = [];
    listCustommerProfiletmp =
        await supportChatWithUserController.onLoadScreenSuportChatWithUser();
    if (listCustommerProfiletmp != null) {
      setState(() {
        listCustommerProfile = listCustommerProfiletmp;
      });
    }
  }

  onFindEmailUserChated({String value}) async {
    setState(() {
      onFind = true;
    });
    CustomerProfileModel customerProfileModelTmp =
        await supportChatWithUserController.onFindEmailUserChated(email: value);
    if (customerProfileModelTmp != null) {
      setState(() {
        listCustommerProfileTmp = [customerProfileModelTmp];
      });
    } else {
      setState(() {
        listCustommerProfileTmp = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListProfileCustommer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Người dùng cần nhắn tin",
          style: styleTextTitleInAppWhite,
        ),
        backgroundColor: colorAppbar,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(setWidthSize(size: 15)),
            child: Search_TextField_Border(
              borderRadius: 5,
              hintText: "Tìm kiếm",
              sizeBorder: 2,
              colorBorDer: Colors.white,
              onChanged: (value) {
                onFindEmailUserChated(value: value);
                if (value == "") {
                  setState(() {
                    listCustommerProfileTmp = [];
                    onFind = false;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullUp: false,
              child: buildListCustommerNeedSupport(
                  onFind ? listCustommerProfileTmp : listCustommerProfile),
              physics: BouncingScrollPhysics(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 500),
              ),
              onRefresh: () async {
                //monitor fetch data from network
                await Future.delayed(Duration(milliseconds: 1000));
                await getListProfileCustommer();

                if (mounted)
                  setState(() {
                    onFind = false;
                  });
                _refreshController.refreshCompleted();
              },
//                onLoading: () async {
//                  //monitor fetch data from network
//                  await Future.delayed(Duration(milliseconds: 200));
//
//                  if (mounted) setState(() {});
//                  _refreshController.loadFailed();
//                },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListCustommerNeedSupport(listCustommerProfile) {
    return listCustommerProfile.length > 0
        ? ListView.separated(
            padding: EdgeInsets.only(
                left: setWidthSize(size: 10), right: setWidthSize(size: 10)),
            itemBuilder: (context, index) => Item(
              document_id_custommer_need_chat:
                  listCustommerProfile[index].document_id_custommer,
              url: listCustommerProfile[index].linkImages,
              email: listCustommerProfile[index].email,
              user_name: listCustommerProfile[index].user_name,
            ),
            separatorBuilder: (context, index) {
              return Container(
                height: 0.5,
                color: Colors.greenAccent,
              );
            },
            itemCount: listCustommerProfile.length,
          )
        : Center(
            child: Container(
              child: Text(
                "Không có dữ liệu",
                style: styleTextContentBlack,
              ),
            ),
          );
  }

  Widget Item(
      {String email,
      String user_name,
      String url,
      String document_id_custommer_need_chat}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.id,
            arguments: ChatScreen(
              document_id_custommer_need_chat: document_id_custommer_need_chat,
            ));
      },
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(setWidthSize(size: 5)),
            child: url == null
                ? CircleAvatar(
                    radius: 30,
                    child: Container(
                      margin: EdgeInsets.all(setWidthSize(size: 10)),
                      child: Image.asset("assets/images/library_image.png"),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(url),
                  ),
          ),
          SizedBox(
            width: setWidthSize(size: 5),
          ),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    email,
                    style: styleTextContentBlack,
                  ),
                  SizedBox(
                    height: setHeightSize(size: 10),
                  ),
                  Text(
                    user_name,
                    style: styleTextContentBlack,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
