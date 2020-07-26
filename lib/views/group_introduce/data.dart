import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(
      "Với mong muốn tạo ra một loại hình dịch vụ tư vấn uy tín nhất, nhanh chóng nhất, chất lượng nhất về lĩnh vực Bất Động Sản nhằm mang tới cho khách hàng một nơi an cư lạc nghiệp, một tổ ấm bình yên, một ngôi nhà hoàn hảo.");
  sliderModel.setTitle("SunLand Group");
  sliderModel.setImageAssetPath("assets/images/icon_sunland.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
      "Công ty TNHH TMDV BẤT ĐỘNG SẢN SUNLAND đã chính thức được thành lập vào ngày 28/09/2017.Trải qua gần 3 năm hoạt động, Ban Giám đốc và toàn thể CBNV công ty đã cùng nhau cố gắng, nỗ lực và toàn tâm xây dựng công ty ngày một vững mạnh hơn.Chúng tôi xin trân trọng cám ơn toàn thể CBNV công ty cùng các đơn vị đối tác, khách hàng đã tin tưởng và đồng hành cùng SUNLAND GROUP trong thời gian qua.");
  sliderModel.setTitle("Quá trình phát triển");
  sliderModel.setImageAssetPath("assets/images/icon_sunland.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "SUNLAND đang ngày càng phát triển cả về lượng và chất, sẽ tiếp tục là lựa chọn tin cậy trong lĩnh vực tư vấn Bất Động Sản tại Nam Sài Gòn. Để nân cao thêm trải nghiệm của khách hàng SunLand xin ra mắt App Mobile với rất nhiều tính năng, mời quý khách hàng cùng khám phá và trải nghiệm. Trân trọng!");
  sliderModel.setTitle("Lời kết");
  sliderModel.setImageAssetPath("assets/images/icon_sunland.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
