import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker
{
  Future<BitmapDescriptor> createCustomTeardropMarker(String circleImageUrl,
      Color color) async
  {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    const double circleRadius = 65.0;
    const double borderWidth = 8.0;
    const double taperHeight = 25.0;
    const double shadowOffset = 5.0;

    const double markerWidth = circleRadius * 2.2;
    const double markerHeight = circleRadius * 2 + taperHeight;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 10.0)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const Offset circleCenter = Offset(circleRadius, circleRadius);

    final Path shadowPath = Path();
    shadowPath.addOval(Rect.fromCircle(center: circleCenter.translate(shadowOffset, shadowOffset), radius: circleRadius));

    shadowPath.moveTo(circleRadius - circleRadius, circleRadius + shadowOffset);
    shadowPath.cubicTo(
      circleRadius - 80 + shadowOffset, circleRadius - 50 + shadowOffset,
      circleRadius + 60 + shadowOffset, circleRadius - 50 + shadowOffset,
      circleRadius + circleRadius + shadowOffset, circleRadius + shadowOffset,
    );

    shadowPath.lineTo(circleRadius + shadowOffset, circleRadius * 2 + taperHeight + shadowOffset);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);

    final Path teardropPath = Path();
    teardropPath.addOval(Rect.fromCircle(center: circleCenter, radius: circleRadius));

    teardropPath.moveTo(circleRadius - circleRadius, circleRadius);
    teardropPath.cubicTo(
      circleRadius - 80, circleRadius - 50,
      circleRadius + 60, circleRadius - 20,
      circleRadius + circleRadius, circleRadius,
    );

    teardropPath.lineTo(circleRadius, circleRadius * 2 + taperHeight);
    teardropPath.close();

    canvas.drawPath(teardropPath, borderPaint);

    final imageProvider = AssetImage(circleImageUrl);
    final Completer<ui.Image> imageCompleter = Completer();
    final ImageStreamListener listener = ImageStreamListener((imageInfo, synchronousCall) {
      final image = imageInfo.image;
      imageCompleter.complete(image);
    });
    imageProvider.resolve(const ImageConfiguration()).addListener(listener);

    final ui.Image circleImage = await imageCompleter.future;

    final Path clipPath = Path()
      ..addOval(Rect.fromCircle(center: circleCenter, radius: circleRadius - borderWidth));

    canvas.clipPath(clipPath);

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

    final ui.Image finalImage = await pictureRecorder.endRecording().toImage(
      markerWidth.toInt(),
      markerHeight.toInt(),
    );

    final ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }

  Future<BitmapDescriptor> createDangerMarker()
  {
    return BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 50)),
      'assets/illustrations/danger.png',
    );
  }
}
