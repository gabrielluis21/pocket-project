import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pocketpersonaltrainer/src/controllers/auth_controller.dart';
import 'package:pocketpersonaltrainer/src/services/gps_service.dart';
import 'package:pocketpersonaltrainer/src/ui/home/home_view.dart';

class CustomGoogleLoginButton extends StatelessWidget {
  CustomGoogleLoginButton({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        color: Colors.red,
      ),
      child: IconButton(
        iconSize: 30,
        onPressed: () => singUpWithGoogle(context),
        icon: const Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
      ),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/userinfo.profile",
    ],
  );

  singUpWithGoogle(BuildContext context) async {
    late Map<String, dynamic> userData = {};
    late Map<String, double?> pos = {};

    await GpsService.getLocation().then((position) {
      pos["latitude"] = position?.latitude;
      pos["longitude"] = position?.longitude;
    });

    await GpsService.getAddressByGeoCordinates(pos["longitude"], pos["latitude"]).then((value) {
      userData["address"] = "${value.streetAddress}, ${value.streetNumber}";
      userData["city"] = value.city;
    });

    print("${pos["longitude"]},${pos["latitude"]}");

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    print(credential.asMap());

    userData["name"] = googleSignInAccount?.displayName;
    userData["email"] = googleSignInAccount?.email;
    userData["profilePhoto"] = googleSignInAccount?.photoUrl;
    userData["currentPosition"] = pos;

    controller.signUpWithGoogle(userData, credential).then((value) {
      print(controller.currentUser.user?.toMap());
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
}
