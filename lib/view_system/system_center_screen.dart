import 'package:flutter/material.dart';
import 'package:flutter_core/PushNotifications/PushNotificationsManager.dart';
import 'package:flutter_core/view_system/group_control_panel/control_panel_screen.dart';
import 'package:flutter_core/view_system/group_notify_system_users/notify_system_users_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_check_attendance/check_attendance_screen.dart';
import 'package:flutter_core/widgets/bottom_navy_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class SystemCenterScreen extends StatefulWidget {
  static String id = "HomeCenterAdministator";
  @override
  _SystemCenterScreenState createState() => _SystemCenterScreenState();
}

class _SystemCenterScreenState extends State<SystemCenterScreen> {
  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();
  int _currentIndex = 0;
  @override
  void initState() {
    pushNotificationsManager.registerNotification();
    pushNotificationsManager.configLocalNotification();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ControlPanelScreen(),
      NotifySystemUsersScreen(),
      CheckAttendanceScreen(),
    ];
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Thêm một lần để thoát'),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_currentIndex),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.grey[300],
        selectedIndex: _currentIndex,
        showElevation: false,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Trang chủ'),
            activeColor: Colors.orangeAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Thông báo'),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person_pin),
            title: Text('Điểm danh'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
