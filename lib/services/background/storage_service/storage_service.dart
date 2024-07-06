import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService
{
  static Future<void> uploadImage(String filePath, String storagePath) async
  {
    try
    {
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      final uploadTask = await storageRef.putFile(File(filePath));
      final imageUrl = await uploadTask.ref.getDownloadURL();
      print('Image uploaded to Firebase Storage: $imageUrl');
    }
    catch (e)
    {
      print('Error uploading image to Firebase Storage: $e');
    }
  }
}
