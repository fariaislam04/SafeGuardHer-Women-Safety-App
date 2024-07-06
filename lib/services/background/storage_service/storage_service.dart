import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../utils/formatters/formatters.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

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

  // -- Extract folders date-wise from storage
  Future<List<String>> listDateFolders(String uid) async
  {
    List<String> dateFolders = [];
    try
    {
      ListResult result = await storage.ref('recordings/images/$uid').listAll();
      for (var prefix in result.prefixes) {
        dateFolders.add(prefix.name);
      }
    }
    catch (e)
    {
      print('Error listing date folders: $e');
    }
    return dateFolders;
  }

  // -- extract image src, date and time from the storage
  Future<List<ImageData>> listImagesForEachDate(String uid, String date) async {
    List<ImageData> imageDatas = [];
    try
    {
      ListResult result = await storage.ref('recordings/images/$uid/$date/').listAll();
      for (var item in result.items)
      {
        String imageUrl = await item.getDownloadURL();
        String imageDate = extractTimeFromPath(item.fullPath);
        imageDatas.add(ImageData(imageUrl, imageDate));
      }
    }
    catch (e)
    {
      print('Error listing image URLs: $e');
    }
    return imageDatas;
  }

  // -- Extracts image time from the image name
  String extractTimeFromPath(String filename)
  {
    String pathWithoutImageExtension = filename.split('.').first; // remove
    // .jpg extension
    List<String> parts = pathWithoutImageExtension.split(' '); // Split by space to separate date and time
    String time = Formatters.formatTime(parts.last); // Take the last part which is the time
    return time;
  }
}

// -- class that contains necessary data for showing image list on
// recording_details page
class ImageData
{
  final String imageUrl;
  final String date;

  ImageData(this.imageUrl, this.date);
}