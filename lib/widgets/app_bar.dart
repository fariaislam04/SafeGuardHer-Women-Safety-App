import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SvgPicture.asset(
                'assets/logos/logo.svg',
                width: 80,
                height: 45,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              badges.Badge(
                badgeContent: const Text('3', style: TextStyle(color: Colors.white)),
                badgeColor: const Color(0xFFCE0450),
                child: IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print("Notification btn");
                    }
                  },
                  icon: const Icon(Icons.notifications),
                  color: const Color(0xFF222222),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("menu btn");
                  }
                },
                padding: const EdgeInsets.only(left: 30.0, right: 24.0),
                icon: const Icon(Icons.menu),
                color: const Color(0xFF222222),
              )
            ],
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(color: Color(0xFFEDEDED)),
      ),
    );
  }
}
