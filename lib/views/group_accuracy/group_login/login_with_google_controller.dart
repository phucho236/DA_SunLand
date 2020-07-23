import 'dart:async';
import 'dart:convert';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/helpers/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginWithGoogleController {
  Validators validators = new Validators();
  StreamController _erroController = new StreamController();
  CustomerProfileModel customerProfile = null;
  Stream get erroController => _erroController.stream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  logOutGoogle() async {
    await _auth.signOut();
  }

  Future<dynamic> initiateGoogleLogin() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    // lấy 2 cái token với id token gửi cho google để lấy thông tin
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);

    final FirebaseUser user = authResult.user;
//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);
//
//    final FirebaseUser currentUser =
//        await _auth.currentUser(); // đây là thông tin người dùng

    Map<String, dynamic> data = Map<String, dynamic>();
    data["uid"] = user.uid;
    data["email"] = user.email;
    data["displayName"] = user.displayName;
    data["photoUrl"] = user.photoUrl;
    data["phoneNumber"] = user.phoneNumber;
    ProfileGoogle profileGoogle = ProfileGoogle.fromJson(data);
    var api = HttpApi();
    await api.loginGG(gg_id: user.uid).then((value) {
      if (value != null) {
        setDocumentIdCustommer(newValue: value.documentID);
        customerProfile = CustomerProfileModel.fromJson(value.data);
      }
    });
    if (customerProfile != null) {
      return customerProfile;
    } else {
      return profileGoogle;
    }
  }
}
