import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_note_screen/note_screen_controller.dart';
import 'package:flutter_core/views/group_like_item/like_item_controller.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NoteScreen extends StatefulWidget {
  static String id = "NoteScreen";
  NoteScreen({this.document_id_product_need_support});
  final String document_id_product_need_support;
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool isLoading = false;
  List<NotedModel> listNote = [];
  List<CustomerProfileModel> listCustommerProfile = [];
  NoteScreen args;
  NoteController noteController = NoteController();
  getListNote() async {
    List<NotedModel> listNoteTmp = [];
    listNoteTmp = await noteController.onLoadGetListNote(
        document_id_product_need_support:
            args.document_id_product_need_support);
    if (listNoteTmp.length > 0) {
      setState(() {
        listNote = listNoteTmp;
      });
      getListDataCustommerProfile();
    } else {
      isLoading = false;
      listNoteTmp = [];
      setState(() {});
    }
  }

  getListDataCustommerProfile() async {
    var customerProfile;
    List<CustomerProfileModel> ListProfileCustommertmp = [];
    for (var item in listNote) {
      customerProfile = await noteController.onLoadGetDataProifile(
          document_id_custommer: item.note_by);
      if (customerProfile != null) {
        ListProfileCustommertmp.add(
            CustomerProfileModel.fromJson(customerProfile));
      }
    }

    if (ListProfileCustommertmp.length > 0) {
      setState(() {
        isLoading = false;
        listCustommerProfile = ListProfileCustommertmp;
      });
    } else {
      setState(() {
        isLoading = false;
        listCustommerProfile = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        isLoading = true;
        args = ModalRoute.of(context).settings.arguments;
      });
      getListNote();
    });
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text("Chú thích về hỗ trợ"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: false,
                    child:
                        listNote.length < 1 && listCustommerProfile.length < 1
                            ? Center(
                                child: Text("Không có chú thích"),
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
                      await getListNote();
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
              customerProfileModel: listCustommerProfile[index],
              notedModel: listNote[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            color: Colors.greenAccent,
          );
        },
        itemCount: listCustommerProfile.length);
  }

  Widget Item({
    CustomerProfileModel customerProfileModel,
    NotedModel notedModel,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                    height: setHeightSize(size: 5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        customerProfileModel.user_name,
                        style: styleTextContentBlack,
                      ),
                      Text(
                        getDateShow(notedModel.post_at),
                        style: styleTextContentBlack,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: setHeightSize(size: 5),
                  ),
                  Text(
                    notedModel.content,
                    style: styleTextContentBlack,
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
