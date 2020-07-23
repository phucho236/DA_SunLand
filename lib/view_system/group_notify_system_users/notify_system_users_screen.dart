import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_notify_system_users/notify_system_users_screen_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'notify_system_users_screen_controller.dart';

class NotifySystemUsersScreen extends StatefulWidget {
  static String id = "NotifySystemUsersScreen";
  @override
  _NotifySystemUsersScreenState createState() =>
      _NotifySystemUsersScreenState();
}

class _NotifySystemUsersScreenState extends State<NotifySystemUsersScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLoading = false;
  List<CustomerProfileModel> listCustommerProfile = [];
  NotifySystemUsersController notifySystemUsersController =
      NotifySystemUsersController();
  List<NotifySystemUsersModel> listNotifySystemUsers = [];
  getListNotifySystemUsers() async {
    setState(() {
      isLoading = true;
    });
    List<NotifySystemUsersModel> listNotifySystemUsersTmp = [];
    listNotifySystemUsersTmp =
        await notifySystemUsersController.getlistNotifySystemUsers();
    if (listNotifySystemUsersTmp != null) {
      setState(() {
        listNotifySystemUsers = listNotifySystemUsersTmp;
      });
      getListCustomerProfileModel();
    }
  }

  getListCustomerProfileModel() async {
    List<CustomerProfileModel> listCustommerProfiletmp = [];
    listCustommerProfiletmp =
        await notifySystemUsersController.getListCustommerProifile(
            listNotifySystemUsersModel: listNotifySystemUsers);
    if (listCustommerProfiletmp != null) {
      setState(() {
        listCustommerProfile = listCustommerProfiletmp;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getListNotifySystemUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorAppbarGrey,
        title: Text(
          "Thông báo",
          style: styleTextTitleInAppBarBlack,
        ),
      ),
      body: Scaffold(
        backgroundColor: colorBackGroundGrey,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullUp: false,
                      child: listNotifySystemUsers.length < 1
                          ? Center(
                              child: Text(
                                "Không có dữ liệu",
                                style: styleTextContentBlack,
                              ),
                            )
                          : buildListCustommerNeedSupport(),
                      physics: BouncingScrollPhysics(),
                      footer: ClassicFooter(
                        loadStyle: LoadStyle.ShowWhenLoading,
                        completeDuration: Duration(milliseconds: 500),
                      ),
                      onRefresh: () async {
                        //monitor fetch data from network
                        await Future.delayed(Duration(milliseconds: 1000));

                        await getListNotifySystemUsers();

                        if (mounted) setState(() {});
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
      ),
    );
  }

  Widget buildListCustommerNeedSupport() {
    return ListView.separated(
      padding: EdgeInsets.only(
          left: setWidthSize(size: 5), right: setWidthSize(size: 5)),
      itemBuilder: (context, index) => Items(
          customerProfileModel: listCustommerProfile[index],
          notifySystemUsersModel: listNotifySystemUsers[index]),
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: Colors.greenAccent,
        );
      },
      itemCount: listCustommerProfile.length,
    );
  }
}

class Items extends StatefulWidget {
  Items({this.customerProfileModel, this.notifySystemUsersModel});
  final CustomerProfileModel customerProfileModel;
  final NotifySystemUsersModel notifySystemUsersModel;
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(2.0, 2.0),
                        blurRadius: 8.0,
                        spreadRadius: 1.0),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-2.0, -2.0),
                        blurRadius: 8.0,
                        spreadRadius: 1.0),
                  ],
                ),
                margin: EdgeInsets.all(setWidthSize(size: 10)),
                child: widget.customerProfileModel.linkImages == null
                    ? Padding(
                        padding: EdgeInsets.all(setWidthSize(size: 2.0)),
                        child: CircleAvatar(
                          radius: 30,
                          child: Container(
                            margin: EdgeInsets.all(setWidthSize(size: 10)),
                            child:
                                Image.asset("assets/images/library_image.png"),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(setWidthSize(size: 2.0)),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              widget.customerProfileModel.linkImages),
                        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.customerProfileModel.user_name,
                          style: styleTextContentBlack,
                        ),
                        Text(
                          getDateShow(widget.notifySystemUsersModel.post_at),
                          style: styleTextContentBlack,
                        ),
                      ],
                    ),
                    Text(
                      widget.customerProfileModel.email,
                      style: styleTextContentBlack,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            " ${widget.notifySystemUsersModel.title}",
            style: styleTextContentBlack,
          ),
          Text(
            "Nội dung:",
            style: styleTextHintBlack,
          ),
          Text(
            widget.notifySystemUsersModel.content,
            style: styleTextContentBlack,
          )
        ],
      ),
    );
  }
}
