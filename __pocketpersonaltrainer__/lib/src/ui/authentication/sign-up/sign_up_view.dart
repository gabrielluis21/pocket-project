import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketpersonaltrainer/src/app/app_pages.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/controllers/auth_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_model.dart';
import 'package:pocketpersonaltrainer/src/provider/fbstorage.dart';
import 'package:pocketpersonaltrainer/src/services/gps_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pocketpersonaltrainer/src/ui/animations/animated_button.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-up/widgets/pick_or_take_profile_photo.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-up/widgets/signup_form.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwdController = TextEditingController();

  final Map<String, double?> pos = {};
  String profilePhoto = '';
  final _picker = ImagePicker();
  final newUser = UserModel();
  late AnimationController _controller;
  final AuthController _authController = Get.find<AuthController>(tag: 'auth');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _saveProfile();
      }
      if (status == AnimationStatus.completed) {
        Navigator.restorablePushReplacementNamed(context, Routes.HOME);
      }
    });
  }

  void takePhoto() {
    _picker.pickImage(source: ImageSource.camera).then((file) async {
      if (file == null) return;
      var childName;
      if (newUser.uid != null) {
        childName = newUser.uid! + DateTime.now().millisecondsSinceEpoch.toString();
      } else {
        childName = newUser.email != null ? newUser.email : _emailController.text;
      }
      var snap = FbStorage.instace.uploadFiles(childName, file);
      setState(() async {
        profilePhoto = await snap.ref.getDownloadURL();
      });
    });
  }

  void choosePhoto() async {
    _picker.pickImage(source: ImageSource.gallery).then((file) async {
      if (file == null) return;
      var childName;
      if (newUser.uid != null) {
        childName = newUser.uid! + DateTime.now().millisecondsSinceEpoch.toString();
      } else {
        childName = newUser.email != null ? newUser.email : _emailController.text;
      }
      var snap = FbStorage.instace.uploadFiles(childName, file);
      setState(() async {
        profilePhoto = await snap.ref.getDownloadURL();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft),
          onPressed: () => Get.offAllNamed(Routes.LOGIN),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background/nathan-dumlao-jlf9QyI250Y-unsplash.jpg",
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Color(0xb2000000), BlendMode.srcOver),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 504,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 65),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: PickOrTakeProfilePhoto(
                                    profilePhoto: profilePhoto,
                                  ),
                                ),
                                Positioned(
                                  top: 120,
                                  right: 0,
                                  child: Container(
                                    width: 44.7,
                                    height: 46.55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: AppColorTheme().customLightColorScheme.primary,
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          Get.dialog(
                                            AlertDialog(
                                              title: Text(AppLocalizations.of(context)!.getPhotoTitulo),
                                              content: Text(AppLocalizations.of(context)!.getPhotoMensagem),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    takePhoto();
                                                  },
                                                  child: Text(AppLocalizations.of(context)!.camera),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    choosePhoto();
                                                  },
                                                  child: Text(AppLocalizations.of(context)!.galeria),
                                                ),
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: Text(AppLocalizations.of(context)!.cancelar),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(MdiIcons.camera)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SignUpForm(
                        pos: pos,
                        formKey: _formKey,
                        emailController: _emailController,
                        addressController: _addressController,
                        cityController: _cityController,
                        nameController: _nameController,
                        passwdController: _passwdController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .1,
              right: 180,
              left: 20,
              child: SizedBox(
                child: Text(
                  "${AppLocalizations.of(context)?.signUpPresentations}",
                  style: TextStyle(
                    color: AppColorTheme().customLightColorScheme.primary,
                    fontSize: 24,
                    fontFamily: 'Noto Sans SC',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            AnimatedButton(
              controller: _controller,
              text: "${AppLocalizations.of(context)?.signUpButton}",
            ),
          ],
        ),
      ),
    );
  }

  _saveProfile() {
    try {
      _controller.forward();
      if (_formKey.currentState?.validate() == true) {
        if (pos.isEmpty) {
          GpsService.getLocation().then((position) {
            this.pos.addAll({"latitude": position?.latitude, "longitude": position?.longitude});
          });
        }

        newUser.name = _nameController.text;
        newUser.address = _addressController.text;
        newUser.email = _emailController.text;
        newUser.photoUrl = _emailController.text;
        newUser.password = _passwdController.text;
        newUser.city = _cityController.text;
        newUser.location = pos;
        newUser.acceptedTerms = true;
        print(newUser.toMap());
        _authController.signUpByForms(newUser);
        if (_authController.currentUser.user?.uid != null) {
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        _controller.reset();
        Get.snackbar(AppLocalizations.of(context)!.signUpErro, AppLocalizations.of(context)!.signUpErroMensagem, backgroundColor: Colors.redAccent);
      }
    } catch (e) {
      print(e);
      _controller.reset();
      _controller.reset();
      Get.snackbar(AppLocalizations.of(context)!.signUpErro, AppLocalizations.of(context)!.signUpErroMensagem, backgroundColor: Colors.redAccent);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
