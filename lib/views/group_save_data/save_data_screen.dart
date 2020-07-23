import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/PushNotifications/PushNotificationsManager.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/providers/global_provider.dart';
import 'package:flutter_core/view_system/system_center_screen.dart';
import 'package:flutter_core/views/group_save_data/check_user_system_controller.dart';
import 'package:flutter_core/views/group_save_data/save_data_controller.dart';
import 'package:flutter_core/views/home_center_screen.dart';
import 'package:provider/provider.dart';

class SaveDataScreen extends StatefulWidget {
  static String id = "SaveDataScreen";
  @override
  _SaveDataScreenState createState() => _SaveDataScreenState();
}

class _SaveDataScreenState extends State<SaveDataScreen> {
  Check_User_System_Controller check_user_system_controller =
      Check_User_System_Controller();
  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();
  SaveDataController saveDataController = SaveDataController();
  String firstName;
  String lastName;
  String userName;
  String linkImages;
  String phoneNumber;
  int type;
  GetData() async {
    // lưu thông tin
    await saveDataController.onLoadSaveData();
    firstName = await getFirstName();
    lastName = await getLastName();
    userName = await getUserName();
    linkImages = await getLinkImages();
    phoneNumber = await getPhoneNumber();
    type = await getType();
    String document_id_custommer = await getDocumentIdCustommer();
    // chỉ khi type =1
    context.read<GlobalData>().updatefistName(newValue: firstName);
    context.read<GlobalData>().updatelastName(newValue: lastName);
    context.read<GlobalData>().updateUserName(newValue: userName);
    context.read<GlobalData>().updateAvatarUser(newValue: linkImages);
    context.read<GlobalData>().updatephoneNumber(newValue: phoneNumber);
    if (type == 1) {
      //check lần đầu đăng nhập không có database tiến hành tạo và cấp quyền admin
      await check_user_system_controller
          .onLoadScreenHomeCenterCheckExistGroupPermission(
              document_id_custommer: document_id_custommer);
      //lấy quyền trong group
      await check_user_system_controller.onLoadScreenHomeGetListPermisstion(
          document_id_custommer: document_id_custommer);
      Navigator.pushReplacementNamed(context, SystemCenterScreen.id);
    } else {
      Navigator.pushReplacementNamed(context, HomeCenterScreen.id);
    }
  }

  void updateTokenMessagesFireBase() async {
    String id = await getDocumentIdCustommer();
    await pushNotificationsManager.getTokenFireMessenger(
        documentIdCustommer: id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
    updateTokenMessagesFireBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: setWidthSize(size: 35),
                ),
                Hero(
                  tag: "SunLand_Logo_Ainimation",
                  child: Image.asset(
                    "assets/images/icon_sunland.png",
                    height: setHeightSize(size: 100),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset("assets/images/icon_text_sunland.png",
                        color: Colors.black, height: setHeightSize(size: 25)),
                    SizedBox(
                      child: TypewriterAnimatedTextKit(
                          speed: Duration(milliseconds: 200),
                          isRepeatingAnimation: false,
                          text: [
                            "Đang tải dữ liệu",
                          ],
                          textStyle: TextStyle(fontSize: 25.0),
                          textAlign: TextAlign.start,
                          alignment: AlignmentDirectional
                              .topStart // or Alignment.topLeft
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
