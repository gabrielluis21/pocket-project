import 'package:flutter/material.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../widgets/social-buttons/custom_facebook_button.dart';
import '../../../../widgets/social-buttons/custom_google_button.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({Key? key, required this.authController}) : super(key: key);

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomGoogleLoginButton(
          controller: authController,
        ),
        SizedBox(
          width: 15,
        ),
        CustomFacebookLoginButton(
          controller: authController,
        ),
      ],
    );
  }
}
