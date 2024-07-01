import 'dart:math';
import 'package:flutter/material.dart';

class GenerateSafeCodeForRescue
{
  static int generateSafeCodeForRescue()
  {
    Random random = Random();
    int code = 1000 + random.nextInt(9000);
    return code;
  }
}

void goTo(BuildContext context, Widget nextScreen)
{
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ));
}

dialogueBox(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(text),
    ),
  );
}

Widget progressIndicator(BuildContext context)
{
  return const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
        strokeWidth: 7,
      ));
}

