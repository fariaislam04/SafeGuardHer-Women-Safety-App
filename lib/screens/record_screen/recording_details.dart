import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:photo_view/photo_view.dart';
import '../../services/background/storage_service/storage_service.dart';
import '../../utils/constants/colors/colors.dart';
import '../../utils/formatters/formatters.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../widgets/navigations/app_bar.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class RecordingDetails extends StatelessWidget {
  final String audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  final String uid;
  final String date;

  const RecordingDetails({super.key, required this.uid, required this.date});

  @override
  Widget build(BuildContext context) {
    String formattedDate = Formatters.formatDateString(date);

    return FutureBuilder<List<ImageData>>(
      future: StorageService().listImagesForEachDate(uid, date),
      builder: (context, snapshot)
      {
        // -- while app is fetching data from storage, show app loader
        if (snapshot.connectionState == ConnectionState.waiting)
        {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Center(
              child: appHelperFunctions.appLoader(context),
            ),
          );
        }

        // -- If there's an error, show error
        else if (snapshot.hasError)
        {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // -- If the date folder contains no images, show "No images"
        else if (!snapshot.hasData || snapshot.data!.isEmpty)
        {
          return const Scaffold(
            appBar: CustomAppBar(),
            body: Center(
              child: Text('No images found for this date.'),
            ),
          );
        }

        // -- Show the images in PhotoWidget
        else
        {
          List<ImageData> imageDatas = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(),
            body: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 3.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF263238),
                          size: 15,
                        ),
                        onPressed: () => appHelperFunctions.goBack(context),
                      ),
                      Text(
                        'Record History of $formattedDate',
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0.0),
                  const Text(
                    'Record lasted 30 minutes.',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(color: AppColors.dividerPrimary),
                  const SizedBox(height: 10),
                  Text(
                    'Photos (${imageDatas.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: imageDatas.map((data) => PhotoWidget(data: data)).toList(),
                    ),
                  ),
                  const Divider(color: Color(0xFFEDEDED)),
                  const SizedBox(height: 16),
                  const Text(
                    'Audios (1)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: VoiceMessageView(
                      controller: VoiceController(
                        audioSrc: audioUrl,
                        onComplete: () {},
                        onPause: () {},
                        onPlaying: () {},
                        onError: (err) {},
                        maxDuration: const Duration(minutes: 30),
                        isFile: false,
                        noiseCount: 50,
                      ),
                      size: 50.0,
                      innerPadding: 3,
                      playIcon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      pauseIcon: const Icon(
                        Icons.pause_rounded,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      activeSliderColor: AppColors.secondary,
                      circlesTextStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      circlesColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class PhotoWidget extends StatelessWidget {
  final ImageData data;

  const PhotoWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appHelperFunctions.goTo(context, ZoomableImagePage(imageSrc: data.imageUrl));
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(data.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.date,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class ZoomableImagePage extends StatelessWidget {
  final String imageSrc;

  const ZoomableImagePage({super.key, required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoomed Image'),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageSrc),
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }
}
