import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class ImagesBrain {
  ImagePicker imagePicker = ImagePicker();
  Future<List<File>> pickerMultilImages() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.image,
      //allowedExtensions: ['jpg', 'png'],
    );
    return files;
  }

  Future<File> getImageCameraNoCrop({ImageSource source_picker}) async {
    var images = await imagePicker.getImage(
      source: source_picker,
    );
    if (images != null) {
      return File(images.path);
    }
  }

  Future<File> getImageCamera(ImageSource source_picker) async {
    var images = await imagePicker.getImage(
      source: source_picker,
    );
    File _cropImage = await cropImage(File(images.path));
    if (_cropImage != null) {
      return _cropImage;
    }
  }

  Future<File> cropImageUseProDuct(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.ratio4x3,
              ]
            : [
                CropAspectRatioPreset.ratio4x3,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: colorAppbar,
            hideBottomControls: true,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cắt ảnh',
        ));
    return croppedFile;
  }

  Future<File> cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      androidUiSettings: AndroidUiSettings(
          hideBottomControls: true,
          toolbarTitle: 'Cắt ảnh',
          toolbarWidgetColor: colorAppbar,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        title: 'Cắt ảnh',
      ),
    );
    return croppedFile;
  }
}
