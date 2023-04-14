// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageServiceProvider = Provider((ref) {
  return FirebaseStorageService(firebaseStorage: FirebaseStorage.instance);
});

class FirebaseStorageService {
  final FirebaseStorage firebaseStorage;
  FirebaseStorageService({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String path, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(path).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
