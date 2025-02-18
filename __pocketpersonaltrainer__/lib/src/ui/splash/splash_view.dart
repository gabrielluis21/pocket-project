import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocketpersonaltrainer/src/ui/animations/logo_animation.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-in/sign_in_view.dart';
import '../../widgets/painter/custom_hole_painter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late LogoAnimation _logo;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);
    _logo = LogoAnimation(_controller);
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: CustomPaint(
                painter: HolePainter(color: Theme.of(context).primaryColor, holeSize: _logo.holeSize.value * MediaQuery.of(context).size.width),
              ),
            ),
            Positioned(
              top: _logo.dropPosition.value * MediaQuery.of(context).size.height,
              left: MediaQuery.of(context).size.width / 2 - _logo.logoSize.value / 2,
              child: Visibility(
                visible: _logo.logoVisible.value,
                child: SizedBox(
                  height: _logo.logoSize.value,
                  width: _logo.logoSize.value,
                  child: CircleAvatar(
                    maxRadius: _logo.logoSize.value,
                    backgroundImage: const AssetImage(
                      "assets/images/New_Logo.png",
                    ),
                  ),
                ),
              ),
            ),
            /* Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: _logo.textOpacity.value,
                  child: Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ), */
          ],
        );
      },
    );
  }
}
