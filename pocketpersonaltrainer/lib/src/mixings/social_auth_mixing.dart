import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/auth_controller.dart';
import 'package:pocketpersonaltrainer/src/services/gps_service.dart';

mixin SocialAuthMixin {
  Future<void> signInWithFacebookLogin(AuthController controller) async {
    Map<String, dynamic> userData = {};
    Map<String, double?> pos = {};

    await GpsService.getLocation().then((position) {
      pos["latitude"] = position?.latitude;
      pos["longitude"] = position?.longitude;
    });

    print("${pos["longitude"]},${pos["latitude"]}");

    await GpsService.getAddressByGeoCordinates(pos["longitude"], pos["latitude"]).then((value) {
      userData["address"] = "${value.streetAddress}, ${value.streetNumber}";
      userData["city"] = value.city;
    });

    var loginResult = await FacebookAuth.instance.login(permissions: ["email", "public_profile"]);
    if (loginResult.status == LoginStatus.success) {
      final profile = await FacebookAuth.instance.getUserData();
      final AuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      userData["name"] = profile["name"];
      userData["email"] = profile["email"];
      userData["profilePhoto"] = profile["picture"]["data"]["url"];
      userData["currentLocation"] = pos;
      controller.signUpWithFacebook(userData, credential);
    } else {
      Get.snackbar("Erro ao continuar com o Facebook", "Por favor, verifique sua conexão com internet e tente novamente", backgroundColor: Colors.red);
    }
  }
}
