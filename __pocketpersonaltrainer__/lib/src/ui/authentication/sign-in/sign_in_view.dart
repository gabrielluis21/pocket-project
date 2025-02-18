import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocketpersonaltrainer/src/ui/home/home_view.dart';
import 'package:pocketpersonaltrainer/src/utils/size_screen_config.dart';

import './widgets/app_logo.dart';
import './widgets/recover_password_button.dart';
import './widgets/sign_in_form.dart';
import './widgets/social_buttons.dart';
import '../../animations/animated_button.dart';
import '../../../app/app_pages.dart';
import '../../../controllers/auth_controller.dart';
import '../../../ui/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  late final bool? isOk;
  late final AnimationController _animationController;
  final authController = Get.find<AuthController>(tag: 'auth');

  @override
  void initState() {
    super.initState();
    isOk = false;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _logIn();
      }
      if (status == AnimationStatus.completed) {
        Navigator.of(context).restorablePushReplacement(
          (context, _) => MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  Widget buildMobileView() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background/samuel-girven-VJ2s0c20qCo-unsplash.jpg",
            ),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(Color(0xb2000000), BlendMode.srcOver),
          ),
        ),
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(top: 50, left: 15, right: 15, child: AppLogo()),
            Positioned.fill(
              top: 325,
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical! * 65,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 30, left: 14, right: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: SignInForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          senhaController: _senhaController,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RecoverPasswordButton(
                          emailController: _emailController,
                          authController: authController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 118.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "${AppLocalizations.of(context)?.newAccountButton}\n",
                                recognizer: TapGestureRecognizer()..onTap = () => Get.offNamed(Routes.CADASTRO),
                                children: [
                                  TextSpan(text: "\n${AppLocalizations.of(context)?.ouText}\n"),
                                  TextSpan(
                                    text: "\n${AppLocalizations.of(context)?.outraOpcao}",
                                  )
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF031CFF),
                                fontSize: 14,
                                fontFamily: 'Noto Sans SC',
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 225,
              child: Container(
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.bottomCenter,
                child: AnimatedButton(
                  controller: _animationController,
                  text: AppLocalizations.of(context)!.loginButton,
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              child: SocialButtons(authController: authController),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDesktopView() {
    return Container();
  }

  Widget buildTabletView() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    timeDilation = 1;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Responsive(
      mobile: buildMobileView(),
      desktop: buildDesktopView(),
      tablet: buildTabletView(),
    );
  }

  void _logIn() {
    _animationController.forward();
    if (_formKey.currentState?.validate() == true) {
      authController.loginByEmailAndPassword(_emailController.text, _senhaController.text);
      if (authController.currentUser.user?.uid != null) {
        Get.offNamed(Routes.HOME);
      }
    } else {
      _animationController.reset();
      Get.snackbar("Erro ao entrar", "E-mail ou senha inválido(s)", backgroundColor: Colors.redAccent, duration: const Duration(seconds: 2));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
