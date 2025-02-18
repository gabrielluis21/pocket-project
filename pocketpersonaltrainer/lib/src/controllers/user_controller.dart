import 'package:get/get.dart';
import '../data/models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _user = UserModel().obs;

  UserModel? get user => _user.value;
  set user(UserModel? value) => _user.value = value;

  void clear() => _user.value = UserModel();
}
