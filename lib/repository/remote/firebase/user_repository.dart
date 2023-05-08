import 'package:demo_spotify_app/data/network/firebase/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/firebase/user.dart';

class UserRepository {
  UserRepository._();

  static final UserRepository instance = UserRepository._();
  final _userService = UserService();

  Future<void> signInWithGoogle(UserCredential userCredential) async {
    await _userService.addUser(Users(
        id: userCredential.user!.uid,
        displayName: userCredential.user!.displayName.toString(),
        email: userCredential.user!.email.toString(),
        photoUrl: userCredential.user!.photoURL.toString()));
  }

  Future<void> registerUsernameAndPassword(
      {required UserCredential userCredential,
      required String displayName,
      required String email}) async {
    await _userService.addUser(Users(
      id: userCredential.user!.uid,
      displayName: displayName,
      email: email,
    ));
  }

  Future<void> editProfile({required Users user}) async {
    await _userService.updateUser(user: user);
  }

  Future<Users> getUser(String email) {
    return _userService.getUser(email);
  }
}
