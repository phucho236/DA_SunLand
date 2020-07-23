import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/dialog_post_notify_system_user.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/group_detail_notify_system_user/detail_notify_system_user.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/post_notify_system_users_controller.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostNotifySystemUsersScreen extends StatefulWidget {
  static String id = "PostNotifySystemUsersScreen";
  @override
  _PostNotifySystemUsersScreenState createState() =>
      _PostNotifySystemUsersScreenState();
}

class _PostNotifySystemUsersScreenState
    extends State<PostNotifySystemUsersScreen> {
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<CustomerProfileModel> listCustommerProfile = [];
  PostNotifySystemUsersController postNotifySystemUsersController =
      PostNotifySystemUsersController();
  List<NotifySystemUsersModel> listNotifySystemUsers = [];
  getListNotifySystemUsers() async {
    List<NotifySystemUsersModel> listNotifySystemUsersTmp = [];
    listNotifySystemUsersTmp =
        await postNotifySystemUsersController.getlistNotifySystemUsers();
    if (listNotifySystemUsersTmp.length > 0) {
      setState(() {
        listNotifySystemUsers = listNotifySystemUsersTmp;
        getListCustomerProfileModel();
      });
    } else {
      setState(() {
        listNotifySystemUsers = [];
        isLoading = false;
      });
    }
  }

  getListCustomerProfileModel() async {
    List<CustomerProfileModel> listCustommerProfiletmp = [];
    listCustommerProfiletmp =
        await postNotifySystemUsersController.getListCustommerProifile(
            listNotifySystemUsersModel: listNotifySystemUsers);
    if (listCustommerProfiletmp.length > 0) {
      setState(() {
        listCustommerProfile = listCustommerProfiletmp;
        isLoading = false;
      });
    } else {
      listNotifySystemUsers = [];
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getListNotifySystemUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Thông báo cho người dùng hệ thống",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Column(
              children: <Widget>[
//              Padding(
//                padding: EdgeInsets.all(setWidthSize(size: 5)),
//                child: Search_TextField_Border(
//                  borderRadius: 5,
//                  hintText: "Tìm kiếm",
//                  sizeBorder: 2,
//                  colorBorDer: Colors.white,
//                  onChanged: (value) {},
//                ),
//              ),
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: false,
                    child: listNotifySystemUsers.length < 1
                        ? Center(
                            child: Text(
                              "Không có dữ liệu.",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogPostNotifySystemUser();
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: colorAppbar,
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
      onTap: () {
        Navigator.pushNamed(context, DetailNotifySystemUser.id,
            arguments: DetailNotifySystemUser(
              customerProfileModel: widget.customerProfileModel,
              notifySystemUsersModel: widget.notifySystemUsersModel,
            ));
      },
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(setWidthSize(size: 5)),
            child: widget.customerProfileModel.linkImages == null
                ? CircleAvatar(
                    radius: 30,
                    child: Container(
                      margin: EdgeInsets.all(setWidthSize(size: 10)),
                      child: Image.asset("assets/images/library_image.png"),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(widget.customerProfileModel.linkImages),
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
                      widget.notifySystemUsersModel.removed
                          ? "Đã xóa"
                          : "Hoạt động",
                      style: styleTextContentBlack,
                    ),
                  ],
                ),
                Text(
                  widget.customerProfileModel.email,
                  style: styleTextContentBlack,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.notifySystemUsersModel.title,
                      style: styleTextContentBlack,
                    ),
                    Text(
                      getDateShow(widget.notifySystemUsersModel.post_at),
                      style: styleTextContentBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
