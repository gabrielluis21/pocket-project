import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketpersonaltrainer/src/controllers/auth_controller.dart';
import 'package:pocketpersonaltrainer/src/mixings/social_auth_mixing.dart';

class CustomFacebookLoginButton extends StatelessWidget with SocialAuthMixin {
  const CustomFacebookLoginButton({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        color: Colors.indigoAccent,
      ),
      child: IconButton(
        iconSize: 30,
        onPressed: () => signInWithFacebookLogin,
        icon: const Icon(
          FontAwesomeIcons.facebook,
          color: Colors.white,
        ),
      ),
    );
  }
}
