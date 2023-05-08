import 'dart:io';

import 'package:demo_spotify_app/repository/remote/firebase/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/firebase/user.dart';
import '../../utils/toast_utils.dart';

class ProfileViewModel with ChangeNotifier {
  File? imageFile;
  String displayName = '';

  void setDisplayName(String name) {
    displayName = name;
    notifyListeners();
  }

  Future<void> editProfile(Users user) async {
    if (imageFile != null) {
      user.photoUrl = await uploadImage();
    }
    user.displayName = displayName;
    await UserRepository.instance.editProfile(user: user);
    ToastCommon.showCustomText(content: 'Edit profile success');
  }

  Future<String> uploadImage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(imageFile!);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
    return null;
  }

  void clear() {
    imageFile = null;
    displayName = '';
  }
}
