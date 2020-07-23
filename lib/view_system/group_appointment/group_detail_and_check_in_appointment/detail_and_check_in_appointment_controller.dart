import 'dart:io';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class DetailAndCheckInAppointmentController {
  onGetCustomerProifile(
      {String document_id_custommer,
      bool is_custommer_profile_out_the_system = false}) async {
    var api = HttpApi();
    var result_;
    CustomerProfileModel customerProfileModel;
    result_ = is_custommer_profile_out_the_system
        ? await api.GetDataCustommerOutTheSystem(
            document_id_custommer: document_id_custommer)
        : await api.GetDataCustommer(
            document_id_custommer: document_id_custommer);
    if (result_ != null) {
      customerProfileModel = CustomerProfileModel.fromJson(result_);
      customerProfileModel.document_id_custommer = document_id_custommer;
    }
    return customerProfileModel;
  }

  onGetProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetProductFindByID(
        document_id_product: document_id_product);
  }

  onCheckInAppointment(
      {String documment_id_custommer,
      CoordinatesDoubleModel coordinatesDoubleModel,
      String document_id_appointment,
      File file_images_check_in}) async {
    String time_stamp = DateTime.now().millisecondsSinceEpoch.toString();
    Directory appDocPath = await getApplicationDocumentsDirectory();
    var file_images_type_png = File('${appDocPath.path}/$time_stamp.png');
    file_images_type_png.writeAsBytesSync(
        await returnImagesTypePng(file_images_check_in),
        flush: true,
        mode: FileMode.write);
    String url_images_check_in;
    var api = HttpApi();
    if (file_images_type_png.existsSync()) {
      url_images_check_in = await api.uploadImages(
          images: file_images_type_png,
          PathDatabase: PathDatabase.Images_CheckIn);
    }
    if (url_images_check_in != null) {
      file_images_type_png.deleteSync(recursive: true);
      return await api.CheckInAppointment(
          coordinatesDoubleModel: coordinatesDoubleModel,
          document_id_appointment: document_id_appointment,
          documment_id_custommer: documment_id_custommer,
          url_images_check_in: url_images_check_in);
    } else {
      return false;
    }
  }

  returnImagesTypePng(File images) async {
    var compressImageData = await FlutterImageCompress.compressWithFile(
        //returns Future<List<int>>
        images.path,
        minWidth: 120,
        minHeight: 120,
        quality: 100,
        format: CompressFormat.png //e.g. compress to PNG
        );
    return compressImageData;
  }
}
