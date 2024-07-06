import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mic_stream/mic_stream.dart';
import 'view_recordings_history.dart';
import '../../services/background/background_services.dart';
import '../../utils/helpers/helper_functions.dart';

/// This screen records audio and takes images every 5 seconds from front and
/// back camera, and stores them in Firebase storage under Recordings folder.

class RecordScreen extends StatefulWidget
{
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
{
  StreamSubscription? streamSubscription;
  List<int> samples = [];
  Stream? stream;
  bool isListening = false;
  AppHelperFunctions appHelperFunctions = AppHelperFunctions();

  // -- Camera service
  late CameraService _cameraService;
  late String _date;
  final String _uid = '7';
  
  @override
  void initState() 
  {
    super.initState();
    _initializeServices();
    _date = AppHelperFunctions.extractTodayDate();
  }

  // -- _initializeServices(): This function waits for camera permission, and
  // if user accepts it, the cameras are initialized
  Future<void> _initializeServices() async
  {
    PermissionService.requestCameraPermission();
    _cameraService = CameraService();
    await _cameraService.initializeCameras();
    setState(() {});
  }

  // -- startListening(): The app starts toggling between front and back 
  // cameras, and takes in the audio streams. These occur independently in
  // case the users want to access only one service.
  startListening() async
  {
    _startCameraSwitchTimer();
    stream = MicStream.microphone(
      sampleRate: 16000,
      audioSource: AudioSource.MIC,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
    );
    if (stream != null)
    {
      streamSubscription = stream!.listen((event)
      {
        setState(()
        {
          samples = event;
        });
      });
    }
    else
    {
      log("microphone stream is null");
    }
  }

  stopListening()
  {
    log("stopping");
    streamSubscription?.cancel();
  }

  // -- _startCameraSwitchTimer(): If recording is on, cameras toggle
  // every 5 seconds, images are captured, and stores in firebase storage
  // service.
  void _startCameraSwitchTimer()
  {
    Timer.periodic(const Duration(seconds: 5), (timer) async
    {
      if (isListening)
      {
        final imagePath = await _cameraService.captureImage();
        if (imagePath != null)
        {
          await StorageService.uploadImage(imagePath, 'recordings/images/$_uid/$_date/${DateTime.now()}.jpg');
        }
        await _cameraService.toggleCamera();
      }
      else
      {
        timer.cancel();
      }
    });
  }

  @override
  void dispose()
  {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anonymous Recording',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Anonymously record audio and capture images without notifying '
                  'others.',
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
            const Divider(color: Color(0xFFEDEDED)),
            const SizedBox(height: 13),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/anonymous_recording_icon.svg',
                  width: 30,
                  height: 30,
                ),
                title: const Text(
                  'Recordings',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('Tap to see history'),
                onTap: ()
                {
                  isListening = false;
                  stopListening();
                  appHelperFunctions.goTo(context, const
                  ViewRecordingsHistory(uid: '2',));
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF263238),
                  size: 15,
                ),
              ),
            ),
            const SizedBox(height: 0),
            // Audio Visualizer
            Row(
              children: [
                ...List.generate(
                  samples.length,
                      (index) => CustomPaint(
                    foregroundPainter: LinePainter(samples[index], index * 2),
                    child: Container(),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 6),
            Center(
              child: ElevatedButton.icon(
                onPressed: ()
                {
                  setState(()
                  {
                    if (!isListening)
                    {
                      isListening = true;
                      startListening();
                    }
                    else
                    {
                      isListening = false;
                      stopListening();
                    }
                  });
                },
                icon: Container(
                  padding: const EdgeInsets.all(0.5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isListening ? Icons.stop : Icons.fiber_manual_record,
                    color: isListening ? Colors.black : Colors.red,
                    size: 24,
                  ),
                ),
                label: Text(
                  isListening ? 'Stop Recording' : 'Start Recording',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  backgroundColor: const Color(0xFF272727),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final int height;
  final int gap;

  LinePainter(this.height, this.gap);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = const Color(0xFFF93F95);
    paint.strokeWidth = 1;

    canvas.drawLine(
      Offset(gap.toDouble(), -height.toDouble() + 200),
      Offset(gap.toDouble(), 200),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}