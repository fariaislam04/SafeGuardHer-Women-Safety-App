import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 90,
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SvgPicture.asset(
                'assets/logos/logo.svg',
                width: 80,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 0.0, top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: badges.Badge(
                    badgeContent:
                        const Text('3', style: TextStyle(color: Colors.white)),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Color(0xFFCE0450),
                      padding: EdgeInsets.all(6),
                      shape: badges.BadgeShape.circle,
                    ),
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
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print("menu btn");
                      }
                    },
                    icon: const Icon(Icons.menu),
                    color: const Color(0xFF222222),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
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
