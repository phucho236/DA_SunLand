import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/views/group_not_connection/check_connection_controller.dart';
import 'package:flutter_core/views/group_not_connection/not_connection_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_core/providers/global_provider.dart';
import 'package:flutter_core/routes.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:here_sdk/core.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyConnectivity _connectivity = MyConnectivity.instance;
  Map _source = {ConnectivityResult.none: false};
  bool connection = true;
  bool returnCheckConnection() {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        return false;
        break;
      case ConnectivityResult.mobile:
        return true;
        break;
      case ConnectivityResult.wifi:
        return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SdkContext.init(IsolateOrigin.main);
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    connection = returnCheckConnection();
    ScreenUtil.instance = ScreenUtil(
      width: 375.0,
      height: 812.0,
      allowFontScaling: true,
    )..init(context);
    return connection == false
        ? NotConnectionScreen()
        : MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => GlobalData()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SunLand',
              initialRoute: initialRoute,
              routes: routes,
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
//          brightness: Brightness.light,
                textTheme: TextTheme(
                  body1: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: ScreenUtil.getInstance().setSp(14.0),
                      color: Colors.black,
                      height: 1.4),
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _connectivity.disposeStream();
  }
}
