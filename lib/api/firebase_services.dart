import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Firebase_services {
  FirebaseStorage storage = FirebaseStorage.instance;
  void UploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String nama = result.files.first.name;
      try {
        await storage.ref('profile/$nama').putFile(file);
        log("Berhasil upload");
        
        // ignore: nullable_type_in_catch_clause
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        log(e.toString());
      }
    } else {
      // User canceled the picker
      log("Tidak memilih file");
    }
  }

 
}
