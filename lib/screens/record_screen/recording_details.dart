import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RecordingDetails extends StatelessWidget {
  final String audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  const RecordingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record History of 21/05/24'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record lasted for 10 secs',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Photos (2)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PhotoWidget(src: 'assets/photo1.jpg', time: '12:10 PM'),
                  PhotoWidget(src: 'assets/photo2.jpg', time: '1:20 PM'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Audios (1)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AudioPlayerWidget(audioUrl: audioUrl, time: '12:10 PM'),
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
    return Column(
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
        Text(time),
      ],
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String time;

  const AudioPlayerWidget({super.key, required this.audioUrl, required this.time});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _setupAudio();
  }

  void _setupAudio() async {
    await audioPlayer.setUrl(widget.audioUrl);

    audioPlayer.durationStream.listen((event) {
      setState(() {
        duration = event ?? Duration.zero;
      });
    });

    audioPlayer.positionStream.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  void _togglePlayPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  height: 50,
                  color: Colors.pink[50],
                  child: Center(
                    child: isPlaying
                        ? const Icon(Icons.pause, color: Colors.pink)
                        : const Icon(Icons.play_arrow, color: Colors.pink),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.time),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: position.inSeconds / (duration.inSeconds == 0 ? 1 : duration.inSeconds),
        ),
      ],
    );
  }
}
