import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_notication/group_detail_notifycation/detail_notifycation_screen.dart';
import 'package:flutter_core/widgets/Item_notifycation.dart';

import 'notifycation_controller.dart';

class NotifycatonScreen extends StatefulWidget {
  static String id = "NoticationScreen";
  @override
  _NotifycatonScreenState createState() => _NotifycatonScreenState();
}

class _NotifycatonScreenState extends State<NotifycatonScreen> {
  NotifycationController notifycationController = NotifycationController();
  List<NotifiProductAdsModel> _result = [];

  @override
  void initState() {
    Getdata();
    // TODO: implement initState
    super.initState();
  }

  void Getdata() async {
    var _resulttmp = await notifycationController.onLoadScreenNotifycation();
    if (_resulttmp != null) {
      setState(() {
        _result = _resulttmp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(),
        title: Text("Thông báo"),
        centerTitle: true,
        backgroundColor: colorAppbar,
      ),
      body: Scaffold(
        body: ListView.builder(
          itemCount: _result.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemNotifycation(
              onTap: () {
                Navigator.pushNamed(context, DeatailNotifycationScreen.id,
                    arguments: DeatailNotifycationScreen(
                      notifiProductAdsModel: _result[index],
                    ));
              },
              notifiProductAdsModel: _result[index],
            );
          },
        ),
      ),
    );
  }
}
