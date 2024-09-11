import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomBubbleMarker {
  Future<BitmapDescriptor> createCustomBubbleMarker(String circleImageUrl, String additionalImageUrl) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double circleRadius = 70.0; // The radius of the circular part of the marker
    const double borderWidth = 8.0; // Border thickness
    const double taperHeight = 50.0; // Height of the bottom taper

    // Define the total size of the marker
    final double markerWidth = circleRadius * 2;
    final double markerHeight = circleRadius * 2 + taperHeight;

    // Draw the circle with border
    final Paint borderPaint = Paint()
      ..color = Colors.blue // Border color
      ..style = PaintingStyle.fill;

    final Offset circleCenter = Offset(circleRadius, circleRadius);

    // Draw the circle (main marker)
    canvas.drawCircle(circleCenter, circleRadius, borderPaint);

    // Draw the main image inside the circle
    final imageProvider = AssetImage(circleImageUrl);
    final Completer<ui.Image> imageCompleter = Completer();
    final ImageStreamListener listener = ImageStreamListener((imageInfo, synchronousCall) {
      final image = imageInfo.image;
      imageCompleter.complete(image);
    });
    imageProvider.resolve(const ImageConfiguration()).addListener(listener);

    // Wait for the image to load
    final ui.Image circleImage = await imageCompleter.future;

    // Create a circular clipping path for the image
    final Path path = Path()
      ..addOval(Rect.fromCircle(center: circleCenter, radius: circleRadius - borderWidth));

    // Clip the canvas to the circular path
    canvas.clipPath(path);

    // Draw the main image
    canvas.drawImageRect(
      circleImage,
      Rect.fromLTWH(0, 0, circleImage.width.toDouble(), circleImage.height.toDouble()),
      Rect.fromCenter(
        center: circleCenter,
        width: (circleRadius - borderWidth) * 2,
        height: (circleRadius - borderWidth) * 2,
      ),
      Paint(),
    );

    // Draw the additional image below the circle
    final imageProvider2 = AssetImage(additionalImageUrl);
    final Completer<ui.Image> imageCompleter2 = Completer();
    final ImageStreamListener listener2 = ImageStreamListener((imageInfo, synchronousCall) {
      final image = imageInfo.image;
      imageCompleter2.complete(image);
    });
    imageProvider2.resolve(const ImageConfiguration()).addListener(listener2);

    // Wait for the additional image to load
    final ui.Image additionalImage = await imageCompleter2.future;

    // Define the position of the additional image
    final double additionalImageWidth = additionalImage.width.toDouble();
    final double additionalImageX = circleCenter.dx - additionalImageWidth / 2;
    final double additionalImageY = circleRadius * 2; // Position below the circle

    // Draw the additional image
    canvas.drawImage(
      additionalImage,
      Offset(additionalImageX, additionalImageY),
      Paint(),
    );

    // Draw the tapering pointer (arrow) at the bottom
    final Paint taperPaint = Paint()
      ..color = Colors.blue // Match the color of the border
      ..style = PaintingStyle.fill;

    final Path taperPath = Path();

    // Adjust the width and position of the taper/arrow
    taperPath.moveTo(circleRadius - 20, circleRadius * 2); // Left corner of the taper
    taperPath.lineTo(circleRadius + 20, circleRadius * 2); // Right corner of the taper
    taperPath.lineTo(circleRadius, circleRadius * 2 + taperHeight); // Bottom tip of the taper
    taperPath.close();

    // Draw the taper path (arrow)
    canvas.drawPath(taperPath, taperPaint);

    // Finalize the image and convert to a PNG
    final ui.Image finalImage = await pictureRecorder.endRecording().toImage(
      markerWidth.toInt(),
      markerHeight.toInt(),
    );
    final ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }
}
