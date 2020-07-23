import 'package:validators/validators.dart' as validate;

class Validators {
  bool checkMessenger(String messenger) {
    return messenger != '' && messenger != null;
  }

  bool checkName(String name) {
    return name != null && name != '';
  }

  bool checkNameGroup(String name) {
    return name != '';
  }

  bool isPhoneNumber(String phoneNumber) {
    return isNumber(num.parse(phoneNumber));
  }

  bool checkLengPhongNumber(String phoneNumber) {
    return phoneNumber.length == 10;
  }

  bool isDate(String date) {
    return date != '' && date != null;
  }

  bool isNegative(String number) {
    return double.parse(number) >= 0 && number != '-';
  }

  bool isValidOTP(String otp) {
    return otp != '' && otp != null && otp.length == 20;
  }

  bool isValidEmail(String email) {
    return email != '' && email != null && validate.isEmail(email);
  }

  bool isValidPass(String password) {
    return password != null && password != '';
  }

  bool isValidConfirmPass(String confirmpass) {
    return confirmpass != '';
  }

  bool checkLengPass(String password) {
    return password.length >= 6 && password.length <= 15;
  }

  bool isNumber(num number) {
    return number != null && number > 0;
  }

  bool StringIsequal(String a, String b) {
    return a == b ? true : false;
  }
}
