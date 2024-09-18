import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as encrypt; // Encryption package
import '../../../utils/formatters/formatters.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

class StorageService {
  static Future<void> uploadAudio(Uint8List audioData, String path) async {
    try {
      Reference ref = storage.ref().child(path);
      UploadTask uploadUserAudio = ref.putData(audioData);
      await uploadUserAudio;
    } catch (e) {
      log("Failed to upload audio: $e");
    }
  }

  // Encrypt image bytes using AES
  static Uint8List encryptImage(Uint8List imageBytes) {
    final key = encrypt.Key.fromLength(32); // Use a 32-byte key
    final iv = encrypt.IV.fromLength(16); // Use a 16-byte IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encryptBytes(imageBytes, iv: iv);
    return encrypted.bytes;
  }

  static Future<void> uploadImage(String filePath, String storagePath) async {
    try {
      // Read the image as bytes
      File imageFile = File(filePath);
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Encrypt the image bytes
      Uint8List encryptedImageBytes = encryptImage(imageBytes);

      // Upload the encrypted image bytes to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      UploadTask uploadTask = storageRef.putData(encryptedImageBytes);
      await uploadTask;

      final imageUrl = await storageRef.getDownloadURL();
      if (kDebugMode) {
        print('Encrypted image uploaded to Firebase Storage: $imageUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading encrypted image to Firebase Storage: $e');
      }
    }
  }

  // Extract folders date-wise from storage
  Future<List<String>> listDateFolders(String uid) async {
    List<String> dateFolders = [];
    try {
      ListResult result = await storage.ref('recordings/images/$uid').listAll();
      for (var prefix in result.prefixes) {
        dateFolders.add(prefix.name);
      }
    } catch (e) {
      if (e is FirebaseException) {
        log('FirebaseException: ${e.message}');
        log('Error code: ${e.code}');
      } else {
        log('Unexpected error: $e');
      }
    }
    return dateFolders;
  }

  // Extract image src, date, and time from the storage
  Future<List<ImageData>> listImagesForEachDate(String uid, String date) async {
    List<ImageData> imageDatas = [];
    try {
      ListResult result =
          await storage.ref('recordings/images/$uid/$date/').listAll();
      for (var item in result.items) {
        String imageUrl = await item.getDownloadURL();
        String imageDate = extractTimeFromPath(item.fullPath);
        imageDatas.add(ImageData(imageUrl, imageDate));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error listing image URLs: $e');
      }
    }
    return imageDatas;
  }

  // Extracts image time from the image name
  String extractTimeFromPath(String filename) {
    String pathWithoutImageExtension =
        filename.split('.').first; // remove .jpg extension
    List<String> parts = pathWithoutImageExtension
        .split(' '); // Split by space to separate date and time
    String time = Formatters.formatTime(
        parts.last); // Take the last part which is the time
    return time;
  }
}

// Class that contains necessary data for showing image list on recording_details page
class ImageData {
  final String imageUrl;
  final String date;

  ImageData(this.imageUrl, this.date);
}
