import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker {
  Future<BitmapDescriptor> createCustomDestinationMarker(
      double latitude,
      double longitude,
      double rippleRadius,
      String imageUrl) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double radius = 60.0; // Marker radius
    const double borderWidth = 6.0; // Border width
    const double rippleOffset = 90.0; // Ripple offset

    // Draw the wave-like ripple effect circle
    final ripplePaint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw the ripple effect
    canvas.drawCircle(
      Offset(radius + rippleOffset, radius + rippleOffset),
      rippleRadius,
      ripplePaint,
    );

    // Draw the white border circle, centered
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(
      Offset(radius + rippleOffset, radius + rippleOffset),
      radius + borderWidth / 2,
      borderPaint,
    );

    // Load the image
    final imageProvider = AssetImage(imageUrl);
    final Completer<ui.Image> imageCompleter = Completer();
    final ImageStreamListener listener = ImageStreamListener((imageInfo, synchronousCall) {
      final image = imageInfo.image;
      imageCompleter.complete(image);
    });
    imageProvider.resolve(const ImageConfiguration()).addListener(listener);

    // Wait for the image to load
    final ui.Image image = await imageCompleter.future;

    // Create a circular path for clipping, centered
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(radius + rippleOffset, radius + rippleOffset), radius: radius));

    // Clip the canvas to the circular path
    canvas.clipPath(path);

    // Draw the image, centered within the circle
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromCenter(
        center: Offset(radius + rippleOffset, radius + rippleOffset),
        width: radius * 2,
        height: radius * 2,
      ),
      Paint(),
    );

    // Adjust the size of the canvas to ensure the ripple effect is fully drawn
    final img = await pictureRecorder.endRecording().toImage(
        (radius * 2 + borderWidth + rippleOffset * 2).toInt(),
        (radius * 2 + borderWidth + rippleOffset * 2).toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }

  Future<BitmapDescriptor> createCustomSourceMarker(
      double latitude, double longitude, String imageUrl) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double radius = 60.0; // Marker radius

    // Load the image
    final imageProvider = AssetImage(imageUrl);
    final Completer<ui.Image> imageCompleter = Completer();
    final ImageStreamListener listener = ImageStreamListener((imageInfo, synchronousCall) {
      final image = imageInfo.image;
      imageCompleter.complete(image);
    });
    imageProvider.resolve(const ImageConfiguration()).addListener(listener);

    // Wait for the image to load
    final ui.Image image = await imageCompleter.future;

    // Create a circular path for clipping, centered
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(radius, radius), radius: radius));

    // Clip the canvas to the circular path
    canvas.clipPath(path);

    // Draw the image, centered within the circle
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromCenter(
        center: Offset(radius, radius),
        width: radius * 2,
        height: radius * 2,
      ),
      Paint(),
    );

    // Adjust the size of the canvas to ensure the image is fully drawn
    final img = await pictureRecorder.endRecording().toImage(
        (radius * 2).toInt(),
        (radius * 2).toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }

  Future<BitmapDescriptor> createWarningMarker() async {
    return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(70, 70)),
      'assets/illustrations/warning.png',
    );
  }
}
