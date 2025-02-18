import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInButton extends StatefulWidget {
  const SignInButton({
    super.key,
    this.signIn,
  });
  final void Function()? signIn;
  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.signIn!(),
      child: Text(
        '${AppLocalizations.of(context)?.loginButton}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Noto Sans SC',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
