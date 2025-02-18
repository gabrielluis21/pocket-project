import 'package:firebase_auth/firebase_auth.dart';
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
    var userCredentials = await _fbAuth.signInWithCredential(credentials);
    newUser.uid = userCredentials.user?.uid;
    await database.addUser(newUser);
    return newUser;
  }

  Future<UserModel> signUpWithGoogle(UserModel newUser, dynamic credentials) async {
    print(credentials.toString());
    final authCreds = AuthCredential(providerId: credentials.providerId, signInMethod: credentials.signInMethod, accessToken: credentials.accessToken);
    var userCredentials = await _fbAuth.signInWithCredential(authCreds);
    newUser.uid = userCredentials.user?.uid;
    var hasUser = await database.getUserId(newUser.uid);
    if (hasUser == null) {
      await database.addUser(newUser);
      return newUser;
    } else {
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
