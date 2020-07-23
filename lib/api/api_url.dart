//class APIConfig {
//  String _baseUrl;
//
//  APIConfig() {
//    switch ('dev') {
//      case 'dev':
//        _baseUrl = 'https://sunland-2b6ba.firebaseio.com';
//        //_baseUrl = 'http://118.69.226.194:8800/api';
//        break;
////      case 'stag':
////        _baseUrl = 'https://reqres.in/api';
////        break;
////      case 'prod':
////        _baseUrl = 'https://reqres.in/api';
////        break;
////      default:
////        _baseUrl = 'http://azgo.bclocal.top:81/api/v1';
////        break;
//    }
//  }
//  String get baseUrl {
//    return _baseUrl;
//  }
//}
//
//var apiConfig = APIConfig();
//String baseUrl = apiConfig.baseUrl;

class PathDatabase {
  static String Authenticator = 'Authenticator';
  static String CustomerProfile = 'CustomerProfile';
  static String OTP = 'OTP';
  static String Messenges = 'Messages';
  static String NotifyProductAds = 'NotifyProductAds';
  static String RealRstate = 'RealEstate';
  static String GroupPermission = 'GroupPermission';
  static String DataCustommerSystem = 'DataCustommerSystem';
  static String Product = 'Product';
  static String DetailProduct = 'DetailProduct';
  static String ProductNeedSuport = "ProductNeedSuport";
  static String RequestToBecomeAPartner = "RequestToBecomeAPartner";
  static String NotifySystemUsers = 'NotifySystemUsers';
  static String GroupAttendance = "GroupAttendance";
  static String UserInGroupAttendance = "UserInGroupAttendance";
  static String SessionAttendance = "SessionAttendance";
  static String CustommerProfileOutTheSystem = "CustommerProfileOutTheSystem";
  static String Appointment = "Appointment";
  //Đường dẩn đăng file
  static String Images_Customer = 'Images_Customer';
  static String Images_Product = 'Images_Product';
  static String Images_CheckIn = 'Images_CheckIn';
  static String Images_Messenger = 'Images_Messenger';
}
