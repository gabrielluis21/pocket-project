import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocketpersonaltrainer/src/app/app_pages.dart';
import 'user_controller.dart';
import '../data/models/user_model.dart';
import '../services/auth_services.dart';

class AuthController extends GetxController {
  final AuthService repository;
  late AppLocalizations laguanges;
  AuthController(this.repository);

  late final UserController currentUser;
  Rxn<User> firebaseUser = Rxn<User>(null);
  @override
  void onInit() async {
    super.onInit();
    laguanges = await AppLocalizations.delegate.load(Locale.fromSubtags());
  }

  @override
  onReady() {
    currentUser = Get.find<UserController>(tag: "user");
    /*ever(_firebaseUser, handleAutoLogin);
    _firebaseUser.bindStream(repository.user);*/
    super.onReady();
  }

  loginByEmailAndPassword(String email, String password) async {
    var result = await repository.signIn(email, password);
    if (result.uid == null) {
      Get.snackbar("Erro ao entrar", "E-mail ou senha inválidos!", backgroundColor: Colors.red);
    } else {
      currentUser.user = result;
    }
  }

  signUpByForms(UserModel user) async {
    try {
      var result = await repository.signUp(user);
      if (result == null) {
        Get.snackbar("Error", "${laguanges.signUpErroMensagem}", backgroundColor: Colors.red);
      } else {
        currentUser.user = result;
      }
    } catch (e) {
      print(e);
    }
  }

  handleAutoLogin(user) async {
    var result = await repository.autoLogin(user);
    if (result?.uid != null) {
      currentUser.user = result;
      Get.offNamed(Routes.HOME);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }

  signUpWithFacebook(Map<String, dynamic> data, AuthCredential credentials) async {
    try {
      var result = await repository.signUpWithFacebook(
          UserModel(
            name: data["name"],
            email: data["email"],
            address: data["address"],
            city: data["city"],
            location: data["currentPosition"],
            photoUrl: data["profilePhoto"],
            acceptedTerms: true,
          ),
          credentials);
      if (result.uid == null) {
        Get.snackbar("Erro ao continuar com o Facebook", "Por favor, verifique sua conexão com internet e tente novamente", backgroundColor: Colors.red);
      } else {
        currentUser.user = result;
      }
    } on Exception catch (e) {
      print(e);
      Get.snackbar("Erro", "Falha ao continuar com Facebook", backgroundColor: Colors.red);
    }
  }

  Future<void> signUpWithGoogle(Map<String, dynamic> data, dynamic credentials) async {
    try {
      var result = await repository.signUpWithGoogle(
          UserModel(
            name: data["name"],
            email: data["email"],
            address: data["address"],
            city: data["city"],
            location: data["currentPosition"],
            photoUrl: data["profilePhoto"],
            acceptedTerms: true,
          ),
          credentials);
      if (result.uid == null) {
        Get.snackbar("Erro ao continuar com o Facebook", "Por favor, verifique sua conexão com internet e tente novamente", backgroundColor: Colors.red);
      } else {
        currentUser.user = result;
      }
    } on Exception catch (e) {
      print(e);
      Get.snackbar("Erro", "Falha ao continuar com Google", backgroundColor: Colors.red);
    }
  }

  void recoverPassword(String text) async {
    await repository.recoverPassword(text);
  }
}
