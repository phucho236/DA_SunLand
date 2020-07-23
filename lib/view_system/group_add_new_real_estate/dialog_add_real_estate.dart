import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_add_new_real_estate/add_real_estate_controller.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';

class DialogAddRealEstateScreen extends StatelessWidget {
  DialogAddRealEstateScreen({
    this.document_id_custommer,
  });
  String name_real_estate;
  String longitude;
  String latitude;
  final String document_id_custommer;
  AddRealEstareController addRealEstareController = AddRealEstareController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text("Thêm dự án"),
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Tên dự án",
                        style: styleTextTitleInBodyBlack,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(setWidthSize(size: 10.0)),
                          child: Column(
                            children: <Widget>[
                              StreamBuilder(
                                stream: addRealEstareController.nameRealEStream,
                                builder: (context, snapshot) => TextFieldBorder(
                                  onChanged: (value) {
                                    name_real_estate = value;
                                  },
                                  hintText: "Tên dự án",
                                  colorTextWhite: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: setHeightSize(size: 10),
                      ),
                      Text(
                        "Tọa độ dự án trên bản đồ",
                        style: styleTextTitleInBodyBlack,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(setWidthSize(size: 10.0)),
                          child: Column(
                            children: <Widget>[
                              StreamBuilder(
                                stream: addRealEstareController.longitudeStream,
                                builder: (context, snapshot) => TextFieldBorder(
                                  onChanged: (value) {
                                    longitude = value;
                                  },
                                  hintText: "kinh độ",
                                  typeInputIsNumber: true,
                                  colorTextWhite: false,
                                ),
                              ),
                              SizedBox(
                                height: setHeightSize(size: 10),
                              ),
                              StreamBuilder(
                                stream: addRealEstareController.latitudeStream,
                                builder: (context, snapshot) => TextFieldBorder(
                                  onChanged: (value) {
                                    latitude = value;
                                  },
                                  hintText: "vĩ độ",
                                  typeInputIsNumber: true,
                                  colorTextWhite: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          child: StreamBuilder(
                            stream: addRealEstareController.errStream,
                            builder: (context, snapshot) => Text(
                              snapshot.hasError ? snapshot.error : '',
                              style: styleTextErrorBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: setHeightSize(size: 140),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/background_dialog_1.png"),
                )),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Đóng")),
        FlatButton(
          onPressed: () async {
            bool result = await addRealEstareController.onSubmitAddRealEstare(
                document_id_custommer: document_id_custommer,
                name_real_estate: name_real_estate,
                longitude: longitude,
                latitude: latitude);
            if (result == true) {
              Navigator.pop(context, result);
            }
          },
          child: (Text("Thêm")),
        ),
      ],
    );
  }
}
