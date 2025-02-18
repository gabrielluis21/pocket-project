import 'package:flutter/material.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';

class AnimatedButton extends StatelessWidget {
  final AnimationController controller;
  final String text;

  AnimatedButton({
    super.key,
    required this.controller,
    required this.text,
  })  : buttonSqueeze = Tween(begin: 320.0, end: 60.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.150),
          ),
        ),
        buttonZoomOut = Tween(
          begin: 60.0,
          end: 1000.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5, 1, curve: Curves.bounceOut),
        ));

  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: InkWell(
          onTap: () {
            controller.forward();
          },
          child: Hero(
            tag: "fade",
            child: buttonZoomOut.value == 60
                ? Container(
                    width: buttonSqueeze.value,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColorTheme().customLightColorScheme.primary, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: _buildInside(context))
                : Container(
                    width: buttonZoomOut.value,
                    height: buttonZoomOut.value,
                    decoration: BoxDecoration(color: AppColorTheme().customLightColorScheme.primary, shape: buttonZoomOut.value < 500 ? BoxShape.circle : BoxShape.rectangle),
                  ),
          )),
    );
  }

  Widget _buildInside(BuildContext context) {
    if (buttonSqueeze.value > 75) {
      return Text(
        this.text,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 0.3),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: this.controller,
    );
  }
}
