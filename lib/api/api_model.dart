import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ProfileGoogle {
  String uid;
  String email;
  String displayName;
  String photoUrl;
  String phoneNumber;
  ProfileGoogle(
      {this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.phoneNumber});
  ProfileGoogle.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    email = json["email"];
    displayName = json["displayName"];
    photoUrl = json["photoUrl"];
    phoneNumber = json["phoneNumber"];
  }
}

class ProfileFacebook {
  String name;
  String first_name;
  String last_name;
  String email;
  String id;
  ProfileFacebook(
      {this.email, this.name, this.id, this.last_name, this.first_name});
  ProfileFacebook.fromJson(Map<String, dynamic> json) {
    first_name = json["first_name"];
    last_name = json["last_name"];
    email = json["email"];
    id = json["id"];
    name = json["name"];
  }
}

class InfoOTP {
  String email;
  String time_create_otp;
  InfoOTP({this.email, this.time_create_otp});
  InfoOTP.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    time_create_otp = json["time_create_otp"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["email"] = email;
    data["time_create_otp"] = time_create_otp;
    return data;
  }
}

class Authenticator {
  String document_id_custommer;
  String email;
  String pass;
  String last_change_password;
  Authenticator(
      {this.document_id_custommer,
      this.email,
      this.pass,
      this.last_change_password});
  Authenticator.fromJson(Map<String, dynamic> json) {
    document_id_custommer = json["document_id_custommer"];
    email = json["email"];
    pass = json["pass"];
    last_change_password = json["last_change_password"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["document_id_custommer"] = document_id_custommer;
    data["email"] = email;
    data["pass"] = pass;
    data["last_change_password"] = last_change_password;
    return data;
  }
}

class GroupPermission {
  // tạo group các quyền group quyền có thể tạo thêm từ các quyền nhỏ hơn
  String name_group_permission;
  List<String> list_permisstion_system;
}

class PermisstionSystem {
  //này tạo mặc định không cho thêm nên id tự gán :)))
  String id_permisstion;
  String name_permisstion;
}

class DataCustommerSystem {
  String document_id_custommer;
  List<String> list_permission;
  DataCustommerSystem({this.document_id_custommer, this.list_permission});
  DataCustommerSystem.fromJson(Map<String, dynamic> json) {
    document_id_custommer = json["document_id_custommer"];
    list_permission = json["[list_permission]"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["document_id_custommer"] = document_id_custommer;
    data["[list_permission]"] = List.from(list_permission);
    return data;
  }
}

class AppointmentModel {
  String document_id_appointment;
  String document_id_user_handing;
  String document_id_custommer_out_the_system;
  bool is_custommer_profile_out_the_system;
  String document_id_product;
  String post_by;
  String post_at;
  String time_metting;
  String url_images_check_in;
  CoordinatesDoubleModel location_images_check_in;
  bool checked_in;
  String checked_in_at;
  String address_appointment;
  String checked_in_by;
  String last_edit_by;
  String last_edit_at;
  bool removed;
  String removed_at;
  String remove_by;
  AppointmentModel(
      {this.document_id_user_handing,
      this.document_id_custommer_out_the_system,
      this.is_custommer_profile_out_the_system,
      this.document_id_product,
      this.last_edit_by,
      this.post_at,
      this.removed,
      this.last_edit_at,
      this.time_metting,
      this.post_by,
      this.remove_by,
      this.checked_in,
      this.checked_in_at,
      this.address_appointment,
      this.checked_in_by,
      this.location_images_check_in,
      this.removed_at,
      this.url_images_check_in,
      this.document_id_appointment});
  AppointmentModel.fromJson(Map<String, dynamic> json) {
    address_appointment = json["address_appointment"];
    checked_in = json["checked_in"];
    checked_in_at = json["checked_in_at"];
    checked_in_by = json["checked_in_by"];
    location_images_check_in = json["location_images_check_in"] == null
        ? null
        : CoordinatesDoubleModel.fromJson(json["location_images_check_in"]);
    document_id_custommer_out_the_system =
        json["document_id_custommer_out_the_system"];
    document_id_product = json["document_id_product"];
    document_id_user_handing = json["document_id_user_handing"];
    is_custommer_profile_out_the_system =
        json["is_custommer_profile_out_the_system"];
    last_edit_at = json["last_edit_at"];
    last_edit_by = json["last_edit_by"];
    post_at = json["post_at"];
    post_by = json['post_by'];
    remove_by = json["remove_by"];
    removed = json["removed"];
    removed_at = json["removed_at"];
    time_metting = json["time_metting"];
    url_images_check_in = json["url_images_check_in"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["document_id_user_handing"] = document_id_user_handing;
    data["address_appointment"] = address_appointment;
    data["document_id_custommer_out_the_system"] =
        document_id_custommer_out_the_system;
    data["is_custommer_profile_out_the_system"] =
        is_custommer_profile_out_the_system;
    data["document_id_product"] = document_id_product;
    data["post_by"] = post_by;
    data["post_at"] = DateTime.now().toString();
    data["url_images_check_in"] = url_images_check_in;
    data["location_images_check_in"] = location_images_check_in.toJson();
    data["checked_in"] = false;
    data["checked_in_at"] = checked_in_at;
    data["checked_in_by"] = checked_in_by;
    data["last_edit_by"] = last_edit_by;
    data["last_edit_at"] = last_edit_at;
    data["removed"] = removed;
    data["removed_at"] = removed_at;
    data["time_metting"] = time_metting;
    data["remove_by"] = remove_by;
    return data;
  }
}

class CustomerProfileModel {
  bool is_seleced = false;
  bool chatted;
  String first_name;
  String last_name;
  String user_name;
  String chatting_with;
  String email;
  String phone_number;
  bool status;
  String fb_id;
  String gg_id;
  bool is_partner;
  String linkImages;
  String created_at;
  String deleted_at;
  String last_login;
  int total_days;
  List<dynamic> list_item_like;
  int type;
  String document_id_custommer;

  CustomerProfileModel({
    this.is_seleced,
    this.chatted,
    this.first_name,
    this.last_name,
    this.email,
    this.user_name,
    this.chatting_with,
    this.phone_number,
    this.status,
    this.fb_id,
    this.gg_id,
    this.is_partner,
    this.linkImages,
    this.created_at,
    this.deleted_at,
    this.last_login,
    this.total_days,
    this.list_item_like,
    this.type,
    this.document_id_custommer,
  });

  CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    chatted = json["chated"];
    first_name = json["first_name"];
    last_name = json["last_name"];
    user_name = json["user_name"];
    chatting_with = json["chatting_with"];
    email = json["email"];
    phone_number = json["phone_number"];
    status = json["status"];
    fb_id = json["fb_id"];
    gg_id = json["gg_id"];
    is_partner = json["is_partner"];
    linkImages = json['linkImages'];
    created_at = json["created_at"];
    deleted_at = json["deleted_at"];
    last_login = json["last_login"];
    total_days = json["total_days"];
    list_item_like = json["list_item_like"];
    type = json['type'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["chated"] = chatted;
    data["first_name"] = first_name;
    data["last_name"] = last_name;
    data["user_name"] = user_name;
    data["email"] = email;
    data["phone_number"] = phone_number;
    data["status"] = status;
    data["fb_id"] = fb_id;
    data["gg_id"] = gg_id;
    data["is_partner"] = is_partner;
    data["linkImages"] = linkImages;
    data["created_at"] = created_at;
    data["deleted_at"] = deleted_at;
    data["last_login"] = last_login;
    data["total_days"] = total_days;
    data["list_item_like"] = list_item_like;
    data["type"] = type;
    return data;
  }
}

class SizeImages {
  double weight;
  double height;
  SizeImages({this.weight, this.height});

  SizeImages.fromJson(Map<String, dynamic> json) {
    weight = json["weight"];
    height = json["height"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["weight"] = weight;
    data["height"] = height;
    return data;
  }
}

class ItemsIcon {
  int id_icon;
  String name_icon;
  bool is_choos;
  ItemsIcon({this.id_icon, this.name_icon, this.is_choos = false});

  ItemsIcon.fromJson(Map<String, dynamic> json) {
    id_icon = json["id_icon"];
    name_icon = json["name_icon"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id_icon"] = id_icon;
    data["name_icon"] = name_icon;
    return data;
  }
}

class ImagesModel {
  // tra ve cua user
  String linkImages;
  ImagesModel({this.linkImages});

  ImagesModel.fromJson(Map<String, dynamic> json) {
    linkImages = json["linkImages"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["linkImages"] = linkImages;
    return data;
  }
}

class NotifiProductAdsModel {
  String document_id_notify_product_ads;
  String content;
  List<dynamic> list_document_id_product;
  String post_at;
  String post_by;
  String remove_at;
  String remove_by;
  bool removed;
  String title;
  NotifiProductAdsModel(
      {this.document_id_notify_product_ads,
      this.content,
      this.list_document_id_product,
      this.post_at,
      this.post_by,
      this.remove_at,
      this.remove_by,
      this.removed,
      this.title});

  NotifiProductAdsModel.fromJson(Map<String, dynamic> json) {
    content = json["content"];
    list_document_id_product = json["list_document_id_product"];
    post_at = json["post_at"];
    post_by = json["post_by"];
    remove_at = json["remove_at"];
    remove_by = json["remove_by"];
    removed = json["removed"];
    title = json["title"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["content"] = content;
    data["list_document_id_product"] = list_document_id_product;
    data["post_at"] = post_at;
    data["post_by"] = post_by;
    data["remove_at"] = remove_at;
    data["remove_by"] = remove_by;
    data["removed"] = removed;
    data["title"] = title;
    return data;
  }
}

class PermistionModel {
  bool isSelected;
  String id;
  String title;
  PermistionModel({this.id, this.title, this.isSelected = false});
  PermistionModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["title"] = title;
    return data;
  }
}

class TypeApartmentModel {
  String id;
  String name;
  TypeApartmentModel({this.id, this.name});
  TypeApartmentModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}

class DistrictModel {
  String id;
  String name;
  DistrictModel({this.id, this.name});
  DistrictModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}

class TypeFloorModel {
  String id;
  String name;
  TypeFloorModel({this.id, this.name});
  TypeFloorModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}

class AddressModelHereMapReturn {
  AddressModel addressModel;
  DisplayPositionModel displayPositionModel;
  AddressModelHereMapReturn({
    this.addressModel,
    this.displayPositionModel,
  });
  AddressModelHereMapReturn.fromJson(Map<String, dynamic> json) {
    addressModel = json["addressModel"];
    //displayPositionModel = jsonDecode(json["displayPositionModel"]);
  }
}

class AddressSuggestionsModelMatchLevelDistrict {
  String country;
  String county;
  String city;
  String district;
  String street;

  AddressSuggestionsModelMatchLevelDistrict({
    this.country,
    this.county,
    this.city,
    this.district,
    this.street,
  });
  AddressSuggestionsModelMatchLevelDistrict.fromJson(
      Map<String, dynamic> json) {
    country = json["country"];
    county = json["county"];
    city = json["city"];
    district = json["district"];
    street = json["street"];
  }
}

class AddressSuggestionsModelMatchLevelStreet {
  String country;
  String county;
  String city;
  String district;
  String street;

  AddressSuggestionsModelMatchLevelStreet({
    this.country,
    this.county,
    this.city,
    this.district,
    this.street,
  });
  AddressSuggestionsModelMatchLevelStreet.fromJson(Map<String, dynamic> json) {
    country = json["country"];
    county = json["county"];
    city = json["city"];
    district = json["district"];
    street = json["street"];
  }
}

class AddressSuggestionsModelMatchLevelHouseNumber {
  String country;
  String county;
  String city;
  String district;
  String street;
  String houseNumber;
  AddressSuggestionsModelMatchLevelHouseNumber({
    this.country,
    this.county,
    this.city,
    this.district,
    this.street,
    this.houseNumber,
  });
  AddressSuggestionsModelMatchLevelHouseNumber.fromJson(
      Map<String, dynamic> json) {
    country = json["country"];
    county = json["county"];
    city = json["city"];
    district = json["district"];
    street = json["street"];
    houseNumber = json["houseNumber"];
  }
}

class SuggestionsModel {
  String label;
  String language;
  String countryCode;
  String locationId;
  AddressSuggestionsModelMatchLevelHouseNumber address_lever_house_number;
  AddressSuggestionsModelMatchLevelStreet address_lever_street;
  AddressSuggestionsModelMatchLevelDistrict address_lever_district;

  String matchLevel;
  SuggestionsModel({
    this.label,
    this.language,
    this.countryCode,
    this.address_lever_house_number,
    this.address_lever_street,
    this.address_lever_district,
    this.matchLevel,
  });
  SuggestionsModel.fromJson(Map<String, dynamic> json) {
    label = json["label"];
    language = json["language"];
    countryCode = json["countryCode"];
    address_lever_house_number =
        AddressSuggestionsModelMatchLevelHouseNumber.fromJson(json["address"]);
    address_lever_district =
        AddressSuggestionsModelMatchLevelDistrict.fromJson(json["address"]);
    address_lever_street =
        AddressSuggestionsModelMatchLevelStreet.fromJson(json["address"]);
    matchLevel = json["matchLevel"];
  }
}

class DisplayPositionModel {
  double Latitude;
  double Longitude;
  DisplayPositionModel({
    this.Latitude,
    this.Longitude,
  });
  DisplayPositionModel.fromJson(Map<String, dynamic> json) {
    Latitude = json["Latitude"];
    Longitude = json["Longitude"];
  }
}

class AddressModel {
  String Label;
  String Country;
  String County;
  String City;
  String District;
  String Subdistrict;
  String Street;
  String HouseNumber;

  AddressModel(
      {this.Label,
      this.Country,
      this.County,
      this.City,
      this.District,
      this.Subdistrict,
      this.Street,
      this.HouseNumber});
  AddressModel.fromJson(Map<String, dynamic> json) {
    Label = json["Label"];
    Country = json["Country"];
    County = json["County"];
    City = json["City"];
    District = json["District"];
    Subdistrict = json["Subdistrict"];
    Street = json["Street"];
    HouseNumber = json["HouseNumber"];
  }
}

class CoordinatesDoubleModel {
  double longitude;
  double latitude;
  CoordinatesDoubleModel({this.longitude, this.latitude});
  CoordinatesDoubleModel.fromJson(Map<String, dynamic> json) {
    latitude = json["latitude"];
    longitude = json["longitude"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["latitude"] = latitude;
    data["longitude"] = longitude;
    return data;
  }
}

class CoordinatesModel {
  String longitude;
  String latitude;
  CoordinatesModel({this.longitude, this.latitude});
  CoordinatesModel.fromJson(Map<String, dynamic> json) {
    latitude = json["latitude"];
    longitude = json["longitude"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["latitude"] = latitude;
    data["longitude"] = longitude;
    return data;
  }
}

class NotedModel {
  String content;
  String post_at;
  String note_by;
  NotedModel({this.content, this.post_at});
  NotedModel.fromJson(Map<String, dynamic> json) {
    post_at = json["post_at"];
    note_by = json["note_by"];
    content = json["content"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["content"] = content;
    data["post_at"] = post_at;
    data["note_by"] = note_by;
    return data;
  }
}

class ProductNeedSuportModel {
  String document_id_product_need_support;
  String document_id_custommer_need_contact;
  List<dynamic> list_document_id_product;
  String post_at;
  bool contacted;
  String contacted_at;
  bool taked;
  String contact_by;
  String taked_at;
  String taked_by;
  List<dynamic> note;
  String last_edit;
  String edit_by;
  ProductNeedSuportModel({
    this.list_document_id_product,
    this.contacted,
    this.document_id_custommer_need_contact,
    this.document_id_product_need_support,
  });
  ProductNeedSuportModel.fromJson(Map<String, dynamic> json) {
    contacted_at = json["contacted_at"];
    contact_by = json["contacted_by"];
    contacted = json["contacted"];
    document_id_custommer_need_contact =
        json["document_id_custommer_need_contact"];
    list_document_id_product = json["list_document_id_product"];
    note = json["note"];
    post_at = json["post_at"];
    taked = json["taked"];
    taked_at = json["taked_at"];
    taked_by = json["taked_by"];
    edit_by = json["edit_by"];
    last_edit = json["last_edit"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["document_id_custommer_need_contact"] =
        document_id_custommer_need_contact;
    data["list_document_id_product"] = list_document_id_product;
    data["post_at"] = post_at;
    data["contacted"] = contacted;
    data["contacted_at"] = contacted_at;
    data["contact_by"] = contact_by;
    data["taked"] = taked;
    data["taked_at"] = taked_at;
    data["note"] = note.map((e) => e.toJson());
    data["edit_by"] = null;
    data["last_edit"] = null;
    return data;
  }
}

class CostModel {
  String management_cost;
  String motorbike_parking_cost;
  String car_parking_cost;
  String gym_cost;
  String swimming_pool_cost;

  CostModel(
      {this.management_cost,
      this.car_parking_cost,
      this.gym_cost,
      this.motorbike_parking_cost,
      this.swimming_pool_cost});
  CostModel.fromJson(Map<String, dynamic> json) {
    management_cost = json["management_cost"];
    motorbike_parking_cost = json["motorbike_parking_cost"];
    car_parking_cost = json["car_parking_cost"];
    gym_cost = json["gym_cost"];
    swimming_pool_cost = json["swimming_pool_cost"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["management_cost"] = management_cost;
    data["motorbike_parking_cost"] = motorbike_parking_cost;
    data["car_parking_cost"] = car_parking_cost;
    data["gym_cost"] = gym_cost;
    data["swimming_pool_cost"] = swimming_pool_cost;
    return data;
  }
}

class RealEstateModel {
  String document_id_estate;
  String name_real_estate;
  CoordinatesModel coordinates;
  String last_edit;
  String last_edit_by;
  String post_at;
  String post_by;
  RealEstateModel(
      {this.name_real_estate,
      this.coordinates,
      this.last_edit,
      this.last_edit_by,
      this.post_at,
      this.post_by,
      this.document_id_estate});
  RealEstateModel.fromJson(Map<String, dynamic> json) {
    coordinates = CoordinatesModel.fromJson(json["coordinates"]);
    last_edit = json["last_edit"];
    last_edit_by = json["last_edit_by"];
    name_real_estate = json["name_real_estate"];
    post_at = json["post_at"];
    post_by = json["post_by"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name_real_estate"] = name_real_estate;
    data["coordinates"] = coordinates.toJson();
    data["last_edit"] = last_edit;
    data["last_edit_by"] = last_edit_by;
    data["post_at"] = post_at;
    data["post_by"] = post_by;
    return data;
  }
}

class ProductModel {
  String ducument_id_product;
  String name_apartment;
  num price;
  String district;
  num acreage_apartment;
  num amount_bedroom;
  num seen;
  num like;
  String url_images_avatar_product;
  bool is_selected = false;
  ProductModel({
    this.ducument_id_product,
    this.name_apartment,
    this.price,
    this.district,
    this.acreage_apartment,
    this.amount_bedroom,
    this.seen,
    this.like,
    this.url_images_avatar_product,
    this.is_selected,
  });
  ProductModel.fromJson(Map<String, dynamic> json) {
    url_images_avatar_product = json["url_images_avatar_product"];
    name_apartment = json["name_apartment"];
    price = json["price"];
    amount_bedroom = json["amount_bedroom"];
    district = json["district"];
    acreage_apartment = json["acreage_apartment"];
    seen = json["seen"];
    like = json["like"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name_apartment"] = name_apartment;
    data["price"] = price;
    data["district"] = district;
    data["acreage_apartment"] = acreage_apartment;
    data["amount_bedroom"] = amount_bedroom;
    data["url_images_avatar_product"] = url_images_avatar_product;
    data["seen"] = seen;
    data["like"] = like;
    return data;
  }
}

class DetailProductModel {
  String document_id_detail_product;
  num amount_bathrooms;
  List<ItemsIcon> list_item_infrastructure;
  String type_apartment;
  String remove_at;
  String last_edit_by;
  String type_floor;
  CostModel cost;
  String document_id_product;
  String document_id_real_estate;
  String last_edit;
  bool censored;
  String censored_by;
  String post_at;
  String post_by;
  List<String> list_images;
  DetailProductModel(
      {this.document_id_detail_product,
      this.amount_bathrooms,
      this.list_item_infrastructure,
      this.type_apartment,
      this.remove_at,
      this.last_edit_by,
      this.type_floor,
      this.cost,
      this.document_id_product,
      this.document_id_real_estate,
      this.last_edit,
      this.censored,
      this.list_images});
  DetailProductModel.fromJson(Map<String, dynamic> json) {
    amount_bathrooms = json["amount_bathrooms"];
    censored = json["censored"];
    censored_by = json["censored_by"];
    cost = CostModel.fromJson(json["cost"]);
    document_id_product = json["document_id_product"];
    document_id_real_estate = json["document_id_real_estate"];
    last_edit = json["last_edit"];
    last_edit_by = json["last_edit_by"];
    list_images = List.from(json["list_images"]);
    list_item_infrastructure = json["list_item_infrastructure"]
        .map<ItemsIcon>((x) => ItemsIcon.fromJson(x))
        .toList();
    post_at = json["post_at"];
    post_by = json["post_by"];
    remove_at = json["remove_at"];
    type_apartment = json["type_apartment"];
    type_floor = json["type_floor"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["amount_bathrooms"] = amount_bathrooms;
    data["list_item_infrastructure"] = list_item_infrastructure;
    data["type_apartment"] = type_apartment;
    data["remove_at"] = remove_at;
    data["last_edit_by"] = last_edit_by;
    data["type_floor"] = type_floor;
    data["cost"] = cost;
    data["document_id_product"] = document_id_product;
    data["document_id_real_estate"] = document_id_real_estate;
    data["last_edit"] = last_edit;
    data["censored"] = censored;
    data["list_images"] = list_images;
    return data;
  }
}

class RequestToBecomeAPartnerModel {
  String document_id_request;
  String document_id_custommer;
  String content;
  String send_at;
  bool accepted;
  String last_edit;
  String edit_by;
  bool censored;
  String censored_at;
  String censored_by;

  RequestToBecomeAPartnerModel(
      {this.document_id_request, this.content, this.document_id_custommer});
  RequestToBecomeAPartnerModel.fromJson(Map<String, dynamic> json) {
    accepted = json["accepted"];
    document_id_custommer = json["document_id_custommer"];
    content = json["content"];
    send_at = json["send_at"];
    last_edit = json["last_edit"];
    edit_by = json["edit_by"];
    censored = json["censored"];
    censored_at = json["censored_at"];
    censored_by = json["censored_by"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["accepted"] = accepted;
    data["document_id_custommer"] = document_id_custommer;
    data["content"] = content;
    data["send_at"] = send_at;
    data["last_edit"] = last_edit;
    data["edit_by"] = edit_by;
    data["censored"] = censored;
    data["censored_at"] = censored_at;
    data["censored_by"] = censored_by;
    return data;
  }
}

class NotifySystemUsersModel {
  String document_id_notify_system_users;
  String content;
  String title;
  String remove_at;
  String remove_by;
  String post_at;
  String post_by;
  bool removed;

  NotifySystemUsersModel(
      {this.document_id_notify_system_users,
      this.content,
      this.title,
      this.remove_by});
  NotifySystemUsersModel.fromJson(Map<String, dynamic> json) {
    document_id_notify_system_users = json["document_id_notify_system_users"];
    content = json["content"];
    remove_at = json["remove_at"];
    remove_by = json["remove_by"];
    post_at = json["post_at"];
    post_by = json["post_by"];
    removed = json["removed"];
    title = json["title"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["document_id_notify_system_users"] = document_id_notify_system_users;
    data["content"] = content;
    data["title"] = title;
    data["remove_at"] = remove_at;
    data["remove_by"] = remove_by;
    data["post_at"] = post_at;
    data["post_by"] = post_by;
    data["removed"] = removed;
    return data;
  }
}

class SessionAttendanceModel {
  String document_id_session_attendance;
  bool check_in_late;
  String document_id_group_attendance;
  String time_check_in;
  String time_minute_check_in_late;
  String time_check_out;
  String time_minute_check_out_soon;
  bool took_check_out;
  bool check_out_soon;
  bool took_check_in;
  String day;

  SessionAttendanceModel(
      {this.document_id_session_attendance,
      this.check_in_late,
      this.document_id_group_attendance,
      this.time_check_in,
      this.time_minute_check_in_late,
      this.time_check_out,
      this.time_minute_check_out_soon,
      this.took_check_out,
      this.took_check_in,
      this.check_out_soon,
      this.day});
  SessionAttendanceModel.fromJson(Map<String, dynamic> json) {
    check_in_late = json["check_in_late"];
    document_id_group_attendance = json["document_id_group_attendance"];
    time_check_in = json["time_check_in"];
    time_minute_check_in_late = json["time_minute_check_in_late"];
    time_check_out = json["time_check_out"];
    time_minute_check_out_soon = json["time_minute_check_out_soon"];
    took_check_out = json["took_check_out"];
    took_check_in = json["took_check_in"];
    check_out_soon = json["check_out_soon"];
    day = json["day"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["time_check_in"] = time_check_in;
    data["check_in_late"] = check_in_late;
    data["day"] = day;
    data["time_check_in_late"] = time_minute_check_in_late;
    data["time_check_out"] = null;
    data["took_check_out"] = false;
    data["took_check_in"] = true;
    data["time_minute_check_out_soon"] = time_minute_check_out_soon;
    data["id_group_attendance"] = document_id_group_attendance;
    data["check_out_soon"] = check_out_soon;

    return data;
  }
}

class TimeModel {
  int hours;
  int minute;
  TimeModel({this.hours, this.minute});
  TimeModel.fromJson(Map<String, dynamic> json) {
    hours = json["hours"];
    minute = json["minute"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["hours"] = hours;
    data["minute"] = minute;
    return data;
  }
}

class GroupDecentralizationModel {
  String document_id_group;
  String last_edit_at;
  String last_edit_by;
  List<dynamic> list_permission;
  String post_at;
  String post_by;
  bool removed = false;
  GroupDecentralizationModel(
      {this.document_id_group,
      this.list_permission,
      this.removed,
      this.post_by,
      this.post_at,
      this.last_edit_by,
      this.last_edit_at});

  GroupDecentralizationModel.fromJson(Map<String, dynamic> json) {
    last_edit_at = json["last_edit_at"];
    last_edit_by = json["last_edit_by"];
    list_permission = json["list_permission"];
    post_at = json["post_at"];
    post_by = json["post_by"];
    removed = json["removed"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["last_edit_at"] = last_edit_at;
    data["last_edit_by"] = last_edit_by;
    data["list_permission"] = list_permission;
    data["post_at"] = post_at;
    data["post_by"] = post_by;
    data["removed"] = removed;
    return data;
  }
}

class GroupAttendanceModel {
  String document_id_group_attendance;
  String name_group;
  CoordinatesDoubleModel coordinatesDoubleModel;
  String last_edit_by;
  String last_edit_at;
  String post_at;
  String post_by;
  bool removed;
  TimeModel time_start;
  TimeModel time_end;
  GroupAttendanceModel(
      {this.time_start,
      this.time_end,
      this.name_group,
      this.coordinatesDoubleModel,
      this.document_id_group_attendance});

  GroupAttendanceModel.fromJson(Map<String, dynamic> json) {
    coordinatesDoubleModel =
        CoordinatesDoubleModel.fromJson(json["coordinatesDoubleModel"]);
    last_edit_at = json["last_edit_at"];
    last_edit_at = json["last_edit_by"];
    name_group = json["name_group"];
    post_at = json["post_at"];
    post_by = json["post_by"];
    removed = json["removed"];
    time_end = TimeModel.fromJson(json["time_end"]);
    time_start = TimeModel.fromJson(json["time_start"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["coordinatesDoubleModel"] = coordinatesDoubleModel;
    data["last_edit_at"] = last_edit_at;
    data["last_edit_at"] = last_edit_at;
    data["name_group"] = name_group;
    data["post_at"] = post_at;
    data["post_by"] = post_by;
    data["removed"] = removed;
    data["time_end"] = time_end;
    data["time_start"] = time_start;
    return data;
  }
}
