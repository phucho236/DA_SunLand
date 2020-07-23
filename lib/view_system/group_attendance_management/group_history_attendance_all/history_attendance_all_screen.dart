import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_add_user_system_to_group_attendance/add_user_system_to_group_attendance_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_history_attendance/history_attendance_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_history_attendance_all/history_attendance_all_controller.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';

class HistoryAttendanceAllScreen extends StatefulWidget {
  static String id = "HistoryAttendanceAllScreen";
  @override
  _HistoryAttendanceAllScreenState createState() =>
      _HistoryAttendanceAllScreenState();
}

class _HistoryAttendanceAllScreenState
    extends State<HistoryAttendanceAllScreen> {
  bool isLoading = false;
  List<CustomerProfileModel> listCustommerProfile = [];
  HistoryAttendanceAllController historyAttendanceAllController =
      HistoryAttendanceAllController();
  FindCustommerProfileByEmailOrUserName({String email}) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp = await historyAttendanceAllController
        .onFindCustommerProfileByEmailOrUserName(email: email);
    if (customerProfileModelTmp != null) {
      setState(() {
        listCustommerProfile = [customerProfileModelTmp];
      });
    }
  }

  getListCustommerProfile() async {
    List<CustomerProfileModel> listCustommerProfileTmp = [];
    listCustommerProfileTmp =
        await historyAttendanceAllController.onGetListCustommerProfile();
    if (listCustommerProfileTmp.length > 0) {
      setState(() {
        listCustommerProfile = listCustommerProfileTmp;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getListCustommerProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Lịch sử điểm danh toàn hệ thống",
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
                Padding(
                  padding: EdgeInsets.all(setWidthSize(size: 10)),
                  child: Search_TextField_Border(
                    borderRadius: 5,
                    hintText: "Nhập email.",
                    sizeBorder: 2,
                    colorBorDer: Colors.white,
                    onChanged: (value) async {
                      await FindCustommerProfileByEmailOrUserName(email: value);
                      if (value == "") {
                        getListCustommerProfile();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: setWidthSize(size: 5),
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pushNamed(
                                context, HistoryAttendanceScreen.id,
                                arguments: HistoryAttendanceScreen(
                                  document_id_user: listCustommerProfile[index]
                                      .document_id_custommer,
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: setWidthSize(size: 5),
                              horizontal: setWidthSize(size: 5),
                            ),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  listCustommerProfile[index].linkImages != null
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              listCustommerProfile[index]
                                                  .linkImages),
                                          radius: 30.0,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/library_image.png"),
                                          radius: 30.0,
                                        ),
                                  SizedBox(
                                    width: setWidthSize(size: 10),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        listCustommerProfile[index].user_name,
                                        style: styleTextContentBlack,
                                      ),
                                      Text(
                                        listCustommerProfile[index].email,
                                        style: styleTextContentBlack,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          color: Colors.greenAccent,
                        );
                      },
                      itemCount: listCustommerProfile.length),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorAppbar,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddUserSystemToGroupAttendanceScreen.id);
        },
      ),
    );
  }
}
