import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_accuracy/group_forgot_password/forgot_password_screen.dart';
import 'package:flutter_core/views/group_accuracy/group_login/login_controller.dart';
import 'package:flutter_core/views/group_accuracy/group_login/login_with_facebook_controller.dart';
import 'package:flutter_core/views/group_accuracy/group_login/login_with_google_controller.dart';
import 'package:flutter_core/views/group_accuracy/group_register/register_screen.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_save_data/save_data_screen.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/views/group_introduce/introduce_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  String email;
  String pass;
  LoginController loginController = LoginController();
  LoginWithFacebookController loginWithFacebookController =
      LoginWithFacebookController();
  LoginWithGoogleController loginWithGoogleController =
      LoginWithGoogleController();
  bool hidePassWord = true;
  bool isClickButton = false;
  bool whenSendData = false;
  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    print(animation.value);
    controller.forward();
    controller.addListener(() {
      setState(() {
        //controller.value;
        print(animation.value);
      });
    });
    onViewIntroduce();
    // TODO: implement initState
    super.initState();
  }

  onViewIntroduce() async {
    if (await getIntroduce() != true) {
      Navigator.pushReplacementNamed(context, IntroduceScreen.id);
    } else {
      onLogin();
    }
  }

  onLogin() async {
    String document_id_custommer = await getDocumentIdCustommer();
    if (document_id_custommer != null) {
      if (document_id_custommer != '') {
        print("ABCD");
        print(document_id_custommer.runtimeType);
        Navigator.pushReplacementNamed(context, SaveDataScreen.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            // height: getScreenHeight(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_login.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                height: getScreenHeight() + setHeightSize(size: 120),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Hero(
                              tag: "SunLand_Logo_Ainimation",
                              child: Container(
                                height: animation.value * 250,
                                child: Image.asset(
                                  "assets/images/icon_sunland.png",
                                  //height: setHeightSize(size: 200),
                                ),
                              ),
                            ),
                            Image.asset("assets/images/icon_text_sunland.png",
                                height: setHeightSize(size: 50)),
                          ],
                        ),
                        height: getScreenHeight() / 2 - getTopBarHeight(),
                        width: setHeightSize(size: 300),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: setWidthSize(size: 15)),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: setHeightSize(size: 10)),
                                child: StreamBuilder(
                                  stream: loginController.errStream,
                                  builder: (context, snapshot) => Text(
                                    snapshot.hasError ? snapshot.error : '',
                                    style: styleTextErrorWhite,
                                  ),
                                ),
                              ),
                            ),
                            TextFieldBorder(
                              iconLeft: Icon(
                                Icons.perm_identity,
                                color: Colors.white,
                              ),
                              hintText: "Tài khoản",
                              onChanged: (value) {
                                setState(() {
                                  isClickButton = true;
                                });
                                email = value;
                              },
                            ),
                            SizedBox(
                              height: setHeightSize(size: 20),
                            ),
                            TextFieldBorder(
                              stylePassWord: hidePassWord,
                              hintText: "Mật khẩu",
                              onChanged: (value) {
                                setState(() {
                                  isClickButton = true;
                                });
                                pass = value;
                              },
                              iconLeft: Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                              ),
                              iconShowPas: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  hidePassWord
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    hidePassWord = !hidePassWord;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Quên mật khẩu ?",
                                    style: styleText,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ForgotPasswordScreen.id);
                                  },
                                ),
                              ],
                            ),
                            Container(
                              width: setWidthSize(size: 200),
                              child: ButtonNormal(
                                onTap: isClickButton
                                    ? () async {
                                        setState(() {
                                          isClickButton = false;
                                          whenSendData = true;
                                        });
                                        await loginController
                                            .onSubmitLogin(
                                                email: email != null
                                                    ? email.trim()
                                                    : email,
                                                password: pass != null
                                                    ? pass.trim()
                                                    : pass)
                                            .then((value) {
                                          if (value) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SaveDataScreen(),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              whenSendData = false;
                                            });
                                          }
                                        });
                                      }
                                    : null,
                                text: "Đăng nhập",
                              ),
                            ),
                            SizedBox(
                              height: setHeightSize(size: 20),
                            ),
                            Text(
                              "Hoặc đăng nhập với: ",
                              style: styleText,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                ClipOval(
                                  child: Material(
                                    color: Colors.red, // button color
                                    child: InkWell(
                                      splashColor: Colors.grey, // inkwell color
                                      child: SizedBox(
                                        width: setHeightSize(size: 45),
                                        height: setHeightSize(size: 45),
                                        child: Image.asset(
                                            "assets/images/google_icon.png"),
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          isClickButton = false;
                                          whenSendData = true;
                                        });
                                        await loginWithGoogleController
                                            .initiateGoogleLogin()
                                            .then((value) {
                                          if (value.runtimeType ==
                                              ProfileGoogle) {
                                            print(value.uid);
                                            Navigator.pushNamed(
                                              context,
                                              RegisterScreen.id,
                                              arguments: RegisterScreen(
                                                email: value.email,
                                                fist_name: value.displayName,
                                                gg_id: value.uid,
                                                phone_number: value.phoneNumber,
                                              ),
                                            ).then((value) {
                                              if (value == true) {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDiaLogScreen(
                                                      title: "Thông báo",
                                                      message:
                                                          "Tạo tài khoản thành công",
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          }
                                          if (value.runtimeType ==
                                              CustomerProfileModel) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SaveDataScreen(),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              whenSendData = false;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: setWidthSize(size: 10),
                                ),
                                ClipOval(
                                  child: Material(
                                    color: Colors.blue, // button color
                                    child: InkWell(
                                      splashColor: Colors.grey, // inkwell color
                                      child: SizedBox(
                                        width: setHeightSize(size: 45),
                                        height: setHeightSize(size: 45),
                                        child: Image.asset(
                                            "assets/images/facebook_icon.png"),
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          isClickButton = false;
                                          whenSendData = true;
                                        });
                                        await loginWithFacebookController
                                            .initiateFacebookLogin()
                                            .then((value) {
                                          if (value.runtimeType ==
                                              ProfileFacebook) {
                                            Navigator.pushNamed(
                                              context,
                                              RegisterScreen.id,
                                              arguments: RegisterScreen(
                                                fist_name: value.first_name,
                                                email: value.email,
                                                fb_id: value.id,
                                                last_name: value.last_name,
                                              ),
                                            ).then((value) {
                                              if (value == true) {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDiaLogScreen(
                                                      title: "Thông báo",
                                                      message:
                                                          "Tạo tài khoản thành công",
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          }
                                          if (value.runtimeType ==
                                              CustomerProfileModel) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SaveDataScreen(),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              whenSendData = false;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            child: Visibility(
              visible: whenSendData,
              //maintainSize: false,
              child: Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.all(setWidthSize(size: 10)),
                  child: Image.asset(
                    "assets/images/loading_images.gif",
                    height: 75,
                  )),
            ),
          )
        ],
      ),
    );
  }

  TextStyle styleTextLink = TextStyle(
    height: 1,
    color: Colors.blueAccent,
    fontWeight: FontWeight.normal,
    fontSize: setFontSize(size: 14),
  );
  TextStyle styleText = TextStyle(
    height: 1,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: setFontSize(size: 14),
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
