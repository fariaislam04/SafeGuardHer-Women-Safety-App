import 'package:flutter/material.dart';

class BottomToTopAnimatedRoute extends PageRouteBuilder<void> {
  final Widget page;

  BottomToTopAnimatedRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1);
      const end = Offset(0.0, 0.0);
      final tween = Tween<Offset>(begin: begin, end: end).animate(animation);
      return SlideTransition(
        position: tween,
        child: child,
      );
    },
  );
}