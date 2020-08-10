import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_user_need_contact/group_detai_user_need_contact/detail_user_need_contact_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'user_need_contact_controller.dart';

class UserNeedContactScreen extends StatefulWidget {
  @override
  _UserNeedContactScreenState createState() => _UserNeedContactScreenState();
}

class _UserNeedContactScreenState extends State<UserNeedContactScreen> {
  bool isLoading = false;
  UserNeedContactController userNeedContactController =
      UserNeedContactController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ProductNeedSuportModel> ListProductNeedSuportModelNotYetContactBy = [];
  List<CustomerProfileModel>
      ListProfileCustommerNeedSuportModelNotYetContactBy = [];

  getListProductNeedSuportModelNotYetContactBy() async {
    List<ProductNeedSuportModel> ListProductNeedSuportModelNotYetContactByTmp =
        [];
    ListProductNeedSuportModelNotYetContactByTmp =
        await userNeedContactController
            .onLoadGetListProductNeedSuportModelNotYetContactBy();
    if (ListProductNeedSuportModelNotYetContactByTmp.length > 0) {
      if (mounted) {
        setState(() {
          ListProductNeedSuportModelNotYetContactBy =
              ListProductNeedSuportModelNotYetContactByTmp;
        });
      }
      getListDataCustommerProfile();
    } else {
      setState(() {
        if (mounted) {
          setState(() {
            ListProductNeedSuportModelNotYetContactBy = [];
            ListProfileCustommerNeedSuportModelNotYetContactBy = [];
            isLoading = false;
          });
        }
      });
    }
  }

  getListDataCustommerProfile() async {
    var customerProfile;
    List<CustomerProfileModel>
        ListProfileCustommerNeedSuportModelNotYetContactBytmp = [];
    for (var item in ListProductNeedSuportModelNotYetContactBy) {
      customerProfile = await userNeedContactController.onLoadGetDataProifile(
          document_id_custommer: item.document_id_custommer_need_contact);
      if (customerProfile != null) {
        ListProfileCustommerNeedSuportModelNotYetContactBytmp.add(
            CustomerProfileModel.fromJson(customerProfile));
      }
    }

    if (ListProfileCustommerNeedSuportModelNotYetContactBytmp.length > 0) {
      if (mounted) {
        setState(() {
          isLoading = false;
          ListProfileCustommerNeedSuportModelNotYetContactBy =
              ListProfileCustommerNeedSuportModelNotYetContactBytmp;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          ListProductNeedSuportModelNotYetContactBy = [];
          ListProfileCustommerNeedSuportModelNotYetContactBy = [];
          isLoading = false;
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

    getListProductNeedSuportModelNotYetContactBy();
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
                    child: ListProductNeedSuportModelNotYetContactBy.length <
                                1 &&
                            ListProfileCustommerNeedSuportModelNotYetContactBy
                                    .length <
                                1
                        ? Center(
                            child: Text("Không có người cần liên lạc"),
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
                      await getListProductNeedSuportModelNotYetContactBy();
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
          left: setWidthSize(size: 5),
          right: setWidthSize(size: 5),
        ),
        itemBuilder: (context, index) {
          return Item(
              customerProfileModel:
                  ListProfileCustommerNeedSuportModelNotYetContactBy[index],
              productNeedSuportModel:
                  ListProductNeedSuportModelNotYetContactBy[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            color: Colors.greenAccent,
          );
        },
        itemCount: ListProfileCustommerNeedSuportModelNotYetContactBy.length);
  }

  Widget Item({
    CustomerProfileModel customerProfileModel,
    ProductNeedSuportModel productNeedSuportModel,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailUserNeedContact.id,
          arguments: DetailUserNeedContact(
            is_taked_screen: false,
            customerProfileModel: customerProfileModel,
            productNeedSuportModel: productNeedSuportModel,
          ),
        ).then(
          (value) async {
            if (value == true) {
              await getListProductNeedSuportModelNotYetContactBy();
              await getListDataCustommerProfile();
            }
          },
        );
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
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      customerProfileModel.user_name,
                      style: styleTextContentBlack,
                    ),
                    SizedBox(
                      height: setHeightSize(size: 5),
                    ),
                    Text(
                      customerProfileModel.email,
                      style: styleTextContentBlack,
                    ),
                    SizedBox(
                      height: setHeightSize(size: 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(customerProfileModel.phone_number,
                            style: styleTextContentBlack),
                        Text(getDateShow(productNeedSuportModel.post_at)),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
