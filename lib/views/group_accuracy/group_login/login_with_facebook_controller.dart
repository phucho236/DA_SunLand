import 'dart:async';
import 'dart:convert';

import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/helpers/validators.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class LoginWithFacebookController {
  final facebookLogin = FacebookLogin();
  Validators validators = new Validators();
  StreamController _erroController = new StreamController();
  Stream get erroController => _erroController.stream;
  logOutFace() async {
    await facebookLogin.logOut();
  }

  Future<dynamic> initiateFacebookLogin() async {
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final facebookLoginResult = await facebookLogin.logIn(['email']);
    print(facebookLoginResult.status);
    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');
    ProfileFacebook profileFacebook =
        ProfileFacebook.fromJson(jsonDecode(graphResponse.body));

    CustomerProfileModel customerProfile;
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        {
          _erroController.sink.addError('Login with facebook Error');
          break;
        }

      case FacebookLoginStatus.cancelledByUser:
        {
          _erroController.sink.addError('CancelledByUser');
          break;
        }

      case FacebookLoginStatus.loggedIn:
        {
          print("LoggedIn");
          print(profileFacebook.id);
          var api = HttpApi();
          await api.loginFB(fb_id: profileFacebook.id).then((value) {
            if (value != null) {
              setDocumentIdCustommer(newValue: value.documentID);
              customerProfile = CustomerProfileModel.fromJson(value.data);
            }
          });
          break;
        }
    }
    if (customerProfile != null) {
      return customerProfile;
    } else {
      return profileFacebook;
    }
  }
}
