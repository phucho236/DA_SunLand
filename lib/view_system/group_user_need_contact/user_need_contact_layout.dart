import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/view_system/group_user_need_contact/group_user_need_contact_screen/user_need_contact_screen.dart';

import 'group_taked_user_need_contact/taked_user_need_contact_screen.dart';
import 'group_taked_user_need_contact_all/taked_user_need_contact_all_screen.dart';

class UserNeedContactLayout extends StatefulWidget {
  static String id = "UserNeedContactLayout";
  UserNeedContactLayout({this.permisstion_user_need_contact_all});
  final bool permisstion_user_need_contact_all;

  @override
  _UserNeedContactLayoutState createState() => _UserNeedContactLayoutState();
}

class _UserNeedContactLayoutState extends State<UserNeedContactLayout>
    with SingleTickerProviderStateMixin {
  UserNeedContactLayout args;
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      _tabController = TabController(
          vsync: this, length: args.permisstion_user_need_contact_all ? 3 : 2);
    });
  }

  List<Widget> listTabBar1 = [
    Tab(
      text: "Nhận liên lạc",
    ),
    Tab(
      text: "Đã nhận liên lạc",
    ),
  ];
  List<Widget> listTabBar2 = [
    Tab(
      text: "Nhận liên lạc",
    ),
    Tab(
      text: "Đã nhận liên lạc",
    ),
    Tab(
      text: "Đã nhận liên lạc (Tất cã hệ thống)",
    )
  ];
  List<Widget> listWidget1 = [
    UserNeedContactScreen(),
    TakedUserNeedContactScreen(),
  ];
  List<Widget> listWidget2 = [
    UserNeedContactScreen(),
    TakedUserNeedContactScreen(),
    TakedUserNeedContactAllScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return args == null
        ? Center(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: colorAppbar,
              title: Text("Người dùng cần liên lạc"),
              bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: args.permisstion_user_need_contact_all
                    ? listTabBar2
                    : listTabBar1,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: args.permisstion_user_need_contact_all
                  ? listWidget2
                  : listWidget1,
            ),
          );
  }
}
