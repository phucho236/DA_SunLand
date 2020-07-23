import 'package:flutter/material.dart';
import 'package:flutter_core/PushNotifications/PushNotificationsManager.dart';
import 'package:flutter_core/views/group_home_page/home_page_screen.dart';
import 'package:flutter_core/widgets/bottom_navy_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'group_like_item/like_item_screen.dart';
import 'group_message/message_screen.dart';
import 'group_profile_page/profile_screen.dart';

class HomeCenterScreen extends StatefulWidget {
  static String id = "HomeCenterScreen";

  @override
  _HomeCenterScreenState createState() => _HomeCenterScreenState();
}

class _HomeCenterScreenState extends State<HomeCenterScreen> {
  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();
  int _selectedIndex = 0;
  final pageController = PageController();
  void onPageChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    HomePageScreen(),
    LikeItemScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    pushNotificationsManager.registerNotification();
    pushNotificationsManager.configLocalNotification();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Thêm một lần để thoát'),
        ),
        child: PageView(
          children: _widgetOptions,
          controller: pageController,
          onPageChanged: onPageChange,
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          pageController.jumpToPage(index);
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Trang chủ'),
            activeColor: Colors.orangeAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Yêu thích'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Cá nhân'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
