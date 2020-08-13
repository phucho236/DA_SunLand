import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_support_chat_with_user/support_chat_with_user_controller.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/group_request_to_become_a_partner_screen/dialog_detail_request_to_become_a_partner.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/group_request_to_become_a_partner_screen/request_to_become_a_partner_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_core/api/api_model.dart';

class RequestToBecomeAPartnerScreen extends StatefulWidget {
  static String id = "RequestToBecomeAPartnerScreen";
  @override
  _RequestToBecomeAPartnerScreenState createState() =>
      _RequestToBecomeAPartnerScreenState();
}

class _RequestToBecomeAPartnerScreenState
    extends State<RequestToBecomeAPartnerScreen> {
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<RequestToBecomeAPartnerModel> listRequestToBecomeAPartnerModel = [];
  RequestToBecomeAPartnerController requestToBecomeAPartnerController =
      RequestToBecomeAPartnerController();

  List<CustomerProfileModel> listCustommerProfile = [];
  getListRequestToBecomeAPartner() async {
    List<RequestToBecomeAPartnerModel> listRequestToBecomeAPartnerModelTmp = [];
    listRequestToBecomeAPartnerModelTmp =
        await requestToBecomeAPartnerController
            .onLoadGetListRequestToBecomeAPartner();
    if (listRequestToBecomeAPartnerModelTmp.length > 0) {
      List<CustomerProfileModel> listCustommerProfileTmp = [];
      listCustommerProfileTmp = await requestToBecomeAPartnerController
          .onLoadGetListProFileCustommer(listRequestToBecomeAPartnerModelTmp);

      if (mounted) {
        setState(() {
          isLoading = false;
          listCustommerProfile = listCustommerProfileTmp;
          listRequestToBecomeAPartnerModel =
              listRequestToBecomeAPartnerModelTmp;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
          listCustommerProfile = [];
          listRequestToBecomeAPartnerModel = [];
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getListRequestToBecomeAPartner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: listRequestToBecomeAPartnerModel.length < 1 ||
                            listCustommerProfile.length < 1
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
                      await getListRequestToBecomeAPartner();
                      if (mounted) setState(() {});
                      _refreshController.refreshCompleted();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildListCustommerNeedSupport() {
    return ListView.separated(
      padding: EdgeInsets.only(
          left: setWidthSize(size: 5), right: setWidthSize(size: 5)),
      itemBuilder: (context, index) => Item(
          customerProfileModel: listCustommerProfile[index],
          requestToBecomeAPartnerModel:
              listRequestToBecomeAPartnerModel[index]),
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: Colors.greenAccent,
        );
      },
      itemCount: listCustommerProfile.length,
    );
  }

  Widget Item({
    CustomerProfileModel customerProfileModel,
    RequestToBecomeAPartnerModel requestToBecomeAPartnerModel,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return DialogDetailRequestToBecomeAPartner(
              customerProfileModel: customerProfileModel,
              requestToBecomeAPartnerModel: requestToBecomeAPartnerModel,
            );
          },
        ).then((value) {
          if (value == true) {
            getListRequestToBecomeAPartner();
          }
        });
      },
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(setWidthSize(size: 5)),
            child: customerProfileModel.linkImages == null
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
                        NetworkImage(customerProfileModel.linkImages),
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
                      customerProfileModel.email,
                      style: styleTextContentBlack,
                    ),
                  ],
                ),
                SizedBox(
                  height: setHeightSize(size: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      customerProfileModel.user_name,
                      style: styleTextContentBlack,
                    ),
                    Text(
                      getDateShow(requestToBecomeAPartnerModel.send_at),
                      style: styleTextContentBlack,
                    ),
                  ],
                ),
                requestToBecomeAPartnerModel.censored
                    ? Text(
                        "Đã kiểm duyệt",
                        style: styleTextContentBlack,
                      )
                    : Text(
                        "Chưa kiểm duyệt",
                        style: styleTextContentNoInput,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
