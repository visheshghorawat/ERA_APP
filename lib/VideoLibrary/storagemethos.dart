import 'package:ERA/models/videodetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageMethods {
  Future uploadToStorage() async {
    try {
      final DateTime now = DateTime.now();
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String today = ('$month-$date');
      final file = await ImagePicker.pickVideo(source: ImageSource.gallery);
      //video upload on firebase storage...
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("video")
          .child(today)
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          ref.putFile(file, StorageMetadata(contentType: 'video/mp4'));

      String url =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();
      //Video detail upload on firebase....
      VideoDetail videoDetail = VideoDetail(
          subtitle: "upload Video tutorial",
          title: "Upload Video",
          type: "video",
          timestamp: Timestamp.now(),
          videoId: DateTime.now().toIso8601String(),
          videoUrl: url);
      await FirebaseFirestore.instance
          .collection("Videos")
          .doc()
          .set(videoDetail.toMap(videoDetail));
      print("upload");
      print(url);
    } catch (error) {
      print(error);
    }
  }
}
