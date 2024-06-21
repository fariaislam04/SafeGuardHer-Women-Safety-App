import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final String message;
  final Color color;

  const CustomSnackbar({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.23,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: 1.0,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}