import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  final String fileName;

  StorageService({required this.fileName});

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future uploadNotes(pdfToUpload) async {
    final pdf = pdfToUpload;
    final file = File(pdf);

    await firebase_storage.FirebaseStorage.instance
        .ref('notes')
        .child(fileName)
        .putFile(file);
  }

  Future<String?> getNotesUrl() async {
    String? downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref('notes')
        .child(fileName)
        .getDownloadURL();

    return downloadUrl;
  }

  Future uploadCircular(pdfToUpload) async {
    final pdf = pdfToUpload;
    final file = File(pdf);

    await firebase_storage.FirebaseStorage.instance
        .ref('circular')
        .child(fileName)
        .putFile(file);
  }

  Future<String?> getCircularUrl() async {
    String? downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref('circular')
        .child(fileName)
        .getDownloadURL();

    return downloadUrl;
  }
}
