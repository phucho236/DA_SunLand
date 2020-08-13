import 'package:flutter/cupertino.dart';
import 'package:flutter_core/api/api_model.dart';

class GlobalData extends ChangeNotifier {
  String avatarUser = null;
  String userName = "";
  String fistName = "";
  String lastName = "";
  String phoneNumber = "";
  String creat_at = "";
  String travelTimeHouse = "00";
  String travelTimeMinutes = "00";
  String travelLength = "999";
  CoordinatesDoubleModel coordinatesModel =
      CoordinatesDoubleModel(latitude: 10.808820, longitude: 106.623436);
  Future<CoordinatesDoubleModel> updateCoordinatesDoubleModel(
      {CoordinatesDoubleModel newValue}) {
    coordinatesModel = newValue;
    notifyListeners();
  }

  Future<String> updateTravelTimeHouse({String newValue}) {
    travelTimeHouse = newValue;
    print(travelTimeHouse);
    notifyListeners();
  }

  Future<String> updateTravelTimeMinutes({String newValue}) {
    travelTimeMinutes = newValue;
    print(travelTimeMinutes);
    notifyListeners();
  }

  Future<String> updateTravelLength({String newValue}) {
    travelLength = newValue;
    print(travelLength);
    notifyListeners();
  }

  Future<String> updateAvatarUser({String newValue}) {
    avatarUser = newValue;
    notifyListeners();
  }

  Future<String> updateUserName({String newValue}) {
    userName = newValue;
    notifyListeners();
  }

  Future<String> updatefistName({String newValue}) {
    fistName = newValue;
    notifyListeners();
  }

  Future<String> updatelastName({String newValue}) {
    lastName = newValue;
    notifyListeners();
  }

  Future<String> updatephoneNumber({String newValue}) {
    phoneNumber = newValue;
    notifyListeners();
  }

  Future<String> updatecreatAt({String newValue}) async {
    creat_at = newValue;
    notifyListeners();
  }
}
