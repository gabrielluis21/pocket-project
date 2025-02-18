import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FbStorage {
  var storage = FirebaseStorage.instance;

  static FbStorage get instace => FbStorage();

  TaskSnapshot uploadFiles(childName, file) {
    UploadTask task = storage
        .ref()
        .child("photos")
        .child("profilePhotos")
        .child(childName)
        .putFile(File(file.path));

    return task.snapshot;
  }
}
