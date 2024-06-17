import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AddContactWidget extends StatelessWidget {
  const AddContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top:5.0, bottom: 15.0, left: 15.0,
            right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Text(
                      'Track Me',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    'Share your live location with close contacts',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Add People button pressed");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(5), backgroundColor: const
                Color(0xFFCE0450),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.person_add_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
