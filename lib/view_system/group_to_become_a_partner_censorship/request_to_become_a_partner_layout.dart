import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/group_request_to_become_a_partner_all/request_to_become_a_partner_all_screen.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/group_request_to_become_a_partner_screen/request_to_become_a_partner_screen.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/group_request_to_become_a_partner_user/request_to_become_a_partner_user_screen.dart';

class RequestToBecomeAPartnerLayout extends StatefulWidget {
  static String id = "RequestToBecomeAPartnerLayout";
  RequestToBecomeAPartnerLayout(
      {this.permisstion_to_become_a_partner_censorship_all});
  final bool permisstion_to_become_a_partner_censorship_all;
  @override
  _RequestToBecomeAPartnerLayoutState createState() =>
      _RequestToBecomeAPartnerLayoutState();
}

class _RequestToBecomeAPartnerLayoutState
    extends State<RequestToBecomeAPartnerLayout>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  RequestToBecomeAPartnerLayout args;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      _tabController = TabController(
          vsync: this,
          length: args.permisstion_to_become_a_partner_censorship_all ? 3 : 2);
    });
  }

  List<Widget> listTabBar1 = [
    Tab(
      text: "Yêu cầu",
    ),
    Tab(
      text: "Yêu cầu đã duyệt",
    ),
  ];
  List<Widget> listTabBar2 = [
    Tab(
      text: "Yêu cầu",
    ),
    Tab(
      text: "Yêu cầu đã duyệt",
    ),
    Tab(
      text: "Yêu cầu(tất cã hệ thống)",
    ),
  ];
  List<Widget> listWidget1 = [
    RequestToBecomeAPartnerScreen(),
    RequestToBecomeAPartnerOfTheUserScreen(),
  ];
  List<Widget> listWidget2 = [
    RequestToBecomeAPartnerScreen(),
    RequestToBecomeAPartnerOfTheUserScreen(),
    RequestToBecomeAPartnerAllScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return args == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: colorAppbar,
              title: Text("Yêu cầu trở thành đối tác"),
              bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: args.permisstion_to_become_a_partner_censorship_all
                    ? listTabBar2
                    : listTabBar1,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: args.permisstion_to_become_a_partner_censorship_all
                  ? listWidget2
                  : listWidget1,
            ),
          );
  }
}
