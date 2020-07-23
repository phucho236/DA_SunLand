import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_accuracy/group_forgot_password/send_otp_controller.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = "ForgotPasswordScreen";
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email;
  String otp;
  String password;
  String confirmPass;
  final ForgotPasswordController forgotPasswordController =
      new ForgotPasswordController();
  SendOTPController sendOTPController = SendOTPController();
  int _curentStep = 0;

  bool isClickButton = false;
  bool whenSendEmail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text("Quên mật khẩu"),
        // flexibleSpace: Image.asset("assets/images/Sunland_Logo.png"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: setHeightSize(size: 30),
            ),
            Container(
              child: StreamBuilder(
                stream: forgotPasswordController.errStream,
                builder: (context, snapshot) => Text(
                  snapshot.hasError ? snapshot.error : '',
                  style: styleTextErrorBlack,
                ),
              ),
            ),
            Stepper(
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Row(
                  children: <Widget>[
                    Visibility(
                      visible: false,
                      child: FlatButton(
                        onPressed: onStepContinue,
                        child: null,
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: FlatButton(
                        onPressed: onStepCancel,
                        child: const Text(''),
                      ),
                    ),
                  ],
                );
              },
              steps: _mySteps(),
              currentStep: _curentStep,
              type: StepperType.vertical,
            ),
          ],
        ),
      ),
    );
  }

  List<Step> _mySteps() {
    List<Step> _step = [
      Step(
        title: Text("Bước 1"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                email = value;
                setState(() {
                  isClickButton = true;
                });
              },
              style: styleText,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: styleText,
                prefixIcon: Icon(Icons.mail_outline),
              ),
            ),
            FlatButton(
              onPressed: isClickButton
                  ? () async {
                      setState(() {
                        isClickButton = false;
                        whenSendEmail = true;
                      });
                      await forgotPasswordController
                          .onSubmitSendOTP(
                              email: email != null ? email.trim() : email)
                          .then((_) async {
                        if (_ != null) {
                          await sendOTPController.SendOTP(
                                  recipents_email: email, otp: _)
                              .then((value) {
                            print(value.toString());
                            if (value == true) {
                              setState(() {
                                _curentStep = 1;
                              });
                            }
                          });
                        } else {
                          setState(() {
                            whenSendEmail = false;
                          });
                        }
                      });
                    }
                  : null,
              child: Text(
                "Xác nhận",
                style: isClickButton ? styleText : styleTextWhenClick,
              ),
            ),
            Visibility(
              visible: whenSendEmail,
              //maintainSize: false,
              child: Container(
                  child: Image.asset("assets/images/loading_mail.gif")),
            ),
          ],
        ),
        isActive: _curentStep == 0,
      ),
      Step(
        title: Text("Bước 2"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                otp = value;
                setState(() {
                  isClickButton = true;
                });
              },
              style: styleText,
              decoration: InputDecoration(
                hintStyle: styleText,
                hintText: "OTP",
                prefixIcon: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(Icons.chat_bubble_outline),
                    Text(
                      "OTP",
                      style: styleTextWithIconOTP,
                    ),
                  ],
                ),
                //prefixText: "OTP",
              ),
            ),
            FlatButton(
              onPressed: isClickButton
                  ? () async {
                      await forgotPasswordController
                          .onSubmitCheckOTP(otp: otp)
                          .then((value) {
                        print(value);
                        if (value == true) {
                          setState(() {
                            _curentStep = 2;
                            return;
                          });
                        }
                      });
                    }
                  : null,
              child: Text(
                "Xác nhận",
                style: isClickButton ? styleText : styleTextWhenClick,
              ),
            ),
          ],
        ),
        isActive: _curentStep == 1,
      ),
      Step(
        title: Text("Bước 3"),
        content: Column(
          children: <Widget>[
            TextField(
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                setState(() {
                  isClickButton = true;
                });
                password = value;
              },
              style: styleText,
              decoration: InputDecoration(
                hintText: "Mật khẩu mới.",
                hintStyle: styleText,
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
            TextField(
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                setState(() {
                  isClickButton = true;
                });
                confirmPass = value;
              },
              style: styleText,
              decoration: InputDecoration(
                hintText: "Nhập lại mật khẩu.",
                hintStyle: styleText,
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
            FlatButton(
              onPressed: isClickButton
                  ? () async {
                      setState(() {
                        isClickButton = false;
                      });
                      if (_curentStep == 2) {
                        await forgotPasswordController
                            .onSubmitchangePassword(
                                email: email,
                                password: password != null
                                    ? password.trim()
                                    : password,
                                confirmPass: confirmPass != null
                                    ? confirmPass.trim()
                                    : confirmPass)
                            .then((value) {
                          if (value == true) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Đổi mật khẩu thành công",
                                );
                              },
                            ).then((exit) {
                              if (exit) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        });
                      }
                    }
                  : null,
              child: Text(
                "Xác nhận",
                style: isClickButton ? styleText : styleTextWhenClick,
              ),
            )
          ],
        ),
        isActive: _curentStep == 2,
      )
    ];
    return _step;
  }

  TextStyle styleText = TextStyle(
    height: 1,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: setFontSize(size: 14),
  );
  TextStyle styleTextWhenClick = TextStyle(
    height: 1,
    color: Colors.grey,
    fontWeight: FontWeight.normal,
    fontSize: setFontSize(size: 14),
  );
  TextStyle styleTextWithIconOTP = TextStyle(
    height: 1,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: setFontSize(size: 7),
  );
}
