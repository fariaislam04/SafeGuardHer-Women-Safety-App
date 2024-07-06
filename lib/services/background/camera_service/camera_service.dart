import 'dart:async';
import 'package:camera/camera.dart';

List<CameraDescription> _availableCameras = [];

class CameraService
{
  late CameraController _cameraController;
  late CameraDescription _currentCamera;
  bool get isInitialized => _cameraController.value.isInitialized;

  Future<void> initializeCameras() async
  {
    _availableCameras = await availableCameras();
    _currentCamera = _availableCameras.first;

    _cameraController = CameraController(
      _currentCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
  }

  Future<String?> captureImage() async
  {
    if (!_cameraController.value.isInitialized) {
      return null;
    }

    final XFile image = await _cameraController.takePicture();
    return image.path;
  }

  Future<void> toggleCamera() async
  {
    if (_currentCamera.lensDirection == CameraLensDirection.front) {
      _currentCamera = await _getCamera(CameraLensDirection.back);
    } else {
      _currentCamera = await _getCamera(CameraLensDirection.front);
    }

    await _cameraController.dispose();
    _cameraController = CameraController(
      _currentCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
  }

  Future<CameraDescription> _getCamera(CameraLensDirection direction) async
  {
    return _availableCameras
        .firstWhere((camera) => camera.lensDirection == direction);
  }

  void dispose()
  {
    _cameraController.dispose();
  }
}