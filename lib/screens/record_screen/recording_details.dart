import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:photo_view/photo_view.dart';
import '../../widgets/navigations/app_bar.dart';

class RecordingDetails extends StatelessWidget {
  final String audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  const RecordingDetails({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Record History of 12/05/24',
                  style: TextStyle(
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
            const Divider(color: Color(0xFFEDEDED)),
            const SizedBox(height: 10),
            const Text(
              'Photos (4)',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 8),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PhotoWidget(src: 'assets/placeholders/cam1 (1).png', time: '12:10 AM'),
                  PhotoWidget(src: 'assets/placeholders/cam1 (2).png', time: '12:40 AM'),
                  PhotoWidget(src: 'assets/placeholders/cam1 (3).png', time: '1:00 AM'),
                  PhotoWidget(src: 'assets/placeholders/cam1 (4).png', time: '1:20 AM'),
                ],
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
                activeSliderColor: const Color(0xFFD20452),
                circlesTextStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                circlesColor: const Color(0xFFD20452),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoWidget extends StatelessWidget {
  final String src;
  final String time;

  const PhotoWidget({super.key, required this.src, required this.time});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ZoomableImagePage(imageSrc: src),
          ),
        );
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
                image: AssetImage(src),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
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
          imageProvider: AssetImage(imageSrc),
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }
}
