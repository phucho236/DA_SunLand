import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

setListPermistionCustommerSystem(
    {List<String> listPermistionCustommerSystem}) async {
  print(listPermistionCustommerSystem);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(
      'listPermistionCustommerSystem', listPermistionCustommerSystem);
}

getListPermistionCustommerSystem() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('listPermistionCustommerSystem');
}

setType({int type}) async {
  print(type);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('type', type);
}

getType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('type');
}

setLinkImagesCustommer({String linkImagesCustommer}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('linkImagesCustommer', linkImagesCustommer);
}

getLinkImagesCustommer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('linkImagesCustommer');
}

setEmail({String email}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);
}

getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

setPhoneNumber({String phone_number}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('phone_number', phone_number);
}

getPhoneNumber() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('phone_number');
}

setCreatedAt({String created_at}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('created_at', created_at);
}

getCreatedAt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('created_at');
}

setLastName({String last_name}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('last_name', last_name);
}

getLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_name');
}

setIsPartner({bool is_partner}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('is_partner', is_partner);
}

getIsPartner() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_partner');
}

setFirstName({String first_name}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('first_name', first_name);
}

getFirstName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('first_name');
}

setUserName({String last_name, String first_name}) async {
  String userName = "$last_name $first_name";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user_name', userName);
}

getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name');
}

setLinkImages({String linkImages}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('linkImages', linkImages);
}

getLinkImages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('linkImages');
}

setDocumentIdCustommer({String newValue}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('document_id_custommer', newValue);
}

getDocumentIdCustommer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('document_id_custommer');
}

setFontSize({double size}) {
  return ScreenUtil.getInstance().setSp(size);
}

setHeightSize({double size}) {
  return ScreenUtil.getInstance().setHeight(size);
}

setWidthSize({double size}) {
  return ScreenUtil.getInstance().setWidth(size);
}

getBottomBarHeight({double size}) {
  return ScreenUtil.bottomBarHeight;
}

getTopBarHeight({double size}) {
  return ScreenUtil.statusBarHeight;
}

getScreenWidth() {
  return ScreenUtil.screenWidthDp;
}

getScreenHeight({double size}) {
  return ScreenUtil.screenHeightDp;
}

removeb({String exist_value_b}) {
  String value_return = "";
  try {
    value_return = exist_value_b.split(new RegExp(r"</b>|<b>")).join('');
  } catch (e) {
    return value_return;
  }
  return value_return;
}

getDateShowOnlyHourAndMinute(String dateTypeString) {
  DateTime _date = DateTime.parse(dateTypeString);
  return "${_date.hour >= 10 ? _date.hour : "0${_date.hour}"}:${_date.minute >= 10 ? _date.minute : "0${_date.minute}"}. ";
}

getDateShowHourAndMinute(String dateTypeString) {
  DateTime _date = DateTime.parse(dateTypeString);
  return "${_date.hour < 10 ? "0${_date.hour}" : _date.hour}:${_date.minute < 10 ? "0${_date.minute}" : _date.minute}. ${_date.day < 10 ? "0${_date.day}" : _date.day}/${_date.month < 10 ? "0${_date.month}" : _date.month}/${_date.year}";
}

getDateShow(String dateTypeString) {
  DateTime _date = DateTime.parse(dateTypeString);
  return "${_date.hour}giờ. ${_date.day < 10 ? "0${_date.day}" : _date.day}/${_date.month < 10 ? "0${_date.month}" : _date.month}/${_date.year}";
}

getDateNoHour(String dateTypeString) {
  DateTime _date = DateTime.parse(dateTypeString);
  return "${_date.day < 10 ? "0${_date.day}" : _date.day}/${_date.month < 10 ? "0${_date.month}" : _date.month}/${_date.year}";
}

getSizeImages({File images_path}) {
  Completer<Size> completer = Completer();
  Image image = Image.file(images_path);
  image.image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        var myImage = image.image;
        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(size);
      },
    ),
  );
  return completer.future;
}

String PriceFortmatMoney({double value, bool symbol = true}) {
  FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
      amount: value,
      settings: MoneyFormatterSettings(
        symbol: symbol ? 'VNĐ' : 'VNĐ',
        thousandSeparator: '.',
        fractionDigits: 0,
      ));
  return fmf.output.symbolOnRight;
}

List<String> listTypeSortTime = ["Ngày", "Tháng"];
List<PermistionModel> listPermisstionModelInSystem = [
  PermistionModel(title: "Thêm Sản phẩm", id: "post_product"),
  PermistionModel(title: "Thêm Dự Án", id: "post_project"),
  PermistionModel(title: "Duyệt sản phẩm", id: "product_censorship"),
  PermistionModel(
      title: "Hỗ trợ chat với người dùng", id: "support_chat_with_user"),
  PermistionModel(title: "Người dùng cần liên lạc", id: "user_need_contact"),
  PermistionModel(title: "Chỉnh sửa sản phẩm", id: "edit_product"),
  PermistionModel(
      title: "Duyệt người dùng trở thành đối tác",
      id: "to_become_a_partner_censorship"),
  PermistionModel(
      title: "Quản lí Thông báo cho người dùng hệ thống",
      id: "post_notify_system_users"),
  PermistionModel(title: "Quản lí thông báo gợi ý sản phẩm", id: "product_ads"),
  PermistionModel(title: "Phân quyền", id: "decentralization"),
  PermistionModel(title: "Quản lí điểm danh", id: "attendance_management"),
  PermistionModel(title: "Quản lí lịch hẹn", id: "appointment_management"),
  PermistionModel(
      title: "Người dùng cần liên lạc-tất cã (Chỉ xem)",
      id: "permisstion_user_need_contact_all"),
  PermistionModel(
      title: "Duyệt người dùng trở thành đối tác-tất cã (Chỉ xem)",
      id: "permisstion_to_become_a_partner_censorship_all"),
  PermistionModel(
      title: "Quản lí lịch hẹn-tất cã (Chỉ xem)",
      id: "appointment_management_all_system"),

];

List<TypeFloorModel> listTypeloorModel = [
  TypeFloorModel(id: "1", name: "Tần thấp"),
  TypeFloorModel(id: "2", name: "Trung bình"),
  TypeFloorModel(id: "3", name: "Tần cao"),
];
List<TypeApartmentModel> listTypeApartmentModel = [
  TypeApartmentModel(id: "1", name: "Bán"),
  TypeApartmentModel(id: "2", name: "Thuê"),
];
List<DistrictModel> listDistrictModel = [
  //PermistionModel(title: "Quản trị hệ thống", id: "all_permisstion"),
  DistrictModel(id: "760", name: "Quận 1"),
  DistrictModel(id: "761", name: "Quận 12"),
  DistrictModel(id: "762", name: "Quận Thủ Đức"),
  DistrictModel(id: "763", name: "Quận 9"),
  DistrictModel(id: "764", name: "Quận Gò Vấp"),
  DistrictModel(id: "765", name: "Quận Bình Thạnh"),
  DistrictModel(id: "766", name: "Quận Tân Bình"),
  DistrictModel(id: "767", name: "Quận Tân Phú"),
  DistrictModel(id: "768", name: "Quận Phú Nhuận"),
  DistrictModel(id: "769", name: "Quận 2"),
  DistrictModel(id: "770", name: "Quận 3"),
  DistrictModel(id: "771", name: "Quận 10"),
  DistrictModel(id: "772", name: "Quận 11"),
  DistrictModel(id: "773", name: "Quận 4"),
  DistrictModel(id: "774", name: "Quận 5"),
  DistrictModel(id: "775", name: "Quận 6"),
  DistrictModel(id: "776", name: "Quận 8"),
  DistrictModel(id: "777", name: "Quận Bình Tân"),
  DistrictModel(id: "778", name: "Quận 7"),
  DistrictModel(id: "783", name: "Huyện Củ Chi"),
  DistrictModel(id: "784", name: "Huyện Hóc Môn"),
  DistrictModel(id: "785", name: "Huyện Bình Chánh"),
  DistrictModel(id: "786", name: "Huyện Nhà Bè"),
  DistrictModel(id: "787", name: "Huyện Cần Giờ"),
];
List<ItemsIcon> dataItemsIcons = [
  ItemsIcon(id_icon: 0, name_icon: "Internet"),
  ItemsIcon(id_icon: 1, name_icon: "Wifi"),
  ItemsIcon(id_icon: 2, name_icon: "Đỗ xe"),
  ItemsIcon(id_icon: 3, name_icon: "Bão vệ"),
  ItemsIcon(id_icon: 4, name_icon: "Thẻ ra vào"),
  ItemsIcon(id_icon: 5, name_icon: "Máy phát điện"),
  ItemsIcon(id_icon: 6, name_icon: "Nhân viên trì"),
  ItemsIcon(id_icon: 7, name_icon: "Hồ bơi"),
  ItemsIcon(id_icon: 8, name_icon: "Phòng Gym"),
  ItemsIcon(id_icon: 9, name_icon: "Hệ thống liên lạc"),
  ItemsIcon(id_icon: 10, name_icon: "Sân vui chơi"),
  ItemsIcon(id_icon: 11, name_icon: "Tiệm Coffe"),
  ItemsIcon(id_icon: 12, name_icon: "Ngân hàng/ ATM"),
  ItemsIcon(id_icon: 13, name_icon: "Sân Tenis"),
  ItemsIcon(id_icon: 14, name_icon: "Trung tâm mua sắm"),
  ItemsIcon(id_icon: 15, name_icon: "Siêu thị"),
  ItemsIcon(id_icon: 16, name_icon: "Nhà hàng"),
  ItemsIcon(id_icon: 17, name_icon: "Yoga & Meditation"),
  ItemsIcon(id_icon: 18, name_icon: "Cầu lông"),
  ItemsIcon(id_icon: 19, name_icon: "Nhà thuốc"),
  ItemsIcon(id_icon: 20, name_icon: "Thang máy"),
  ItemsIcon(id_icon: 21, name_icon: "Nhà bếp"),
  ItemsIcon(id_icon: 22, name_icon: "Tivi"),
];
List<IconData> itemsIcon = [
  MdiIcons.earth, //Internet 0
  MdiIcons.wifi, // wifi 1
  MdiIcons.parking, // đỗ xe 2
  MdiIcons.security, // bão vệ 3
  MdiIcons.wallet, // thẻ ra vào tòa nhà 4
  MdiIcons.batteryCharging, //  máy phát điện dự phòng 5
  Icons.gavel, // nhân viên bảo trì 6
  MdiIcons.swim, // hồ bơi 7
  MdiIcons.dumbbell, //phòng gym 8
  MdiIcons.deskphone, // hệ thống liên lạc tòa nhà 9
  MdiIcons.golf, // sân vui chơi 10
  MdiIcons.coffee, // Tiệm cà phê 11
  MdiIcons.bank, //ngân hàng / atm 12
  MdiIcons.tennisBall, // sân tenis 13
  MdiIcons.officeBuilding, // trun tâm mua sắm 14
  MdiIcons.cart, //Siêu thị 15
  MdiIcons.foodForkDrink, // nhà hàng 16
  MdiIcons.yoga, // Yoga & meditation 17
  MdiIcons.badminton, // cầu lông 18
  MdiIcons.pill, // nhà thuốc 19
  MdiIcons.elevator, // thang máy
  Icons.whatshot, // nhà bếp
  MdiIcons.television //tivi
];
