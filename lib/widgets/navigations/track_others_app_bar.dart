import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: TrackOthersAppBar(),
        body: Center(child: Text('Main Content')),
      ),
    );
  }
}

class TrackOthersAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text(
              "Binita’s Current Location",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.my_location_rounded, color: Colors.blueAccent),
                SizedBox(width: 8),
                Expanded( // Use Expanded to handle overflow
                  child: Text(
                    "Shahingbagh, Dhaka (15 Km away)",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.green),
                SizedBox(width: 8),
                Expanded( // Use Expanded to handle overflow
                  child: Text(
                    "Estd. 3 min to reach",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(170); // Set the height of the
// custom app bar
}
