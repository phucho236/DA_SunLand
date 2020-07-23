import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_accuracy/group_register/register_controller.dart';
import 'package:flutter_core/views/group_images_brain/images_brain.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "RegisterScreen";
  RegisterScreen(
      {this.email,
      this.fist_name,
      this.last_name,
      this.phone_number,
      this.gg_id,
      this.fb_id});
  final String email;
  final String fist_name;
  final String last_name;
  final String phone_number;
  final String fb_id;
  final String gg_id;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterController registerController = RegisterController();
  RegisterScreen args;
  var textEmailController = new TextEditingController();
  var textFirstNameController = new TextEditingController();
  var textLastNameController = new TextEditingController();
  var textPhoneNumberController = new TextEditingController();
  var textPasswordController = new TextEditingController();
  var textConfirmPaswordcontroller = new TextEditingController();
  File _images;
  ImagesBrain imagesBrain = ImagesBrain();
  bool isClickButton = false;
  bool whenSendData = false;
  bool hidePassWord = true;
  bool hideConfirmPassWord = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      textFirstNameController.text = args.fist_name;
      textLastNameController.text = args.last_name;
      textEmailController.text = args.email;
      textPhoneNumberController.text = args.phone_number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Đăng kí"),
        // flexibleSpace: Image.asset("assets/images/Sunland_Logo.png"),
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_login.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: setWidthSize(size: 15.0)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: setHeightSize(size: 30),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheetImagesPicker(context);
                      },
                      child: _images == null
                          ? CircleAvatar(
                              child: Image.asset(
                                'assets/images/library_image.png',
                                color: Colors.blueAccent,
                                fit: BoxFit.cover,
                              ),
                              radius: 150 / 2,
                              backgroundColor: Colors.white,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150 / 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.5),
                                    blurRadius:
                                        3, // has the effect of softening the shadow
                                    spreadRadius:
                                        .1, // has the effect of extending the shadow
                                    offset: Offset(
                                      1.0, // horizontal, move right 10
                                      1.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundImage: FileImage(_images),
                                radius: 150 / 2,
                                backgroundColor: Colors.black26,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 10),
                    ),
                    Center(
                      child: Container(
                        child: StreamBuilder(
                          stream: registerController.errStream,
                          builder: (context, snapshot) => Text(
                            snapshot.hasError ? snapshot.error : '',
                            style: styleTextErrorWhite,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 20),
                    ),
                    StreamBuilder(
                      stream: registerController.emailStream,
                      builder: (context, snapshot) => TextFieldBorder(
                        readOnly: true,
                        controller: textEmailController,
                        iconLeft: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        hintText: "Email: ",
                        onChanged: (value) {
                          setState(() {
                            isClickButton = true;
                          });
                          textEmailController = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 20),
                    ),
                    StreamBuilder(
                      stream: registerController.firsNameStream,
                      builder: (context, snapshot) => TextFieldBorder(
                        controller: textFirstNameController,
                        iconLeft: Icon(
                          Icons.short_text,
                          color: Colors.white,
                        ),
                        hintText: "Tên: ",
                        onChanged: (value) {
                          setState(() {
                            isClickButton = true;
                          });
                          textFirstNameController = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 20),
                    ),
                    StreamBuilder(
                      stream: registerController.lastNameStream,
                      builder: (context, snapshot) => TextFieldBorder(
                        controller: textLastNameController,
                        iconLeft: Icon(
                          Icons.short_text,
                          color: Colors.white,
                        ),
                        hintText: "Họ: ",
                        onChanged: (value) {
                          setState(() {
                            isClickButton = true;
                          });
                          textLastNameController = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 20),
                    ),
                    StreamBuilder(
                      stream: registerController.phoneStream,
                      builder: (context, snapshot) => TextFieldBorder(
                        typeInputIsNumber: true,
                        controller: textPhoneNumberController,
                        iconLeft: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        hintText: "Số điện thoại: ",
                        onChanged: (value) {
                          setState(() {
                            isClickButton = true;
                          });
                          textPhoneNumberController = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 20),
                    ),
                    StreamBuilder(
                      stream: registerController.passwordStream,
                      builder: (context, snapshot) => TextFieldBorder(
                        stylePassWord: true,
                        ShowPass: hidePassWord,
                        iconShowPas: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            hidePassWord
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              hidePassWord = !hidePassWord;
                            });
                          },
                        ),
                        controller: textPasswordController,
                        iconLeft: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                        ),
                        hintText: "Mật khẩu: ",
                        onChanged: (value) {
                          setState(() {
                            isClickButton = true;
                          });
                          textPasswordController = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 20),
                    ),
                    StreamBuilder(
                      stream: registerController.confirmPassStream,
                      builder: (context, snapshot) => TextFieldBorder(
                        ShowPass: hideConfirmPassWord,
                        iconShowPas: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            hideConfirmPassWord
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              hideConfirmPassWord = !hideConfirmPassWord;
                            });
                          },
                        ),
                        controller: textConfirmPaswordcontroller,
                        stylePassWord: true,
                        iconLeft: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                        ),
                        hintText: "Nhập lại mật khẩu: ",
                        onChanged: (value) {
                          setState(() {
                            isClickButton = true;
                          });
                          textConfirmPaswordcontroller = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 40),
                    ),
                    Container(
                      width: setWidthSize(size: 200),
                      child: ButtonNormal(
                        text: "Xác nhận",
                        onTap: isClickButton
                            ? () async {
                                setState(() {
                                  isClickButton = false;
                                  whenSendData = true;
                                });
                                dynamic document_id_custommer =
                                    await registerController
                                        .onSubmitRegisterAddCustommerProfile(
                                            email: textEmailController.text,
                                            firstName:
                                                textFirstNameController.text,
                                            lastName:
                                                textLastNameController.text,
                                            images: _images,
                                            phoneNumber:
                                                textPhoneNumberController.text,
                                            password:
                                                textPasswordController.text,
                                            confirmPass:
                                                textConfirmPaswordcontroller
                                                    .text,
                                            created_at:
                                                DateTime.now().toString(),
                                            fb_id: args.fb_id,
                                            gg_id: args.gg_id);
                                if (document_id_custommer != null) {
                                  String document_id_authenticator =
                                      await registerController
                                          .onSubmitRegisterAuthenticator(
                                    document_id_custommer:
                                        document_id_custommer,
                                    email: textEmailController.text,
                                    pass: textPasswordController.text,
                                  );
                                  if (document_id_authenticator != null) {
                                    Navigator.pop(context, true);
                                  }
                                } else {
                                  setState(() {
                                    whenSendData = false;
                                  });
                                }
                              }
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: setHeightSize(size: 45),
                    ),
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
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.all(setWidthSize(size: 10)),
                  child: Image.asset(
                    "assets/images/loading_images.gif",
                    height: 75,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void showModalBottomSheetImagesPicker(context) {
    File _imagesTMP;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(
                      Icons.camera_alt,
                      // color: kColorBorDer,
                    ),
                    title: new Text('Camera'),
                    onTap: () async {
                      _imagesTMP =
                          await imagesBrain.getImageCamera(ImageSource.camera);
                      setState(() {
                        _images = _imagesTMP;
                      });
                      Navigator.pop(context);
                    }),
                new ListTile(
                  leading: new Icon(
                    Icons.image,
                    //color: kColorBorDer,
                  ),
                  title: new Text('Gallery'),
                  onTap: () async {
                    _imagesTMP =
                        await imagesBrain.getImageCamera(ImageSource.gallery);
                    setState(() {
                      _images = _imagesTMP;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
