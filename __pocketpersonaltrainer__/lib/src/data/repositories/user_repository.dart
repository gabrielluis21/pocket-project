import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class UserRepository {
  final FbDatabase api;

  UserRepository(this.api);

  getId(uid) {
    return api.getUserId(uid);
  }

  delete(id) {
    return api.deleteUser(id);
  }

  edit(obj) {
    return api.editUser(obj.uid, obj);
  }

  add(obj) {
    return api.addUser(obj);
  }
}
