import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AddContactWidget extends StatelessWidget {
  const AddContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      'Track Me',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Share your live location with close contacts',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Add People button pressed");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10), backgroundColor: const Color(0xFFCE0450),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
