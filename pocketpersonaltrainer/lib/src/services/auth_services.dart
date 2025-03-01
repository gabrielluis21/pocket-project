import 'package:firebase_auth/firebase_auth.dart';
import 'package:pocketpersonaltrainer/src/extensions/list_extension.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';
import '../data/models/user_model.dart';

class AuthService {
  final FbDatabase database;
  AuthService({required this.database});

  final _fbAuth = FirebaseAuth.instance;

  Stream<User?> get user => _fbAuth.authStateChanges();

  Future<UserModel> signIn(String email, String password) async {
    var userCredentials = await _fbAuth.signInWithEmailAndPassword(email: email, password: password);
    return database.getUserId(userCredentials.user?.uid);
  }

  Future<UserModel?> signUp(UserModel newUser) async {
    try {
      var userCredentials = await _fbAuth.createUserWithEmailAndPassword(email: newUser.email!, password: newUser.password!);
      newUser.uid = userCredentials.user?.uid;
      await database.addUser(newUser);
      return newUser;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserModel> signUpWithFacebook(UserModel newUser, AuthCredential credentials) async {
    var allUsers = await database.getAllUser();
    var hasUser = allUsers.isEmpty ? null : allUsers.firstWhereOrNull((user) => user.email == newUser.email);
    if (hasUser == null) {
      var userCredentials = await _fbAuth.signInWithCredential(credentials);
      newUser.uid = userCredentials.user?.uid;
      await database.addUser(newUser);
      return newUser;
    } else {
      await _fbAuth.currentUser?.linkWithCredential(credentials);
      return hasUser;
    }
  }

  Future<UserModel> signUpWithGoogle(UserModel newUser, dynamic credentials) async {
    var allUsers = await database.getAllUser();
    var hasUser = allUsers.firstWhereOrNull((user) => user.email == newUser.email);
    final authCreds = AuthCredential(providerId: credentials.providerId, signInMethod: credentials.signInMethod, accessToken: credentials.accessToken);
    if (hasUser == null) {
      var userCredentials = await _fbAuth.signInWithCredential(authCreds);
      newUser.uid = userCredentials.user?.uid;
      return newUser;
    } else {
      _fbAuth.currentUser?.linkWithCredential(authCreds);
      return hasUser;
    }
  }

  recoverPassword(String text) async {
    await _fbAuth.sendPasswordResetEmail(email: text);
  }

  Future<UserModel?> autoLogin(firebaseUser) async {
    UserModel? signed;
    if (firebaseUser != null) {
      signed = await database.getUserId(firebaseUser.uid);
    }
    return signed;
  }
}
